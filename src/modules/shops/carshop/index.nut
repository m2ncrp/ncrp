// constants
const CARSHOP_STATE_FREE = "free";
const CARSHOP_DISTANCE   = 50.0; // distance for command
const CARSHOP_PRICE_DIFF = 50.0;

const DIAMOND_CARSHOP_X = -204.324;
const DIAMOND_CARSHOP_Y =  826.917;
const DIAMOND_CARSHOP_Z = -20.8854;

const BADGUY_CARSHOP_X  = -632.584;
const BADGUY_CARSHOP_Y  =  959.446;
const BADGUY_CARSHOP_Z  = -19.0542;

const TRUCK_SHOP_X  = 602.769;
const TRUCK_SHOP_Y  = 739.019;
const TRUCK_SHOP_Z  = -16.5903;

local DIAMOND_MOTORS_PLACE_COORDS = [ -188.079, 812.369, -224.955, 843.047 ];
local DIAMOND_MOTORS_PLACE_NAME = "DiamondMotors";

local TRUCK_SHOP_PLACE_COORDS = [ 597.339, 751.284, 610.922, 724.341 ];
local TRUCK_SHOP_PLACE_NAME = "TruckShop";

local WORKING_HOUR = {
    "diamondMotors": {
        "start": 9,
        "end": 19
    },
    "truckShop": {
        "start": 8,
        "end": 18
    }
}

/**
 * Regiser coordinates for vehicles (4 doors at diamond motors)
 * @type {Array}
 */
local vehiclePositions = {
    "diamondMotors": [ // diamond motors
        { state = CARSHOP_STATE_FREE, position = Vector3(-205.466, 835.142, -20.9735), rotation = Vector3(159.300, 0.346464, 2.31108) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-209.199, 833.547, -21.0283), rotation = Vector3(160.662, 0.470803, 2.37895) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-213.164, 832.172, -20.9392), rotation = Vector3(160.965, 0.350293, 2.35895) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-217.133, 830.954, -20.9312), rotation = Vector3(159.368, 0.344307, 2.36111) },

        { state = CARSHOP_STATE_FREE, position = Vector3(-220.716, 827.691, -20.8228), rotation = Vector3(120.179, -0.570173, 3.1387) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-221.450, 822.812, -20.7874), rotation = Vector3(92.0500, 3.58971,  1.63252) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-221.450, 818.652, -20.6618), rotation = Vector3(92.0500, 3.72205, 0.869233) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-221.450, 814.535, -20.6319), rotation = Vector3(92.0500, 3.80713, 0.798234) },
    ],
    "badGuy": [   // bad guy
        //{ state = CARSHOP_STATE_FREE, position = Vector3(-626.011, 949.629, -18.7708), rotation = Vector3(-89.2381, 1.3864, -0.456439) },
        //{ state = CARSHOP_STATE_FREE, position = Vector3(-625.906, 954.701, -18.7714), rotation = Vector3(-89.3728, 1.50941, -0.26591) },
    ],
    "truckShop": [ // truck shop
        //{ state = CARSHOP_STATE_FREE, position = Vector3(-705.155, 1456.00, -6.48204), rotation = Vector3(-43.0174, -0.252974, -0.64192) },
        //{ state = CARSHOP_STATE_FREE, position = Vector3(-708.151, 1453.25, -6.50832), rotation = Vector3(-43.1396, -0.445434, -1.12674) },
        //{ state = CARSHOP_STATE_FREE, position = Vector3(-711.119, 1450.54, -6.52765), rotation = Vector3(-41.8644, -0.613728,  -1.6044) },
        //{ state = CARSHOP_STATE_FREE, position = Vector3(-714.315, 1447.55, -6.52792), rotation = Vector3(-41.1587, -1.82778, -0.432325) },
        //
        { state = CARSHOP_STATE_FREE, position = Vector3(  605.94, 731.011, -16.2717), rotation = Vector3(-45.6876, 0.0817516, 0.254064) },
        { state = CARSHOP_STATE_FREE, position = Vector3(  605.94, 737.011, -16.2717), rotation = Vector3(-45.6876, 0.0817516, 0.254064) },
        { state = CARSHOP_STATE_FREE, position = Vector3(  605.94, 743.011, -16.2717), rotation = Vector3(-45.6876, 0.0817516, 0.254064) },
    ]
}

