acmd("weather", function(playerid, weatherId) {
    if (setCurrentWeather(weatherId.tointeger())) {
        return sendPlayerMessage(playerid, "You've successfully changed the weather");
    }
});

acmd("weatherCustom", function(playerid, weather) {
    triggerClientEvent(playerid, "onServerWeatherSync", weather);
});
