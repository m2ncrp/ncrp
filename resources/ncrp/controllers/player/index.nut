include("controllers/player/commands.nut");
include("controllers/player/PlayerList.nut");

players <- {};
playerList <- null;

addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial) {
    players[playerid] <- {};
    players[playerid]["job"] <- null;
    players[playerid]["money"] <- 0.63;
    players[playerid]["skin"] <- 10;
    players[playerid]["request"] <- {}; // need for invoice to transfer money

    players[playerid]["taxi"] <- {};
    players[playerid]["taxi"]["call_address"] <- false; // Address from which was caused by a taxi
    players[playerid]["taxi"]["call_state"] <- false; // Address from which was caused by a taxi

    playerList.addPlayer(playerid, name, ip, serial);
});

addEventHandler("onPlayerDisconnect", function(playerid, reason) {
    playerList.delPlayer(playerid);
});

addEventHandler("onPlayerSpawn", function(playerid) {
    setPlayerPosition(playerid, -567.499, 1531.58, -15.8716);
    setPlayerHealth(playerid, 730.0);
});

addEventHandler("onPlayerDeath", function(playerid, killerid) {
    if (killerid != INVALID_ENTITY_ID) {
        sendPlayerMessageToAll("~ " + getPlayerName(playerid) + " has been killed by " + getPlayerName(killerid) + ".", 255, 204, 0);
    } else {
        sendPlayerMessageToAll("~ " + getPlayerName(playerid) + " has died.", 255, 204, 0 );
    }
});



/**
 * Check is player sit in a valid vehicle
 * @param  {int}  playerid
 * @param  {int}  modelid  - model vehicle
 * @return {Boolean} true/false
 */
function isPlayerInValidVehicle(playerid, modelid) {
    return (isPlayerInVehicle(playerid) && getVehicleModel( getPlayerVehicle(playerid) ) == modelid.tointeger());
}

/**
 * Check is player have a valid job
 * @param  {int}  playerid
 * @param  {string}  jobname  - name of job
 * @return {Boolean} true/false
 */
function isPlayerHaveValidJob(playerid, jobname) {
    return (players[playerid]["job"] == jobname);
}

/**
 * Check is player have a any job
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerHaveJob(playerid) {
    return (players[playerid]["job"]) ? true : false;
}

/**
 * Get job of player
 * @param  {int}  playerid
 * @return {string}  - job of player
 */
function getPlayerJob(playerid) {
    return (players[playerid]["job"]) ? players[playerid]["job"] : false;
}

/**
 * Get player position and return to OBJECT
 * @param  {int} playerid
 * @return {object}
 */
function getPlayerPositionObj ( playerid ) {
    local plaPos = getPlayerPosition(playerid);
    local newPos = {}
    newPos.x <- plaPos[0];
    newPos.y <- plaPos[1],
    newPos.z <- plaPos[2];
    return newPos;
}

/**
 * Set player position to coordinates from objpos.x, objpos.y, objpos.z
 * @param {int} playerid
 * @param {object} objpos
 */
function setPlayerPositionObj ( playerid, objpos ) {
    setPlayerPosition( playerid, objpos.x, objpos.y, objpos.z);
}
