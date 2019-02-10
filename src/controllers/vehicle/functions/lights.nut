/**
 * Switch vehicle FRONT lights
 * @param  {int} vehicleid
 */
function switchLights(vehicleid) {
    local prevState = getVehicleLightState( vehicleid );
    setVehicleLightState( vehicleid, !prevState );
}

/**
 * Switch vehicle BOTH Indicator Light
 * @param  {int} vehicleid
 */
function switchBothLight(vehicleid) {

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
 * @param  {int} vehicleid
 */
function switchRightLight(vehicleid) {
    local rightState = getIndicatorLightState(vehicleid, INDICATOR_RIGHT);

    setIndicatorLightState(vehicleid, INDICATOR_RIGHT, !rightState);
    setIndicatorLightState(vehicleid, INDICATOR_LEFT, false);
}

/**
 * Switch vehicle LEFT Indicator Light
 * @param  {int} vehicleid
 */
function switchLeftLight(vehicleid) {
    local leftState = getIndicatorLightState(vehicleid, INDICATOR_LEFT);

    setIndicatorLightState(vehicleid, INDICATOR_LEFT, !leftState);
    setIndicatorLightState(vehicleid, INDICATOR_RIGHT, false);
}
