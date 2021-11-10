DEBUG   <- false;
VERSION <- "1.4.0";
MOD_HOST <- "139.59.142.46";
MOD_PORT <- 7790;

const DEBUG_ENABLED = true;
__DEBUG__EXPORT <- false;

/**
 * Updated module includer script version
 * throws exceptions if module was not found
 * returns true if module was loaded
 *
 * If ".nut" was not found in the path,
 * "/index.nut" will be concatenated to path
 *
 * @param  {String} path
 * @return {Boolean}
 */
function include(path) {
    if (!path.find(".nut")) {
        path += "/index.nut";
    }

    try {
        return dofile("src/" + path, true) || true;
    } catch (e) {
        throw "\n============================\nSystem: File inclusion error\n(wrong filename or error in the file): " + path;
    }
}

local require = dofile("vendor/squirrel-require/src/require.nut", true)({
    root        = "./src",
    module_dir  = "./vendor",
    aliases     = {
        src             = "./src",
        controllers     = "./src/controllers",
        engine          = "./src/engine",
        module          = "./src/modules",
        jobs            = "./src/modules/jobs",
    }
});

// load libs
__FILE__ <- "vendor/squirrel-orm/index.nut";
dofile("vendor/squirrel-orm/index.nut", true);
dofile("vendor/JSONEncoder/JSONEncoder.class.nut", true);
dofile("vendor/JSONParser/JSONParser.class.nut", true);

// setup logger
logger <- require("./engine/logger")
logger.use(function(data) {
    ::print(data);
});

/**
 * Function that logs to server console
 * provided any number of provided values
 *
 * @param  {...}  any number of arguments
 * @return none
 */
function logStr(...) {
    return ::print(JSONEncoder.encode(vargv).slice(2).slice(0, -2));
};


/**
 * Function that logs to server console
 * provided any number of provided values
 * NOTE: addes prefix [debug] in front of output
 *
 * @param  {...}  any number of arguments
 * @return none
 */
function dbg(...) {
    return DEBUG_ENABLED ? ::print("[dbg] " + JSONEncoder.encode(vargv)) : null;
}

console.log = dbg;
trim <- strip;
nano_sequence_id <- 0;

function nano(json) {
    json.sequence_id <- (nano_sequence_id++);
    nnTrigger(JSONEncoder.encode(json));
};


if (__DEBUG__EXPORT) {
    addEventHandler     <- function(...) {};
    addCommandHandler   <- function(...) {};
    createVehicle       <- function(...) {};
}

// load classes
include("helpers/patterns");

include("traits/Colorable.nut");
include("models/Color.nut");
include("models/Vehicle.nut");
include("models/World.nut");
include("models/TeleportPosition.nut");
include("models/TimestampStorage.nut");
include("models/StatisticPoint.nut");
include("models/StatisticText.nut");
include("models/MigrationVersion.nut");
include("models/Business.nut");

// load helpers
include("helpers/vector.nut");
include("helpers/assert.nut");
include("helpers/array.nut");
include("helpers/function.nut");
include("helpers/string.nut");
include("helpers/math.nut");
include("helpers/matrix.nut");
include("helpers/distance.nut");
include("helpers/color.nut");
include("helpers/datetime.nut");
include("helpers/base64.nut");
include("helpers/urlencode.nut");
include("helpers/table.nut");
include("helpers/constants.nut");

// load controllers
include("controllers");

// load modules
include("modules/index.nut");

// translations
include("translations/en.nut");
include("translations/ru.nut");
include("translations/cyr.nut");

//experiments
include("experiments/model_drawing.nut");
// unit testing
// dofile("resources/ncrp/unittests/index.nut", true);

function fread(filename) {
    local handler = file(filename, "r");
    local content = "";


    for (local i = 0; i < handler.len(); i++) {
        content += handler.readn('b').tochar();
    }

    handler.close();
    return content;
}

