/**
 * Move player to a specified place from his coordinates
 *
 * @param  {Integer} playerid
 * @param  {Number} x
 * @param  {Number} y
 * @param  {Number} z
 * @return {Boolean}
 */
function movePlayer(playerid, x = 0.0, y = 0.0, z = 0.0) {
    local pos = getPlayerPosition(playerid.tointeger());
    return setPlayerPosition(playerid.tointeger(), pos[0] + x.tofloat(), pos[1] + y.tofloat(), pos[2] + z.tofloat());
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
