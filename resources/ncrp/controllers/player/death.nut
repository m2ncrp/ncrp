local lastDeaths = {};

/**
 * Check if player was dead in last 1 second
 * @param  {Integer}  playerid
 * @return {Boolean}
 */
function isPlayerBeenDead(playerid) {
    return (playerid in lastDeaths && ((getTimestamp() - lastDeaths[playerid]) <= 10));
}

/**
 * Set last player death to current timestamp
 * @param {Integer} playerid
 */
function setPlayerBeenDead(playerid) {
    lastDeaths[playerid] <- getTimestamp();
}


event("native:onPlayerDeath", function(playerid, killerid) {
    // store state for respawning
    setPlayerBeenDead(playerid);

    // start triggers
    trigger("onPlayerDeath", playerid);


    dbg("player", "death", getAuthor(playerid), (killerid != INVALID_ENTITY_ID) ? getAuthor(killerid) : "self");

    if (killerid != INVALID_ENTITY_ID) {
        trigger("onPlayerMurdered", playerid, killerid);
        trigger("onPlayerKill", killerid, playerid);
    }
});

event("onPlayerSpawn", function(playerid) {
    if (!isPlayerBeenDead(playerid)) return;

    // maybe deduct some money...
    if (canMoneyBeSubstracted(playerid, HOSPITAL_AMOUNT)) {
        subMoneyToPlayer(playerid, HOSPITAL_AMOUNT);
        msg(playerid, "hospital.money.deducted", [HOSPITAL_AMOUNT], CL_SUCCESS);
        setPlayerHealth(playerid, 730.0);
    } else {
        msg(playerid, "hospital.money.donthave", [], CL_ERROR);
        setPlayerHealth(playerid, 370.0);
    }

    // repsawn at the hospital
    players[playerid].setPosition( vector3(HOSPITAL_X, HOSPITAL_Y, HOSPITAL_Z) );
});