local initializeEnvironment = function() {
    local envblob = file(".env", "a+");

    // try to read env, or create new
    if (envblob.eos()) {
        envblob.writen('d', 'b');
        DEBUG = true;
    } else {
        DEBUG = (envblob.readn('b') == 'd') ? true : false;
    }

    envblob.close();

    // local verblob = file("globalSettings/version.ver", "r");
    // local version = "";

    // // try to read data from version
    // for (local i = 1; i < verblob.len(); i++) {
    //     version += verblob.readn('b').tochar();
    //     verblob.seek(i);
    // }

    // if (version) {
    //     // VERSION = strip(version);
    // }

    // verblob.close();
};


// bind general events
event("native:onScriptInit", function() {
    logStr("[core] starting initialization...");

    initializeEnvironment();

    if (DEBUG) {
        logStr("[core] running in DEBUG mode...");
    } else {
        logStr("[core] running in PROD mode...")
    }

    logStr(format("[core] running version %s...", VERSION));

    // setup default values
    setGameModeText( "mafia2online.ru | vk.com/m2ncrp");
    setMapName( "Empire Bay" );
    srand(time()); // set random seed

    // trigger pre init events
    trigger("onScriptInit");

    // creating playerList storage
    // playerList = PlayerList();

    // triggerring load events
    trigger("onServerStarted");

    dbg("server", "server started");
	//dbg("police", "parking", "noFreeSpace");
	//dbg("police", "parking", "send", "Fernando Fabbri", "11:48 15.09.2019", [["Номер", "PD-123"], ["Модель", "Smith Custom 200 Police"]]);
	//dbg("police", "jail", "unjail", "Fernando Fabbri", "Ottavio Ricci", "15.09.2019 11:48");
	//dbg("police", "parking", "send", "Fernando Fabbri", "11:48 15.09.2019", [["Номер", "PD-123"], ["Модель", "Smith Custom 200 Police"]]);
	//dbg("chat", "report", "Автодилер", format("Не удалось отправить на штрафстоянку автомобиль с номером %s", "dsdsd"));
	// ex("{\"type\": \"test\"}")
/*
    delayedFunction(1000, function () {
    ex(JSONEncoder.encode({type = "test1"}))
    });


    delayedFunction(2000, function () {
    ex(JSONEncoder.encode({type = "test2"}))
    });

    delayedFunction(3000, function () {
    ex(JSONEncoder.encode({type = "test3"}))
    });
*/
});

event("onServerStarted", function() {
    // imitate server restart after script init
    // (after script exit for still connected players)
    foreach (playerid, name in getPlayers()) {
        trigger("onPlayerConnectInit", playerid, name, "0.0.0.0", getPlayerSerial(playerid));
        trigger("native:onPlayerSpawn", playerid);
    }
});

event("native:onScriptExit", function() {
    trigger("onServerStopping");
    trigger("onServerStopped");

    dbg("server", "server stopped");
});

event("native:onServerShutdown", function() {
    dbg("server", "onServerStopping:start");
    trigger("onServerStopping");
    dbg("server", "onServerStopping:finish");

    dbg("server", "onServerStopped:start");
    trigger("onServerStopped");
    dbg("server", "onServerStopped:finish");
});

event("native:onPlayerConnect", function(playerid, name, ip, serial) {
    dbg("player", "connect", name, playerid, ip, serial);

    if (!IS_AUTHORIZATION_ENABLED || DEBUG) {
        setLastActiveSession(playerid);
        trigger("onPlayerConnectInit", playerid, name, ip, serial);
    } else {
        trigger("onPlayerConnectInit", playerid, name, ip, serial);
    }
});

/**
 * Registering proxies
 */
// server
proxy("onScriptInit",               "native:onScriptInit"               );
proxy("onScriptExit",               "native:onScriptExit"               );
proxy("onConsoleInput",             "native:onConsoleInput"             );
proxy("onServerShutdown",           "native:onServerShutdown"           );
// onScriptError
// onServerPulse
//proxy("onServerPulse", "onServerPulse");

