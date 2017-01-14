const VEHICLE_DIRT_STEP = 0.0041;

event("onServerMinuteChange", function() {
    foreach (vehicleid, object in __vehicles) {
        if (isVehicleEmpty(vehicleid)) continue;
        local speed = getVehicleSpeed(vehicleid);

        if (speed[0] > 1.0 && speed[1] > 1.0 && __vehicles[vehicleid].dirt <= 1.0) {
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
