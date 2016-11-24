include("controllers/vehicle/functions");
include("controllers/vehicle/commands.nut");
include("controllers/vehicle/hiddencars.nut");

vehicle_tank <- [
    [0, 52], // ascot_baileys200_pha
    [1, 78], // berkley_kingfisher_pha
    [2, 0],  // fuel_tank
    [3, 180],// gai_353_military_truck
    [4, 180],// hank_b
    [5, 180],// hank_fueltank
    [6, 64], // hot_rod_1
    [7, 64], // hot_rod_2
    [8, 64], // hot_rod_3
    [9, 65], // houston_wasp_pha
    [10, 65],// isw_508
    [11, 54],// jeep
    [12, 54],// jeep_civil
    [13, 83],// jefferson_futura_pha
    [14, 65],// jefferson_provincial
    [15, 84],// lassiter_69
    [16, 84],// lassiter_69_destr
    [17, 85],// lassiter_75_fmv
    [18, 85],// lassiter_75_pha
    [19, 75],// milk_truck
    [20, 142],// parry_bus
    [21, 142],// parry_prison
    [22, 50],// potomac_indian
    [23, 55],// quicksilver_windsor_pha
    [24, 55],// quicksilver_windsor_taxi_pha
    [25, 60],// shubert_38
    [26, 60],// shubert_38_destr
    [27, 0],// shubert_armoured
    [28, 75],// shubert_beverly
    [29, 65],// shubert_frigate_pha
    [30, 60],// shubert_hearse
    [31, 60],// shubert_panel
    [32, 60],// shubert_panel_m14
    [33, 60],// shubert_taxi
    [34, 93],//shubert_truck_cc
    [35, 93],// shubert_truck_ct
    [36, 93],// shubert_truck_ct_cigar
    [37, 93],// shubert_truck_qd
    [38, 93],// shubert_truck_sg
    [39, 93],// shubert_truck_sp
    [40, 75],// sicily_military_truck
    [41, 75],// smith_200_pha
    [42, 75],// smith_200_p_pha
    [43, 47],// smith_coupe
    [44, 63],// smith_mainline_pha
    [45, 65],// smith_stingray_pha
    [46, 75],// smith_truck
    [47, 60],// smith_v8
    [48, 47],// smith_wagon_pha
    [49, 0], // trailer
    [50, 65],// ulver_newyorker
    [51, 65],// ulver_newyorker_p
    [52, 75],// walker_rocket
    [53, 38] // walter_coupe
];

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

            local setWheels = function(id, entity) {
                return function() {
                    setVehicleWheelTexture(id, 0, entity.fwheel);
                    setVehicleWheelTexture(id, 1, entity.rwheel);
                };
            };

            delayedFunction(1000, setWheels(vehicleid, vehicle));

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
