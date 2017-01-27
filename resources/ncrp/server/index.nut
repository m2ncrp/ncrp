DEBUG   <- false;
VERSION <- "0.0.000";
MOD_HOST <- "139.59.142.46";
MOD_PORT <- 7790;

// initialize libraries
dofile("resources/ncrp/libraries/index.nut", true);

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
dofile("resources/ncrp/unittests/index.nut", true);

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

    local verblob = file("globalSettings/version.ver", "r");
    local version = "";

    // try to read data from version
    for (local i = 1; i < verblob.len(); i++) {
        version += verblob.readn('b').tochar();
        verblob.seek(i);
    }

    if (version) {
        VERSION = strip(version);
    }

    verblob.close();
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
    setGameModeText( VERSION );
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

// Klo's playground
proxy("RentCar",                    "RentCar"                           );
proxy("loginGUIFunction",           "loginGUIFunction"                  );
proxy("registerGUIFunction",        "registerGUIFunction"               );
proxy("updateMoveState",            "updateMoveState"                   );
proxy("changeModel",                "changeModel"                       );

/**
 * Debug export
 * if constant is set to true
 * all currently registered comamnds
 * will be printed to server log
 */
if (__DEBUG__EXPORT) {
    dbg(__commands);
}
