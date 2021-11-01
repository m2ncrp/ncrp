const VEHICLE_DIRT_STEP = 0.0041;
const VEHICLE_ENGINE_TEMPERATURE_STEP_WINTER = 1.67;
const VEHICLE_ENGINE_TEMPERATURE_STEP_SUMMER = 0.56;

event("onServerMinuteChange", function() {
    foreach (vehicleid, object in __vehicles) {
        local veh = getVehicleEntity(vehicleid);
        if(!veh) continue;
        if (!("engine" in veh.data.parts)) {
            veh.data.parts.engine <- {"temperature": 0};
        }
        local temperature = veh.data.parts.engine.temperature;
        local step = isSummer() ? VEHICLE_ENGINE_TEMPERATURE_STEP_SUMMER : VEHICLE_ENGINE_TEMPERATURE_STEP_WINTER;
        if (isVehicleEngineStarted(vehicleid)) {
            veh.data.parts.engine.temperature = 100;
        } else if ((temperature - step) > 0) {
            veh.data.parts.engine.temperature -= step;
        } else {
            veh.data.parts.engine.temperature = 0;
        }
        local speed = getVehicleSpeed(vehicleid);
        if (isVehicleEmpty(vehicleid)) continue;
        if ((speed[0] > 1.0 || speed[1] > 1.0) && __vehicles[vehicleid].dirt <= 1.0) {
            __vehicles[vehicleid].dirt += VEHICLE_DIRT_STEP
        }

        // special override for winter vehicles
        if (getVehicleModel(vehicleid) == 43) {
            if (__vehicles[vehicleid].dirt > 0.5){
                __vehicles[vehicleid].dirt = 0.5;
            }
        }

        setVehicleDirtLevel(vehicleid, __vehicles[vehicleid].dirt);
    }
});

// override custom method
nativeSetVehicleDirtLevel <- setVehicleDirtLevel;

function setVehicleDirtLevel(vehicleid, level) {
    if (vehicleid in __vehicles) {
        __vehicles[vehicleid].dirt = level.tofloat();
    }

    return nativeSetVehicleDirtLevel(vehicleid, level.tofloat());
}

acmd("clear", function(playerid) {
    if (!isPlayerInVehicle(playerid)) return;

    setVehicleDirtLevel(getPlayerVehicle(playerid), 0.0);
});
