// configs
const WORLD_SECONDS_PER_MINUTE = 30;
const WORLD_MINUTES_PER_HOUR = 60;
const WORLD_HOURS_PER_DAY = 24;
const WORLD_DAYS_PER_MONTH = 30;
const WORLD_MONTH_PER_YEAR = 12;
const WEATHER_PHASE_CHANGE = 2;

const AUTOSAVE_TIME = 10;

// includes
include("controllers/world/World.nut");

// setup local storage
local world  = null;
local ticker = null;

addEventHandlerEx("onServerStarted", function() {
    log("[world] starting world ...");

    // crate objects
    world = World();
    ticker = timer(function() { world.onSecondChange(); }, 1000, -1);
});

addEventHandlerEx("onServerStopping", function() {
    ticker.Kill();

    // reset objects
    world = null;
    ticker = null;
});

addEventHandler("onPlayerConnect", function(playerid, a, b, c) {
    world.sendToClient(playerid);
});
