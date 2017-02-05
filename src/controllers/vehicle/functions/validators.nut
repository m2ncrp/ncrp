const DEFAULT_NEAR_RADIUS = 5.0;

/**
 * NOTE(inlife): BUGGED, after player timeout in vehicle
 * it setVehicleSpeed returns speed which was on
 * Return true if vehicle is moving.
 * @param  {int}  vehicleid
 * @param  {float}  minimalspeed - Vehicle is standing if real speed of vehicle less that minimalspeed
 * @return {bool} true/false
 */
function isVehicleMoving (vehicleid, minimalspeed = 0.5) {
    local velocity = getVehicleSpeed( vehicleid );
    return (fabs(velocity[0]) > minimalspeed || fabs(velocity[1]) > minimalspeed);
}

/**
 * Return true if vehicle of player is moving.
 * @param  {int}  playerid
 * @param  {float}  minimalspeed - Vehicle of player is standing if real speed of vehicle less that minimalspeed
 * @return {bool} true/false
*/

function isPlayerVehicleMoving (playerid, minimalspeed = 0.5) {
    local vehicleid = getPlayerVehicle( playerid );
    return (isVehicleMoving(vehicleid, minimalspeed));
}

/**
 * @deprecated use isPlayerVehicleInValidPoint
 * Check if VEHICLE of PLAYERid in radius of given point
 *
 * @param  {int} playerid
 * @param  {float} X
 * @param  {float} Y
 * @param  {float} radius
 * @return {bool} true/false
 */
function isVehicleInValidPoint(playerid, X, Y, radius) {
    return isPlayerVehicleInValidPoint(playerid, X, Y, radius);
}
function isPlayerVehicleInValidPoint(playerid, X, Y, radius) {
    return (isPlayerInVehicle(playerid) && isVehicleNearPoint( getPlayerVehicle(playerid), X, Y, radius));
}

/**
 * Check if vehicle is in radius
 * @param  {int}  vehicleid
 * @param  {float}  x
 * @param  {float}  y
 * @param  {float}  radius
 * @return {Boolean}
 */
function isVehicleNearPoint(vehicleid, x, y, radius = DEFAULT_NEAR_RADIUS) {
    local vehPos = getVehiclePosition(vehicleid);
    return isPointInCircle2D( vehPos[0], vehPos[1], x, y, radius );
}
