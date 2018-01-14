// constants
const CARSHOP_STATE_FREE = "free";
const CARSHOP_DISTANCE   = 5.0; // distance for command
const CARSHOP_PRICE_DIFF = 50.0;

const DIAMOND_CARSHOP_X = -204.324;
const DIAMOND_CARSHOP_Y =  826.917;
const DIAMOND_CARSHOP_Z = -20.8854;

const BADGUY_CARSHOP_X  = -632.584;
const BADGUY_CARSHOP_Y  =  959.446;
const BADGUY_CARSHOP_Z  = -19.0542;

local CARSHOP_PLACE_COORDS = [ -188.079, 812.369, -224.955, 843.047 ];
local CARSHOP_PLACE_NAME = "CarShop";

local CARSHOP_WORKING_HOUR_START = 8;
local CARSHOP_WORKING_HOUR_END = 18;

/**
 * Regiser coordinates for vehicles (4 doors at diamond motors)
 * @type {Array}
 */
local vehiclePositions = [
    [   // diamond motors
        { state = CARSHOP_STATE_FREE, position = Vector3(-205.466, 835.142, -20.9735), rotation = Vector3(159.300, 0.346464, 2.31108) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-209.199, 833.547, -21.0283), rotation = Vector3(160.662, 0.470803, 2.37895) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-213.164, 832.172, -20.9392), rotation = Vector3(160.965, 0.350293, 2.35895) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-217.133, 830.954, -20.9312), rotation = Vector3(159.368, 0.344307, 2.36111) },

        { state = CARSHOP_STATE_FREE, position = Vector3(-220.716, 827.691, -20.8228), rotation = Vector3(120.179, -0.570173, 3.1387) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-221.450, 822.812, -20.7874), rotation = Vector3(92.0500, 3.58971,  1.63252) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-221.450, 818.652, -20.6618), rotation = Vector3(92.0500, 3.72205, 0.869233) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-221.450, 814.535, -20.6319), rotation = Vector3(92.0500, 3.80713, 0.798234) },
    ],
    [   // bad guy
        { state = CARSHOP_STATE_FREE, position = Vector3(-626.011, 949.629, -18.7708), rotation = Vector3(-89.2381, 1.3864, -0.456439) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-625.906, 954.701, -18.7714), rotation = Vector3(-89.3728, 1.50941, -0.26591) },
    ]
];

/**
 * Array with current market car prices
 * @type {Array}
 */
local carPricesAll = [
    [   // diamond motors
        { modelid = 0  , price = 7690 , rent = 0.74, title = "Ascot Bailey S200"            },
        { modelid = 1  , price = 6325 , rent = 0.61, title = "Berkley Kingfisher"           },
        { modelid = 9  , price = 2810 , rent = 0.32, title = "Houston Wasp"                 },
        { modelid = 10 , price = 10070, rent = 0.98, title = "ISW 508"                      },
        { modelid = 12 , price = 2400 , rent = 0.24, title = "Walter Utility"               },
        { modelid = 13 , price = 26500, rent = 2.65, title = "Jefferson Futura"             },
        { modelid = 14 , price = 5050 , rent = 0.51, title = "Jefferson Provincial"         },
        { modelid = 15 , price = 3600 , rent = 0.36, title = "Lassiter Series 69"           },
        { modelid = 18 , price = 7870 , rent = 0.79, title = "Lassiter Series 75 Hollywood" },
        { modelid = 22 , price = 2200 , rent = 0.22, title = "Potomac Indian"               },
        { modelid = 23 , price = 1800 , rent = 0.18, title = "Quicksilver Windsor"          },
        { modelid = 25 , price = 650  , rent = 0.07, title = "Shubert 38"                   },
        { modelid = 28 , price = 2600 , rent = 0.26, title = "Shubert Beverly"              },
        { modelid = 29 , price = 4575 , rent = 0.46, title = "Shubert Frigate"              },
        { modelid = 31 , price = 730  , rent = 0.07, title = "Shubert 38 Panel Truck"       },
        { modelid = 41 , price = 2800 , rent = 0.28, title = "Smith Custom 200"             },
        { modelid = 43 , price = 470  , rent = 0.05, title = "Smith Coupe"                  },
        { modelid = 44 , price = 1650 , rent = 0.17, title = "Smith Mainline"               },
        { modelid = 45 , price = 4800 , rent = 0.48, title = "Smith Thunderbolt"            },
        { modelid = 47 , price = 570  , rent = 0.06, title = "Smith V8"                     },
        { modelid = 48 , price = 1580 , rent = 0.16, title = "Smith Deluxe Station Wagon"   },
        { modelid = 50 , price = 2050 , rent = 0.21, title = "Culver Empire"                },
        { modelid = 52 , price = 4950 , rent = 0.5 , title = "Walker Rocket"                },
        { modelid = 53 , price = 490  , rent = 0.05, title = "Walter Coupe"                 },

    ],
    [
        // bad guy
    ]
];

