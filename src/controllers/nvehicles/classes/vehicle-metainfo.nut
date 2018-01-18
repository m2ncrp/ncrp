/**
 * Table that include all meta data about vehicle model.
 * max_tank ~ maximum of the fuel tank capacity;
 * fuel_consumption_idle ~ how much fuel does running engine need while vehicle isn't moving;
 * fuel_consumprion_mode ~ how much fuel does engine need to move vehicle. Below you can see how it's calculate:
 *         isEngineRun = 1;
 *         consumption = isEngineRun * (ingame_consumtion + fuel_consumption_idle + speed * fuel_consumption_move);
 *     So new fuel level will be (calculate each minute):
 *         fuel -= consumption;
 *
 *      Example: fuel = 60; time = 5 min; ingame_consumption = 0.0063 * 100 = 0.63;
 *          consumption = 1 * (0.63 + 0.01 + 30.0 * 0.02) = 1.33; // 1 min
 *          consumption = 1 * (0.63 + 0.01 + 50.0 * 0.02) = 1.64; // 2 min
 *          consumption = 1 * (0.63 + 0.01 + 80.0 * 0.02) = 2.33; // 3 min
 *          consumption = 1 * (0.63 + 0.01 + 20.0 * 0.02) = 1.04; // 4 min
 *          consumption = 1 * (0.63 + 0.01 + 0.0 * 0.02)  = 0.64; // 5 min
 *          total_consumption = 6.98;
 *          fuel = 60 - 6.98 = 53.02; // After 5 minutes in game (~2.5 minules real)
 *      So full 60 gallons fuel tank will last for about 20 minutes or 40 minutes in game.
 *
 *      NOTE: Is there could be a bug? When player shut down engine on minute change it could skip all consumption
 *            calculations couse isEngineRun = 0 for a split of a second.
 *      The idia of cunsumprion calculation is to make vehicles much more expensive in use for players.
 *
 * seats ~ how many players could be placed as a passanger in dat vehicle model.
 *
 * Further enhancement:
 * - make speed buffes and debuffes to make vehicles little bit heavier especially if it's truck with trailer
 * - create vehicle links (means Hank B truck + trailer with fish or oil)
 * @type {Table}
 */
