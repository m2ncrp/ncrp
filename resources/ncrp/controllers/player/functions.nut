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
    return { x = plaPos[0], y = plaPos[1], z = plaPos[2] };
}

/**
 * Set player position to coordinates from objpos.x, objpos.y, objpos.z
 * @param {int} playerid
 * @param {object} objpos
 */
function setPlayerPositionObj ( playerid, objpos ) {
    setPlayerPosition( playerid, objpos.x, objpos.y, objpos.z);
}


/**
 * Check if PLAYER in radius of given point
 * @param  {int} playerid
 * @param  {float} X
 * @param  {float} Y
 * @param  {float} radius
 * @return {bool} true/false
 */
function isPlayerInValidPoint(playerid, X, Y, radius) {
    local plaPos = getPlayerPosition( playerid );
    return isPointInCircle2D( plaPos[0], plaPos[1], X, Y, radius );
}

/**
 * Check if PLAYER in radius of given point 3D
 * @param  {int} playerid
 * @param  {float} X
 * @param  {float} Y
 * @param  {float} Z
 * @param  {float} radius
 * @return {bool} true/false
 */
function isPlayerInValidPoint3D(playerid, X, Y, Z, radius) {
    local plaPos = getPlayerPosition( playerid );
    return isPointInCircle3D( plaPos[0], plaPos[1], plaPos[2], X, Y, Z, radius );
}
