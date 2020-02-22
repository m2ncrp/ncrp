// acmd("weather", function(playerid, weatherId) {
//     if (setCurrentWeather(weatherId.tointeger())) {
//         return sendPlayerMessage(playerid, "You've successfully changed the weather");
//     }
// });

local current = 0;
local weathers = [
"DTFreeRideDayWinter",
"DTFreeRideDaySnow",
"DTFreeRideNightSnow", // -
"DT02part01Railwaystation",
"DT02part02JoesFlat",
"DT02part03Charlie",
"DT02part04Giuseppe",
"DT02part05Derek",
"DT02NewStart1",
 "DT02NewStart2",
 "DT03part01JoesFlat",
 "DT03part02FreddysBar",
 "DT03part03MariaAgnelo",
 "DT03part04PriceOffice",
 "DT04part01JoesFlat",
 "DT04part02",
 "DT05Distillery_inside",
 "DT05part01JoesFlat",
 "DT05part02FreddysBar",
 "DT05part03HarrysGunshop",
 "DT05part04Distillery",
 "DT05part05ElGreco",
 "DT05part06Francesca", // -
]

/*
Summer:

"DTFreeRideDay",
"DT01part01sicily_svit",
"DT01part02sicily",
"DT06part01",
"DT06part02",
"DT06part03",
"DT07part01fromprison",
"DT07part02dereksubquest",
"DT07part03prepadrestaurcie",
 "DT07part04night_bordel",
 "DT08part01cigarettesriver",
 "DT08part02cigarettesmill",
 "DT08part03crazyhorse",
 "DT08part04subquestwarning",
 "DT09part1VitosFlat",
 "DT09part2MalteseFalcone",
 "DT09part3SlaughterHouseAfter",
 "DT09part4MalteseFalcone2",
 "DT10part02Roof",
 "DT10part02bSUNOFF",
 "DT10part03Evening",
 "DT10part03Subquest",
 "DT11part01",
 "DT11part02",
 "DT11part03",
 "DT11part04",
 "DT11part05",
 "DT12_part_all",
 "DT13part01death",
 "DT13part02",
 "DT14part1_6",
 "DT14part7_10",
 "DT14part11",
 "DT15",
 "DT15_interier",
 "DT15end",
 "DT_RTRclear_day_afternoon",
 "DT_RTRclear_day_early_morn1",
 "DT_RTRclear_day_early_morn2",
 "DT_RTRclear_day_evening",
 "DT_RTRclear_day_late_afternoon",
 "DT_RTRclear_day_late_even",
 "DT_RTRclear_day_morning",
 "DT_RTRclear_day_night",
 "DT_RTRclear_day_noon",
 "DT_RTRfoggy_day_afternoon",
 "DT_RTRfoggy_day_early_morn1",
 "DT_RTRfoggy_day_evening",
 "DT_RTRfoggy_day_late_afternoon",
 "DT_RTRfoggy_day_late_even",
 "DT_RTRfoggy_day_morning",
 "DT_RTRfoggy_day_night",
 "DT_RTRfoggy_day_noon",
 "DT_RTRrainy_day_afternoon",
 "DT_RTRrainy_day_early_morn",
 "DT_RTRrainy_day_evening",
 "DT_RTRrainy_day_late_afternoon",
 "DT_RTRrainy_day_late_even",
 "DT_RTRrainy_day_morning",
 "DT_RTRrainy_day_night",
 "DT_RTRrainy_day_noon",
 "DTFreeRideDayRain",

	*/

function admSetWeather(playerid, weatherid) {
    local weatherid = weatherid.tointeger();
    if(weatherid > 22 || weatherid < 0) weatherid = 0;
    local weathername = weathers[weatherid];
    current = weatherid;
    setWeather(weathername);
    msg(playerid, "Weather changed: "+weathername+" #"+weatherid);
}

acmd("weather", function(playerid, weatherid) {
    admSetWeather(playerid, weatherid);
});

addKeyboardHandler("num_2", "up", function(playerid) {
    local b = weathers[current];
    weathers[current] = weathers[current-1];
    weathers[current-1] = b;
    msg(playerid, "Move weather "+weathers[current]+" down");
});

addKeyboardHandler("num_8", "up", function(playerid) {
    local b = weathers[current];
    weathers[current] = weathers[current+1];
    weathers[current+1] = b;
    msg(playerid, "Move weather "+weathers[current]+" up");
});



addKeyboardHandler("num_4", "up", function(playerid) {
    admSetWeather(playerid, current-1);
});


addKeyboardHandler("num_6", "up", function(playerid) {
    admSetWeather(playerid, current+1);
});

addKeyboardHandler("num_5", "up", function(playerid) {
    dbg(weathers);
})
