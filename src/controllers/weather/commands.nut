// acmd("weather", function(playerid, weatherId) {
//     if (setCurrentWeather(weatherId.tointeger())) {
//         return sendPlayerMessage(playerid, "You've successfully changed the weather");
//     }
// });

local current = 0;
local weathers = ["DT04part02","DT05part01JoesFlat","DTFreeRideDaySnow","DT03part01JoesFlat","DT05part02FreddysBar","DT05part04Distillery","DTFreeRideDayWinter","DT04part01JoesFlat","DT02part01Railwaystation","DT05part03HarrysGunshop","DT05part05ElGreco","DT02part02JoesFlat","DT02part03Charlie","DT02part04Giuseppe","DT03part02FreddysBar","DT05Distillery_inside","DT02part05Derek","DT02NewStart1","DT03part03MariaAgnelo","DT02NewStart2","DT03part04PriceOffice"];


function admSetWeather(playerid, weatherid) {
    local weatherid = weatherid.tointeger();
    if(weatherid > 21 || weatherid < 0) weatherid = 0;
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

// acmd("season", function(playerid, season) {
//     if (season == "s" || season == "summer") {
//         return setSummer(true);
//     }

//     if (season == "w" || season == "winter") {
//         return setSummer(false);
//     }
// });
