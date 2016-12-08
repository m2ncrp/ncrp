// configs
WORLD_SECONDS_PER_MINUTE    <- 30;
WORLD_MINUTES_PER_HOUR      <- 60;
WORLD_HOURS_PER_DAY         <- 24;
WORLD_DAYS_PER_MONTH        <- 30;
WORLD_MONTH_PER_YEAR        <- 12;

AUTOSAVE_TIME               <- 10;

// setup local storage
__world  <- null;
local ticker = null;

event("onServerStarted", function() {
    log("[world] starting world ...");

    World.findAll(function(err, worlds) {
        if (err || worlds.len() < 1) {
            __world = World();

            __world.second = 0;
            __world.minute = 0;

            __world.day = 1;
            __world.month = 1;
            __world.year = 1949;
        } else {
            __world = worlds[0];
        }

        ticker = timer(function() { __world.onSecondChange(); }, 1000, -1);
        trigger("onPhaseChange", __world);
    });
});

event("onServerStopping", function() {
    __world.save();
    ticker.Kill();

    // reset objects
    __world = null;
    ticker = null;
});

event("onPlayerConnect", function(playerid, a, b, c) {
    __world.sendToClient(playerid);
});

// register auto time sync on player spawn
event("onPlayerSpawn", function(playerid) {
    __world.sendToClient(playerid);
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
    return format("%02d.%02d.%d", __world.day, __world.month, __world.year);
}

/**
 * Return string with current time on server
 * NOTE: Game time
 * format: 15:52
 *
 * @return {string}
 */
function getTime() {
    return format("%02d:%02d", __world.hour, __world.minute);
}

function getDay() {
    return __world.day;
}

function getMonth() {
    return __world.month;
}

function getYear() {
    return __world.year;
}

function getHour() {
    return __world.hour;
}

function getMinute() {
    return __world.minute;
}

function getSecond() {
    return __world.second;
}

function setDay(value) {
    __world.day = value;
    __world.sendToAllClients();
}

function setMonth(value) {
    __world.month = value;
    __world.sendToAllClients();
}

function setYear(value) {
    __world.year = value;
    __world.sendToAllClients();
}

function setHour(value) {
    __world.hour = value;
    __world.sendToAllClients();
}

function setMinute(value) {
    __world.minute = value;
    __world.sendToAllClients();
}

function setSecond(value) {
    __world.second = value;
    __world.sendToAllClients();
}

