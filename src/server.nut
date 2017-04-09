DEBUG   <- false;
VERSION <- "1.0.0";
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

local require = dofile("vendor/squirrel-require/src/require.nut", true)("./src");

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
function log(...) {
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
    return DEBUG_ENABLED ? ::print("[debug] " + JSONEncoder.encode(vargv)) : null;
}

if (__DEBUG__EXPORT) {
    addEventHandler     <- function(...) {};
    addCommandHandler   <- function(...) {};
    createVehicle       <- function(...) {};
}

// load classes
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
include("helpers/patterns");
include("helpers/vector.nut");
include("helpers/assert.nut");
include("helpers/array.nut");
include("helpers/function.nut");
include("helpers/string.nut");
include("helpers/math.nut");
include("helpers/distance.nut");
include("helpers/color.nut");
include("helpers/base64.nut");
include("helpers/urlencode.nut");
include("helpers/table.nut");

// load controllers
include("controllers");

// load modules
include("modules/index.nut");

// translations
include("translations/en.nut");
include("translations/ru.nut");

// unit testing
// dofile("resources/ncrp/unittests/index.nut", true);

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
    log("[core] starting initialization...");

    initializeEnvironment();

    if (DEBUG) {
        log("[core] running in DEBUG mode...");
    } else {
        log("[core] running in PROD mode...")
    }

    log(format("[core] running version %s...", VERSION));

    // setup default values
    setGameModeText( "NCRP " + VERSION );
    setMapName( "Empire Bay" );
    srand(time()); // set random seed

    // trigger pre init events
    trigger("onScriptInit");

    // creating playerList storage
    // playerList = PlayerList();

    // triggerring load events
    trigger("onServerStarted");

    dbg("server", "server started");

});

event("onServerStarted", function() {
    // imitate server restart after script init
    // (after script exit for still connected players)
    foreach (playerid, name in getPlayers()) {
        // trigger("onPlayerInit", playerid);
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
    trigger("onServerStopping");
    trigger("onServerStopped");
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
proxy("onPlayerLanguageChange",     "onPlayerLanguageChange"            );
proxy("map:onClientOpen",           "map:onClientOpen"                  );
proxy("map:onClientClose",          "map:onClientClose"                 );

// Klo's playground
proxy("loginGUIFunction",           "loginGUIFunction"                  );
proxy("registerGUIFunction",        "registerGUIFunction"               );
proxy("updateMoveState",            "updateMoveState"                   );
proxy("changeModel",                "changeModel"                       );

// RentCar
proxy("RentCar",                    "RentCar"                           );

// Telephone
proxy("PhoneCallGUI",               "PhoneCallGUI"                      );

// Metro
proxy("travelToStationGUI",         "travelToStationGUI"                );

//Inventory system
proxy("inventory:use",              "native:onPlayerUseItem"             );
proxy("inventory:move",             "native:onPlayerMoveItem"            );
proxy("inventory:drop",             "native:onPlayerDropItem"            );
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
