include("controllers/vehicle/functions");
include("controllers/vehicle/commands.nut");
//include("controllers/vehicle/hiddencars.nut");

const VEHICLE_RESPAWN_TIME      = 600; // 10 minutes
const VEHICLE_FUEL_DEFAULT      = 40.0;
const VEHICLE_MIN_DIRT          = 0.25;
const VEHICLE_MAX_DIRT          = 0.75;
const VEHICLE_DEFAULT_OWNER     = "";
const VEHICLE_OWNERSHIP_NONE    = 0;
const VEHICLE_OWNERSHIP_SINGLE  = 1;

event("onScriptInit", function() {
    // police cars
    addVehicleOverride(42, function(id) {
        setVehicleColour(id, 255, 255, 255, 0, 0, 0);
        setVehicleSirenState(id, false);
        // setVehicleBeaconLight(id, false);
        setVehiclePlateText(id, getRandomVehiclePlate("PD"));
    });

    addVehicleOverride(51, function(id) {
        setVehicleColour(id, 0, 0, 0, 150, 150, 150);
        setVehicleSirenState(id, false);
        // setVehicleBeaconLight(id, false);
        // added override for plate number
        setVehiclePlateText(id, getRandomVehiclePlate("PD"));
    });

    // trucks
    addVehicleOverride(range(34, 39), function(id) {
        setVehicleColour(id, 30, 30, 30, 154, 154, 154);
    });

    // trucks fish
    addVehicleOverride(38, function(id) {
        setVehicleColour(id, 15, 32, 24, 80, 80, 80);
    });

    // armoured lassiter 75
    addVehicleOverride(17, function(id) {
        setVehicleColour(id, 0, 0, 0, 0, 0, 0);
    });

    // milk
    addVehicleOverride(19, function(id) {
        setVehicleColour(id, 154, 154, 154, 98, 26, 21);
    });
});

// binding events
event("onServerStarted", function() {
    log("[vehicles] starting...");
    local counter = 0;

    // load all vehicles from db
    Vehicle.findAll(function(err, results) {
        foreach (idx, vehicle in results) {
            // create vehicle
            local vehicleid = createVehicle( vehicle.model, vehicle.x, vehicle.y, vehicle.z, vehicle.rx, vehicle.ry, vehicle.rz );

            // load all the data
            setVehicleColour      ( vehicleid, vehicle.cra, vehicle.cga, vehicle.cba, vehicle.crb, vehicle.cgb, vehicle.cbb );
            setVehicleRotation    ( vehicleid, vehicle.rx, vehicle.ry, vehicle.rz );
            setVehicleTuningTable ( vehicleid, vehicle.tunetable );
            setVehicleDirtLevel   ( vehicleid, vehicle.dirtlevel );
            setVehicleFuel        ( vehicleid, vehicle.fuellevel );
            setVehiclePlateText   ( vehicleid, vehicle.plate );
            setVehicleOwner       ( vehicleid, vehicle.owner );

            // secial methods for custom vehicles
            setVehicleRespawnEx   ( vehicleid, false );
            setVehicleSaving      ( vehicleid, true );
            setVehicleEntity      ( vehicleid, vehicle );

            // block vehicle by default
            blockVehicle          ( vehicleid );

            local setWheelsGenerator = function(id, entity) {
                return function() {
                    setVehicleWheelTexture( id, 0, entity.fwheel );
                    setVehicleWheelTexture( id, 1, entity.rwheel );
                };
            };

            delayedFunction(1000, setWheelsGenerator(vehicleid, vehicle));
            counter++;
        }

        log("[vehicles] loaded " + counter + " vehicles from database.");
    });
});

// respawn cars and update passangers
event("onServerMinuteChange", function() {
    updateVehiclePassengers();
    checkVehicleRespawns();
});

// handle vehicle enter
event("native:onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    // handle vehicle passangers
    addVehiclePassenger(vehicleid, playerid);

    // check blocking
    if (getVehicleSaving(vehicleid) && seat == 0) {
        if (isPlayerVehicleOwner(playerid, vehicleid)) {
            unblockVehicle(vehicleid);
        } else {
            blockVehicle(vehicleid);
            msg(playerid, "vehicle.owner.warning", CL_WARNING);
        }
    }

    // handle respawning and saving
    resetVehicleRespawnTimer(vehicleid);
    trySaveVehicle(vehicleid);

    // trigger other events
    trigger("onPlayerVehicleEnter", playerid, vehicleid, seat);
});

// handle vehicle exit
event("native:onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    // handle vehicle passangers
    removeVehiclePassenger(vehicleid, playerid);

    // check blocking
    if (getVehicleSaving(vehicleid) && isPlayerVehicleOwner(playerid, vehicleid)) {
        blockVehicle(vehicleid);
    }

    // handle respawning and saving
    resetVehicleRespawnTimer(vehicleid);
    trySaveVehicle(vehicleid);

    // trigger other events
    trigger("onPlayerVehicleExit", playerid, vehicleid, seat);
});

// saving current vehicle data
event("onServerAutosave", function() {
    return saveAllVehicles();
});

// clearing all vehicles on server stop
event("onServerStopping", function() {
    return destroyAllVehicles();
});
