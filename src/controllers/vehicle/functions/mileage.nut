
local vehiclesPositions = {};

event("onServerSecondChange", function() {
    foreach (vehicleid, object in __vehicles) {

        if (isVehicleEmpty(vehicleid)) continue;

        local id = vehicleid;
        if(!(vehicleid in vehiclesPositions)) {
            vehiclesPositions[vehicleid] <- getVehiclePositionObj(vehicleid);
        }

        if(__vehicles[vehicleid].entity == null) {
            continue;
        }

        if(__vehicles[vehicleid].entity && __vehicles[vehicleid].entity && ("mileage" in __vehicles[vehicleid].entity.data) == false) {
            __vehicles[vehicleid].entity.data.mileage <- 0;
        }

        local currentPosition = getVehiclePositionObj(vehicleid);
        local distance = getDistanceBetweenPoints2D(vehiclesPositions[vehicleid].x, vehiclesPositions[vehicleid].y, currentPosition.x, currentPosition.y);
        vehiclesPositions[vehicleid] = currentPosition;
        __vehicles[vehicleid].entity.data.mileage += distance;


    }
});


/*
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
*/

/*
        local speed = getVehicleSpeed(vehicleid);

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

 */
