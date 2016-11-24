// configs
WORLD_SECONDS_PER_MINUTE    <- 30;
WORLD_MINUTES_PER_HOUR      <- 60;
WORLD_HOURS_PER_DAY         <- 24;
WORLD_DAYS_PER_MONTH        <- 30;
WORLD_MONTH_PER_YEAR        <- 12;

AUTOSAVE_TIME               <- 10;

// setup local storage
local world  = null;
local ticker = null;

addEventHandlerEx("onServerStarted", function() {
    log("[world] starting world ...");

    World.findAll(function(err, worlds) {
        if (err || worlds.len() < 1) {
            world = World();

            world.second = 0;
            world.minute = 0;

            world.day = 1;
            world.month = 1;
            world.year = 1949;
        } else {
            world = worlds[0];
        }

        ticker = timer(function() { world.onSecondChange(); }, 1000, -1);
    });
});

event("onServerStopping", function() {
    world.save();
    ticker.Kill();

    // reset objects
    world = null;
    ticker = null;
});

addEventHandler("onPlayerConnect", function(playerid, a, b, c) {
    world.sendToClient(playerid);
});

// register auto time sync on player spawn
addEventHandler("onPlayerSpawn", function(playerid) {
    world.sendToClient(playerid);
});

/**
 * Return string with current datetime on server
 * NOTE: Game time
 * format: 01.01.1952 15:52
 *
 * @return {string}
 */
function getDateTime() {
    return getDate() + " " + getTime();
}

/**
 * Return string with current date on server
 * NOTE: Game time
 * format: 01.01.1952
 *
 * @return {string}
 */
function getDate() {
    return format("%02d.%02d.%d", world.time.day, world.time.month, world.time.year);
}

/**
 * Return string with current time on server
 * NOTE: Game time
 * format: 15:52
 *
 * @return {string}
 */
function getTime() {
    return format("%02d:%02d", world.time.hour, world.time.minute);
}

function getDay() {
    return world.time.day;
}

function getMonth() {
    return world.time.month;
}

function getYear() {
    return world.time.year;
}

function getHour() {
    return world.time.hour;
}

function getMinute() {
    return world.time.minute;
}

function getSecond() {
    return world.time.second;
}
