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
        names = ["ascot_baileys200_pha", "Ascot Bailey S200"],
            // Passanger meta data
        seats = 2,
            // Geometry meta data (relative positions from vehicle center)
        triggers = {
            front_left_wheel      = [-1.1320,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2160, -1.1500],
            rear_right_wheel      = [ 1.1320, -1.1500],
            hood                  = [ 0.0000,  2.5900],
            trunk                 = [ 0.0000, -2.5900],
                // Doors
            front_left_door       = [-1.1600, -0.2500],
            front_right_door      = [ 1.1300, -0.2500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
            // actual vel physical limit you could get drive full speed ahead
        engine = {
            top_speed_mph = [127.0,  127.0,  134.0],
            top_speed_kmh = [205.0, 205.0, 216.0],
        },
        weight_kg  = [856.0, 772.0, 772.0],
        heat_limit = null,
    },

    model_1  = {
        names = ["berkley_kingfisher_pha", "Berkley Kingfisher"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2600,  1.6000],
            front_right_wheel     = [ 1.2600,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6000],
            rear_right_wheel      = [ 1.2800, -1.6000],
            hood                  = [ 0.0000,  3.1000],
            trunk                 = [ 0.0000, -3.1000],
            front_left_door       = [-1.3100,  0.0000],
            front_right_door      = [ 1.3100,  0.0000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [106.0,  106.0,  106.0],
            top_speed_kmh = [170.0, 170.0, 180.0],
        },
        weight_kg  = [1957.0, 1760.0, 1760.0],
        heat_limit = null,
    },

    model_2  = {
        names = ["fuel_tank", "Fuel Tank"], // fuel trailer
        seats = 0,
        triggers = {
            front_left_wheel      = null,
            front_right_wheel     = null,
            middle_left_wheel     = [-1.7400, -3.0000],
            middle_right_wheel    = [ 1.7400, -3.0000],
            rear_left_wheel       = [-1.7400, -4.0000],
            rear_right_wheel      = [ 1.7400, -4.0000],
            hood                  = null,
            trunk                 = null,
            front_left_door       = null,
            front_right_door      = null,
            back_left_door        = null,
            back_right_door       = null,
            hook                  = [ 0.0000,  3.0000],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [70.0, 70.0, 70.0],
            top_speed_kmh = [112.0, 112.0, 112.0],
        },
        weight_kg  = [5520.0, 5520.0, 5520.0],
        heat_limit = null,
    },

    model_3  = {
        names = ["gai_353_military_truck", "GAI 353 Military Truck"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3900,  2.5900],
            front_right_wheel     = [ 1.3900,  2.5900],
            middle_left_wheel     = [-1.3900, -1.2500],
            middle_right_wheel    = [ 1.3900, -1.2500],
            rear_left_wheel       = [-1.3900, -2.6000],
            rear_right_wheel      = [ 1.3900, -2.6000],
            hood                  = [ 0.0000,  4.0000],
            trunk                 = [ 0.0000, -4.0000],
            front_left_door       = [-1.4700,  1.3300],
            front_right_door      = [ 1.4700,  1.3300],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [47.0, 47.0, 47.0],
            top_speed_kmh = [75.0, 75.0, 75.0],
        },
        weight_kg  = [5316.0, 5316.0, 5316.0],
        heat_limit = null,
    },

    model_4  = {
        names = ["hank_b", "Hank B"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.6000,  3.0000],
            front_right_wheel     = [ 1.6000,  3.0000],
            middle_left_wheel     = [-1.6000, -1.4890],
            middle_right_wheel    = [ 1.6000, -1.4890],
            rear_left_wheel       = [-1.6000, -3.0280],
            rear_right_wheel      = [ 1.6000, -3.0280],
            hood                  = [ 0.0000,  4.2000],
            trunk                 = null,
            front_left_door       = [-1.5500,  1.6000],
            front_right_door      = [ 1.5500,  1.6000],
            back_left_door        = null,
            back_right_door       = null,
            cargo_connector       = [ 0.0000, -2.2500],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [70.0, 70.0, 70.0],
            top_speed_kmh = [112.0, 112.0, 112.0],
        },
        weight_kg  = [5520.0, 5520.0, 5520.0],
        heat_limit = null,
    },

    model_5  = {
        names = ["hank_fueltank", "Hank B Fuel Tank"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.6500,  3.6000],
            front_right_wheel     = [ 1.6500,  3.6000],
            middle_left_wheel     = [-1.6500, -2.3500],
            middle_right_wheel    = [ 1.6500, -2.3500],
            rear_left_wheel       = [-1.6600, -3.5000],
            rear_right_wheel      = [ 1.6600, -3.5000],
            hood                  = [ 0.0000,  5.2000],
            trunk                 = null,
            front_left_door       = [-1.6800,  2.1000],
            front_right_door      = [ 1.6800,  2.1000],
            back_left_door        = null,
            back_right_door       = null,
            cargo                 = [ 0.0000, -5.2500],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [70.0, 70.0, 70.0],
            top_speed_kmh = [112.0, 112.0, 112.0],
        },
        weight_kg  = [12870.0, 12870.0, 12870.0],
        heat_limit = null,
    },

    model_6  = {
        names = ["hot_rod_1", "Walter Hot Rod"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.1320,  1.4000],
            front_right_wheel     = [ 1.2800,  1.4000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2160, -1.4000],
            rear_right_wheel      = [ 1.1320, -1.4000],
            hood                  = [ 0.0000,  2.5600],
            trunk                 = [ 0.0000, -2.5600],
                // Doors
            front_left_door       = [-1.1600,  0.0000],
            front_right_door      = [ 1.1300,  0.0000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [134.0, 143.0, 134.0],
            top_speed_kmh = [216.0, 230.0, 216.0],
        },
        weight_kg  = [1045.0, 1045.0, 1150.0],
        heat_limit = null,
    },

    model_7  = {
        names = ["hot_rod_2", "Smith 34 Hot Rod"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.1320,  1.4000],
            front_right_wheel     = [ 1.2800,  1.4000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2160, -1.6690],
            rear_right_wheel      = [ 1.1320, -1.6690],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [-1.2000, -0.5000],
            front_right_door      = [ 1.2000, -0.5000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [119.0, 126.0, 119.0],
            top_speed_kmh = [192.0, 203.0, 192.0],
        },
        weight_kg  = [612.0, 912.0, 1015.0],
        heat_limit = null,
    },

    model_8  = {
        names = ["hot_rod_3", "Shuber Pickup Hot Rod"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.1320,  1.4500],
            front_right_wheel     = [ 1.2800,  1.4500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2160, -1.6000],
            rear_right_wheel      = [ 1.1320, -1.6000],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [-1.1600, -0.1000],
            front_right_door      = [ 1.1300, -0.1000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [110.0, 110.0, 127.0],
            top_speed_kmh = [178.0, 178.0, 204.0],
        },
        weight_kg  = [1086.0, 1086.0, 978.0],
        heat_limit = null,
    },


    model_9  = {
        names = ["houston_wasp_pha", "Houston Wasp"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.4500],
            front_right_wheel     = [ 1.2800,  1.4500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6000],
            rear_right_wheel      = [ 1.2800, -1.6000],
            hood                  = [ 0.0000,  2.6400],
            trunk                 = [ 0.0000, -2.7000],
                // Doors
            front_left_door       = [-1.2800,  0.3200],
            front_right_door      = [ 1.2800,  0.3200],
            back_left_door        = [-1.2800, -0.5000],
            back_right_door       = [ 1.2800, -0.5000],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [104.0, 104.0, 110.0],
            top_speed_kmh = [168.0, 138.0, 177.0],
        },
        weight_kg  = [1636.0, 1470.0, 1470.0],
        heat_limit = null,
    },

    model_10 = {
        names = ["isw_508", "ISW 508"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2500,  1.3000],
            front_right_wheel     = [ 1.2500,  1.3000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2500, -1.4500],
            rear_right_wheel      = [ 1.2500, -1.4500],
            hood                  = [ 0.0000,  2.5500],
            trunk                 = [ 0.0000, -2.5500],
                // Doors
            front_left_door       = [-1.2500, -0.2500],
            front_right_door      = [ 1.2500, -0.2500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [120.0, 120.0, 132.0],
            top_speed_kmh = [194.0, 194.0, 221.0],
        },
        weight_kg  = [1315.0, 1215.0, 1215.0],
        heat_limit = null,
    },

    model_11 = {
        names = ["jeep", "Jeep"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.1520],
            front_right_wheel     = [ 1.2800,  1.1520],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2100, -1.1500],
            rear_right_wheel      = [ 1.2100, -1.1500],
            hood                  = [ 0.0000,  2.2000],
            trunk                 = [ 0.0000, -2.2000],
                // Doors
            front_left_door       = [-1.2800,  0.0000],
            front_right_door      = [ 1.2800,  0.0000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [72.0, 72.0, 94.0],
            top_speed_kmh = [116.0, 116.0, 151.0],
        },
        weight_kg  = [1040.0, 930.0, 930.0],
        heat_limit = null,
    },

    model_12 = {
        names = ["jeep_civil", "Jeep Civil"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.1520],
            front_right_wheel     = [ 1.2800,  1.1520],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2100, -1.1500],
            rear_right_wheel      = [ 1.2100, -1.1500],
            hood                  = [ 0.0000,  2.2000],
            trunk                 = [ 0.0000, -2.2000],
                // Doors
            front_left_door       = [-1.2800,  0.0000],
            front_right_door      = [ 1.2800,  0.0000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [72.0, 72.0, 94.0],
            top_speed_kmh = [116.0, 116.0, 151.0],
        },
        weight_kg  = [1040.0, 930.0, 930.0],
        heat_limit = null,
    },

    model_13 = {
        names = ["jefferson_futura_pha", "Jefferson Futura"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5000],
            rear_right_wheel      = [ 1.2800, -1.5000],
            hood                  = [ 0.0000,  2.7000],
            trunk                 = [ 0.0000, -2.7000],
                // Doors
            front_left_door       = [-1.2800,  0.0930],
            front_right_door      = [ 1.2800,  0.0930],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [121.0, 121.5, 132.0],
            top_speed_kmh = [198.0, 198.0, 216.0],
        },
        weight_kg  = [2475.0, 2215.0, 2215.0],
        heat_limit = null,
    },

    model_14 = {
        names = ["jefferson_provincial", "Jefferson Provincial"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6000],
            rear_right_wheel      = [ 1.2800, -1.6000],
            hood                  = [ 0.0000,  2.6500],
            trunk                 = [ 0.0000, -2.6500],
                // Doors
            front_left_door       = [-1.2800,  0.0500],
            front_right_door      = [ 1.2800,  0.0500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [97.0,  97.0,  113.0],
            top_speed_kmh = [156.0, 156.0, 182.0],
        },
        weight_kg  = [1620.0, 1480.0, 1480.0],
        heat_limit = null,
    },

    model_15 = {
        names = ["lassiter_69", "Lassiter 69"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5500],
            rear_right_wheel      = [ 1.2800, -1.5500],
            hood                  = [ 0.0000,  2.7000],
            trunk                 = [ 0.0000, -2.7000],
                // Doors
            front_left_door       = [-1.2800,  0.1500],
            front_right_door      = [ 1.2800,  0.1500],
            back_left_door        = [-1.2800, -0.6000],
            back_right_door       = [ 1.2800, -0.6000],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [107.0, 108.5, 117.0],
            top_speed_kmh = [172.0, 172.0, 188.0],
        },
        weight_kg  = [1873.0, 1680.0, 1680.0],
        heat_limit = null,
    },

    model_16 = {
        names = ["lassiter_69_destr", "Lassiter 69 Destroy"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5500],
            rear_right_wheel      = [ 1.2800, -1.5500],
            hood                  = [ 0.0000,  2.7000],
            trunk                 = [ 0.0000, -2.7000],
                // Doors
            front_left_door       = [-1.2800,  0.1500],
            front_right_door      = [ 1.2800,  0.1500],
            back_left_door        = [-1.2800, -0.6000],
            back_right_door       = [ 1.2800, -0.6000],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [107.0, 107.0, 117.0],
            top_speed_kmh = [172.0, 172.0, 188.0],
        },
        weight_kg  = [1873.0, 1680.0, 1680.0],
        heat_limit = null,
    },

    model_17 = {
        names = ["lassiter_75_fmv", "Lassiter 75 FMV"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.8500],
            front_right_wheel     = [ 1.2800,  1.8500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6700],
            rear_right_wheel      = [ 1.2800, -1.6700],
            hood                  = [ 0.0000,  2.9000],
            trunk                 = [ 0.0000, -2.9000],
                // Doors
            front_left_door       = [-1.2800,  0.2500],
            front_right_door      = [ 1.2800,  0.2500],
            back_left_door        = [-1.2800, -0.6100],
            back_right_door       = [ 1.2800, -0.6100],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [110.0, 110.0, 116.0],
            top_speed_kmh = [177.0, 177.0, 187.0],
        },
        weight_kg  = [2070.0, 1820.0, 1820.0],
        heat_limit = null,
    },

    model_18 = {
        names = ["lassiter_75_pha", "Lassiter 75"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.8500],
            front_right_wheel     = [ 1.2800,  1.8500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6700],
            rear_right_wheel      = [ 1.2800, -1.6700],
            hood                  = [ 0.0000,  2.9000],
            trunk                 = [ 0.0000, -2.9000],
                // Doors
            front_left_door       = [-1.2800,  0.2500],
            front_right_door      = [ 1.2800,  0.2500],
            back_left_door        = [-1.2800, -0.6100],
            back_right_door       = [ 1.2800, -0.6100],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [110.0, 110.0, 116.0],
            top_speed_kmh = [177.0, 177.0, 187.0],
        },
        weight_kg  = [2070.0, 1820.0, 1820.0],
        heat_limit = null,
    },

    model_19 = {
        names = ["milk_truck", "Milk Truck"],
        seats = 1,
        triggers = {
            front_left_wheel      = [-1.2800,  1.0000],
            front_right_wheel     = [ 1.2800,  1.0000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.4000],
            rear_right_wheel      = [ 1.2800, -1.4000],
            hood                  = [ 0.0000,  2.4500],
            trunk                 = [ 0.0000, -2.4500],
                // Doors
            front_left_door       = [-1.2800,  0.5000],
            front_right_door      = null,
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [68.0, 68.0, 89.0],
            top_speed_kmh = [110.0, 110.0, 143.0],
        },
        weight_kg  = [2430.0, 2130.0, 2130.0],
        heat_limit = null,
    },

    model_20 = {
        names = ["parry_bus", "Parry Bus"],
        seats = 1,
        triggers = {
            front_left_wheel      = [  1.5500, -2.9100],
            front_right_wheel     = [ -1.5500, -2.9100],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [ -1.5500,  3.1050],
            rear_right_wheel      = [  1.5500,  3.1050],
            hood                  = [  0.0000, -5.4800],
            trunk                 = null,
                // Doors
            front_left_door       = [ -1.5500,  4.2700],
            front_right_door      = [  1.5500,  4.2700],
            back_left_door        = [ -1.5500, -1.5000],
            back_right_door       = [  1.5500, -1.5000],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [54.0, 54.0, 54.0],
            top_speed_kmh = [84.0, 84.0, 84.0],
        },
        weight_kg  = [3616.0, 3616.0, 3616.0],
        heat_limit = null,
    },

    model_21 = {
        names = ["parry_prison", "Parry Bus Police"],
        seats = 1,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        triggers = {
            front_left_wheel      = [ 1.5500, -2.9100],
            front_right_wheel     = [-1.5500, -2.9100],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.5500,  3.1050],
            rear_right_wheel      = [ 1.5500,  3.1050],
            hood                  = [ 0.0000,  -5.4800],
            trunk                 = null,
                // Doors
            front_left_door       = [ -1.5500,  4.2700],
            front_right_door      = [  1.5500,  4.2700],
            back_left_door        = [ -1.5500, -1.5000],
            back_right_door       = [  1.5500, -1.5000],
        },
        engine = {
            top_speed_mph = [82.0, 82.0, 82.0],
            top_speed_kmh = [132.0, 132.0, 132.0],
        },
        weight_kg  = [3616.0, 3616.0, 3616.0],
        heat_limit = null,
    },

    model_22 = {
        names = ["potomac_indian" , "Potomac Indian"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5000],
            rear_right_wheel      = [ 1.2800, -1.5000],
            hood                  = [ 0.0000,  2.7000],
            trunk                 = [ 0.0000, -2.7000],
                // Doors
            front_left_door       = [-1.3000,  0.2500],
            front_right_door      = [ 1.3000,  0.2500],
            back_left_door        = [-1.3000, -0.6100],
            back_right_door       = [ 1.3000, -0.6100],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [100.0, 100.0, 106.0],
            top_speed_kmh = [161.0, 161.0, 170.0],
        },
        weight_kg  = [1676.0, 1510.0, 1510.0],
        heat_limit = null,
    },

    model_23 = {
        names = ["quicksilver_windsor_pha", "Quicksilver Windsor"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.3000],
            rear_right_wheel      = [ 1.2800, -1.3000],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [-1.2800,  0.2500],
            front_right_door      = [ 1.2800,  0.2500],
            back_left_door        = [-1.2800, -0.6000],
            back_right_door       = [ 1.2800, -0.6000],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [101.0, 101.0, 110.0],
            top_speed_kmh = [162.0, 162.0, 177.0],
        },
        weight_kg  = [1620.0, 1460.0, 1460.0],
        heat_limit = null,
    },

    model_24 = {
        names = ["quicksilver_windsor_taxi_pha", "Quicksilver Windsor Taxi"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.3000],
            rear_right_wheel      = [ 1.2800, -1.3000],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [-1.2800,  0.2500],
            front_right_door      = [ 1.2800,  0.2500],
            back_left_door        = [-1.2800, -0.6000],
            back_right_door       = [ 1.2800, -0.6000],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [101.0, 101.0, 110.0],
            top_speed_kmh = [162.0, 162.0, 177.0],
        },
        weight_kg  = [1620.0, 1460.0, 1460.0],
        heat_limit = null,
    },

    model_25 = {
        names = ["shubert_38", "Shubert 38"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2100, -1.2500],
            rear_right_wheel      = [ 1.2100, -1.2500],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [-1.1700,  0.0000],
            front_right_door      = [ 1.1700,  0.0000],
            back_left_door        = [-1.1700, -0.7500],
            back_right_door       = [ 1.1700, -0.7500],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [86.0,  86.0,  91.0],
            top_speed_kmh = [139.0, 139.0, 147.0],
        },
        weight_kg  = [1420.0, 1300.0, 1300.0],
        heat_limit = null,
    },

    model_26 = {
        names = ["shubert_38_destr", "Shubert 38 Destroy"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2100, -1.2500],
            rear_right_wheel      = [ 1.2100, -1.2500],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [-1.1700,  0.0000],
            front_right_door      = [ 1.1700,  0.0000],
            back_left_door        = [-1.1700, -0.7500],
            back_right_door       = [ 1.1700, -0.7500],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [86.0,  86.0,  91.0],
            top_speed_kmh = [139.0, 139.0, 147.0],
        },
        weight_kg  = [1420.0, 1300.0, 1300.0],
        heat_limit = null,
    },

    model_27 = {
        names = ["shubert_armoured", "Shubert Armored Truck"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.9000],
            front_right_wheel     = [ 1.2800,  1.9000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5500],
            rear_right_wheel      = [ 1.2800, -1.5500],
            hood_wing_left        = [-1.2800,  1.7500],
            hood_wing_right       = [ 1.2800,  1.7500],
            trunk                 = [ 0.0000, -3.4500],
                // Doors
            front_left_door       = [-1.2800,  0.5500],
            front_right_door      = [ 1.2800,  0.5500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 4,
            gridSizeY = 3,
            weightLimit = 200,
        },
        engine = {
            top_speed_mph = [69.0, 69.0, 69.0],
            top_speed_kmh = [111.0, 111.0, 111.0],
        },
        weight_kg  = [4501.0, 4501.0, 4501.0],
        heat_limit = null,
    },

    model_28 = {
        names = ["shubert_beverly", "Shubert Beverly"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.4500],
            rear_right_wheel      = [ 1.2800, -1.4500],
            hood                  = [ 0.0000,  2.7000],
            trunk                 = [ 0.0000, -2.7000],
                // Doors
            front_left_door       = [-1.2800,  0.0000],
            front_right_door      = [ 1.2800,  0.0000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [103.0, 103.0, 112.0],
            top_speed_kmh = [166.0, 166.0, 174.0],
        },
        weight_kg  = [1565.0, 1450.0, 1450.0],
        heat_limit = null,
    },

    model_29 = {
        names = ["shubert_frigate_pha", "Shubert Frigate"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.2500],
            front_right_wheel     = [ 1.2800,  1.2500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6000],
            rear_right_wheel      = [ 1.2800, -1.6000],
            hood                  = [ 0.0000,  2.6000],
            trunk                 = [ 0.0000, -2.6000],
                // Doors
            front_left_door       = [-1.2800, -0.3500],
            front_right_door      = [ 1.2800, -0.3500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [108.0, 108.0, 114.0],
            top_speed_kmh = [175.0, 175.0, 184.0],
        },
        weight_kg  = [1293.0, 1160.0, 1160.0],
        heat_limit = null,
    },

    model_30 = {
        names = ["shubert_hearse", "Shubert Hearse"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.8000],
            rear_right_wheel      = [ 1.2800, -1.8000],
            hood                  = [ 0.0000,  2.8000],
            trunk                 = [ 0.0000, -2.9500],
                // Doors
            front_left_door       = [-1.2800, -0.1000],
            front_right_door      = [ 1.2800, -0.1000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [83.0,  83.0,  98.0],
            top_speed_kmh = [134.0, 134.0, 157.0],
        },
        weight_kg  = [1631.0, 1491.0, 1494.0],
        heat_limit = null,
    },

    model_31 = {
        names = ["shubert_panel" , "Shubert Panel"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.5000],
            front_right_wheel     = [ 1.2800,  1.5000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [ 1.2100, -1.6690],
            rear_right_wheel      = [-1.2100, -1.6690],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [ 1.1600, -0.1000],
            front_right_door      = [-1.1300, -0.1000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [80.0,  88.0,  84.0],
            top_speed_kmh = [128.0, 128.0, 135.0],
        },
        weight_kg  = [1801.0, 1451.0, 1451.0],
        heat_limit = null,
    },

    model_32 = {
        names = ["shubert_panel_m14", "Shubert Panel M14"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.5000],
            front_right_wheel     = [ 1.2800,  1.5000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [ 1.2100, -1.6690],
            rear_right_wheel      = [-1.2100, -1.6690],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [ 1.1600, -0.1000],
            front_right_door      = [-1.1300, -0.1000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [80.0,  88.0,  84.0],
            top_speed_kmh = [128.0, 128.0, 135.0],
        },
        weight_kg  = [1801.0, 1451.0, 1451.0],
        heat_limit = null,
    },

    model_33 = {
        names = ["shubert_taxi", "Shubert Taxi"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2100, -1.2000],
            rear_right_wheel      = [ 1.2100, -1.2000],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [-1.1700,  0.0000],
            front_right_door      = [ 1.1700,  0.0000],
            back_left_door        = [-1.1700, -0.7500],
            back_right_door       = [ 1.1700, -0.7500],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [86.0,  86.0,  91.0],
            top_speed_kmh = [139.0, 139.0, 147.0],
        },
        weight_kg  = [1420.0, 1300.0, 1300.0],
        heat_limit = null,
    },

    model_34 = {
        names = ["shubert_truck_cc", "Shubert Truck Fresh Meat"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3000,  2.0000],
            front_right_wheel     = [ 1.3000,  2.0000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.3000, -1.6690],
            rear_right_wheel      = [ 1.3000, -1.6690],
            hood                  = [ 0.0000,  3.2000],
            trunk                 = [ 0.0000, -4.0000],
                // Doors
            front_left_door       = [-1.3000,  1.4500],
            front_right_door      = [ 1.3000,  1.4500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [63.0,  63.0,  63.0],
            top_speed_kmh = [101.0, 101.0, 101.0],
        },
        weight_kg  = [4500.0, 4500.0, 4500.0],
        heat_limit = null,
    },

    model_35 = {
        names = ["shubert_truck_ct", "Shubert Truck Flatbed"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3000,  2.2500],
            front_right_wheel     = [ 1.3000,  2.2500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.3000, -1.6690],
            rear_right_wheel      = [ 1.3000, -1.6690],
            hood                  = [ 0.0000,  3.4000],
            trunk                 = [ 0.0000, -4.5000],
                // Doors
            front_left_door       = [-1.3000,  1.6000],
            front_right_door      = [ 1.3000,  1.6000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [63.0,  63.0,  63.0],
            top_speed_kmh = [101.0, 101.0, 101.0],
        },
        weight_kg  = [4500.0, 4500.0, 4500.0],
        heat_limit = null,
    },

    model_36 = {
        names = ["shubert_truck_ct_cigar", "Shubert Truck Cigars"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3000,  2.2500],
            front_right_wheel     = [ 1.3000,  2.2500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.3000, -1.6690],
            rear_right_wheel      = [ 1.3000, -1.6690],
            hood                  = [ 0.0000,  3.4000],
            trunk                 = [ 0.0000, -4.5000],
                // Doors
            front_left_door       = [-1.3000,  1.6000],
            front_right_door      = [ 1.3000,  1.6000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [63.0,  63.0,  63.0],
            top_speed_kmh = [101.0, 101.0, 101.0],
        },
        weight_kg  = [4500.0, 4500.0, 4500.0],
        heat_limit = null,
    },

    model_37 = {
        names = ["shubert_truck_qd", "Shubert Truck Covered"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3000,  2.2500],
            front_right_wheel     = [ 1.3000,  2.2500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.3000, -1.6690],
            rear_right_wheel      = [ 1.3000, -1.6690],
            hood                  = [ 0.0000,  3.4000],
            trunk                 = [ 0.0000, -4.5000],
                // Doors
            front_left_door       = [-1.3000,  1.6000],
            front_right_door      = [ 1.3000,  1.6000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [63.0,  63.0,  63.0],
            top_speed_kmh = [101.0, 101.0, 101.0],
        },
        weight_kg  = [4500.0, 4500.0, 4500.0],
        heat_limit = null,
    },

    model_38 = {
        names = ["shubert_truck_sg", "Shubert Truck Seagift"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3000,  2.2500],
            front_right_wheel     = [ 1.3000,  2.2500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.3000, -1.6690],
            rear_right_wheel      = [ 1.3000, -1.6690],
            hood                  = [ 0.0000,  3.4000],
            trunk                 = [ 0.0000, -4.5000],
                // Doors
            front_left_door       = [-1.3000,  1.6000],
            front_right_door      = [ 1.3000,  1.6000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [63.0,  63.0,  63.0],
            top_speed_kmh = [101.0, 101.0, 101.0],
        },
        weight_kg  = [4500.0, 4500.0, 4500.0],
        heat_limit = null,
    },

    model_39 = {
        names = ["shubert_truck_sp", "Shubert Snow Plow"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3000,  2.2500],
            front_right_wheel     = [ 1.3000,  2.2500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.3000, -1.6690],
            rear_right_wheel      = [ 1.3000, -1.6690],
            hood                  = [ 0.0000,  4.5000],
            trunk                 = [ 0.0000, -4.5000],
                // Doors
            front_left_door       = [-1.3000,  1.6000],
            front_right_door      = [ 1.3000,  1.6000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [63.0,  63.0,  63.0],
            top_speed_kmh = [101.0, 101.0, 101.0],
        },
        weight_kg  = [4500.0, 4500.0, 4500.0],
        heat_limit = null,
    },

    model_40 = {
        names = ["sicily_military_truck", "Sicily Military Truck"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  2.2000],
            front_right_wheel     = [ 1.2800,  2.2000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6690],
            rear_right_wheel      = [ 1.2800, -1.6690],
            hood_wing_left        = [-1.2800,  2.2000],
            hood_wing_right       = [ 1.2800,  2.2000],
            trunk                 = [ 0.0000, -3.5000],
                // Doors
            front_left_door       = [-1.2800,  1.1000],
            front_right_door      = [ 1.2800,  1.1000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [52.0, 52.0, 52.0],
            top_speed_kmh = [83.0, 83.0, 83.0],
        },
        weight_kg  = [2750.0, 2750.0, 2750.0],
        heat_limit = null,
    },

    model_41 = {
        names = ["smith_200_pha", "Smith Custom 200"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.3500],
            rear_right_wheel      = [ 1.2800, -1.3500],
            hood                  = [ 0.0000,  3.0000],
            trunk                 = [ 0.0000, -3.0000],
                // Doors
            front_left_door       = [-1.2800,  0.2500],
            front_right_door      = [ 1.2800,  0.2500],
            back_left_door        = [-1.2800, -0.4800],
            back_right_door       = [ 1.2800, -0.4800],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [118.0, 118.0, 127.0],
            top_speed_kmh = [190.0, 190.0, 205.0],
        },
        weight_kg  = [1500.0, 1320.0, 1320.0],
        heat_limit = null,
    },

    model_42 = {
        names = ["smith_200_p_pha", "Smith Custom 200 Police Special"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.3500],
            rear_right_wheel      = [ 1.2800, -1.3500],
            hood                  = [ 0.0000,  3.0000],
            trunk                 = [ 0.0000, -3.0000],
                // Doors
            front_left_door       = [-1.2800,  0.2500],
            front_right_door      = [ 1.2800,  0.2500],
            back_left_door        = [-1.2800, -0.4800],
            back_right_door       = [ 1.2800, -0.4800],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [118.0, 118.0, 127.0],
            top_speed_kmh = [190.0, 190.0, 205.0],
        },
        weight_kg  = [1500.0, 1320.0, 1320.0],
        heat_limit = null,
    },

    model_43 = {
        names = ["smith_coupe", "Smith Coupe"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.3000],
            front_right_wheel     = [ 1.2800,  1.3000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.4500],
            rear_right_wheel      = [ 1.2800, -1.4500],
            hood                  = [ 0.0000,  2.5000],
            trunk                 = [ 0.0000, -2.5000],
                // Doors
            front_left_door       = [-1.2800, -0.1500],
            front_right_door      = [ 1.2800, -0.1500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 2,
            gridSizeY = 2,
            weightLimit = 70,
        },
        engine = {
            top_speed_mph = [77.0,  77.0,  100.0],
            top_speed_kmh = [124.0, 124.0, 161.0],
        },
        weight_kg  = [1090.0, 980.0, 980.0],
        heat_limit = null,
    },

    model_44 = {
        names = ["smith_mainline_pha", "Smith Mainline"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.5000],
            front_right_wheel     = [ 1.2800,  1.5000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.4500],
            rear_right_wheel      = [ 1.2800, -1.4500],
            hood                  = [ 0.0000,  2.6000],
            trunk                 = [ 0.0000, -2.6000],
                // Doors
            front_left_door       = [-1.2800,  0.1000],
            front_right_door      = [ 1.2800,  0.1000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [100.0, 100.0, 110.0],
            top_speed_kmh = [160.0, 160.0, 177.0],
        },
        weight_kg  = [1500.0, 1350.0, 1350.0],
        heat_limit = null,
    },

    model_45 = {
        names = ["smith_stingray_pha", "Smith Thunderbolt"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.5000],
            front_right_wheel     = [ 1.2800,  1.5000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.3000],
            rear_right_wheel      = [ 1.2800, -1.3000],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [-1.2800, -0.2500],
            front_right_door      = [ 1.2800, -0.2500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [121.0, 121.0, 135.0],
            top_speed_kmh = [195.0, 195.0, 218.0],
        },
        weight_kg  = [1352.0, 1215.0, 1215.0],
        heat_limit = null,
    },

    model_46 = {
        names = ["smith_truck", "Smith Truck"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  2.5000],
            front_right_wheel     = [ 1.2800,  2.5000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.8000],
            rear_right_wheel      = [ 1.2800, -1.8000],
            hood_wing_left        = [-1.2800,  2.2000],
            hood_wing_right       = [ 1.2800,  2.2000],
            trunk                 = [ 0.0000, -3.5000],
                // Doors
            front_left_door       = [-1.2800,  1.1500],
            front_right_door      = [ 1.2800,  1.1500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [60.0, 60.0, 60.0],
            top_speed_kmh = [97.0, 97.0, 97.0],
        },
        weight_kg  = [3280.0, 3280.0, 3280.0],
        heat_limit = null,
    },

    model_47 = {
        names = ["smith_v8", "Smith V8"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6500],
            front_right_wheel     = [ 1.2800,  1.6500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6690],
            rear_right_wheel      = [ 1.2800, -1.6690],
            hood_wing_left        = [-1.2800,  1.0000],
            hood_wing_right       = [ 1.2800,  1.0000],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [-1.2800,  0.0000],
            front_right_door      = [ 1.2800,  0.0000],
            back_left_door        = [-1.2800, -0.7000],
            back_right_door       = [ 1.2800, -0.7000],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 2,
            weightLimit = 60,
        },
        engine = {
            top_speed_mph = [82.0,  82.0,  87.0],
            top_speed_kmh = [133.0, 133.0, 140.0],
        },
        weight_kg  = [1166.0, 1040.0, 1040.0],
        heat_limit = null,
    },

    model_48 = {
        names = ["smith_wagon_pha", "Smith Wagon"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.3000],
            front_right_wheel     = [ 1.2800,  1.3000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5000],
            rear_right_wheel      = [ 1.2800, -1.5000],
            hood                  = [ 0.0000,  2.6000],
            trunk                 = [ 0.0000, -2.6000],
                // Doors
            front_left_door       = [-1.2800,  0.0930],
            front_right_door      = [ 1.2800,  0.0930],
            back_left_door        = [-1.2800, -0.7500],
            back_right_door       = [ 1.2800, -0.7500],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_49 = {
        names = ["trailer", "Trailer"],
        seats = 0,
        triggers = {
            front_left_wheel      = null,
            front_right_wheel     = null,
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -2.5000],
            rear_right_wheel      = [ 1.2800, -2.5000],
            hood                  = null,
            trunk                 = [ 0.0000, -5.0000],
            hook                  = [ 0.0000,  3.0000],
                // Doors
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
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_50 = {
        names = ["ulver_newyorker", "Culver Empire"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.4500],
            front_right_wheel     = [ 1.2800,  1.4500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.4500],
            rear_right_wheel      = [ 1.2800, -1.4500],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [-1.2800,  0.1000],
            front_right_door      = [ 1.2800,  0.1000],
            back_left_door        = [-1.2800, -0.6000],
            back_right_door       = [ 1.2800, -0.6000],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [96.0,  96.0,  104.0],
            top_speed_kmh = [155.0, 155.0, 167.0],
        },
        weight_kg  = [1750.0, 1580.0, 1580.0],
        heat_limit = null,
    },

    model_51 = {
        names = ["ulver_newyorker_p", "Culver Empire Police Special"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.4500],
            front_right_wheel     = [ 1.2800,  1.4500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.4500],
            rear_right_wheel      = [ 1.2800, -1.4500],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.5800],
                // Doors
            front_left_door       = [-1.2800,  0.1000],
            front_right_door      = [ 1.2800,  0.1000],
            back_left_door        = [-1.2800, -0.6000],
            back_right_door       = [ 1.2800, -0.6000],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [96.0,  96.0,  104.0],
            top_speed_kmh = [155.0, 155.0, 167.0],
        },
        weight_kg  = [1750.0, 1580.0, 1580.0],
        heat_limit = null,
    },

    model_52 = {
        names = ["walker_rocket", "Walker Rocket"],
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5000],
            rear_right_wheel      = [ 1.2800, -1.5000],
            hood                  = [ 0.0000,  2.7500],
            trunk                 = [ 0.0000, -2.7500],
                // Doors
            front_left_door       = [-1.2800,  0.2000],
            front_right_door      = [ 1.2800,  0.2000],
            back_left_door        = [-1.2800, -0.5500],
            back_right_door       = [ 1.2800, -0.5500],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            weightLimit = 100,
        },
        engine = {
            top_speed_mph = [132.0, 132.0, 136.0],
            top_speed_kmh = [209.0, 209.0, 219.0],
        },
        weight_kg  = [1920.0, 1730.0, 1730.0],
        heat_limit = null,
    },

    model_53 = {
        names = ["walter_coupe", "Walter Coupe"],
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.4500],
            front_right_wheel     = [ 1.2800,  1.4500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.4000],
            rear_right_wheel      = [ 1.2800, -1.4000],
            hood                  = [ 0.0000,  2.5500],
            trunk                 = [ 0.0000, -2.5500],
                // Doors
            front_left_door       = [-1.2800,  0.1000],
            front_right_door      = [ 1.2800,  0.1000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 2,
            gridSizeY = 2,
            weightLimit = 70,
        },
        engine = {
            top_speed_mph = [66.0,  66.0,  90.0],
            top_speed_kmh = [107.0, 107.0, 145.0],
        },
        weight_kg  = [942.0, 870.0, 870.0],
        heat_limit = null,
    },
};

