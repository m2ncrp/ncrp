local old__getVehicleEngineState = getVehicleEngineState;
local old__setVehicleEngineState = setVehicleEngineState;
const VEHICLE_ENGINE_TEMPERATURE_STEP_WINTER = 1.67;
const VEHICLE_ENGINE_TEMPERATURE_STEP_SUMMER = 0.56;

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

/**
 * Check if vehicle engine is started
 * @param  {int}  vehicleid
 * @return {Boolean}
 */
function isVehicleEngineStarted(vehicleid) {
    return (getVehicleEngineState(vehicleid) ? true : false);
}

event("onServerMinuteChange", function() {
    foreach (vehicleid, object in __vehicles) {
        local veh = getVehicleEntity(vehicleid);
        if(!veh) continue;
        local temperature = veh.data.parts.engine.temperature;
        local step = isSummer() ? VEHICLE_ENGINE_TEMPERATURE_STEP_SUMMER : VEHICLE_ENGINE_TEMPERATURE_STEP_WINTER;
        if (isVehicleEngineStarted(vehicleid)) {
            veh.data.parts.engine.temperature = 100;
        } else if ((temperature - step) > 0) {
            veh.data.parts.engine.temperature -= step;
        } else {
            veh.data.parts.engine.temperature = 0;
        }
    }
});