// player
proxy("onPlayerConnect",            "native:onPlayerConnect"            );
proxy("onPlayerDisconnect",         "native:onPlayerDisconnect"         );
proxy("onPlayerConnectionRejected", "native:onPlayerConnectionRejected" );
proxy("onPlayerChat",               "native:onPlayerChat"               );
proxy("onPlayerSpawn",              "native:onPlayerSpawn"              );
proxy("onPlayerChangeNick",         "native:onPlayerChangeNick"         );
proxy("onPlayerDeath",              "native:onPlayerDeath"              );
proxy("onPlayerChangeWeapon",       "native:onPlayerChangeWeapon"       );
proxy("onPlayerChangeHealth",       "native:onPlayerChangeHealth"       );
proxy("onPlayerVehicleEnter",       "native:onPlayerVehicleEnter"       );
proxy("onPlayerVehicleExit",        "native:onPlayerVehicleExit"        );

// vehicle
proxy("onVehicleSpawn",             "native:onVehicleSpawn"             );
proxy("setVehicleDoorLocked",       "setVehicleDoorLocked"              );
proxy("setVehicleTrunkLocked",      "setVehicleTrunkLocked"             );

// client events
proxy("onClientKeyboardPress",      "onClientKeyboardPress"             );
proxy("onClientNativeKeyboardPress","onClientNativeKeyboardPress"       );
proxy("onClientScriptError",        "onClientScriptError"               );
proxy("onPlayerTeleportRequested",  "onPlayerTeleportRequested"         );
proxy("onClientDebugToggle",        "onClientDebugToggle"               );
proxy("onClientSendFPSData",        "onClientSendFPSData"               );
proxy("onPlayerPlaceEnter",         "native:onPlayerPlaceEnter"         );
proxy("onPlayerPlaceExit",          "native:onPlayerPlaceExit"          );
proxy("onPlayerCharacterCreate",    "onPlayerCharacterCreate"           );
proxy("onPlayerCharacterSelect",    "onPlayerCharacterSelect"           );
proxy("onClientSuccessfulyStarted", "onClientSuccessfulyStarted"        );
proxy("onClientSuccessfulyStartedAgain", "onClientSuccessfulyStartedAgain" );
proxy("onPlayerLanguageChange",     "onPlayerLanguageChange"            );

proxy("onPlayerWeaponShoot",        "onPlayerWeaponShoot"             );
proxy("onPlayerWeaponReload",       "onPlayerWeaponReload"            );

proxy("onPlayerShowForgotGUI",      "onPlayerShowForgotGUI"             );
proxy("onPlayerHideForgotGUI",      "onPlayerHideForgotGUI"             );
proxy("onPlayerGetLoginByEmail",    "onPlayerGetLoginByEmail"           );
proxy("onPlayerGetEmailBySerial",   "onPlayerGetEmailBySerial"          );
proxy("onPlayerChangePassword",     "onPlayerChangePassword"            );

proxy("onPlayerKicked",             "onPlayerKicked"                    );

proxy("map:onClientOpen",           "map:onClientOpen"                  );
proxy("map:onClientClose",          "map:onClientClose"                 );

proxy("loginGUIFunction",           "loginGUIFunction"                  );
proxy("registerGUIFunction",        "registerGUIFunction"               );
proxy("updateMoveState",            "updateMoveState"                   );
proxy("changeModel",                "changeModel"                       );
proxy("onGenerateFirstname",        "onGenerateFirstname"               );
proxy("onGenerateLastname",         "onGenerateLastname"                );

// RentCar
proxy("RentCar",                    "RentCar"                           );

// Bank
proxy("bankPlayerDeposit",                "bankPlayerDeposit"           );
proxy("bankPlayerWithdraw",               "bankPlayerWithdraw"          );

// Biz Fuel
proxy("bizFuelStationSave",                "bizFuelStationSave"           );
proxy("bizFuelStationOpen",                "bizFuelStationOpen"           );
proxy("bizFuelStationClose",               "bizFuelStationClose"          );
proxy("bizFuelStationOnSale",              "bizFuelStationOnSale"         );
proxy("bizFuelStationOnSaleToCity",        "bizFuelStationOnSaleToCity"   );
proxy("bizFuelStationOnAddBalanceMoney",   "bizFuelStationOnAddBalanceMoney" );
proxy("bizFuelStationOnSubBalanceMoney",   "bizFuelStationOnSubBalanceMoney" );