/**
 * Array with current market car prices
 * @type {Array}
 */
local carPricesAll = [
       { modelid = 0   , price = 8200  , rent = 0.84, title = "Ascot Bailey S200"            },
       { modelid = 1   , price = 5600  , rent = 0.71, title = "Berkley Kingfisher"           },
       { modelid = 2   , price = 8200  , rent = 0.84, title = "Fuel Tank"                    },
       { modelid = 3   , price = 8200  , rent = 0.84, title = "GAI 353 Military Truck"       },
       { modelid = 5   , price = 18000 , rent = 2.71, title = "Hank B Fuel Tank"             },
       { modelid = 6   , price = 18000 , rent = 2.71, title = "Walter Hot Rod"               },
       { modelid = 7   , price = 18000 , rent = 2.71, title = "Smith 34 Hot Rod"             },
       { modelid = 8   , price = 18000 , rent = 2.71, title = "Shubert Pickup Hot Rod"       },
       { modelid = 9   , price = 2710  , rent = 0.42, title = "Houston Wasp"                 },
       { modelid = 10  , price = 12508 , rent = 1.08, title = "ISW 508"                      },
       { modelid = 11  , price = 2500  , rent = 1.08, title = "Walter Military"              },
       { modelid = 12  , price = 2100  , rent = 0.34, title = "Walter Utility"               },
       { modelid = 13  , price = 16700 , rent = 2.75, title = "Jefferson Futura"             },
       { modelid = 14  , price = 5400  , rent = 0.61, title = "Jefferson Provincial"         },
       { modelid = 15  , price = 3000  , rent = 0.46, title = "Lassiter Series 69"           },
       { modelid = 16  , price = 3000  , rent = 0.46, title = "Lassiter Series 69 Destroy"   },
       { modelid = 17  , price = 9100  , rent = 0.46, title = "Lassiter Series 75 Hollywood FMV" },
       { modelid = 18  , price = 9100  , rent = 0.89, title = "Lassiter Series 75 Hollywood" },
       { modelid = 19  , price = 9100  , rent = 0.89, title = "Milk Truck"                   },
       { modelid = 20  , price = 9100  , rent = 0.89, title = "Parry Bus"                    },
       { modelid = 21  , price = 9100  , rent = 0.89, title = "Parry Bus Police"             },
       { modelid = 22  , price = 2050  , rent = 0.32, title = "Potomac Indian"               },
       { modelid = 23  , price = 1550  , rent = 0.28, title = "Quicksilver Windsor"          },
       { modelid = 24  , price = 1550  , rent = 0.28, title = "Quicksilver Windsor Taxi"     },
       { modelid = 25  , price = 680   , rent = 0.17, title = "Shubert 38"                   },
       { modelid = 26  , price = 680   , rent = 0.17, title = "Shubert 38 Destroy"           },
       { modelid = 27  , price = 7680  , rent = 0.17, title = "Shubert Armoured"             },
       { modelid = 28  , price = 3500  , rent = 0.36, title = "Shubert Beverly"              },
       { modelid = 29  , price = 5750  , rent = 0.56, title = "Shubert Frigate"              },
       { modelid = 30  , price = 1050  , rent = 0.56, title = "Shubert Hearse"               },
       { modelid = 31  , price = 810   , rent = 0.17, title = "Shubert 38 Panel Truck"       },
       { modelid = 32  , price = 810   , rent = 0.17, title = "Shubert 38 Panel M14"         },
       { modelid = 33  , price = 810   , rent = 0.17, title = "Shubert 38 Taxi"              },
       { modelid = 34  , price = 810   , rent = 0.17, title = "Shubert Truck Meat"           },
       { modelid = 35  , price = 2410  , rent = 0.0 , title = "Shubert Truck Flatbed"        },
       { modelid = 36  , price = 2410  , rent = 0.0 , title = "Shubert Truck Cigarettes"     },
       { modelid = 37  , price = 2830  , rent = 0.0 , title = "Shubert Truck Covered"        },
       { modelid = 38  , price = 2830  , rent = 0.0 , title = "Shubert Truck Seagift"        },
       { modelid = 39  , price = 2830  , rent = 0.0 , title = "Shubert Truck Snowplow"       },
       { modelid = 40  , price = 2830  , rent = 0.0 , title = "Sicily Military Truck"        },
       { modelid = 41  , price = 3900  , rent = 0.38, title = "Smith Custom 200"             },
       { modelid = 42  , price = 3900  , rent = 0.38, title = "Smith Custom 200 Police"      },
       { modelid = 43  , price = 390   , rent = 0.17, title = "Smith Coupe"                  },
       { modelid = 44  , price = 1150  , rent = 0.27, title = "Smith Mainline"               },
       { modelid = 45  , price = 4600  , rent = 0.58, title = "Smith Thunderbolt"            },
       { modelid = 46  , price = 1960  , rent = 0.0 , title = "Smith Truck"                  }
       { modelid = 47  , price = 590   , rent = 0.16, title = "Smith V8"                     },
       { modelid = 48  , price = 1210  , rent = 0.26, title = "Smith Deluxe Station Wagon"   },
       { modelid = 49  , price = 1210  , rent = 0.26, title = "Trailer Seagift"              },
       { modelid = 50  , price = 1475  , rent = 0.31, title = "Culver Empire"                },
       { modelid = 51  , price = 1475  , rent = 0.31, title = "Culver Empire Police"         },
       { modelid = 52  , price = 2850  , rent = 0.60, title = "Walker Rocket"                },
       { modelid = 53  , price = 510   , rent = 0.20, title = "Walter Coupe"                 },
       { modelid = 54  , price = 22500 , rent = 0.20, title = "Delizia Grandeamerica"        },
       { modelid = 55  , price = 22500 , rent = 0.20, title = "Вилочный погрузчик"           },
       { modelid = 56  , price = 26000 , rent = 0.20, title = "Potomac Elysium"              },
       { modelid = 57  , price = 18500 , rent = 0.20, title = "Roller GL300"                 },
       { modelid = 58  , price = 2300  , rent = 0.20, title = "Waybar Hot Rod"               },
       { modelid = 59  , price = 2800  , rent = 0.20, title = "Chaffeque XT"                 }
];


