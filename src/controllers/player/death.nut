const HOSPITAL_X         = -393.429;
const HOSPITAL_Y         = 912.044;
const HOSPITAL_Z         = -20.0026;
const HOSPITAL_AMOUNT    = 8.29;

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

/**
 * Handler player death
 * mark player as dead, and call appropirate events
 */
event("native:onPlayerDeath", function(playerid, killerid) {
    if (!isPlayerLoaded(playerid)) return;

    players[playerid].spawned = false;

    // store state for respawning
    setPlayerBeenDead(playerid);

    // start triggers
    trigger("onPlayerDeath", playerid);
    dbg("player", "death", getIdentity(playerid), (killerid != INVALID_ENTITY_ID) ? getIdentity(killerid) : "self");

    if (killerid != INVALID_ENTITY_ID) {
        trigger("onPlayerMurdered", playerid, killerid);
        trigger("onPlayerKill", killerid, playerid);
    }
});

/**
 * Handle player respawn event
 * for spawning player in hospital
 */
event("onPlayerSpawn", function(playerid) {
    if (!isPlayerBeenDead(playerid)) return;

    dbg("player", "spawn", "after death", getIdentity(playerid));

    // maybe deduct some money...
    if (canMoneyBeSubstracted(playerid, HOSPITAL_AMOUNT)) {
        subMoneyToPlayer(playerid, HOSPITAL_AMOUNT);
        msg(playerid, "hospital.money.deducted", [HOSPITAL_AMOUNT], CL_SUCCESS);
        players[playerid].health = 730.0;
    } else {
        msg(playerid, "hospital.money.donthave", [], CL_ERROR);
        players[playerid].health = 370.0;
    }

    // repsawn at the hospital
    players[playerid].setPosition( HOSPITAL_X, HOSPITAL_Y, HOSPITAL_Z );
});
