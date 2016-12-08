include("controllers/weather/commands.nut");

// settings
const WEATHER_PHASE_CHANGE = 2;
const WEATHER_DEFAULT_PHASE = 3;
const WEATHER_DEFAULT_WEATHER = 0;
const WEATHER_WINTER_STARTS = 11;
const WEATHER_WINTER_ENDS = 2;
const WEATHER_IS_WINTER = false;

SUMMER_CLEAR <- [
    "DT_RTRclear_day_night",        // 0
    "DT07part04night_bordel",
    "DTFreerideNight",
    "DT14part11",
    "DT11part05",
    "DT_RTRclear_day_early_morn1",  // 5
    "DT_RTRclear_day_early_morn2",
    "DT_RTRclear_day_morning",
    "DTFreeRideDay",
    "DT06part03",
    "DT07part01fromprison",         // 10
    "DT13part01death",
    "DT09part1VitosFlat",
    "DT_RTRclear_day_noon",
    "DT07part02dereksubquest",
    "DT08part01cigarettesriver",
    "DT09part2MalteseFalcone",
    "DT14part1_6",
    "DT_RTRclear_day_afternoon",
    "DT10part02Roof",
    "DT09part3SlaughterHouseAfter", // 20
    "DT10part02bSUNOFF",            // 21   before rain
    "DT09part4MalteseFalcone2",
    "DT08part02cigarettesmill",
    "DT12_part_all",
    "DT13part02",
    "DT_RTRclear_day_late_afternoon",
    "DT08part03crazyhorse",
    "DT07part03prepadrestaurcie",
    "DT05part06Francesca",
    "DT10part03Evening",            // 30
    "DT14part7_10",
    "DT_RTRclear_day_evening",
    "DT08part04subquestwarning",
    "DT_RTRclear_day_late_even"     // 34
];

WINTER_CLEAR <- [
    "DTFreeRideNightSnow"
    "DT04part02"
    "DT05part01JoesFlat"
    "DT03part01JoesFlat"
    "DTFreeRideDaySnow"
    "DT05part02FreddysBar"
    "DTFreeRideDayWinter"
    "DT02part01Railwaystation"
    "DT05part03HarrysGunshop"
    "DT02part02JoesFlat"
    "DT02part04Giuseppe"
    "DT02part05Derek"
    "DT02NewStart1"
    "DT03part03MariaAgnelo"
    "DT02NewStart2"
    "DT03part04PriceOffice"
];

WINTER_FOGGY <- [
    "DT05part04Distillery",
    "DT04part01JoesFlat",
    "DT05part05ElGreco",
    "DT03part02FreddysBar",
    "DT02part03Charlie",
    "DT05Distillery_inside"
];

SUMMER_DAY_ROW <- [
    "DT_RTRclear_day_night",        // 0
    "DT_RTRclear_day_early_morn1",  // 5
    "DT_RTRclear_day_early_morn2",  // 6
    "DT_RTRclear_day_morning",
    "DTFreeRideDay",                // 8 ~
    "DT06part03",
    "DT07part01fromprison",         // 10
    "DT13part01death",              // 11
    "DT07part02dereksubquest",      // 14
    "DT09part3SlaughterHouseAfter", // 20
    "DT09part4MalteseFalcone2",     // 22
    "DT08part02cigarettesmill",     // 23
    "DT_RTRclear_day_late_afternoon",// 26
    "DT07part03prepadrestaurcie",   // 28
    "DT_RTRclear_day_evening"       // 32
];


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
