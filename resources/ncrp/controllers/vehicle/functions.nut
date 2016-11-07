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

/**
 * Get vehicle position and return to OBJECT
 * @param  {int} vehicleid
 * @return {object}
 */
function getVehiclePositionObj ( vehicleid ) {
    local vehPos = getVehiclePosition( vehicleid );
    return { x = vehPos[0], y = vehPos[1], z = vehPos[2] };
}

/**
 * Set vehicle position to coordinates from objpos.x, objpos.y, objpos.z
 * @param {int} vehicleid
 * @param {object} objpos
 */
function setVehiclePositionObj ( vehicleid, objpos ) {
    setVehiclePosition( vehicleid, objpos.x, objpos.y, objpos.z);
}

/**
 * Switch vehicle FRONT lights
 * @param  {int} playerid
 */
function switchLights(playerid) {
    if ( !isPlayerInVehicle(playerid) ) {
        return;
    }
    local vehicleid = getPlayerVehicle( playerid );
    local prevState = getVehicleLightState( vehicleid );
    setVehicleLightState( vehicleid, !prevState );
}

/**
 * Switch vehicle BOTH Indicator Light
 * @param  {int} playerid
 */
function switchBothLight(playerid) {
    if ( !isPlayerInVehicle(playerid) ) {
        return;
    }
    local vehicleid = getPlayerVehicle(playerid);

    local leftState = getIndicatorLightState(vehicleid, INDICATOR_LEFT);
    local rightState = getIndicatorLightState(vehicleid, INDICATOR_RIGHT);

    if(leftState && rightState) {
        leftState = false;
        rightState = false;
    } else {
        leftState = true;
        rightState = true;
    }

    setIndicatorLightState(vehicleid, INDICATOR_LEFT, leftState);
    setIndicatorLightState(vehicleid, INDICATOR_RIGHT, rightState);
}

/**
 * Switch vehicle RIGHT Indicator Light
 * @param  {int} playerid
 */
function switchRightLight(playerid) {
    if ( !isPlayerInVehicle(playerid) ) {
        return;
    }
    local vehicleid = getPlayerVehicle(playerid);
    local rightState = getIndicatorLightState(vehicleid, INDICATOR_RIGHT);

    setIndicatorLightState(vehicleid, INDICATOR_RIGHT, !rightState);
    setIndicatorLightState(vehicleid, INDICATOR_LEFT, false);
}

/**
 * Switch vehicle LEFT Indicator Light
 * @param  {int} playerid
 */
function switchLeftLight(playerid) {
    if ( !isPlayerInVehicle(playerid) ) {
        return;
    }
    local vehicleid = getPlayerVehicle(playerid);
    local leftState = getIndicatorLightState(vehicleid, INDICATOR_LEFT);

    setIndicatorLightState(vehicleid, INDICATOR_LEFT, !leftState);
    setIndicatorLightState(vehicleid, INDICATOR_RIGHT, false);
}
