car1 <- null;
car2 <- null;
event("onServerStarted", function() {
    car1 = createVehicle(1, -1567.36, -193.678, -20.1856, -92.0449, 0.223556, 3.04026);
    car2 = createVehicle(1, -1558.82, -193.678, -20.2218, -92.0449, 0.223556, 3.04026);
});

local rotationQueue = [];
event("onServerPulse", function() {
    if (car1 && car2) {

        rotationQueue.push( [getVehiclePosition(car1), getVehicleRotation(car1), getVehicleSpeed(car1) ]); // push as last elelemt of queue (end)
        //local vehSpeed = getVehicleSpeed(car1);
        if (rotationQueue.len() < 150) return;
        local veh = rotationQueue[0]; // get first element of queue (beginning)
        rotationQueue.remove(0); // remove first element of queue (beginning)
        local car1Pos = getVehiclePosition(car1);
        if (! checkDistanceXYZ(car1Pos[0], car1Pos[1], car1Pos[2], veh[0][0], veh[0][1], veh[0][2], 10.0)) {
            setVehiclePosition(car2, veh[0][0], veh[0][1], veh[0][2]);
        }
        if (! checkDistanceXYZ(car1Pos[0], car1Pos[1], car1Pos[2], veh[0][0], veh[0][1], veh[0][2], 5.0)) {
            setVehicleRotation(car2, veh[1][0], veh[1][1], veh[1][2]);
            setVehicleSpeed(car2, veh[2][0], veh[2][1], veh[2][2]);
        } else {
            setVehicleSpeed(car2, 0.0, 0.0, 0.0);
        }

    }
});