local carOnSale = {
    "diamondMotors": [ 0, 1, 9, 10, 12, 13, 14, 15, 18, 22, 23, 25, 28, 29, 41, 43, 44, 45, 47, 48, 50, 52, 53, 54, 56, 57, 59 ],
    "truckShop": [ 35, 37, 46 ]
};

local currentcarcolor = {};
local carPrices = {};

// translations
alternativeTranslate({
    "en|shops.carshop.gotothere"            : "If you want to buy a car go to Diamond Motors or to uncle Jonathan!"
    "en|shops.carshop.gotothere2"           : "If you want to buy a car go to Diamond Motors or to Bad Guy Motors!"
    "en|shops.carshop.welcome"              : "Hello there, %s! If you want to buy a car, you should first choose it via: /car list"
    "en|shops.carshop.nofreespace"          : "There is no free space near Parking. Please come again later!"
    "en|shops.carshop.money.error"          : "Sorry, you dont have enough money."
    "en|shops.carshop.selectmodel"          : "You can browse vehicle models, and their prices via: /car list"
    "en|shops.carshop.list.title"           : "Select car you like, and proceed to buying via: /buy car MODELID"
    "en|shops.carshop.list.entry"           : " - Model #%d, '%s'. Cost: $%.2f"
    "en|shops.carshop.success"              : "Congratulations on your purchase! Drive safe and enjoy your trip!"
    "en|shops.carshop.notforsale"           : "This car is not for sale."
    "en|shops.carshop.canbuy"               : "You can buy this car for $%.2f: /buy car"
    "en|shops.carshop.paint"                : "To change color - press 2."
    "en|shops.carshop.paint2"               : "To change main color - press 1. To change advanced color - press 2."
    "en|shops.carshop.diamondMotors.closed" : "The car shop is closed. Opening hours: %s:00 - %s:00."
    "en|shops.carshop.welcome1"             : "Welcome to the car shop Diamond Motors."
    "en|shops.carshop.welcome2"             : "We are pleased to offer you a wide range of cars."
    "en|shops.carshop.welcome3"             : "Select a car that suits your needs and sit into."
    "en|shops.carshop.waitingyou"           : "We are waiting for you to buy your «Diamond Motor»!"
    "en|shops.carshop.dontsteal"            : "Don't try to steal the car!"

    "en|shops.carshop.truck.welcome1"       : "Hello! My name is uncle Jonathan. I sell trucks. Do you want to buy?"
    "en|shops.carshop.truck.welcome2"       : "Select a truck that suits your needs and sit into."
    "en|shops.carshop.truckShop.closed"     : "Come back tomorrow from %s:00 to %s:00."

    "en|shops.carshop.help.title"           : "List of available commands for CAR SHOP:"
    "en|shops.carshop.help.list"            : "Lists cars which are available to buy"
    "en|shops.carshop.help.buy"             : "Attempt to buy car by provided modelid"

    "ru|shops.carshop.gotothere"            : "Если вы хотите купить авто, отправляйтесь в Diamond Motors или к дядюшке Джонатану!"
    "ru|shops.carshop.gotothere2"           : "Если вы хотите купить авто, отправляйтесь в Diamond Motors или Bad Guy Motors!"
    "ru|shops.carshop.welcome"              : "Добро пожаловать, %s! Если вы хотите купить авто, выберите модель через: /car list"
    "ru|shops.carshop.nofreespace"          : "К сожалению, на парковке нету свободных мест. Зайдите позже."
    "ru|shops.carshop.money.error"          : "К сожалению, у вас недостаточно денег."
    "ru|shops.carshop.selectmodel"          : "Вы можете посмотреть модели авто и их цены, используя: /car list"
    "ru|shops.carshop.list.title"           : "Выберите модель, которая вам нравится, и купите её, используя: /buy car MODELID"
    "ru|shops.carshop.list.entry"           : " - Модель #%d, «%s». Цена: $%.2f"
    "ru|shops.carshop.success"              : "Поздравляем с покупкой! Наслаждайтесь поездкой!"
    "ru|shops.carshop.notforsale"           : "Этот автомобиль нельзя купить."
    "ru|shops.carshop.canbuy"               : "Вы можете купить этот автомобиль за $%.2f: /buy car"
    "ru|shops.carshop.paint"                : "Выбор цвета покраски - клавиша 2."
    "ru|shops.carshop.paint2"               : "Смена основого цвета - клавиша 1. Смена доп. цвета - клавиша 2."
    "ru|shops.carshop.diamondMotors.closed" : "Автосалон закрыт. Чаcы работы с %s:00 до %s:00."
    "ru|shops.carshop.welcome1"             : "Добро пожаловать в автосалон Diamond Motors."
    "ru|shops.carshop.welcome2"             : "Мы рады предложить вам широкий ассортимент автомобилей."
    "ru|shops.carshop.welcome3"             : "Выбирайте любое понравившееся авто и садитесь в него."
    "ru|shops.carshop.waitingyou"           : "Ждём вас за покупкой «бриллиантового мотора»!"
    "ru|shops.carshop.dontsteal"            : "Не пытайтесь угнать автомобиль!"

    "ru|shops.carshop.truck.welcome1"       : "Привет! Меня зовут дядюшка Джонатан. Я продаю грузовики. Не желаешь приобрести?"
    "ru|shops.carshop.truck.welcome2"       : "Выбирай любой понравившийся трак и садись в него."
    "ru|shops.carshop.truckShop.closed"     : "Я отдыхаю. Приходи завтра с %s:00 до %s:00."


    "ru|shops.carshop.help.title"    : "Список команд для покупки автомобиля:"
    "ru|shops.carshop.help.list"     : "Посмотреть список авто, доступных для покупки"
    "ru|shops.carshop.help.buy"      : "Купить выбранный автомобиль"
});

