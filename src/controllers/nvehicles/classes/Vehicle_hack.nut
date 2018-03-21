vehicle_info <- [
    [0,  52.0,  "ascot_baileys200_pha"          , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [1,  78.0,  "berkley_kingfisher_pha"        , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],//        price: $4,483
    [2,  0.0,   "fuel_tank"                     , 5650, 3000, null, 3, 0.05, 0.1, 3, 3, 10],
    [3,  180.0, "gai_353_military_truck"        , 5650, 3600, 2200, 2, 0.05, 0.1, 3, 3, 10],
    [4,  180.0, "hank_b"                        , 5650, 3600, 2200, 5, 0.05, 0.1, 3, 3, 10],
    [5,  180.0, "hank_fueltank"                 , 5650, 3600, 2200, 5, 0.05, 0.1, 3, 3, 10],
    [6,  64.0,  "hot_rod_1"                     , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [7,  64.0,  "hot_rod_2"                     , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [8,  64.0,  "hot_rod_3"                     , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [9,  65.0,  "houston_wasp_pha"              , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],//              price: 2,543 to $3,099
    [10, 65.0,  "isw_508"                       , 3720, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [11, 54.0,  "jeep"                          , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [12, 54.0,  "jeep_civil"                    , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [13, 83.0,  "jefferson_futura_pha"          , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [14, 65.0,  "jefferson_provincial"          , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],//          price: 4,662
    [15, 84.0,  "lassiter_69"                   , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [16, 84.0,  "lassiter_69_destr"             , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [17, 85.0,  "lassiter_75_fmv"               , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [18, 85.0,  "lassiter_75_pha"               , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [19, 75.0,  "milk_truck"                    , 5650, 2200, 1300, 2, 0.05, 0.1, 3, 3, 10],
    [20, 142.0, "parry_bus"                     , 5650, 3600, 2200, 4, 0.05, 0.1, 3, 3, 10],
    [21, 142.0, "parry_prison"                  , 5650, 3600, 2200, 4, 0.05, 0.1, 3, 3, 10],
    [22, 50.0,  "potomac_indian"                , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [23, 55.0,  "quicksilver_windsor_pha"       , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [24, 55.0,  "quicksilver_windsor_taxi_pha"  , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [25, 60.0,  "shubert_38"                    , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [26, 60.0,  "shubert_38_destr"              , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [27, 100.0, "shubert_armoured"              , 5650, 3000, 1400, 2, 0.05, 0.1, 3, 3, 10],
    [28, 75.0,  "shubert_beverly"               , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [29, 65.0,  "shubert_frigate_pha"           , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [30, 60.0,  "shubert_hearse"                , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [31, 60.0,  "shubert_panel"                 , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 4, 15],
    [32, 60.0,  "shubert_panel_m14"             , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 4, 15],
    [33, 60.0,  "shubert_taxi"                  , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [34, 93.0,  "hubert_truck_cc"               , 5650, 3600, 2200, 2, 0.05, 0.1, 3, 3, 10],
    [35, 93.0,  "shubert_truck_ct"              , 5650, 3600, 2200, 2, 0.05, 0.1, 3, 3, 10],
    [36, 93.0,  "shubert_truck_ct_cigar"        , 5650, 3600, 2200, 2, 0.05, 0.1, 3, 3, 10],
    [37, 93.0,  "shubert_truck_qd"              , 5650, 3600, 2200, 2, 0.05, 0.1, 3, 3, 10],
    [38, 93.0,  "shubert_truck_sg"              , 5650, 3600, 2200, 2, 0.05, 0.1, 3, 3, 10],
    [39, 93.0,  "shubert_truck_sp"              , 5650, 3600, 2200, 2, 0.05, 0.1, 3, 3, 10],
    [40, 75.0,  "sicily_military_truck"         , 5650, 3600, 2200, 2, 0.05, 0.1, 3, 3, 10],
    [41, 75.0,  "smith_200_pha"                 , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [42, 75.0,  "smith_200_p_pha"               , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [43, 47.0,  "smith_coupe"                   , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],//                   price: 450
    [44, 63.0,  "smith_mainline_pha"            , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [45, 65.0,  "smith_stingray_pha"            , 5650, 2200, 1300, 0, 0.05, 0.1, 3, 3, 10],
    [46, 75.0,  "smith_truck"                   , 5650, 3600, 2200, 2, 0.05, 0.1, 3, 3, 10],
    [47, 60.0,  "smith_v8"                      , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [48, 47.0,  "smith_wagon_pha"               , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],//               price: 1500
    [49, 0.0,   "trailer"                       , 5650, 3000, null, 3, 0.05, 0.1, 3, 3, 10],
    [50, 65.0,  "ulver_newyorker"               , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [51, 65.0,  "ulver_newyorker_p"             , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [52, 75.0,  "walker_rocket"                 , 5650, 2200, 1300, 1, 0.05, 0.1, 3, 3, 10],
    [53, 38.0,  "walter_coupe"                  , 5650, 2200, 1200, 0, 0.05, 0.1, 3, 3, 10]
];

function getDefaultVehicleFuelForModel(model) {
    return vehicle_info[model][1];
}

function getModelType(model) {
    return vehicle_info[model][6];
}

function getDefaltEngineConsumptionInIDLE(model) {
    return vehicle_info[model][7];
}

function getDefaltEngineConsumptionInMOVE(model) {
    return vehicle_info[model][8];
}

// function getTrunkDefaultSizeX(model) {
//     return vehicle_info[model][9];
// }

// function getTrunkDefaultSizeY(model) {
//     return vehicle_info[model][10];
// }

// function getTrunkDefaultWeightLimit(model) {
//     return vehicle_info[model][11];
// }

class DirtyHack {
    veh = null;
    model = null;
    engine_timing = [];

    function getEnterEngineTiming() {
        return vehicle_info[this.model][1]; //vehicle_info[this.model][3];
    }

    function getExitEngineTiming() {
        return 3600; //vehicle_info[this.model][4];
    }

    function isOffsetDefined() {
        return 2200; //vehicle_info[this.model][5] != null;
    }

    function getOffset() {
        return 2200; //vehicle_info[this.model][5];
    }

    constructor(vehicle) {
        this.veh = vehicle;
        this.model = vehicle.components.findOne(VehicleComponent.Hull).getModel();

        engine_timing = [
            getEnterEngineTiming(),
            getExitEngineTiming(),  // if player will close the door on exit a vehicle
            getOffset()             // in case if player won't close the door
        ];
    }

    function __onExit(vehicle) {
        vehicle.correct();
    }

    function onEnter(seat) {
        // hack in hack: without this little trick script'll throw error that veh is undefined in delayedFunction
        local v = this.veh;
        local callback = __onExit;

        delayedFunction( engine_timing[0], function () {
            log("------------------> Done!");
            callback(v);
        });
        callback(veh);
    }

    function onExit(seat) {
        // hack in hack: without this little trick script'll throw error that veh is undefined in delayedFunction
        local v = this.veh;
        local callback = __onExit;

        // in case that play fast forward the exit process there's two dalayed functions
        delayedFunction( engine_timing[1], function () {
            log("------------------> Done? [1]");
            callback(v);
        });

        delayedFunction( engine_timing[2], function () {
            log("------------------> Done? [2]");
            callback(v);
        });
        callback(veh);
    }
}


key("f", function(playerid) {
    local vehicle = vehicles.nearestVehicle(playerid);
    local model = vehicle.getComponent(VehicleComponent.Hull).getModel();
    local doors = getVehicleDoorsPosition(model);

    onVehicleDoorTriggerPosition(playerid,
                                vehicle.vehicleid,
                                doors,
        function (playerid, vehicleid, door) {
            // there's natives won't affect on wrapper at all
            // so all should work as it should be working
            setVehicleFuel(vehicleid, getVehicleFuel(vehicleid) + 0.1);
            setVehicleEngineState( vehicleid, true );
            setVehicleLightState(vehicleid, false);
            delayedFunction( 150, function () {
                setVehicleEngineState( vehicleid, false );
            });
        });
});

// полицейская люстра
key("3", function(playerid) {
    local vehicle = vehicles.nearestVehicle(playerid);
    local model = vehicle.getComponent(VehicleComponent.Hull).getModel();

    // if (model != 51 || model != 42) return;

    setVehicleBeaconLightState( vehicle.vehicleid, true );
});

key("4", function(playerid) {
    local vehicle = vehicles.nearestVehicle(playerid);
    local model = vehicle.getComponent(VehicleComponent.Hull).getModel();

    // if (model != 51 || model != 42) return;

    setVehicleBeaconLightState( vehicle.vehicleid, false );
});


function serverPulseEvent() {
    foreach (idx, veh in vehicles) {
        if (veh.isEmpty)
            veh.correct();
    }
    return 1;
}
addEventHandler( "onServerPulse", serverPulseEvent );
