/**
 * Return distance between player and point
 * @param  {int}    playerid
 * @param  {float}  X
 * @param  {float}  Y
 * @param  {float}  Z
 * @return {float}  distance
 */
function getDistanceToPoint(senderID, X, Y, Z) {
    local p1 = getPlayerPosition( senderID );

    return getDistanceBetweenPoints3D(p1[0], p1[1], p1[2], X, Y, Z);
}

/**
 * Return distance between two players by their ids
 * @param  {int}    senderID    id who call command
 * @param  {int}    targetID    id distance to who need to know
 * @return {float}  distance
 */
function getDistance( senderID, targetID ) {
    local p2 = getPlayerPosition( targetID );

    return getDistanceToPoint( senderID, p2[0], p2[1], p2[2] );
}


/**
 * Return true if both players in radius
 * @param  {int}    playerid
 * @param  {int}    targetid
 * @param  {float}  radius
 * @return {bool}
 */
function isBothInRadius(playerid, targetid, radius) {
    return getDistance(playerid, targetid) <= radius;
}

/**
 * Return true if player in radius of given point
 * @param  {int}    playerid
 * @param  {float}  X
 * @param  {float}  Y
 * @param  {float}  Z
 * @param  {float}  radius
 * @return {bool}
 */
function isInRadius(playerid, X, Y, Z, radius) {
    return (getDistanceToPoint(playerid, X, Y, Z) <= radius);
}

/**
 * Call function if player in radius
 * @param  {int}      playerid
 * @param  {float}    radius
 * @param  {Function} callback
 * @return {void}
 */
function intoRadiusDo(playerid, radius, callback) {
    // todo
}

/**
 * Call function if player out of radius
 * @param  {int}      playerid
 * @param  {float}    radius
 * @param  {Function} callback
 * @return {void}
 */
function outofRadiusDo(playerid, radius, callback) {
    // todo
}