/* ==================================================================== EVENTS ================================================================================= */

event("onServerStarted", function() {
    createBlip  ( DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, ICON_LOGO_CAR, ICON_RANGE_VISIBLE );
    createPlace(DIAMOND_MOTORS_PLACE_NAME, DIAMOND_MOTORS_PLACE_COORDS[0], DIAMOND_MOTORS_PLACE_COORDS[1], DIAMOND_MOTORS_PLACE_COORDS[2], DIAMOND_MOTORS_PLACE_COORDS[3]);

    if(getSettingsValue("isTruckShopEnabled")) {
        createBlip(TRUCK_SHOP_X, TRUCK_SHOP_Y, ICON_LOGO_CAR, ICON_RANGE_VISIBLE );
        createPlace(TRUCK_SHOP_PLACE_NAME, TRUCK_SHOP_PLACE_COORDS[0], TRUCK_SHOP_PLACE_COORDS[1], TRUCK_SHOP_PLACE_COORDS[2], TRUCK_SHOP_PLACE_COORDS[3]);
    }

    carPrices = generateRandomCars();

/*
    msg(playerid, "shops.carshop.list.title", CL_INFO);

    local pos = getPlayerPosition( playerid );
    local vehicleid = createVehicle( modelid.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
    // setVehicleColour(vehicleid, 0, 0, 0, 0, 0, 0);
    setVehicleOwner(vehicleid, "__cityNCRP");
    setVehicleSaving(vehicleid, true); // it will be saved to database
    setVehicleRespawnEx(vehicleid, false); // it will respawn (specially)
*/    // spawn it

/*
    // Badguy Motors
    create3DText( BADGUY_CARSHOP_X, BADGUY_CARSHOP_Y, BADGUY_CARSHOP_Z + 0.35, "BAD GUY MOTORS", CL_ROYALBLUE );
    create3DText( BADGUY_CARSHOP_X, BADGUY_CARSHOP_Y, BADGUY_CARSHOP_Z + 0.20, "/car", CL_WHITE.applyAlpha(75), CARSHOP_DISTANCE );

    createBlip  ( BADGUY_CARSHOP_X, BADGUY_CARSHOP_Y, ICON_GEAR, ICON_RANGE_FULL );
*/
    /**
     * Decorations
     */
/*
    local decorations = {
        // bad guy
        owner = createVehicle(10, -636.462, 974, -18.8841, 179.847, -0.177159, 0.506108), // isw_508 (its like owners car)
        truck = createVehicle(4,  -621.439, 978.502, -18.5955, -89.51, 0.508353, -0.0252226), // truck (its like some truck or whatever)
        les69 = createVehicle(15, -626.467, 968.901, -18.8009, -89.6654, 0.517828, -0.130615), // lesisier69 car, just for fun
    };

    // paint lesisier69 black
    setVehicleColour( decorations.les69, 33, 33, 35, 33, 33, 35 );

    foreach (idx, vehicleid in decorations) {
        setVehicleOwner(vehicleid, VEHICLE_OWNER_CITY);
        setVehicleDirtLevel(vehicleid, 0.0);
    }
*/
});

