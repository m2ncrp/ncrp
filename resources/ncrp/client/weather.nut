addEventHandler("onServerWeatherSync", function(name = "") {
    return (name.len() > 0) ? setWeather(name) : null;
});