local carOnSale = [ 0, 1, 9, 10, 12, 13, 14, 15, 18, 22, 23, 25, 28, 29, 41, 43, 44, 45, 47, 48, 50, 52, 53 ];
local currentcarcolor = {};
local carPrices = {};
// translations
alternativeTranslate({
    "en|shops.carshop.gotothere"     : "If you want to buy a car go to Diamond Motors!"
    "en|shops.carshop.gotothere2"    : "If you want to buy a car go to Diamond Motors or to Bad Guy Motors!"
    "en|shops.carshop.welcome"       : "Hello there, %s! If you want to buy a car, you should first choose it via: /car list"
    "en|shops.carshop.nofreespace"   : "There is no free space near Parking. Please come again later!"
    "en|shops.carshop.money.error"   : "Sorry, you dont have enough money."
    "en|shops.carshop.selectmodel"   : "You can browse vehicle models, and their prices via: /car list"
    "en|shops.carshop.list.title"    : "Select car you like, and proceed to buying via: /car buy MODELID"
    "en|shops.carshop.list.entry"    : " - Model #%d, '%s'. Cost: $%.2f"
    "en|shops.carshop.success"       : "Congratulations on your purchase! Drive safe and enjoy your trip!"
    "en|shops.carshop.notforsale"    : "This car is not for sale."
    "en|shops.carshop.canbuy"        : "You can buy this car for $%.2f: /car buy"
    "en|shops.carshop.paint"         : "To change color - press 2."
    "en|shops.carshop.paint2"        : "To change main color - press 1. To change advanced color - press 2."
    "en|shops.carshop.closed"        : "The car shop is closed. Opening hours: %s:00 - %s:00."
    "en|shops.carshop.welcome1"      : "Welcome to the car shop Diamond Motors."
    "en|shops.carshop.welcome2"      : "We are pleased to offer you a wide range of cars."
    "en|shops.carshop.welcome3"      : "Select a car that suits your needs and sit into."
    "en|shops.carshop.waitingyou"    : "We are waiting for you to buy your «Diamond Motor»!"
    "en|shops.carshop.dontsteal"     : "Don't try to steal the car!"

    "en|shops.carshop.help.title"    : "List of available commands for CAR SHOP:"
    "en|shops.carshop.help.list"     : "Lists cars which are available to buy"
    "en|shops.carshop.help.buy"      : "Attempt to buy car by provided modelid"



    "ru|shops.carshop.gotothere"     : "Если вы хотите купить авто, отправляйтесь в Diamond Motors!"
    "ru|shops.carshop.gotothere2"    : "Если вы хотите купить авто, отправляйтесь в Diamond Motors или Bad Guy Motors!"
    "ru|shops.carshop.welcome"       : "Добро пожаловать, %s! Если вы хотите купить авто, выберите модель через: /car list"
    "ru|shops.carshop.nofreespace"   : "К сожалению, на парковке нету свободных мест. Зайдите позже."
    "ru|shops.carshop.money.error"   : "К сожалению, у вас недостаточно денег."
    "ru|shops.carshop.selectmodel"   : "Вы можете посмотреть модели авто и их цены, используя: /car list"
    "ru|shops.carshop.list.title"    : "Выберите модель, которая вам нравится, и купите её, используя: /car buy MODELID"
    "ru|shops.carshop.list.entry"    : " - Модель #%d, «%s». Цена: $%.2f"
    "ru|shops.carshop.success"       : "Поздравляем с покупкой! Наслаждайтесь поездкой!"
    "ru|shops.carshop.notforsale"    : "Этот автомобиль нельзя купить."
    "ru|shops.carshop.canbuy"        : "Вы можете купить этот автомобиль за $%.2f: /car buy"
    "ru|shops.carshop.paint"         : "Выбор цвета покраски - кнопка 2."
    "ru|shops.carshop.paint2"        : "Смена основого цвета - кнопка 1. Смена доп. цвета - кнопка 2."
    "ru|shops.carshop.closed"        : "Автосалон закрыт. Чаcы работы с %s:00 до %s:00."
    "ru|shops.carshop.welcome1"      : "Добро пожаловать в автосалон Diamond Motors."
    "ru|shops.carshop.welcome2"      : "Мы рады предложить вам широкий ассортимент автомобилей."
    "ru|shops.carshop.welcome3"      : "Выбирайте любое понравившееся авто и садитесь в него."
    "ru|shops.carshop.waitingyou"    : "Ждём вас за покупкой «бриллиантового мотора»!"
    "ru|shops.carshop.dontsteal"     : "Не пытайтесь угнать автомобиль!"

    "ru|shops.carshop.help.title"    : "Список команд для автосалона Diamond Motors:"
    "ru|shops.carshop.help.list"     : "Посмотреть список авто, доступных для покупки"
    "ru|shops.carshop.help.buy"      : "Купить выбранный автомобиль"
});