event("onPlayerPlaceEnter", function(playerid, name) {
    if (name == DIAMOND_MOTORS_PLACE_NAME) {
        if(isPlayerInVehicle(playerid)) {
            local vehicleid = getPlayerVehicle(playerid);
            local vehSpeed = getVehicleSpeed(vehicleid);
            local vehSpeedNew = [];
            if (vehSpeed[0] <= 0) vehSpeed[0] = (vehSpeed[0] - 1) * -1;
            if (vehSpeed[1] >= 0) vehSpeed[1] = (vehSpeed[1] + 1) * -1;
            setVehicleSpeed(vehicleid, vehSpeed[0], vehSpeed[1], vehSpeed[2]);
        } else {
            local hour = getHour();
            if(hour < WORKING_HOUR.diamondMotors.start || hour >= WORKING_HOUR.diamondMotors.end) {
                return msg( playerid, "shops.carshop.diamondMotors.closed", [ WORKING_HOUR.diamondMotors.start.tostring(), WORKING_HOUR.diamondMotors.end.tostring()], CL_ROYALBLUE );
            }
            msg(playerid, "===========================================", CL_HELP_LINE);
            msg(playerid, "shops.carshop.welcome1", CL_FIREBUSH);
            msg(playerid, "shops.carshop.welcome2", CL_FIREBUSH);
            msg(playerid, "shops.carshop.welcome3", CL_SILVERSAND);
        }
    }

    if (name == TRUCK_SHOP_PLACE_NAME) {
        if(isPlayerInVehicle(playerid)) {
            local vehicleid = getPlayerVehicle(playerid);
            local vehSpeed = getVehicleSpeed(vehicleid);
            local vehSpeedNew = [];
            if (vehSpeed[1] <= 0) vehSpeed[1] = (vehSpeed[1] + 1) * -1;
            setVehicleSpeed(vehicleid, vehSpeed[0], vehSpeed[1], vehSpeed[2]);
        } else {
            local hour = getHour();
            if(hour < WORKING_HOUR.truckShop.start || hour >= WORKING_HOUR.truckShop.end) {
                return msg( playerid, "shops.carshop.truckShop.closed", [ WORKING_HOUR.truckShop.start.tostring(), WORKING_HOUR.truckShop.end.tostring()], CL_ROYALBLUE );
            }
            msg(playerid, "===========================================", CL_HELP_LINE);
            msg(playerid, "shops.carshop.truck.welcome1", CL_FIREBUSH);
            msg(playerid, "shops.carshop.truck.welcome2", CL_SILVERSAND);
        }
    }
});

