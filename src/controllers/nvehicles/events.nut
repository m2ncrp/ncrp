event("onPlayerNVehicleEnter", function(character, vehicle, seat) {
    msg(character, "vehicle.tryStartEngine", CL_CASCADE);
});

//
// Begin: Prototype of mileage counter
//

local prevVehiclesPosition = {};

event("onServerStarted", function() {
    foreach (id, vehicle in vehicles) {
        prevVehiclesPosition[id] <- vehicle.getPosition();
        if (!("mileage" in vehicle.data)) {
            vehicle.setData("mileage", 0);
        }
    }
});

event("onServerSecondChange", function() {
    foreach (id, vehicle in vehicles) {
        if (!vehicle.isEmpty() && vehicle.isMoving()) {
            local newPos = vehicle.getPosition();
            vehicle.data.mileage += getDistanceBtwObjCoords( prevVehiclesPosition[id], newPos );
            prevVehiclesPosition[id] = newPos;
            dbg("Car ", id, "mileage")
        }
    }
});

cmd("mile", function(playerid) {
    local mil = getPlayerNVehicle(players[playerid]).data.mileage;
    msg(playerid, "Пробег: "+mil);
});

//
// End: Prototype of mileage counter
//
