include("modules/shops/carshop/commands.nut");
include("modules/shops/carshop/functions.nut");

// constants
const CARSHOP_STATE_FREE = "free";
const CARSHOP_DISTANCE   = 5.0; // distance for command

const CARSHOP_X = -204.324;
const CARSHOP_Y =  826.917;
const CARSHOP_Z = -20.8854;

// translations
translation("en", {
    "shops.carshop.gotothere"     : "If you want to buy a car go to Diamond Motors!",
    "shops.carshop.welcome"       : "Hello there, %s! If you want to buy a car, you should first choose it via: /car list",
    "shops.carshop.nofreespace"   : "There is no free space near Parking. Please come again later!",
    "shops.carshop.money.error"   : "Sorry, you dont have enough money.",
    "shops.carshop.selectmodel"   : "You can browse vehicle models, and their prices via: /car list",
    "shops.carshop.list.title"    : "Select car you like, and proceed to buying via: /car buy MODELID",
    "shops.carshop.list.entry"    : " - Model #%d, «%s». Cost: $%.2f",
    "shops.carshop.success"       : "Contratulations! You've successfuly bought a car. Fare you well!",
    "shops.carshop.help.title"    : "List of available commands for CAR SHOP:",
    "shops.carshop.help.list"     : "Lists cars which are available to buy",
    "shops.carshop.help.buy"      : "Attempt to buy car by provided modelid",
});

// translations
translation("ru", {
    "shops.carshop.gotothere"     : "Если вы хотите купить авто, отправляйтесь в Diamond Motors!",
    "shops.carshop.welcome"       : "Добро пожаловать, %s! Если вы хотите купить авто, выберите модель через: /car list",
    "shops.carshop.nofreespace"   : "К сожалению на парковке нету свободных мест. Попробуйте позже!",
    "shops.carshop.money.error"   : "К сожалению у вас недостаточно денег.",
    "shops.carshop.selectmodel"   : "Вы можете просмотреть модели авто и их цены используя: /car list",
    "shops.carshop.list.title"    : "Выберите модель которая вам подходит, и купите ее используя: /car buy MODELID",
    "shops.carshop.list.entry"    : " - Модель #%d, «%s». Цена: $%.2f",
    "shops.carshop.success"       : "Поздравляем! Вы успешно купили автомобиль. Счастливого пути!",
    "shops.carshop.help.title"    : "Список команд, доступных для магазина авто:",
    "shops.carshop.help.list"     : "Просмотреть список авто, доступных для покупки",
    "shops.carshop.help.buy"      : "Купить авто с указанной моделью",
});

event("onServerStarted", function() {
    //creating 3dtext for bus depot
    create3DText( CARSHOP_X, CARSHOP_Y, CARSHOP_Z + 0.35, "DIAMOND MOTORS", CL_ROYALBLUE );
    create3DText( CARSHOP_X, CARSHOP_Y, CARSHOP_Z + 0.20, "/car", CL_WHITE.applyAlpha(75), CARSHOP_DISTANCE );

    createBlip  ( CARSHOP_X, CARSHOP_Y, ICON_GEAR, ICON_RANGE_FULL );
});

event("onPlayerVehicleEnter", function(playerid, vehiclid, seat) {
    return carShopFreeCarSlot(playerid, vehiclid);
});

event("onServerMinuteChange", function() {
    return carShopCheckFreeSpace();
});