event("onPlayerPlaceExit", function(playerid, name) {
    if (name == DIAMOND_MOTORS_PLACE_NAME) {

        if (!isPlayerInVehicle(playerid)) return msg(playerid, "shops.carshop.waitingyou", CL_FIREBUSH);

        local vehicleid = getPlayerVehicle(playerid);
        local plate = getVehiclePlateText( vehicleid );

        if(plate != " SALE ") {
            return;
        }

        blockDriving(playerid, vehicleid);
        //kickPlayer( playerid );
        msg(playerid, "shops.carshop.dontsteal", CL_THUNDERBIRD);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
        tryRespawnVehicleById(vehicleid, true);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
    }
});

event ( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if (isPlayerVehicleOwner(playerid, vehicleid)) {
        return;
    }
    local plate = getVehiclePlateText( vehicleid );

    if(plate != " SALE ") {
        return;
    }

    blockDriving(playerid, vehicleid);

    local shopName = getPlayerCarShopName(playerid);
    local hour = getHour();
    if(hour < WORKING_HOUR[shopName].start || hour >= WORKING_HOUR[shopName].end) {
        return msg( playerid, "shops.carshop."+shopName+".closed", [ WORKING_HOUR[shopName].start.tostring(), WORKING_HOUR[shopName].end.tostring()], CL_ROYALBLUE );
    }

    local modelid = getVehicleModel(vehicleid);
    local car = getCarInfoModelById(modelid);

           msg(playerid, "shops.carshop.canbuy", [car.price], CL_FIREBUSH);
    return msg(playerid, "shops.carshop.paint", CL_SILVERSAND);



});

/*
event("onPlayerVehicleEnter", function(playerid, vehiclid, seat) {
    return carShopFreeCarSlot(playerid, vehiclid);
});

event("onServerMinuteChange", function() {
    return carShopCheckFreeSpace();
});
*/

/* ==================================================================== FUNCTIONS ================================================================================= */

/**
 * Get id of car shop were player is staying at
 * @param  {Inerger} playerid
 * @return {Integer}
 */
