local isSummer = true;
local summerWeather = [
    "nothing"
    "DT05part01JoesFlat",
    "DT05part02FreddysBar",
    "DT05part03HarrysGunshop",
    "DT02part02JoesFlat",
    "DT02part04Giuseppe",
    "DT05part06Francesca",
    "DTFreeRideNightSnow",
    "DT04part02",
    "DTFreeRideDaySnow",
    "DT03part01JoesFlat",
    "DT05part04Distillery",
    "DT02part03Charlie",
    "DT02part04Giuseppe",
    "DT02NewStart1",
    "DT02NewStart2",
    "DT05Distillery_inside",
    "DTFreeRideDaySnow",
    "DT03part01JoesFlat",
    "DT02part01Railwaystation",
    "DT02part02JoesFlat",
    "DT04part01JoesFlat",
    "DT05part05ElGreco",
    "DT03part02FreddysBar",
    "DT03part03MariaAgnelo",
    "DT03part04PriceOffice"
];

function isWinter(name) {
    return (summerWeather.find(name) != null);
}

addEventHandler("onServerWeatherSync", function(name = "") {
    if (name.len() > 0) {
        setWeather(name);

        if (isWinter(name)) {
            isSummer = false;
            setSummer(false);
            return;
        }

        if (!isSummer && !isWinter(name)) {
            setSummer(true);
            isSummer = true;
        }
    }
});
