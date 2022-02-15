include("controllers/world/translations.nut");
include("controllers/world/translations-cyr.nut");
include("controllers/world/inflations.nut");
// configs
WORLD_SECONDS_PER_MINUTE    <- 40;
WORLD_MINUTES_PER_HOUR      <- 60;
WORLD_HOURS_PER_DAY         <- 24;
WORLD_DAYS_PER_MONTH        <- 30;
WORLD_MONTH_PER_YEAR        <- 12;
WORLD_MONTH_PER_YEAR        <- 12;
WORLD_YEAR_TIME_STOOD_STILL <- 1954;

AUTOSAVE_TIME               <- 10;

// setup local storage
__world  <- null;
local ticker = null;

event("onServerStarted", function() {
    logStr("[world] starting world ...");

    World.findAll(function(err, worlds) {
        if (err || worlds.len() < 1) {
            __world = World();

            __world.second = 0;
            __world.minute = 0;

            __world.day = 1;
            __world.month = 1;
            __world.year = 0;
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

event("onPlayerConnect", function(playerid) {
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

function getVirtualDate() {
    return format("%02d %s", __world.day, getStringMonth());
}

function getFullVirtualDate() {
    local year = Math.max(__world.year - WORLD_YEAR_TIME_STOOD_STILL, 0);
    return format("%02d %s, год %d", __world.day, getStringMonth(), year);
}

function formatDateToVirtualDate(date) {
    local arrDate = split(date, ".").map(function(k) { return k.tointeger() });

    return format("%02d %s, год %d", arrDate[0], localize("world.month."+arrDate[1], [], "ru"), formatYearToVirtualYear(arrDate[2]));
}

function formatYearToVirtualYear(year) {
    return Math.max(year - WORLD_YEAR_TIME_STOOD_STILL, 0);
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

function getBirthdate(birthdate) {
    local bdate = split(birthdate, ".").map(function(k) { return k.tointeger() });
    local age = __world.year - bdate[2].tointeger();

    // return format("%d %s (возраст: %d %s)", bdate[0], localize("world.month."+bdate[1], [], "ru"), age, declOfNum(age, ["год", "года", "лет"]));
    return format("%d %s", bdate[0], localize("world.month."+bdate[1], [], "ru"));
}

function getVirtualYear() {
    return formatYearToVirtualYear(__world.year);
}

function getDay() {
    return __world.day;
}

function getMonth() {
    return __world.month;
}

function getStringMonth() {
    return localize("world.month."+__world.month, [], "ru");
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

