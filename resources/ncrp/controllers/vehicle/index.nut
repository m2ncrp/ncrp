include("controllers/vehicle/functions.nut");
include("controllers/vehicle/commands.nut");
include("controllers/vehicle/hiddencars.nut");

addEventHandler("onScriptInit", function() {
    // police cars
    addVehicleOverride(42, function(id) {
        setVehicleColour(id, 255, 255, 255, 0, 0, 0);
        setVehicleSirenState(id, false);
        // setVehicleBeaconLight(id, false);
    });

    addVehicleOverride(51, function(id) {
        setVehicleColour(id, 0, 0, 0, 150, 150, 150);
        setVehicleSirenState(id, false);
        // setVehicleBeaconLight(id, false);
    });

    // trucks
    addVehicleOverride(range(34, 39), function(id) {
        setVehicleColour(id, 255, 255, 255, 0, 0, 0);
    });

    // armoured lassister 75
    addVehicleOverride(17, function() {
        setVehicleColour(id, 0, 0, 0, 0, 0, 0);
    });

    // milk
    addVehicleOverride(19, function() {
        setVehicleColour(id, 160, 160, 130, 50, 230, 50);
    });
});

// binding events
addEventHandlerEx("onServerStarted", function() {
    log("[vehicles] starting...");

    // load all vehicles from db
    Vehicle.findAll(function(err, results) {
        foreach (idx, vehicle in results) {
            // create vehicle
            local vehicleid = createVehicle(vehicle.modelid, vehicle.x, vehicle.y, vehicle.z, vehicle.rx, vehicle.ry, vehicle.rz);

            // load all the data
            setVehicleColour(vehicleid, vehicle.cra, vehicle.cga, vehicle.cba, vehicle.crb, vehicle.cgb, vehicle.cbb);
            setVehicleRotation(vehicleid, vehicle.rx, vehicle.ry, vehicle.rz);
            setVehicleRespawnEx(vehicleid, false);
            setVehicleTuningTable(vehicleid, vehicle.tuning);
        }
    });
});

addEventHandlerEx("onServerTimeMinute", function() {
    checkVehicleRespawns();
});

addEventHandler("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    resetVehicleRespawnTimer(vehicleid);
});

// addEventHandler("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
//     // do nothing
// });

// clearing all vehicles on server stop
addEventHandlerEx("onServerStopping", function() {
    destroyAllVehicles();
});
