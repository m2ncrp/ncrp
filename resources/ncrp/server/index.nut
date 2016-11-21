// initialize libraries
dofile("resources/ncrp/libraries/index.nut", true);

// load classes
include("traits/Colorable.nut");
include("models/Color.nut");
include("models/Account.nut");
include("models/Character.nut");
include("models/Vehicle.nut");
include("models/TeleportPosition.nut");
include("models/TimestampStorage.nut");
include("models/StatisticPoint.nut");
include("models/MigrationVersion.nut");

// load helpers
include("helpers/array.nut");
include("helpers/function.nut");
include("helpers/string.nut");
include("helpers/math.nut");
include("helpers/distance.nut");
include("helpers/chat.nut");
include("helpers/commands.nut");
include("helpers/color.nut");

// load controllers
include("controllers/database");
include("controllers/keyboard");
include("controllers/time");
include("controllers/auth");
include("controllers/chat");
include("controllers/weather");
include("controllers/world");
include("controllers/player");
include("controllers/money");
include("controllers/jobs");
include("controllers/metro");
include("controllers/organizations");
include("controllers/vehicle");
include("controllers/rentcar");
include("controllers/utils");
include("controllers/screen");
include("controllers/admin");
include("controllers/statistics");

// bind general events
addEventHandler("onScriptInit", function() {
    log("[core] starting initialization...");

    // setup default values
    setGameModeText( "NCRP" );
    setMapName( "Empire Bay" );

    // creating playerList storage
    playerList = PlayerList();

    // triggerring load events
    triggerServerEventEx("onServerStarted");
});

addEventHandler("onScriptExit", function() {
    triggerServerEventEx("onServerStopping");
    triggerServerEventEx("onServerStopped");
    ::print("---------------------------------------");
});

addEventHandler("onServerShutdown", function() {
    triggerServerEventEx("onServerStopping");
    triggerServerEventEx("onServerStopped");
});

addEventHandler("onPlayerConnect", function(playerid, name, ip, serial) {
    triggerServerEventEx("onPlayerInit", playerid, name, ip, serial);
});

addEventHandlerEx("onServerStarted", function() {
    foreach (playerid, name in getPlayers()) {
        triggerServerEventEx("onPlayerInit", playerid, name, null, null);
    }
});

/**
 * Debug export
 * if constant is set to true
 * all currently registered comamnds
 * will be printed to server log
 */
if (__DEBUG__EXPORT) {
    dbg(__commands);
}
