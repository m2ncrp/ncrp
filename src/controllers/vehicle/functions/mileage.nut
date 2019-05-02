event("onServerSecondChange", function() {
    foreach (vehicleid, object in __vehicles) {
        if(!object || isVehicleEmpty(vehicleid)) continue;

        local veh = getVehicleEntity(vehicleid);

        if(veh == null) {
            continue;
        }

        if(("mileage" in veh.data) == false) {
            veh.data.mileage <- 0;
        }

        local distance = getVehicleRealSpeed(vehicleid, "mps");
        veh.data.mileage += distance;
    }
});
