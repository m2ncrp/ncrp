addEventHandler("onServerWeatherSync", function(name = "") {
    if (name.len() > 0) {
        setWeather(name);
    }
});