function getVehicleMeta(modelid) {
    return vehicleMetaData["model_" + modelid];
}

function getVehicleNameByModelId(modelid) {
    return vehicleMetaData["model_" + modelid].names[1];
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

function getVehicleSpeedLimit(modelid, tuneLevel) {
    local tuneLevel = (tuneLevel<=0) ? 1 : tuneLevel.tointeger();
    return vehicleMetaData["model_" + modelid].engine.top_speed_mph[tuneLevel];
}

function getVehicleDoorsPosition(modelid) {
    local data = vehicleMetaData["model_" + modelid].triggers;

    // dbg( data.front_left_door[0],
    //      data.front_left_door[1],
    //      0.0 );

    return {
        front_left  = (data.front_left_door != null) ?
                        Vector3( data.front_left_door[0],
                                 data.front_left_door[1],
                                 0.0)
                    : data.front_left_door,
        front_right = (data.front_right_door != null) ?
                        Vector3( data.front_right_door[0],
                                 data.front_right_door[1],
                                 0.0)
                    : data.front_right_door,
        back_left   = (data.back_left_door != null) ?
                        Vector3( data.back_left_door[0],
                                 data.back_left_door[1],
                                 0.0)
                    : data.back_left_door,
        back_right  = (data.back_right_door != null) ?
                        Vector3( data.back_right_door[0],
                                 data.back_right_door[1],
                                 0.0)
                    : data.back_right_door,
    };
}

function getVehicleTruckPosition(modelid) {
    local data = vehicleMetaData["model_" + modelid].triggers;
    return (data.trunk != null)
                    ? Vector3( data.trunk[0],
                               data.trunk[1],
                               0.0)
                    : data.trunk;
}


function getVehicleTriggersPosition(modelid) {
    local res = clone( vehicleMetaData["model_" + modelid].triggers );

    foreach (idx, trigger in res) {
        // dbg(trigger);
        if ( trigger != null ) {
            res[idx] = Vector3( trigger[0],
                                trigger[1],
                                0.0);
        }
    }

    return res;
}



// return door pos
function calcTriggerPositions(playerid, vehicleid, doors) {
    local door_radius = 0.7;
    local v_pos = getVehiclePosition(vehicleid);
    local v_ang = getVehicleRotation(vehicleid);

    local p_pos = players[playerid].getPosition();

    // dbg(doors);

    foreach (idx, door in doors) {
        if (door == null) continue;

        local d_pos = Matrix([door.x, door.y, door.z]);

        d_pos = d_pos * EulerAngles(v_ang);
        // d_pos.tostring();

        door.x = v_pos[0] + d_pos._data[0][0];
        door.y = v_pos[1] + d_pos._data[0][1];
        door.z = v_pos[2] + d_pos._data[0][2] / 2.0;
        // dbg( door.x, door.y, door.z+0.35 );

        if ( checkDistanceXY( door.x, door.y, p_pos.x, p_pos.y, door_radius) ) {
            // dbg("YEah!");
            msg(playerid, "Your are on " + idx);
        }
    }

    // dbg(doors);
    return doors;
}

// call callback when player is on any of vehicle door trigger
// callback should get playerid, vehicleid and door struct as args
function onVehicleDoorTriggerPosition(playerid, vehicleid, doors, callback) {
    local door_radius = 0.35;
    local v_pos = getVehiclePosition(vehicleid);
    local v_ang = getVehicleRotation(vehicleid);
    local p_pos = players[playerid].getPosition();

    foreach (idx, door in doors) {
        if (door == null) continue;

        local d_pos = Matrix([door.x, door.y, door.z]);

        d_pos = d_pos * EulerAngles(v_ang);
        // d_pos.tostring();

        door.x = v_pos[0] + d_pos._data[0][0];
        door.y = v_pos[1] + d_pos._data[0][1];
        door.z = v_pos[2] + d_pos._data[0][2] / 2.0;
        // dbg( door.x, door.y, door.z+0.35 );

        if ( checkDistanceXY( door.x, door.y, p_pos.x, p_pos.y, door_radius) ) {
            callback(playerid, vehicleid, door);
        }
    }

    // dbg(doors);
    return doors;
}
