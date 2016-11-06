/**
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
