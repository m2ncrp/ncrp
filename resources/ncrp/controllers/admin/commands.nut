function kickPlayerFromServer( cheaterID ) {
    msg(cheaterID, format("You has been kicked for: %s", reason), CL_RED);
    delayedFunction(7000, function () {
        kickPlayer( cheaterID );
    });
}


/**
 * Ban player account for some time.    <-------------------- Currently not working properly
 * @param  {uint}   cheaterID 
 * @param  {String} reason    Explonation why player is cheater
 * @param  {Number} adminID   Pass -1 by default if send ban from console
 * @param  {Number} banDays   Pass 0 for permanent ban
 * @return {void}
 */
function banPlayerAccount( cheaterID, reason = "", adminID = -1, banDays = 1 ) {
    local banTime = banDays * 86400;
    return banPlayer( cheaterID, adminID, banTime, reason );
}


/**
 * Ban player account for some time
 * @param  {uint}   cheaterID 
 * @param  {String} reason    Explonation why player is cheater
 * @param  {Number} adminID   Pass -1 by default if send ban from console
 * @param  {Number} banDays   Pass 0 for permanent ban
 * @return {void}
 */
function banPlayerSerial( cheaterID, reason = "", adminID = -1, banDays = 1 ) {
    local banTime = banDays * 86400;
    local serial = getPlayerSerial( cheaterID );
    return banSerial( serial, adminID, banTime, reason);
}


function onCheaterDetected( cheaterID, reason ) {
    local pos = getPlayerPosition(cheaterID);

    togglePlayerControls( cheaterID, true );
    if (isPlayerInVehicle(cheaterID)) {
        local vehID = getPlayerVehicle(cheaterID);
        setVehicleSpeed( vehID, 0.0,0.0,0.0 );
        // removePlayerFromVehicle( playerid );
        respawnVehicle( vehID );
    }
    setPlayerPosition(cheaterID, pos[0], pos[1], pos[2] + 5.0);
    for (local i = 0; i < 11; i++) {
        msg(cheaterID, "");
    }
}


acmd("restart", function(playerid) {
    // todo
});

acmd(["admin", "adm", "a"], function(playerid, ...) {
    return sendPlayerMessageToAll("[ADMIN] " + concat(vargv), CL_MEDIUMPURPLE.r, CL_MEDIUMPURPLE.g, CL_MEDIUMPURPLE.b);
});


acmd(["admin", "adm", "a"], "kick", function(playerid, targetid, ...) {
    local targetid = targetid.tointeger();
    local reason = concat(vargv);

    log( getAuthor(playerid) + "'s kick " + getAuthor(targetid) + " for: " + reason);
    onCheaterDetected( targetid, reason );
    msg(targetid, format("You has been kicked for: %s", reason), CL_RED);
    kickPlayerFromServer( targetid );
});


acmd(["admin", "adm", "a"], "ban", function(playerid, targetid, days, ...) {
    local targetid = targetid.tointeger();
    local days = days.tointeger();
    local reason = concat(vargv);

    log( getAuthor(playerid) + "'s banned " + getAuthor(targetid) + " for " + days + ". Reason: " + reason);
    onCheaterDetected( targetid, reason );
    msg(targetid, format("You has been banned for: %s", reason), CL_RED);
    // banPlayerAccount( targetid, reason, playerid, days );
    banPlayerSerial( targetid, reason, playerid, days );
});


acmd("test1", function(playerid, number = 100) {
    local pos = getPlayerPositionObj(playerid);
    local id;
    for (local i = 0; i < number.tofloat(); i++) {
        id = createPrivate3DText(pos.x + i, pos.y + i, pos.z, "A A", CL_MEDIUMPURPLE, 10000.0);
    }
    msg(playerid, format("created #%s texts", id));
});