/* ==================================================================== EVENTS ================================================================================= */

event("onServerStarted", function() {
    // Diamond Motors motors
    //create3DText( DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, DIAMOND_CARSHOP_Z + 0.35, "DIAMOND MOTORS", CL_ROYALBLUE );
    //create3DText( DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, DIAMOND_CARSHOP_Z + 0.20, "/car", CL_WHITE.applyAlpha(75), CARSHOP_DISTANCE );

    createBlip  ( DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, ICON_LOGO_CAR, ICON_RANGE_FULL );

    createPlace(CARSHOP_PLACE_NAME, CARSHOP_PLACE_COORDS[0], CARSHOP_PLACE_COORDS[1], CARSHOP_PLACE_COORDS[2], CARSHOP_PLACE_COORDS[3]);

    carPrices = generateRandomCarPrices();
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
    if (name == CARSHOP_PLACE_NAME) {
        if(isPlayerInVehicle(playerid)) {
            local vehicleid = getPlayerVehicle(playerid);
            local vehSpeed = getVehicleSpeed(vehicleid);
            local vehSpeedNew = [];
            if (vehSpeed[0] <= 0) vehSpeed[0] = (vehSpeed[0] - 1) * -1;
            if (vehSpeed[1] >= 0) vehSpeed[1] = (vehSpeed[1] + 1) * -1;
            setVehicleSpeed(vehicleid, vehSpeed[0], vehSpeed[1], vehSpeed[2]);
        } else {
            local hour = getHour();
            if(hour < CARSHOP_WORKING_HOUR_START || hour >= CARSHOP_WORKING_HOUR_END) {
                return msg( playerid, "shops.carshop.closed", [ CARSHOP_WORKING_HOUR_START.tostring(), CARSHOP_WORKING_HOUR_END.tostring()], CL_ROYALBLUE );
            }
            msg(playerid, "===========================================", CL_HELP_LINE);
            msg(playerid, "shops.carshop.welcome1", CL_FIREBUSH);
            msg(playerid, "shops.carshop.welcome2", CL_FIREBUSH);
            msg(playerid, "shops.carshop.welcome3", CL_SILVERSAND);
        }
    }
});

