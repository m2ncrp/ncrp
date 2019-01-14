
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