// Telephone
proxy("PhoneCallGUI",               "PhoneCallGUI"                      );

// Metro
proxy("travelToStationGUI",         "travelToStationGUI"                );

//Inventory system
proxy("inventory:loaded",           "native:inventory:loaded"            );
proxy("inventory:use",              "native:onPlayerUseItem"             );
proxy("inventory:transfer",         "native:onPlayerTransferItem"        );
proxy("inventory:destroy",          "native:onPlayerDestroyItem"         );
proxy("inventory:move",             "native:onPlayerMoveItem"            );
proxy("inventory:drop",             "native:onPlayerDropItem"            );
proxy("inventory:close",            "native:onPlayerCloseInventory"      );
proxy("shop:close",                 "native:shop:close"                  );
proxy("shop:purchase",              "native:shop:purchase"               );

/**
 * Debug export
 * if constant is set to true
 * all currently registered comamnds
 * will be printed to server log
 */
if (__DEBUG__EXPORT) {
    dbg(__commands);
}
/*
event("onPlayerWeaponShoot", function(playerid) {
    msg(playerid, "Пиу")
})

event("onPlayerWeaponReload", function(playerid) {
    msg(playerid, "Перезарядка", CL_ERROR)
})
*/

/*
delayedFunction(10000, function() {
    local amount = 12.5;
    local balance = 52.75;
    local reason = "Тест";

    nano({
        "path": "discord",
        "server": "gov",
        "channel": "treasury",
        "action": "add",
        "author": "Test Testov",
        "description": "Приход",
        "color": "green",
        //"author": getPlayerName(character.playerid),
        "datetime": getDateTime(),
        "fields": [
            ["Сумма", format("$ %.2f", amount)],
            ["Основание", reason],
            ["Баланс", format("$ %.2f", balance)],
        ]
    })
})
*/



// nnListen(function(data) {
//     local parsedData = JSONParser.parse(data);
//
//     logStr("from node json: " + parsedData.type + ": "+data);
// });


cmd("nc", function (playerid) {
    dbg("ncrp", "newcomers", "Test Testov");
});

acmd("limit", function (playerid, enabled) {
    triggerClientEvent(playerid, "setSpeedLimiter", enabled);
});

acmd("limitspeed", function (playerid, speed) {
    triggerClientEvent(playerid, "setSpeedLimiterSpeed", speed.tofloat());
});

acmd("cam", function(playerid, x, y, z) {
    dbg("cam: "+x+" "+y+" "+z)
    triggerClientEvent(playerid, "setCameraPosition", x.tofloat(), y.tofloat(), z.tofloat());
})

acmd("cam1", function(playerid) {
    triggerClientEvent(playerid, "hidePlayerModel");
    triggerClientEvent(playerid, "setCameraPosition", 1.0, 0.45, 1.7);
})

// for(local i = 0; i <= 61; i++) {
//     if(i == 2 || i == 26 || i == 16 || i == 49) {
//         continue;
//     }
//     local vehicleid = createVehicle(i, -452.0, 402.722 - 4.0 * i, 1.09233, -90.0, 0.0, 0.0 );
//     local plate = (i < 10) ? "0"+i : i.tostring();
//     setVehiclePlateText(vehicleid, format("%s", plate));
// }

acmd("sn", function(playerid) {
    sn();
    msg(playerid, "sended");
})

function sn() {
    nano({
        "path": "discord",
        "server": "gov",
        "channel": "passport_requests",
        "action": "new",
        "description": "Заявка на паспорт",
        "color": "yellow",
        "datetime": getDateTime(),
        "direction": false,
        "fields": [
            ["Номер", 5],
            ["Имя Фамилия", "Fernando Fabbri"],
            ["Пол", "Мужской"],
            ["Национальность", "Афро-итальянец китайскиого происхождения"],
            ["Дата рождения", "01.01.1930"],
            ["Цвет волос", "Серо-бур-козявчатый"],
            ["Цвет глаз", "Лилово-оранжевый"],
        ]
    });
}
