
vehicleInfo <- {
    model_0  = {
        gamename = "ascot_baileys200_pha",
        name = "Ascot Bailey S200",
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
            gridSizeY = 1,
            volumeLimit = 100,
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
        gamename = "berkley_kingfisher_pha",
        name = "Berkley Kingfisher",
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
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [106.0,  106.0,  106.0],
            top_speed_kmh = [170.0, 170.0, 180.0],
        },
        weight_kg  = [1957.0, 1760.0, 1760.0],
        heat_limit = null,
    },

    model_2  = {
        gamename = "fuel_tank", // fuel trailer
        name = "Fuel Tank",
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
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [70.0, 70.0, 70.0],
            top_speed_kmh = [112.0, 112.0, 112.0],
        },
        weight_kg  = [5520.0, 5520.0, 5520.0],
        heat_limit = null,
    },

    model_3  = {
        gamename = "gai_353_military_truck",
        name = "GAI 353 Military Truck",
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
            gridSizeX = 4,
            gridSizeY = 5,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [47.0, 47.0, 47.0],
            top_speed_kmh = [75.0, 75.0, 75.0],
        },
        weight_kg  = [5316.0, 5316.0, 5316.0],
        heat_limit = null,
    },

    model_4  = {
        gamename = "hank_b",
        name = "Hank B",
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
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [70.0, 70.0, 70.0],
            top_speed_kmh = [112.0, 112.0, 112.0],
        },
        weight_kg  = [5520.0, 5520.0, 5520.0],
        heat_limit = null,
    },

    model_5  = {
        gamename = "hank_fueltank",
        name = "Hank B Fuel Tank",
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
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [70.0, 70.0, 70.0],
            top_speed_kmh = [112.0, 112.0, 112.0],
        },
        weight_kg  = [12870.0, 12870.0, 12870.0],
        heat_limit = null,
    },

    model_6  = {
        gamename = "hot_rod_1",
        name = "Walter Hot Rod",
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
            gridSizeX = 2,
            gridSizeY = 3,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [134.0, 143.0, 134.0],
            top_speed_kmh = [216.0, 230.0, 216.0],
        },
        weight_kg  = [1045.0, 1045.0, 1150.0],
        heat_limit = null,
    },

    model_7  = {
        gamename = "hot_rod_2",
        name = "Smith 34 Hot Rod",
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
            gridSizeX = 2,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [119.0, 126.0, 119.0],
            top_speed_kmh = [192.0, 203.0, 192.0],
        },
        weight_kg  = [612.0, 912.0, 1015.0],
        heat_limit = null,
    },

    model_8  = {
        gamename = "hot_rod_3",
        name = "Shuber Pickup Hot Rod",
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
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [110.0, 110.0, 127.0],
            top_speed_kmh = [178.0, 178.0, 204.0],
        },
        weight_kg  = [1086.0, 1086.0, 978.0],
        heat_limit = null,
    },


    model_9  = {
        gamename = "houston_wasp_pha",
        name = "Houston Wasp",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.4500],
            front_right_wheel     = [ 1.2800,  1.4500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6000],
            rear_right_wheel      = [ 1.2800, -1.6000],
            hood                  = [ 0.0000,  2.6400],
            trunk                 = [ 0.0000, -3.0000],
                // Doors
            front_left_door       = [-1.2800,  0.3200],
            front_right_door      = [ 1.2800,  0.3200],
            back_left_door        = [-1.2800, -0.5000],
            back_right_door       = [ 1.2800, -0.5000],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [104.0, 104.0, 110.0],
            top_speed_kmh = [168.0, 138.0, 177.0],
        },
        weight_kg  = [1636.0, 1470.0, 1470.0],
        heat_limit = null,
    },

    model_10 = {
        gamename = "isw_508",
        name = "ISW 508",
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
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [120.0, 120.0, 132.0],
            top_speed_kmh = [194.0, 194.0, 221.0],
        },
        weight_kg  = [1315.0, 1215.0, 1215.0],
        heat_limit = null,
    },

    model_11 = {
        gamename = "jeep",
        name = "Jeep",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.1520],
            front_right_wheel     = [ 1.2800,  1.1520],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2100, -1.1500],
            rear_right_wheel      = [ 1.2100, -1.1500],
            hood                  = [ 0.0000,  2.2000],
            trunk                 = [ 0.0000, -2.0000],
                // Doors
            front_left_door       = [-1.2800,  0.0000],
            front_right_door      = [ 1.2800,  0.0000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [72.0, 72.0, 94.0],
            top_speed_kmh = [116.0, 116.0, 151.0],
        },
        weight_kg  = [1040.0, 930.0, 930.0],
        heat_limit = null,
    },

    model_12 = {
        gamename = "jeep_civil",
        name = "Jeep Civil",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.1520],
            front_right_wheel     = [ 1.2800,  1.1520],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2100, -1.1500],
            rear_right_wheel      = [ 1.2100, -1.1500],
            hood                  = [ 0.0000,  2.2000],
            trunk                 = [ 0.0000, -2.0000],
                // Doors
            front_left_door       = [-1.2800,  0.0000],
            front_right_door      = [ 1.2800,  0.0000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [72.0, 72.0, 94.0],
            top_speed_kmh = [116.0, 116.0, 151.0],
        },
        weight_kg  = [1040.0, 930.0, 930.0],
        heat_limit = null,
    },

    model_13 = {
        gamename = "jefferson_futura_pha",
        name = "Jefferson Futura",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5000],
            rear_right_wheel      = [ 1.2800, -1.5000],
            hood                  = [ 0.0000,  2.7000],
            trunk                 = [ 0.0000, -3.1000],
                // Doors
            front_left_door       = [-1.2800,  0.0930],
            front_right_door      = [ 1.2800,  0.0930],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 2,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [121.0, 121.5, 132.0],
            top_speed_kmh = [198.0, 198.0, 216.0],
        },
        weight_kg  = [2475.0, 2215.0, 2215.0],
        heat_limit = null,
    },

    model_14 = {
        gamename = "jefferson_provincial",
        name = "Jefferson Provincial",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6000],
            rear_right_wheel      = [ 1.2800, -1.6000],
            hood                  = [ 0.0000,  2.6500],
            trunk                 = [ 0.0000, -2.8500],
                // Doors
            front_left_door       = [-1.2800,  0.0500],
            front_right_door      = [ 1.2800,  0.0500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 2,
            gridSizeY = 1,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [97.0,  97.0,  113.0],
            top_speed_kmh = [156.0, 156.0, 182.0],
        },
        weight_kg  = [1620.0, 1480.0, 1480.0],
        heat_limit = null,
    },

    model_15 = {
        gamename = "lassiter_69",
        name = "Lassiter 69",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5500],
            rear_right_wheel      = [ 1.2800, -1.5500],
            hood                  = [ 0.0000,  2.7000],
            trunk                 = [ 0.0000, -3.1000],
                // Doors
            front_left_door       = [-1.2800,  0.1500],
            front_right_door      = [ 1.2800,  0.1500],
            back_left_door        = [-1.2800, -0.6000],
            back_right_door       = [ 1.2800, -0.6000],
        },
        trunk = {
            gridSizeX = 4,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [107.0, 108.5, 117.0],
            top_speed_kmh = [172.0, 172.0, 188.0],
        },
        weight_kg  = [1873.0, 1680.0, 1680.0],
        heat_limit = null,
    },

    model_16 = {
        gamename = "lassiter_69_destr",
        name = "Lassiter 69 Destroy",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5500],
            rear_right_wheel      = [ 1.2800, -1.5500],
            hood                  = [ 0.0000,  2.7000],
            trunk                 = [ 0.0000, -3.1000],
                // Doors
            front_left_door       = [-1.2800,  0.1500],
            front_right_door      = [ 1.2800,  0.1500],
            back_left_door        = [-1.2800, -0.6000],
            back_right_door       = [ 1.2800, -0.6000],
        },
        trunk = {
            gridSizeX = 4,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [107.0, 107.0, 117.0],
            top_speed_kmh = [172.0, 172.0, 188.0],
        },
        weight_kg  = [1873.0, 1680.0, 1680.0],
        heat_limit = null,
    },

    model_17 = {
        gamename = "lassiter_75_fmv",
        name = "Lassiter 75 FMV",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  2.1500],
            front_right_wheel     = [ 1.2800,  2.1500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6700],
            rear_right_wheel      = [ 1.2800, -1.6700],
            hood                  = [ 0.0000,  2.9000],
            trunk                 = [ 0.0000, -3.5000],
                // Doors
            front_left_door       = [-1.2800,  0.2500],
            front_right_door      = [ 1.2800,  0.2500],
            back_left_door        = [-1.2800, -0.6100],
            back_right_door       = [ 1.2800, -0.6100],
        },
        trunk = {
            gridSizeX = 2,
            gridSizeY = 3,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [110.0, 110.0, 116.0],
            top_speed_kmh = [177.0, 177.0, 187.0],
        },
        weight_kg  = [2070.0, 1820.0, 1820.0],
        heat_limit = null,
    },

    model_18 = {
        gamename = "lassiter_75_pha",
        name = "Lassiter 75",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  2.1500],
            front_right_wheel     = [ 1.2800,  2.1500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6700],
            rear_right_wheel      = [ 1.2800, -1.6700],
            hood                  = [ 0.0000,  2.9000],
            trunk                 = [ 0.0000, -3.5000],
                // Doors
            front_left_door       = [-1.2800,  0.2500],
            front_right_door      = [ 1.2800,  0.2500],
            back_left_door        = [-1.2800, -0.6100],
            back_right_door       = [ 1.2800, -0.6100],
        },
        trunk = {
            gridSizeX = 2,
            gridSizeY = 3,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [110.0, 110.0, 116.0],
            top_speed_kmh = [177.0, 177.0, 187.0],
        },
        weight_kg  = [2070.0, 1820.0, 1820.0],
        heat_limit = null,
    },

    model_19 = {
        gamename = "milk_truck",
        name = "Milk Truck",
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
            gridSizeY = 4,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [68.0, 68.0, 89.0],
            top_speed_kmh = [110.0, 110.0, 143.0],
        },
        weight_kg  = [2430.0, 2130.0, 2130.0],
        heat_limit = null,
    },

    model_20 = {
        gamename = "parry_bus",
        name = "Parry Bus",
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
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [54.0, 54.0, 54.0],
            top_speed_kmh = [84.0, 84.0, 84.0],
        },
        weight_kg  = [3616.0, 3616.0, 3616.0],
        heat_limit = null,
    },

    model_21 = {
        gamename = "parry_prison",
        name = "Parry Bus Police",
        seats = 1,
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            volumeLimit = 100,
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
        gamename = "potomac_indian",
        name = "Potomac Indian",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5000],
            rear_right_wheel      = [ 1.2800, -1.5000],
            hood                  = [ 0.0000,  2.7000],
            trunk                 = [ 0.0000, -2.8500],
                // Doors
            front_left_door       = [-1.3000,  0.2500],
            front_right_door      = [ 1.3000,  0.2500],
            back_left_door        = [-1.3000, -0.6100],
            back_right_door       = [ 1.3000, -0.6100],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [100.0, 100.0, 106.0],
            top_speed_kmh = [161.0, 161.0, 170.0],
        },
        weight_kg  = [1676.0, 1510.0, 1510.0],
        heat_limit = null,
    },

    model_23 = {
        gamename = "quicksilver_windsor_pha",
        name = "Quicksilver Windsor",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.3000],
            rear_right_wheel      = [ 1.2800, -1.3000],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.7800],
                // Doors
            front_left_door       = [-1.2800,  0.2500],
            front_right_door      = [ 1.2800,  0.2500],
            back_left_door        = [-1.2800, -0.6000],
            back_right_door       = [ 1.2800, -0.6000],
        },
        trunk = {
            gridSizeX = 5,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [101.0, 101.0, 110.0],
            top_speed_kmh = [162.0, 162.0, 177.0],
        },
        weight_kg  = [1620.0, 1460.0, 1460.0],
        heat_limit = null,
    },

    model_24 = {
        gamename = "quicksilver_windsor_taxi_pha",
        name = "Quicksilver Windsor Taxi",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.3000],
            rear_right_wheel      = [ 1.2800, -1.3000],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.7800],
                // Doors
            front_left_door       = [-1.2800,  0.2500],
            front_right_door      = [ 1.2800,  0.2500],
            back_left_door        = [-1.2800, -0.6000],
            back_right_door       = [ 1.2800, -0.6000],
        },
        trunk = {
            gridSizeX = 5,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [101.0, 101.0, 110.0],
            top_speed_kmh = [162.0, 162.0, 177.0],
        },
        weight_kg  = [1620.0, 1460.0, 1460.0],
        heat_limit = null,
    },

    model_25 = {
        gamename = "shubert_38",
        name = "Shubert 38",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2100, -1.2500],
            rear_right_wheel      = [ 1.2100, -1.2500],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.6800],
                // Doors
            front_left_door       = [-1.1700,  0.0000],
            front_right_door      = [ 1.1700,  0.0000],
            back_left_door        = [-1.1700, -0.7500],
            back_right_door       = [ 1.1700, -0.7500],
        },
        trunk = {
            gridSizeX = 2,
            gridSizeY = 3,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [86.0,  86.0,  91.0],
            top_speed_kmh = [139.0, 139.0, 147.0],
        },
        weight_kg  = [1420.0, 1300.0, 1300.0],
        heat_limit = null,
    },

    model_26 = {
        gamename = "shubert_38_destr",
        name = "Shubert 38 Destroy",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2100, -1.2500],
            rear_right_wheel      = [ 1.2100, -1.2500],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.6800],
                // Doors
            front_left_door       = [-1.1700,  0.0000],
            front_right_door      = [ 1.1700,  0.0000],
            back_left_door        = [-1.1700, -0.7500],
            back_right_door       = [ 1.1700, -0.7500],
        },
        trunk = {
            gridSizeX = 2,
            gridSizeY = 3,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [86.0,  86.0,  91.0],
            top_speed_kmh = [139.0, 139.0, 147.0],
        },
        weight_kg  = [1420.0, 1300.0, 1300.0],
        heat_limit = null,
    },

    model_27 = {
        gamename = "shubert_armoured",
        name = "Shubert Armored Truck",
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
            trunk                 = [ 0.0000, -3.1000],
                // Doors
            front_left_door       = [-1.2800,  0.5500],
            front_right_door      = [ 1.2800,  0.5500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 4,
            gridSizeY = 5,
            volumeLimit = 200,
        },
        engine = {
            top_speed_mph = [69.0, 69.0, 69.0],
            top_speed_kmh = [111.0, 111.0, 111.0],
        },
        weight_kg  = [4501.0, 4501.0, 4501.0],
        heat_limit = null,
    },

    model_28 = {
        gamename = "shubert_beverly",
        name = "Shubert Beverly",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.4500],
            rear_right_wheel      = [ 1.2800, -1.4500],
            hood                  = [ 0.0000,  2.7000],
            trunk                 = [ 0.0000, -2.8500],
                // Doors
            front_left_door       = [-1.2800,  0.0000],
            front_right_door      = [ 1.2800,  0.0000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 4,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [103.0, 103.0, 112.0],
            top_speed_kmh = [166.0, 166.0, 174.0],
        },
        weight_kg  = [1565.0, 1450.0, 1450.0],
        heat_limit = null,
    },

    model_29 = {
        gamename = "shubert_frigate_pha",
        name = "Shubert Frigate",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.2500],
            front_right_wheel     = [ 1.2800,  1.2500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.6000],
            rear_right_wheel      = [ 1.2800, -1.6000],
            hood                  = [ 0.0000,  2.6000],
            trunk                 = [ 0.0000, -2.8000],
                // Doors
            front_left_door       = [-1.2800, -0.3500],
            front_right_door      = [ 1.2800, -0.3500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 1,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [108.0, 108.0, 114.0],
            top_speed_kmh = [175.0, 175.0, 184.0],
        },
        weight_kg  = [1293.0, 1160.0, 1160.0],
        heat_limit = null,
    },

    model_30 = {
        gamename = "shubert_hearse",
        name = "Shubert Hearse",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.8000],
            rear_right_wheel      = [ 1.2800, -1.8000],
            hood                  = [ 0.0000,  2.8000],
            trunk                 = [ 0.0000, -3.1500],
                // Doors
            front_left_door       = [-1.2800, -0.1000],
            front_right_door      = [ 1.2800, -0.1000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 5,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [83.0,  83.0,  98.0],
            top_speed_kmh = [134.0, 134.0, 157.0],
        },
        weight_kg  = [1631.0, 1491.0, 1494.0],
        heat_limit = null,
    },

    model_31 = {
        gamename = "shubert_panel",
        name = "Shubert Panel",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.5000],
            front_right_wheel     = [ 1.2800,  1.5000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [ 1.2100, -1.6690],
            rear_right_wheel      = [-1.2100, -1.6690],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.7800],
                // Doors
            front_left_door       = [ 1.1600, -0.1000],
            front_right_door      = [-1.1300, -0.1000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 4,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [80.0,  88.0,  84.0],
            top_speed_kmh = [128.0, 128.0, 135.0],
        },
        weight_kg  = [1801.0, 1451.0, 1451.0],
        heat_limit = null,
    },

    model_32 = {
        gamename = "shubert_panel_m14",
        name = "Shubert Panel M14",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.5000],
            front_right_wheel     = [ 1.2800,  1.5000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [ 1.2100, -1.6690],
            rear_right_wheel      = [-1.2100, -1.6690],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.7800],
                // Doors
            front_left_door       = [ 1.1600, -0.1000],
            front_right_door      = [-1.1300, -0.1000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 4,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [80.0,  88.0,  84.0],
            top_speed_kmh = [128.0, 128.0, 135.0],
        },
        weight_kg  = [1801.0, 1451.0, 1451.0],
        heat_limit = null,
    },

    model_33 = {
        gamename = "shubert_taxi",
        name = "Shubert Taxi",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2100, -1.2000],
            rear_right_wheel      = [ 1.2100, -1.2000],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.6800],
                // Doors
            front_left_door       = [-1.1700,  0.0000],
            front_right_door      = [ 1.1700,  0.0000],
            back_left_door        = [-1.1700, -0.7500],
            back_right_door       = [ 1.1700, -0.7500],
        },
        trunk = {
            gridSizeX = 2,
            gridSizeY = 3,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [86.0,  86.0,  91.0],
            top_speed_kmh = [139.0, 139.0, 147.0],
        },
        weight_kg  = [1420.0, 1300.0, 1300.0],
        heat_limit = null,
    },

    model_34 = {
        gamename = "shubert_truck_cc",
        name = "Shubert Truck Fresh Meat",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3000,  2.0000],
            front_right_wheel     = [ 1.3000,  2.0000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.3000, -1.6690],
            rear_right_wheel      = [ 1.3000, -1.6690],
            hood                  = [ 0.0000,  3.2000],
            trunk                 = [ 0.0000, -3.5000],
                // Doors
            front_left_door       = [-1.3000,  1.4500],
            front_right_door      = [ 1.3000,  1.4500],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 5,
            gridSizeY = 5,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [63.0,  63.0,  63.0],
            top_speed_kmh = [101.0, 101.0, 101.0],
        },
        weight_kg  = [4500.0, 4500.0, 4500.0],
        heat_limit = null,
    },

    model_35 = {
        gamename = "shubert_truck_ct",
        name = "Shubert Truck Flatbed",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3000,  2.2500],
            front_right_wheel     = [ 1.3000,  2.2500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.3000, -1.6690],
            rear_right_wheel      = [ 1.3000, -1.6690],
            hood                  = [ 0.0000,  3.4000],
            trunk                 = [ 0.0000, -4.2000],
                // Doors
            front_left_door       = [-1.3000,  1.6000],
            front_right_door      = [ 1.3000,  1.6000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 4,
            gridSizeY = 5,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [63.0,  63.0,  63.0],
            top_speed_kmh = [101.0, 101.0, 101.0],
        },
        weight_kg  = [4500.0, 4500.0, 4500.0],
        heat_limit = null,
    },

    model_36 = {
        gamename = "shubert_truck_ct_cigar",
        name = "Shubert Truck Cigars",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3000,  2.2500],
            front_right_wheel     = [ 1.3000,  2.2500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.3000, -1.6690],
            rear_right_wheel      = [ 1.3000, -1.6690],
            hood                  = [ 0.0000,  3.4000],
            trunk                 = [ 0.0000, -4.2000],
                // Doors
            front_left_door       = [-1.3000,  1.6000],
            front_right_door      = [ 1.3000,  1.6000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 4,
            gridSizeY = 5,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [63.0,  63.0,  63.0],
            top_speed_kmh = [101.0, 101.0, 101.0],
        },
        weight_kg  = [4500.0, 4500.0, 4500.0],
        heat_limit = null,
    },

    model_37 = {
        gamename = "shubert_truck_qd",
        name = "Shubert Truck Covered",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3000,  2.2500],
            front_right_wheel     = [ 1.3000,  2.2500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.3000, -1.6690],
            rear_right_wheel      = [ 1.3000, -1.6690],
            hood                  = [ 0.0000,  3.4000],
            trunk                 = [ 0.0000, -3.6000],
                // Doors
            front_left_door       = [-1.3000,  1.6000],
            front_right_door      = [ 1.3000,  1.6000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 5,
            gridSizeY = 5,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [63.0,  63.0,  63.0],
            top_speed_kmh = [101.0, 101.0, 101.0],
        },
        weight_kg  = [4500.0, 4500.0, 4500.0],
        heat_limit = null,
    },

    model_38 = {
        gamename = "shubert_truck_sg",
        name = "Shubert Truck Seagift",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3000,  2.2500],
            front_right_wheel     = [ 1.3000,  2.2500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.3000, -1.6690],
            rear_right_wheel      = [ 1.3000, -1.6690],
            hood                  = [ 0.0000,  3.4000],
            trunk                 = [ 0.0000, -3.5000],
                // Doors
            front_left_door       = [-1.3000,  1.6000],
            front_right_door      = [ 1.3000,  1.6000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 5,
            gridSizeY = 5,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [63.0,  63.0,  63.0],
            top_speed_kmh = [101.0, 101.0, 101.0],
        },
        weight_kg  = [4500.0, 4500.0, 4500.0],
        heat_limit = null,
    },

    model_39 = {
        gamename = "shubert_truck_sp",
        name = "Shubert Snow Plow",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.3000,  2.2500],
            front_right_wheel     = [ 1.3000,  2.2500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.3000, -1.6690],
            rear_right_wheel      = [ 1.3000, -1.6690],
            hood                  = [ 0.0000,  4.5000],
            trunk                 = [ 0.0000, -4.2000],
                // Doors
            front_left_door       = [-1.3000,  1.6000],
            front_right_door      = [ 1.3000,  1.6000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 4,
            gridSizeY = 4,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [63.0,  63.0,  63.0],
            top_speed_kmh = [101.0, 101.0, 101.0],
        },
        weight_kg  = [4500.0, 4500.0, 4500.0],
        heat_limit = null,
    },

    model_40 = {
        gamename = "sicily_military_truck",
        name = "Sicily Military Truck",
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
            gridSizeX = 5,
            gridSizeY = 5,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [52.0, 52.0, 52.0],
            top_speed_kmh = [83.0, 83.0, 83.0],
        },
        weight_kg  = [2750.0, 2750.0, 2750.0],
        heat_limit = null,
    },

    model_41 = {
        gamename = "smith_200_pha",
        name = "Smith Custom 200",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.3500],
            rear_right_wheel      = [ 1.2800, -1.3500],
            hood                  = [ 0.0000,  3.0000],
            trunk                 = [ 0.0000, -2.9500],
                // Doors
            front_left_door       = [-1.2800,  0.2500],
            front_right_door      = [ 1.2800,  0.2500],
            back_left_door        = [-1.2800, -0.4800],
            back_right_door       = [ 1.2800, -0.4800],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [118.0, 118.0, 127.0],
            top_speed_kmh = [190.0, 190.0, 205.0],
        },
        weight_kg  = [1500.0, 1320.0, 1320.0],
        heat_limit = null,
    },

    model_42 = {
        gamename = "smith_200_p_pha",
        name = "Smith Custom 200 Police Special",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.7000],
            front_right_wheel     = [ 1.2800,  1.7000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.3500],
            rear_right_wheel      = [ 1.2800, -1.3500],
            hood                  = [ 0.0000,  3.0000],
            trunk                 = [ 0.0000, -2.9500],
                // Doors
            front_left_door       = [-1.2800,  0.2500],
            front_right_door      = [ 1.2800,  0.2500],
            back_left_door        = [-1.2800, -0.4800],
            back_right_door       = [ 1.2800, -0.4800],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [118.0, 118.0, 127.0],
            top_speed_kmh = [190.0, 190.0, 205.0],
        },
        weight_kg  = [1500.0, 1320.0, 1320.0],
        heat_limit = null,
    },

    model_43 = {
        gamename = "smith_coupe",
        name = "Smith Coupe",
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
            gridSizeX = 3,
            gridSizeY = 1,
            volumeLimit = 70,
        },
        engine = {
            top_speed_mph = [77.0,  77.0,  100.0],
            top_speed_kmh = [124.0, 124.0, 161.0],
        },
        weight_kg  = [1090.0, 980.0, 980.0],
        heat_limit = null,
    },

    model_44 = {
        gamename = "smith_mainline_pha",
        name = "Smith Mainline",
        seats = 2,
        triggers = {
            front_left_wheel      = [-1.2800,  1.5000],
            front_right_wheel     = [ 1.2800,  1.5000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.4500],
            rear_right_wheel      = [ 1.2800, -1.4500],
            hood                  = [ 0.0000,  2.6000],
            trunk                 = [ 0.0000, -2.8000],
                // Doors
            front_left_door       = [-1.2800,  0.1000],
            front_right_door      = [ 1.2800,  0.1000],
            back_left_door        = null,
            back_right_door       = null,
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [100.0, 100.0, 110.0],
            top_speed_kmh = [160.0, 160.0, 177.0],
        },
        weight_kg  = [1500.0, 1350.0, 1350.0],
        heat_limit = null,
    },

    model_45 = {
        gamename = "smith_stingray_pha",
        name = "Smith Thunderbolt",
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
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [121.0, 121.0, 135.0],
            top_speed_kmh = [195.0, 195.0, 218.0],
        },
        weight_kg  = [1352.0, 1215.0, 1215.0],
        heat_limit = null,
    },

    model_46 = {
        gamename = "smith_truck",
        name = "Smith Truck",
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
            gridSizeX = 5,
            gridSizeY = 5,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [60.0, 60.0, 60.0],
            top_speed_kmh = [97.0, 97.0, 97.0],
        },
        weight_kg  = [3280.0, 3280.0, 3280.0],
        heat_limit = null,
    },

    model_47 = {
        gamename = "smith_v8",
        name = "Smith V8",
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
            trunk                 = null,
                // Doors
            front_left_door       = [-1.2800,  0.0000],
            front_right_door      = [ 1.2800,  0.0000],
            back_left_door        = [-1.2800, -0.7000],
            back_right_door       = [ 1.2800, -0.7000],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 2,
            volumeLimit = 60,
        },
        engine = {
            top_speed_mph = [82.0,  82.0,  87.0],
            top_speed_kmh = [133.0, 133.0, 140.0],
        },
        weight_kg  = [1166.0, 1040.0, 1040.0],
        heat_limit = null,
    },

    model_48 = {
        gamename = "smith_wagon_pha",
        name = "Smith Wagon",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.3000],
            front_right_wheel     = [ 1.2800,  1.3000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5000],
            rear_right_wheel      = [ 1.2800, -1.5000],
            hood                  = [ 0.0000,  2.6000],
            trunk                 = [ 0.0000, -2.7500],
                // Doors
            front_left_door       = [-1.2800,  0.0930],
            front_right_door      = [ 1.2800,  0.0930],
            back_left_door        = [-1.2800, -0.7500],
            back_right_door       = [ 1.2800, -0.7500],
        },
        trunk = {
            gridSizeX = 3,
            gridSizeY = 3,
            volumeLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_49 = {
        gamename = "trailer",
        name = "Trailer",
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
            volumeLimit = 100,
        },
        max_velocity          = [70.0],
        heat_limit = null,
    },

    model_50 = {
        gamename = "ulver_newyorker",
        name = "Culver Empire",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.4500],
            front_right_wheel     = [ 1.2800,  1.4500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.4500],
            rear_right_wheel      = [ 1.2800, -1.4500],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.8500],
                // Doors
            front_left_door       = [-1.2800,  0.1000],
            front_right_door      = [ 1.2800,  0.1000],
            back_left_door        = [-1.2800, -0.6000],
            back_right_door       = [ 1.2800, -0.6000],
        },
        trunk = {
            gridSizeX = 2,
            gridSizeY = 3,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [96.0,  96.0,  104.0],
            top_speed_kmh = [155.0, 155.0, 167.0],
        },
        weight_kg  = [1750.0, 1580.0, 1580.0],
        heat_limit = null,
    },

    model_51 = {
        gamename = "ulver_newyorker_p",
        name = "Culver Empire Police Special",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.4500],
            front_right_wheel     = [ 1.2800,  1.4500],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.4500],
            rear_right_wheel      = [ 1.2800, -1.4500],
            hood                  = [ 0.0000,  2.5800],
            trunk                 = [ 0.0000, -2.8500],
                // Doors
            front_left_door       = [-1.2800,  0.1000],
            front_right_door      = [ 1.2800,  0.1000],
            back_left_door        = [-1.2800, -0.6000],
            back_right_door       = [ 1.2800, -0.6000],
        },
        trunk = {
            gridSizeX = 2,
            gridSizeY = 3,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [96.0,  96.0,  104.0],
            top_speed_kmh = [155.0, 155.0, 167.0],
        },
        weight_kg  = [1750.0, 1580.0, 1580.0],
        heat_limit = null,
    },

    model_52 = {
        gamename = "walker_rocket",
        name = "Walker Rocket",
        seats = 4,
        triggers = {
            front_left_wheel      = [-1.2800,  1.6000],
            front_right_wheel     = [ 1.2800,  1.6000],
            middle_left_wheel     = null,
            middle_right_wheel    = null,
            rear_left_wheel       = [-1.2800, -1.5000],
            rear_right_wheel      = [ 1.2800, -1.5000],
            hood                  = [ 0.0000,  2.7500],
            trunk                 = [ 0.0000, -3.100],
                // Doors
            front_left_door       = [-1.2800,  0.2000],
            front_right_door      = [ 1.2800,  0.2000],
            back_left_door        = [-1.2800, -0.5500],
            back_right_door       = [ 1.2800, -0.5500],
        },
        trunk = {
            gridSizeX = 4,
            gridSizeY = 2,
            volumeLimit = 100,
        },
        engine = {
            top_speed_mph = [132.0, 132.0, 136.0],
            top_speed_kmh = [209.0, 209.0, 219.0],
        },
        weight_kg  = [1920.0, 1730.0, 1730.0],
        heat_limit = null,
    },

    model_53 = {
        gamename = "walter_coupe",
        name = "Walter Coupe",
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
            gridSizeY = 3,
            volumeLimit = 70,
        },
        engine = {
            top_speed_mph = [66.0,  66.0,  90.0],
            top_speed_kmh = [107.0, 107.0, 145.0],
        },
        weight_kg  = [942.0, 870.0, 870.0],
        heat_limit = null,
    },
};


function getVehicleInfo(modelid) {
    return vehicleInfo["model_" + modelid];
}

function getVehicleNameByModelId(modelid) {
    return vehicleInfo["model_" + modelid].name;
}

function getVehicleSeatsNumberByModelId(modelid) {
    return vehicleInfo["model_" + modelid].seats;
}

function getVehicleTrunkDefaultSizeX(modelid) {
    return vehicleInfo["model_" + modelid].trunk.gridSizeX;
}

function getVehicleTrunkDefaultSizeY(modelid) {
    return vehicleInfo["model_" + modelid].trunk.gridSizeY;
}

function getVehicleTrunkDefaultVolumeLimit(modelid) {
    return vehicleInfo["model_" + modelid].trunk.volumeLimit;
}

function getVehicleSpeedLimit(modelid, tuneLevel) {
    local tuneLevel = (tuneLevel <= 0) ? 1 : tuneLevel.tointeger();
    return vehicleInfo["model_" + modelid].engine.top_speed_mph[tuneLevel];
}

function getVehicleTrunkOffset(modelid) {
    local data = vehicleInfo["model_" + modelid].triggers;
    return (data.trunk != null)
      ? Vector3( data.trunk[0],
                 data.trunk[1],
                 0.0)
      : data.trunk;
}

