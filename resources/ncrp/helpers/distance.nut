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
 * Call function if both players in radius
 * @param  {int}      playerid
 * @param  {int}      targetid
 * @param  {float}    radius
 * @param  {Function} callback
 * @return {void}
 */
function intoRadiusDo(playerid, targetid, radius, callback, exceptionText, color = 0) {
    if ( targetid == null ) {
        if (color) {
            msg(playerid, exceptionText, color);
        } else {
            msg(playerid, exceptionText);
        }
        return;
    }
    if ( callback != null && isBothInRadius(playerid, targetid, radius) )
        callback();
}

/**
 * Call function if both players out of radius
 * @param  {int}      playerid
 * @param  {int}      targetid
 * @param  {float}    radius
 * @param  {Function} callback
 * @return {void}
 */
function outofRadiusDo(playerid, targetid, radius, callback) {
    if ( targetid == null ) {
        msg(playerid, "There's no such player.", CL_RED);
        return;
    }
    if ( callback != null && !isBothInRadius(playerid, targetid, radius) )
        callback();
}

/**
 * Send message to all players in radius
 * @param  {int}        sender
 * @param  {string}     message
 * @param  {float}      radius
 * @param  {RGB object} color
 * @return {void}
 */
function inRadiusSendToAll(sender, message, radius, color = 0) {
    local players = playerList.getPlayers();
    foreach(player in players) {
        intoRadiusDo(sender, player, radius, function() {
            if (color) {
                msg(player, message, color);
            } else {
                msg(player, message);
            }
        });
    }
}


/**
* @temporary. Need changes
*
*   Check if a distance between two players less than radius.
*
* @param  {int} playerid
* @param  {int} targetid
* @param  {float} radius
* @return {bool} true/false
*/

function checkDistanceBtwTwoPlayersLess(playerid, targetid, radius) {
    local playerPos = getPlayerPosition( playerid );
    local targetPos = getPlayerPosition( targetid.tointeger() );
    local radius = radius.tofloat();
    local distance = getDistanceBetweenPoints3D( playerPos[0], playerPos[1], playerPos[2], targetPos[0], targetPos[1], targetPos[2] );
    return  (distance <= radius);
}


/**
 * @deprecated
 * Use checkDistanceBtwTwoPlayersLess()
 *
 * Check if a distance between two players is lower than radius.
 *
 * @param  {int} playerid
 * @param  {int} targetid
 * @param  {float} radius
 * @return {bool} true/false
 */

function checkDistance(playerid, targetid, radius) {
    return checkDistanceBtwTwoPlayersLess(playerid, targetid, radius);
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


/**
 * Check if VEHICLE of PLAYERid in radius of given point
 * @param  {int} playerid
 * @param  {float} X
 * @param  {float} Y
 * @param  {float} radius
 * @return {bool} true/false
 */
function isVehicleInValidPoint(playerid, X, Y, radius) {
    local vehPos = getVehiclePosition( getPlayerVehicle(playerid) );
    return isPointInCircle2D( vehPos[0], vehPos[1], X, Y, radius );
}