function getPlayerCarShopName(playerid) {
    if (getDistanceToPoint(playerid, DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, DIAMOND_CARSHOP_Z) <= CARSHOP_DISTANCE) {
        return "diamondMotors";
    }

    // if (getDistanceToPoint(playerid, BADGUY_CARSHOP_X , BADGUY_CARSHOP_Y , BADGUY_CARSHOP_Z ) <= CARSHOP_DISTANCE) {
    //     return "truckShop";
    // }

    if (getDistanceToPoint(playerid, TRUCK_SHOP_X, TRUCK_SHOP_Y , TRUCK_SHOP_Z ) <= CARSHOP_DISTANCE) {
        return "truckShop";
    }

    return null;
}

/**
 * Check if player is near the car shop
 * @param  {Integer}  playerid
 * @return {Boolean}
 */
function isPlayerNearCarShop(playerid) {
    return (getPlayerCarShopIndex(playerid) != null)
}

/**
 * Return car prices array
 * @return {Array}
 */
function getCarPrices(carShopIndex = 0) {
    return carPrices[carShopIndex];
}

/**
 * Check if there is free car shop point
 * @return {Boolean} [description]
 */
function isThereFreeCarShopPoint(carShopIndex) {
    return (getCarShopSlotById(carShopIndex) != null);
}

/**
 * Get free car shop point
 * @return {} [description]
 */
function getCarShopSlotById(carShopIndex, id = CARSHOP_STATE_FREE) {
    foreach (idx, value in vehiclePositions[carShopIndex]) {
        if (value.state == id) {
            return value;
        }
    }

    return null;
}

/**
 * Get car shop model by number id
 * @param  {Integer} modelid
 * @return {Table}
 */
function getCarShopModelById(modelid, carShopIndex = 0) {
    foreach(idx, car in carPrices[carShopIndex]) {
        if (car.modelid == modelid.tointeger()) {
            return car;
        }
    }

    return null;
}

/**
 * Get car info by modelid
 * @param  {Integer} modelid
 * @return {Table}
 */
function getCarInfoModelById(modelid) {
    foreach(idx, car in carPricesAll) {
        if (car.modelid == modelid.tointeger()) {
            return car;
        }
    }

    return null;
}

/**
 * Check for free space near car shop
 * @return {Boolean}
 */
function carShopCheckFreeSpace() {
    // TODO: add in "car teleportation update"
    // foreach (idx, value in getAll) {
    //     // Code
    // }
}

/**
 * Try to free slot point that is might be takend by vehicle
 * @param {Integer} playerid
 * @param {Integer} vehicleid
 */
function carShopFreeCarSlot(playerid, vehicleid) {
    if (!isPlayerVehicleOwner(playerid, vehicleid)) return;

    // try to get slot by vehicle
    local slot = getCarShopSlotById(0, vehicleid);

    if (!slot) {
        slot = getCarShopSlotById(1, vehicleid);
    }

    // if slot exists - remove current car from the slot
    if (slot) {
        slot.state = CARSHOP_STATE_FREE;
    }
}


