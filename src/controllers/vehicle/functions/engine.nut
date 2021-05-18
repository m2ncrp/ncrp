local old__getVehicleEngineState = getVehicleEngineState;
local old__setVehicleEngineState = setVehicleEngineState;

/**
 * Get engine state for vehicle by vehicleid
 * @param  {Integer} vehicleid
 * @return {Boolean} state OR 0 if vehicle not found
 */
function getVehicleEngineState(vehicleid) {
    if (vehicleid in __vehicles) {
        return __vehicles[vehicleid].engineState;
    }

    return false;
}

/**
 * Set engine state for vehicle by vehicleid
 * @param  {Integer} vehicleid
 * @return {Boolean} state OR 0 if vehicle not found
 */
function setVehicleEngineState (vehicleid, state) {
    if (vehicleid in __vehicles) {
        __vehicles[vehicleid].engineState = state;
        old__setVehicleEngineState(vehicleid, state);

        return true
    }

    return false;
}