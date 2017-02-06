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
local vehicleMetaData = {
    model_0  = "ascot_baileys200_pha",
        // Passanger meta data
        seats                 = 2,
        // Geometry meta data (relative positions from vehicle center)
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
            // Engine power meta data
        max_velocity          = 120.0, // In Stock
            // Stock components
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 60.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_1  = "berkley_kingfisher_pha",
        seats                 = 2,
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
        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 90.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_2  = "fuel_tank", // fuel trailer
        seats                 = 0,
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
        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 50.0, // gallons total
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_3  = "gai_353_military_truck",
        seats                 = 2,
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
        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 200.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_4  = "hank_b",
        seats                 = 2,
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
        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 200.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_5  = "hank_fueltank",
        seats                 = 2,
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
        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 200.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_6  = "hot_rod_1",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 70.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_7  = "hot_rod_2",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 70.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_8  = "hot_rod_3",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 70.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_9  = "houston_wasp_pha",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 70.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_10 = "isw_508",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 70.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_11 = "jeep",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 58.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_12 = "jeep_civil",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 58.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_13 = "jefferson_futura_pha",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 90.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_14 = "jefferson_provincial",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 70.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_15 = "lassiter_69",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 90.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_16 = "lassiter_69_destr",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 90.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_17 = "lassiter_75_fmv",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 90.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_18 = "lassiter_75_pha",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 90.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_19 = "milk_truck",
        seats                 = 1,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 80.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_20 = "parry_bus",
        seats                 = 1,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 150.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_21 = "parry_prison",
        seats                 = 1,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 150.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_22 = "potomac_indian",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 70.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_23 = "quicksilver_windsor_pha",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 60.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_24 = "quicksilver_windsor_taxi_pha",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 60.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_25 = "shubert_38",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 65.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_26 = "shubert_38_destr",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 65.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_27 = "shubert_armoured",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 100.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_28 = "shubert_beverly",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 80.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_29 = "shubert_frigate_pha",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 70.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_30 = "shubert_hearse",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 65.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_31 = "shubert_panel",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 65.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_32 = "shubert_panel_m14",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 65.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_33 = "shubert_taxi",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 65.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_34 = "shubert_truck_cc",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 100.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_35 = "shubert_truck_ct",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 100.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_36 = "shubert_truck_ct_cigar",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 100.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_37 = "shubert_truck_qd",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 100.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_38 = "shubert_truck_sg",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 100.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_39 = "shubert_truck_sp",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 100.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_40 = "sicily_military_truck",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 80.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_41 = "smith_200_pha",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 80.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_42 = "smith_200_p_pha",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 80.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_43 = "smith_coupe",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 50.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_44 = "smith_mainline_pha",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 65.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_45 = "smith_stingray_pha",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 70.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_46 = "smith_truck",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 80.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_47 = "smith_v8",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 65.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_48 = "smith_wagon_pha",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 50.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_49 = "trailer",
        seats                 = 0,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 50.0, // gallons total
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_50 = "ulver_newyorker",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 70.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_51 = "ulver_newyorker_p",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 70.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_52 = "walker_rocket",
        seats                 = 4,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 80.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },

    model_53 = "walter_coupe",
        seats                 = 2,

        max_velocity          = 70.0,
        components            = {
            engine = {
                cl_name  = VehicleComponent.Engine,
                type     = "Engine",
                subtype  = "Engine",
                partID   = 2,
                fuel_consumption_idle = 0.01,
                fuel_consumption_move = 0.02,
            },
            fueltank = {
                cl_name  = VehicleComponent.FuelTank,
                type     = "Tank",
                subtype  = "Fuel",
                partID   = 3,
                capacity = 40.0, // gallons total
            },
            hood = {
                cl_name  = VehicleComponent.Hood,
                type     = "Hood",
                subtype  = "Hood",
                partID   = 4,
            },
            trunk = {
                cl_name  = VehicleComponent.Trunk,
                type     = "Trunk",
                subtype  = "Trunk",
                partID   = 5,
            },
            lights = {
                cl_name  = VehicleComponent.Lights,
                type     = "Lights",
                subtype  = "Lights",
                partID   = 6,
            },
            gabarites = {
                cl_name  = VehicleComponent.GabariteLights,
                type     = "Lights",
                subtype  = "Gabarite",
                partID   = 7,
            },
        },
};
