include("controllers/vehicle/functions");
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
    addVehicleOverride(17, function(id) {
        setVehicleColour(id, 0, 0, 0, 0, 0, 0);
    });

    // milk
    addVehicleOverride(19, function(id) {
        setVehicleColour(id, 160, 160, 130, 50, 230, 50);
    });
});

// binding events
addEventHandlerEx("onServerStarted", function() {
    log("[vehicles] starting...");
    local counter = 0;

    // load all vehicles from db
    Vehicle.findAll(function(err, results) {
        foreach (idx, vehicle in results) {
            // create vehicle
            local vehicleid = createVehicle(vehicle.model, vehicle.x, vehicle.y, vehicle.z, vehicle.rx, vehicle.ry, vehicle.rz);

            // load all the data
            setVehicleColour(vehicleid, vehicle.cra, vehicle.cga, vehicle.cba, vehicle.crb, vehicle.cgb, vehicle.cbb);
            setVehicleRotation(vehicleid, vehicle.rx, vehicle.ry, vehicle.rz);
            setVehicleTuningTable(vehicleid, vehicle.tunetable);
            setVehicleDirtLevel(vehicleid, vehicle.dirtlevel);
            setVehicleFuel(vehicleid, vehicle.fuellevel);
            setVehiclePlateText(vehicleid, vehicle.plate);
            setVehicleOwner(vehicleid, vehicle.owner);

            // secial methods for custom vehicles
            setVehicleRespawnEx(vehicleid, false);
            setVehicleSaving(vehicleid, true);
            setVehicleEntity(vehicleid, vehicle);

            counter++;
        }

        log("[vehicles] loaded " + counter + " vehicles from database.");
    });
});

addEventHandlerEx("onServerMinuteChange", function() {
    updateVehiclePassengers();
    checkVehicleRespawns();
});

addEventHandlerEx("onServerAutosave", function() {
    saveAllVehicles();
});

addEventHandler("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    addVehiclePassenger(vehicleid, playerid);
    resetVehicleRespawnTimer(vehicleid);
    trySaveVehicle(vehicleid);
});

addEventHandler("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    removeVehiclePassenger(vehicleid, playerid);
    trySaveVehicle(vehicleid);
});

// clearing all vehicles on server stop
addEventHandlerEx("onServerStopping", function() {
    destroyAllVehicles();
});