function carShopChangeColor(playerid) {

    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getPlayerVehicle(playerid);
    local plate = getVehiclePlateText(vehicleid);
    if(plate != " SALE ") {
        return;
    }

    local shopName = getPlayerCarShopName(playerid);
    local hour = getHour();
    if(hour < WORKING_HOUR[shopName].start || hour >= WORKING_HOUR[shopName].end) {
        return;
    }

    local carpaints = getVehicleColorsArray( vehicleid );

    local num = currentcarcolor[vehicleid] + 1;
    if(num >= carpaints.len()) num = 0;

    local cr = carpaints[num];
    currentcarcolor[vehicleid] = num;

    setVehicleColour(vehicleid, cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
}

function generateRandomCars() {

    local shops = ["diamondMotors"];

    if(getSettingsValue("isTruckShopEnabled")) shops.push("truckShop");

    local carPricesArray = [];

    foreach (idx, shopName in shops) {

        local spaces = vehiclePositions[shopName];
        local countFreeSpaces = spaces.len();

        local carPricesClone = clone(carPricesAll);

        for (local i = 0; i < countFreeSpaces; i++) {
            local rand = random(0, carPricesClone.len() - 1);
            if( carOnSale[shopName].find(carPricesClone[rand].modelid) == null ) { i--; /* dbg("nicht"); */ continue; }

            local offsetY = 0;
            if(carPricesClone[rand].modelid == 46) {
                offsetY = 0.184;
            }

            local vehicleid = createVehicle(carPricesClone[rand].modelid,
                spaces[i].position.x, spaces[i].position.y, spaces[i].position.z + offsetY,
                spaces[i].rotation.x, spaces[i].rotation.y, spaces[i].rotation.z
            );
            currentcarcolor[vehicleid] <- 0;
            setVehiclePlateText(vehicleid, " SALE ");
            setVehicleDirtLevel(vehicleid, 0.0);
            delayedFunction(1000, function() { setRandomVehicleColors(vehicleid); });
            repairVehicle(vehicleid);

            carPricesArray.push(carPricesClone[rand]);
            carPricesClone.remove(rand);
        }
        carPricesClone.clear();
    }

    return carPricesArray;

}


/* ==================================================================== COMMANDS ================================================================================= */

/**
 * Attempt to by car model
 * Usage: /buy car
 */
cmd("buy", "car", function(playerid) {

    if(!isPlayerInVehicle(playerid)) {
        return msg(playerid, "shops.carshop.gotothere", getPlayerName(playerid), CL_WARNING);
    }

    local vehicleid = getPlayerVehicle(playerid);
    local plate = getVehiclePlateText(vehicleid);

    if(plate != " SALE ") {
        return msg(playerid, "shops.carshop.notforsale", CL_WARNING);
    }


    local shopName = getPlayerCarShopName(playerid);
    local hour = getHour();
    if(hour < WORKING_HOUR[shopName].start || hour >= WORKING_HOUR[shopName].end) {
        return msg( playerid, "shops.carshop."+shopName+".closed", [ WORKING_HOUR[shopName].start.tostring(), WORKING_HOUR[shopName].end.tostring()], CL_ROYALBLUE );
    }

    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_ERROR);
    }

    local modelid = getVehicleModel(vehicleid);
    local car = getCarInfoModelById(modelid);

    if (!canMoneyBeSubstracted(playerid, car.price)) {
        //triggerClientEvent(playerid, "hideCarShopGUI");
        return msg(playerid, "shops.carshop.money.error", CL_ERROR);
    }

    local vehicleKey = Item.VehicleKey();
    if (!players[playerid].inventory.isFreeVolume(vehicleKey)) {
        return msg(playerid, "inventory.volume.notenough", CL_ERROR);
    }

    // take money
    subMoneyToPlayer(playerid, car.price);
    addWorldMoney(car.price);

    local vehiclePlate = getRandomVehiclePlate();

    // set params
    setVehicleOwner(vehicleid, playerid);
    setVehiclePlateText(vehicleid, vehiclePlate);
    setVehicleSaving(vehicleid, true);
    setVehicleRespawnEx(vehicleid, false);
    setVehicleDirtLevel(vehicleid, 0.0);
    repairVehicle(vehicleid);
    unblockDriving(vehicleid);

    trySaveVehicle(vehicleid)

    local veh = getVehicleEntity(vehicleid);
    if(veh && !("tax" in veh.data)) veh.data.tax <- 0;

    vehicleKey.setData("id", __vehicles[vehicleid].entity.id);

    players[playerid].inventory.push( vehicleKey );
    vehicleKey.save();
    players[playerid].inventory.sync();

    //triggerClientEvent(playerid, "hideCarShopGUI");
    return msg(playerid, "shops.carshop.success", CL_SUCCESS);
});

/* ==================================================================== BINDS ================================================================================= */

key("2", function(playerid) {
    carShopChangeColor(playerid);
}, KEY_UP);
