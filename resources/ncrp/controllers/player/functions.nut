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
