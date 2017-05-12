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

include("modules/shops/carshop/functions.nut");

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

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------ */
});

event("onServerStarted", function() {
    // Diamond Motors motors
    //create3DText( DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, DIAMOND_CARSHOP_Z + 0.35, "DIAMOND MOTORS", CL_ROYALBLUE );
    //create3DText( DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, DIAMOND_CARSHOP_Z + 0.20, "/car", CL_WHITE.applyAlpha(75), CARSHOP_DISTANCE );

    createBlip  ( DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, ICON_GEAR, ICON_RANGE_FULL );

    createPlace(CARSHOP_PLACE_NAME, CARSHOP_PLACE_COORDS[0], CARSHOP_PLACE_COORDS[1], CARSHOP_PLACE_COORDS[2], CARSHOP_PLACE_COORDS[3]);

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
            if (vehSpeed[0] < 0) vehSpeed[0] = vehSpeed[0] * -1;
            if (vehSpeed[1] > 0) vehSpeed[1] = vehSpeed[1] * -1;
            setVehicleSpeed(vehicleid, vehSpeed[0], vehSpeed[1], vehSpeed[2]);
        } else {
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

    local modelid = getVehicleModel(vehicleid);
    local car = getCarInfoModelById(modelid);

    if (!canMoneyBeSubstracted(playerid, car.price)) {
        //triggerClientEvent(playerid, "hideCarShopGUI");
        return msg(playerid, "shops.carshop.money.error", CL_ERROR);
    }

    // take money
    subMoneyToPlayer(playerid, car.price);

    // add money to treasury
    addMoneyToTreasury(car.price);

    // set params
    setVehicleOwner(vehicleid, playerid);
    setVehiclePlateText(vehicleid, getRandomVehiclePlate());
    setVehicleSaving(vehicleid, true);
    setVehicleRespawnEx(vehicleid, false);
    setVehicleDirtLevel(vehicleid, 0.0);
    repairVehicle(vehicleid);
    unblockVehicle(vehicleid);

    //triggerClientEvent(playerid, "hideCarShopGUI");
    return msg(playerid, "shops.carshop.success", CL_SUCCESS);
});


key("2", function(playerid) {
    carShopChangeColor(playerid);
}, KEY_UP);


function carShopHelp (playerid, a = null, b = null) {
    local title = "shops.carshop.help.title";
    local commands = [
        { name = "/car buy", desc = "shops.carshop.help.buy" },
    ];
    msg_help(playerid, title, commands);
}

// usage: /help car
cmd("help", "car", carShopHelp);
