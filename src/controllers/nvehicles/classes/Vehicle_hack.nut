vehicle_info <- [
    [0,  60.0,  "ascot_baileys200_pha"          , 5650, 2200, 1300],
    [1,  90.0,  "berkley_kingfisher_pha"        , 5650, 2200, 1300],//        price: $4,483
    [2,  50.0,  "fuel_tank"                     , 5650, 3000, null],
    [3,  200.0, "gai_353_military_truck"        , 5650, 3600, 2200],
    [4,  200.0, "hank_b"                        , 5650, 3600, 2200],
    [5,  200.0, "hank_fueltank"                 , 5650, 3600, 2200],
    [6,  70.0,  "hot_rod_1"                     , 5650, 2200, 1300],
    [7,  70.0,  "hot_rod_2"                     , 5650, 2200, 1300],
    [8,  70.0,  "hot_rod_3"                     , 5650, 2200, 1300],
    [9,  70.0,  "houston_wasp_pha"              , 5650, 2200, 1300],//              price: 2,543 to $3,099
    [10, 70.0,  "isw_508"                       , 3720, 2200, 1300],
    [11, 58.0,  "jeep"                          , 5650, 2200, 1300],
    [12, 58.0,  "jeep_civil"                    , 5650, 2200, 1300],
    [13, 90.0,  "jefferson_futura_pha"          , 5650, 2200, 1300],
    [14, 70.0,  "jefferson_provincial"          , 5650, 2200, 1300],//          price: 4,662
    [15, 90.0,  "lassiter_69"                   , 5650, 2200, 1300],
    [16, 90.0,  "lassiter_69_destr"             , 5650, 2200, 1300],
    [17, 90.0,  "lassiter_75_fmv"               , 5650, 2200, 1300],
    [18, 90.0,  "lassiter_75_pha"               , 5650, 2200, 1300],
    [19, 80.0,  "milk_truck"                    , 5650, 2200, 1300],
    [20, 150.0, "parry_bus"                     , 5650, 3600, 2200],
    [21, 150.0, "parry_prison"                  , 5650, 3600, 2200],
    [22, 70.0,  "potomac_indian"                , 5650, 2200, 1300],
    [23, 60.0,  "quicksilver_windsor_pha"       , 5650, 2200, 1300],
    [24, 60.0,  "quicksilver_windsor_taxi_pha"  , 5650, 2200, 1300],
    [25, 65.0,  "shubert_38"                    , 5650, 2200, 1300],
    [26, 65.0,  "shubert_38_destr"              , 5650, 2200, 1300],
    [27, 100.0, "shubert_armoured"              , 5650, 3000, 1400],
    [28, 80.0,  "shubert_beverly"               , 5650, 2200, 1300],
    [29, 70.0,  "shubert_frigate_pha"           , 5650, 2200, 1300],
    [30, 65.0,  "shubert_hearse"                , 5650, 2200, 1300],
    [31, 65.0,  "shubert_panel"                 , 5650, 2200, 1300],
    [32, 65.0,  "shubert_panel_m14"             , 5650, 2200, 1300],
    [33, 65.0,  "shubert_taxi"                  , 5650, 2200, 1300],
    [34, 100.0, "hubert_truck_cc"               , 5650, 3600, 2200],
    [35, 100.0, "shubert_truck_ct"              , 5650, 3600, 2200],
    [36, 100.0, "shubert_truck_ct_cigar"        , 5650, 3600, 2200],
    [37, 100.0, "shubert_truck_qd"              , 5650, 3600, 2200],
    [38, 100.0, "shubert_truck_sg"              , 5650, 3600, 2200],
    [39, 100.0, "shubert_truck_sp"              , 5650, 3600, 2200],
    [40, 80.0,  "sicily_military_truck"         , 5650, 3600, 2200],
    [41, 80.0,  "smith_200_pha"                 , 5650, 2200, 1300],
    [42, 80.0,  "smith_200_p_pha"               , 5650, 2200, 1300],
    [43, 50.0,  "smith_coupe"                   , 5650, 2200, 1300],//                   price: 450
    [44, 65.0,  "smith_mainline_pha"            , 5650, 2200, 1300],
    [45, 70.0,  "smith_stingray_pha"            , 5650, 2200, 1300],
    [46, 80.0,  "smith_truck"                   , 5650, 3600, 2200],
    [47, 65.0,  "smith_v8"                      , 5650, 2200, 1300],
    [48, 50.0,  "smith_wagon_pha"               , 5650, 2200, 1300],//               price: 1500
    [49, 50.0,  "trailer"                       , 5650, 3000, null],
    [50, 70.0,  "ulver_newyorker"               , 5650, 2200, 1300],
    [51, 70.0,  "ulver_newyorker_p"             , 5650, 2200, 1300],
    [52, 80.0,  "walker_rocket"                 , 5650, 2200, 1300],
    [53, 40.0,  "walter_coupe"                  , 5650, 2200, 1200]
];

function getDefaultVehicleFuel(model) {
    return vehicle_info[model][1];
}



class DirtyHack {
    veh = null;
    model = null;
    engine_timing = [];

    function getEnterEngineTiming() {
        return vehicle_info[this.veh.vehicleid][1]; //vehicle_info[this.model][3];
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
        //this.model = vehicle.components.findOne(VehicleComponent.Hull).getModel;

        engine_timing = [
            getEnterEngineTiming(),
            getExitEngineTiming(),  // if player will close the door on exit a vehicle
            getOffset()             // in case if player won't close the door
        ];
    }

    function __OnExit(vehicle) {
        vehicle.correct();
    }

    function OnEnter(seat) {
        // hack in hack: without this little trick script'll throw error that veh is undefined in delayedFunction
        local v = this.veh;
        local callback = __OnExit;

        delayedFunction( engine_timing[0], function () {
            log("------------------> Done!");
            callback(v);
        });
        callback(veh);

        // veh.engine.correct();
        // veh.lights.correct();
        // veh.gabarites.correct();
    }

    function OnExit(seat) {
        // hack in hack: without this little trick script'll throw error that veh is undefined in delayedFunction
        local v = this.veh;
        local callback = __OnExit;

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



// key("w", function(playerid) {
//     if (!isPlayerInVehicle(playerid)) {
//         return;
//     }

//     local eng = vehicles[0].components.findOne(VehicleComponent.Engine);
//     dbg(eng);
//     if (!eng.data.status) {
//         setVehicleFuel(eng.parent.vehicleid, 0.0);
//         return false;
//     }
//     return true;
// });
