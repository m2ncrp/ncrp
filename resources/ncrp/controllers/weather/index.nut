include("controllers/weather/commands.nut");

// settings
const WEATHER_PHASE_CHANGE = 2;
const WEATHER_DEFAULT_PHASE = 3;
const WEATHER_DEFAULT_WEATHER = 0;
const WEATHER_WINTER_STARTS = 11;
const WEATHER_WINTER_ENDS = 2;
const WEATHER_IS_WINTER = false;

// available whethers
local weathers = ["clear", "foggy", "rainy"];

// available day/night cycle phases
local phases = [
    "night", "night", ["early_morn1", "early_morn1", "early_morn"], ["early_morn2", "early_morn1", "early_morn"],
    "morning", "noon", "noon", "afternoon", "late_afternoon", "evening", "late_even", "night"
];

// setup local storage
local currentWeather = WEATHER_DEFAULT_WEATHER;
local currentPhase   = WEATHER_DEFAULT_PHASE;

// overried default function
function setWeather(name) {
    playerList.each(function(playerid) {
        triggerClientEvent(playerid, "onServerWeatherSync", name);
    });

    return true;
}

function setCurrentWeather(id) {
    if (id < 0 || id > weathers.len()) {
        return false;
    }

    // write new vlaue
    currentWeather = id;

    // execute change
    return setWeather(getWeatherName());
}

function getWeatherName() {
    // get current phase
    local phsz = phases[currentPhase];

    // if this is array, select weathery phase
    if (typeof phsz == "array") {
        phsz = phsz[currentWeather];
    }

    // concat everything together
    return "DT_RTR" + weathers[currentWeather] + "_day_" + phsz;
}

// add internal listener for phase changing
addEventHandlerEx("weather:onPhaseChange", function(phaseid) {
    phaseid = phaseid.tointeger();

    if (phaseid >= 0 && phaseid < 24) {
        currentPhase = floor(phaseid / WEATHER_PHASE_CHANGE);
        return setWeather(getWeatherName());
    }
});

// register auto weather sync on player spawn
addEventHandler("onPlayerSpawn", function(playerid) {
    triggerClientEvent(playerid, "onServerWeatherSync", WEATHER_IS_WINTER ? "DTFreeRideNightSnow" : getWeatherName());
});

addEventHandlerEx("onServerStarted", function() {
    setSummer(!WEATHER_IS_WINTER); // preparations for the winter
});
