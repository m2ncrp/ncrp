
local vehiclesPositions = {};

event("onServerSecondChange", function() {
    foreach (vehicleid, object in __vehicles) {

        if (isVehicleEmpty(vehicleid)) continue;

        if(!(vehicleid in vehiclesPositions)) {
            vehiclesPositions[vehicleid] <- getVehiclePositionObj(vehicleid);
        }

        local veh = getVehicleEntity(vehicleid);

        if(veh == null) {
            continue;
        }

        if(("mileage" in veh.data) == false) {
            veh.data.mileage <- 0;
        }

        local currentPosition = getVehiclePositionObj(vehicleid);
        local distance = getDistanceBetweenPoints2D(vehiclesPositions[vehicleid].x, vehiclesPositions[vehicleid].y, currentPosition.x, currentPosition.y);
        vehiclesPositions[vehicleid] = currentPosition;
        veh.data.mileage += distance;

    }
});

function getVehicleMileage(vehicleid) {

    if(!!__vehicles[vehicleid].entity == false || ("mileage" in __vehicles[vehicleid].entity.data) == false) {
        return 0;
    }

    return __vehicles[vehicleid].entity.data.mileage;
}