event("onPlayerPlaceExit", function(playerid, name) {
    if (name == CARSHOP_PLACE_NAME) {

        if (!isPlayerInVehicle(playerid)) return msg(playerid, "shops.carshop.waitingyou", CL_FIREBUSH);

        local vehicleid = getPlayerVehicle(playerid);
        local plate = getVehiclePlateText( vehicleid );

        if(plate != " SALE ") {
            return;
        }

        blockVehicle(vehicleid);
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

    blockVehicle(vehicleid);

    local hour = getHour();
    if(hour < CARSHOP_WORKING_HOUR_START || hour >= CARSHOP_WORKING_HOUR_END) {
        return msg( playerid, "shops.carshop.closed", [ CARSHOP_WORKING_HOUR_START.tostring(), CARSHOP_WORKING_HOUR_END.tostring()], CL_ROYALBLUE );
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
function getPlayerCarShopIndex(playerid) {
    if (getDistanceToPoint(playerid, DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, DIAMOND_CARSHOP_Z) <= CARSHOP_DISTANCE) {
        return 0;
    }
/*
    if (getDistanceToPoint(playerid, BADGUY_CARSHOP_X , BADGUY_CARSHOP_Y , BADGUY_CARSHOP_Z ) <= CARSHOP_DISTANCE) {
        return 1;
    }
*/
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
    foreach(idx, car in carPricesAll[0]) {
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

    local hour = getHour();
    if(hour < CARSHOP_WORKING_HOUR_START || hour >= CARSHOP_WORKING_HOUR_END) {
        return;
    }

    local carpaints = getVehicleColorsArray( vehicleid );

    local num = currentcarcolor[vehicleid] + 1;
    if(num >= carpaints.len()) num = 0;

    local cr = carpaints[num];
    currentcarcolor[vehicleid] = num;

    setVehicleColour(vehicleid, cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
}



/**
 * Automatically changing the range of cars both stores.
 * Writing to carPrices[0] for Diamond Motors and carPrices[1] for Bad Guy
 */

function generateRandomCarPrices() {
    local carPrices = [[],[]];
    local shopDiamondSpaces = vehiclePositions[0];
    local countFreeSpaces = shopDiamondSpaces.len();

    local carPricesDiamond = clone(carPricesAll[0]);
    for (local i = 0; i < countFreeSpaces; i++) {
        local rand = random(0, carPricesDiamond.len() - 1);
        // dbg(carPricesDiamond[rand].modelid);
        if( carOnSale.find(carPricesDiamond[rand].modelid) == null ) { i--; /* dbg("nicht"); */ continue; }

        local vehicleid = createVehicle(carPricesDiamond[rand].modelid,
            shopDiamondSpaces[i].position.x, shopDiamondSpaces[i].position.y, shopDiamondSpaces[i].position.z,
            shopDiamondSpaces[i].rotation.x, shopDiamondSpaces[i].rotation.y, shopDiamondSpaces[i].rotation.z
        );
        currentcarcolor[vehicleid] <- 0;
        setVehiclePlateText(vehicleid, " SALE ");
        setVehicleDirtLevel(vehicleid, 0.0);
        delayedFunction(1000, function() { setRandomVehicleColors(vehicleid); });
        repairVehicle(vehicleid);

        carPrices[0].push(carPricesDiamond[rand]);
        carPricesDiamond.remove(rand);
    }
    carPricesDiamond.clear();


    foreach (idx, subprices in carPrices) {
        foreach (idx_, object in subprices) {
            object.price = randomf(object.price - CARSHOP_PRICE_DIFF * 0.5, object.price + CARSHOP_PRICE_DIFF * 2.0);
        }
    }

    return carPrices;
}

/* ==================================================================== COMMANDS ================================================================================= */


/**
 * Car help
 * Usage: /car
 */
// cmd("car", function(playerid) {
//     if (isPlayerNearCarShop(playerid)) {
//         return msg(playerid, "shops.carshop.welcome", getPlayerName(playerid), CL_INFO);
//     }

//     return msg(playerid, "shops.carshop.gotothere", getPlayerName(playerid), CL_WARNING);
// });

/**
 * RANAMED FROM CAR LIST
 * List car models available in the shop
 * Usage: /car

cmd("car", function(playerid, page = null, a = null) {
    if (!isPlayerNearCarShop(playerid)) {
        return msg(playerid, "shops.carshop.gotothere", getPlayerName(playerid), CL_WARNING);
    }

    local carshopid = getPlayerCarShopIndex(playerid);

    msg(playerid, "shops.carshop.list.title", CL_INFO);

    foreach (idx, car in getCarPrices(carshopid)) {
        msg(playerid, "shops.carshop.list.entry", [car.modelid, car.title, car.price])
    }


    //triggerClientEvent(playerid, "showCarShopGUI");
});
 */


/**
 * Attempt to by car model
 * Usage: /car buy
 */
cmd("car", "buy", function(playerid) {

    if(!isPlayerInVehicle(playerid)) {
        return msg(playerid, "shops.carshop.gotothere", getPlayerName(playerid), CL_WARNING);
    }

    local vehicleid = getPlayerVehicle(playerid);
    local plate = getVehiclePlateText(vehicleid);

    if(plate != " SALE ") {
        return msg(playerid, "shops.carshop.notforsale", CL_WARNING);
    }

    local hour = getHour();
    if(hour < CARSHOP_WORKING_HOUR_START || hour >= CARSHOP_WORKING_HOUR_END) {
        return msg( playerid, "shops.carshop.closed", [ CARSHOP_WORKING_HOUR_START.tostring(), CARSHOP_WORKING_HOUR_END.tostring()], CL_ROYALBLUE );
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
    if (!players[playerid].inventory.isFreeWeight(vehicleKey)) {
        return msg(playerid, "inventory.weight.notenough", CL_ERROR);
    }

    // take money
    subMoneyToPlayer(playerid, car.price);

    // add money to treasury
    addMoneyToTreasury(car.price);

    local vehiclePlate = getRandomVehiclePlate();

    // set params
    setVehicleOwner(vehicleid, playerid);
    setVehiclePlateText(vehicleid, vehiclePlate);
    setVehicleSaving(vehicleid, true);
    setVehicleRespawnEx(vehicleid, false);
    setVehicleDirtLevel(vehicleid, 0.0);
    repairVehicle(vehicleid);
    unblockVehicle(vehicleid);

    trySaveVehicle(vehicleid)

    vehicleKey.setData("id", __vehicles[vehicleid].entity.id);

    players[playerid].inventory.push( vehicleKey );
    vehicleKey.save();
    players[playerid].inventory.sync();

    //triggerClientEvent(playerid, "hideCarShopGUI");
    return msg(playerid, "shops.carshop.success", CL_SUCCESS);
});







/*

cmd("skin", "buy", function(playerid, skinid = null) {
    local skinid = toInteger(skinid);

    if(!isPlayerInValidPoint(playerid, CLOTHES_SHOP_X, CLOTHES_SHOP_Y, CLOTHES_SHOP_DISTANCE)) {
        return msg(playerid, "shops.clothesshop.gotothere", getPlayerName(playerid), CL_THUNDERBIRD);
    }

    if (!skinid || !getSkinBySkinId(skinid)) {
        return msg(playerid, "shops.clothesshop.selectskin");
    }

    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    }

    local skin = getSkinBySkinId(skinid);

    if (!canMoneyBeSubstracted(playerid, skin.price)) {
        //triggerClientEvent(playerid, "hideCarShopGUI");
        return msg(playerid, "shops.clothesshop.money.error", CL_THUNDERBIRD);
    }

    local clothes = Item.Clothes();
    if (!players[playerid].inventory.isFreeWeight(clothes)) {
        return msg(playerid, "inventory.weight.notenough", CL_THUNDERBIRD);
    }
    // take money
    subMoneyToPlayer(playerid, skin.price);
    addMoneyToTreasury(skin.price);
    msg(playerid, "shops.clothesshop.success", CL_SUCCESS);
    clothes.amount = skin.skinid;
    players[playerid].inventory.push( clothes );
    clothes.save();
    players[playerid].inventory.sync();

    //setPlayerModel(playerid, skin.skinid, true);
});





*/




function carShopHelp (playerid, a = null, b = null) {
    local title = "shops.carshop.help.title";
    local commands = [
        { name = "/car buy", desc = "shops.carshop.help.buy" },
    ];
    msg_help(playerid, title, commands);
}
// usage: /help car
cmd("help", "car", carShopHelp);

/* ==================================================================== BINDS ================================================================================= */

key("2", function(playerid) {
    carShopChangeColor(playerid);
}, KEY_UP);