vehicleMetaData <- {
    model_0  = {
        names = ["ascot_baileys200_pha"],
            // Passanger meta data
        seats = 2,
            // Geometry meta data (relative positions from vehicle center)
        triggers = {
            front_left_wheel      = [ 1.2160, -1.6690],
            front_right_wheel     = [-1.1320, -1.6690],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.1320,  1.1520],
            rear_right_wheel      = [ 1.2800,  1.1520],
            hood                  = [-0.0280, -2.5850],
            trunk                 = [ 0.0990,  2.5090],
                // Doors
            front_left_door       = [ 1.1600,  0.0930],
            front_right_door      = [-1.1300,  0.0930],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
            // actual vel physical limit you could get drive full speed ahead
        velocity_limit = [120.0],
        heat_limit = null,
    },

    model_1  = {
        names = ["berkley_kingfisher_pha"],
        seats = 2,
        triggers = {
            front_left_wheel      = [ 1.2810, -1.7240],
            front_right_wheel     = [-1.2610, -1.7240],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [ 1.2620,  1.4080],
            rear_right_wheel      = [ 1.2670,  1.4080],
            hood                  = [-0.0520, -3.0330],
            trunk                 = [ 0.0810,  3.1130],
            front_left_door       = [ 1.3240, -0.1700],
            front_right_door      = [-1.2620, -0.1700],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity = [70.0],
        heat_limit = null,
    },

    model_2  = {
        names = ["fuel_tank"], // fuel trailer
        seats = 0,
        triggers = {
            front_left_wheel      = [ 1.7280,  2.9430],
            front_right_wheel     = [-1.6760,  2.9430],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [ 1.7200,  4.4400],
            rear_right_wheel      = [-1.7930,  4.4400],
            hood                  = null,
            trunk                 = null,
            front_left_door       = null,
            front_right_door      = null,
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity = [70.0],
        heat_limit = null,
    },

    model_3  = {
        names = ["gai_353_military_truck"],
        seats = 2,
        triggers = {
            front_left_wheel      = [ 1.3910, -2.7980],
            front_right_wheel     = [-1.3030, -2.7980],
            middle_left_wheel     = [ 1.4770,  1.3260],
            middle_right_wheel    = [-1.4690,  1.3260],
            rear_left_wheel       = [ 1.4660,  2.5990],
            rear_right_wheel      = [-1.5990,  2.5900],
            hood                  = [-0.0530, -3.6930],
            trunk                 = [ 0.0530,  4.0660],
            front_left_door       = [ 1.2590, -1.2020],
            front_right_door      = [-1.2890, -1.2020],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity = [70.0],
        heat_limit = null,
    },

    model_4  = {
        names = ["hank_b"],
        seats = 2,
        triggers = {
            front_left_wheel      = [ 1.6180, -3.0280],
            front_right_wheel     = [-1.6360, -3.0280],
            middle_left_wheel     = [ 1.5220,  1.6770],
            middle_right_wheel    = [-1.5250,  1.6770],
            rear_left_wheel       = [ 1.5720,  3.1370],
            rear_right_wheel      = [-1.6380,  3.1370],
            hood                  = null,
            trunk                 = [-0.0500, -4.2000],
            front_left_door       = [ 1.5820, -1.4890],
            front_right_door      = [-1.6750, -1.4890],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity = [70.0],
        heat_limit = null,
    },

    model_5  = {
        names = ["hank_fueltank"],
        seats = 2,
        triggers = {
            front_left_wheel      = [ 1.6180, -4.0060],
            front_right_wheel     = [-1.6180, -3.8680],
            middle_left_wheel     = [ 1.6800,  2.0590],
            middle_right_wheel    = [-1.6340,  2.0590],
            rear_left_wheel       = [ 1.6810,  3.5630],
            rear_right_wheel      = [-1.6340,  3.5630],
            hood                  = null,
            trunk                 = [-0.0360, -5.1640],
            front_left_door       = [ 1.5800, -2.3970],
            front_right_door      = [-1.6430, -2.3970],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_6  = {
        names = ["hot_rod_1"],
        seats = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity = [70.0],
        heat_limit = null,
    },

    model_7  = {
        names = ["hot_rod_2"],
        seats = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity = [70.0],
        heat_limit = null,
    },

    model_8  = {
        names = ["hot_rod_3"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },


    model_9  = {
        names = ["houston_wasp_pha"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_10 = {
        names = ["isw_508"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_11 = {
        names = ["jeep"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_12 = {
        names = ["jeep_civil"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_13 = {
        names = ["jefferson_futura_pha"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_14 = {
        names = ["jefferson_provincial"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_15 = {
        names = ["lassiter_69"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_16 = {
        names = ["lassiter_69_destr"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_17 = {
        names = ["lassiter_75_fmv"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_18 = {
        names = ["lassiter_75_pha"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_19 = {
        names = ["milk_truck"],
        seats                 = 1,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_20 = {
        names = ["parry_bus"],
        seats                 = 1,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_21 = {
        names = ["parry_prison"],
        seats                 = 1,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_22 = {
        names = ["potomac_indian"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_23 = {
        names = ["quicksilver_windsor_pha"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_24 = {
        names = ["quicksilver_windsor_taxi_pha"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_25 = {
        names = ["shubert_38"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_26 = {
        names = ["shubert_38_destr"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_27 = {
        names = ["shubert_armoured"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_28 = {
        names = ["shubert_beverly"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_29 = {
        names = ["shubert_frigate_pha"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_30 = {
        names = ["shubert_hearse"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_31 = {
        names = ["shubert_panel"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_32 = {
        names = ["shubert_panel_m14"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_33 = {
        names = ["shubert_taxi"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_34 = {
        names = ["shubert_truck_cc"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_35 = {
        names = ["shubert_truck_ct"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_36 = {
        names = ["shubert_truck_ct_cigar"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_37 = {
        names = ["shubert_truck_qd"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_38 = {
        names = ["shubert_truck_sg"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_39 = {
        names = ["shubert_truck_sp"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_40 = {
        names = ["sicily_military_truck"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_41 = {
        names = ["smith_200_pha"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_42 = {
        names = ["smith_200_p_pha"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_43 = {
        names = ["smith_coupe"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_44 = {
        names = ["smith_mainline_pha"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_45 = {
        names = ["smith_stingray_pha"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_46 = {
        names = ["smith_truck"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_47 = {
        names = ["smith_v8"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_48 = {
        names = ["smith_wagon_pha"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_49 = {
        names = ["trailer"],
        seats                 = 0,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_50 = {
        names = ["ulver_newyorker"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_51 = {
        names = ["ulver_newyorker_p"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_52 = {
        names = ["walker_rocket"],
        seats                 = 4,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_53 = {
        names = ["walter_coupe"],
        seats                 = 2,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },
};

function getVehicleMeta(modelid) {
    return vehicleMetaData["model_" + modelid];
}

function getVehicleNameByModelId(modelid) {
    return vehicleMetaData["model_" + modelid].names[0];
}

function getVehicleSeatsNumberByModelId(modelid) {
    return vehicleMetaData["model_" + modelid].seats;
}


function getTrunkDefaultSizeX(modelid) {
    return vehicleMetaData["model_" + modelid].trunk.gridSizeX;
}

function getTrunkDefaultSizeY(modelid) {
    return vehicleMetaData["model_" + modelid].trunk.gridSizeY;
}

function getTrunkDefaultWeightLimit(modelid) {
    return vehicleMetaData["model_" + modelid].trunk.weightLimit;
}
