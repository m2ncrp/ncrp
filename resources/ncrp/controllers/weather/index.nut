/**
 * This array contains all the weathers and are ordered to fit the hour
 * Layout:
 *      [HOUR_START, HOUR_END, ["LIST", "OF", "WEATHERS", ...] ]
 *
 * So if time is between HOUR_START and HOUR_END,
 * then it will pick one of the weathers that are available in slot [2].
 */
local WEATHERS = {
    SUMMER = [
        // This is between the hours of 00:00 and 02:00 (night)
        [0, 2, ["DT_RTRclear_day_nigh", "DT07part04night_bordel", "DTFreerideNight", "DT14part11", "DT11part05", "DT_RTRrainy_day_night", "DT10part03Subquest", "DT_RTRfoggy_day_night"] ],

        // This is between the hours of 03:00 and 05:00 (night / early morning)
        [3, 5, ["DT_RTRclear_day_early_morn1", "DT_RTRfoggy_day_early_morn1", "DT_RTRrainy_day_early_morn"] ],

        // This is between the hours of 06:00 and 08:00 (morning) etc.
        [6, 9, ["DT_RTRclear_day_early_morn2", "DT_RTRclear_day_morning", "DT_RTRrainy_day_morning", "DT_RTRfoggy_day_morning"] ],

        [10, 10, ["DTFreeRideDay", "DT06part03", "DTFreeRideDayRain", "DT11part01", "DT_RTRfoggy_day_noon"] ],
        [11, 11, ["DT07part01fromprison", "DT13part01death", "DT09part1VitosFlat", "DT_RTRclear_day_noon", "DT06part01", "DT06part02", "DT11part02"] ],
        [12, 12, ["DT07part02dereksubquest", "DT08part01cigarettesriver", "DT09part2MalteseFalcone", "DT14part1_6", "DT_RTRrainy_day_noon", "DT_RTRfoggy_day_afternoon"] ],
        [13, 13, ["DT_RTRclear_day_afternoon", "DT10part02Roof", "DT09part3SlaughterHouseAfter", "DT_RTRrainy_day_afternoon", "DT_RTRfoggy_day_afternoon"] ],
        [14, 15, ["DT09part4MalteseFalcone2", "DT08part02cigarettesmill", "DT12_part_all", "DT15", "DT15end", "DT15_interier"] ],
        [16, 17, ["DT13part02", "DT_RTRclear_day_late_afternoon", "DT01part01sicily_svit" "DT_RTRrainy_day_late_afternoon", "DT11part03", "DT_RTRfoggy_day_late_afternoon"] ],
        [18, 18, ["DT08part03crazyhorse", "DT07part03prepadrestaurcie", "DT_RTRrainy_day_evening", "DT_RTRfoggy_day_late_afternoon"] ],
        [19, 19, ["DT05part06Francesca", "DT10part03Evening", "DT14part7_10", "DT11part04", "DT_RTRfoggy_day_evening"] ],
        [20, 23, ["DT_RTRclear_day_evening", "DT08part04subquestwarning", "DT_RTRclear_day_late_even", "DT_RTRrainy_day_late_even", "DT_RTRfoggy_day_late_even", "DT01part02sicily"] ],
    ],

    WINTER = [
        [0, 7, ["DTFreeRideNightSnow", "DT04part02"] ],
        [8, 11, ["DT05part01JoesFlat", "DT03part01JoesFlat", "DTFreeRideDaySnow"] ],
        [12, 13, ["DT05part02FreddysBar", "DTFreeRideDayWinter", "DT05part04Distillery", "DT04part01JoesFlat"] ],
        [14, 15, ["DT02part01Railwaystation", "DT05part03HarrysGunshop", "DT05part05ElGreco"] ],
        [16, 17, ["DT02part02JoesFlat", "DT02part04Giuseppe", "DT03part02FreddysBar"] ],
        [18, 20, ["DT05Distillery_inside", "DT02part05Derek", "DT02part03Charlie"] ],
        [21, 23, ["DT02NewStart1", "DT03part03MariaAgnelo", "DT02NewStart2", "DT03part04PriceOffice"] ],
    ]
};

local SERVER_IS_SUMMER = true;
local WEATHER_CHANGE_TRIGGER = 0;
local SERVER_WEATHER = null;

function setWeather(name) {
    playerList.each(function(playerid) {
        msg(playerid, "changing weather 4 u")
        trigger(playerid, "onServerWeatherSync", name);
    });

    return true;
}

event("onServerSecondChange", function() {
    WEATHER_CHANGE_TRIGGER--;

    // First we check if weather count has reached 0
    if (WEATHER_CHANGE_TRIGGER > 0) return;

    // calculate season change
    // if (getMonth() > 10 || getMonth() < 3) {
    //     if (SERVER_IS_SUMMER) {
    //         SERVER_IS_SUMMER = false;
    //         setSummer(false);
    //         dbg("triggering winter");
    //     }
    // } else {
    //     if (!SERVER_IS_SUMMER) {
    //         SERVER_IS_SUMMER = true;
    //         setSummer(true);
    //         dbg("triggering summer");
    //     }
    // }

    // Get weather based on what season it is
    local weathers = (SERVER_IS_SUMMER) ? WEATHERS.SUMMER : WEATHERS.WINTER;

    // Go through the weathers array
    for (local i = 0; i < weathers.len(); i++) {
        // Check and compare current hour with the hours in array
        // So it checks if current hour is between HOUR_START and HOUR_END
        if (getHour() >= weathers[i][0] && getHour() <= weathers[i][1]) {
            // Select a random weather from slot [2]
            local randWeather = weathers[i][2][random(0, weathers[i][2].len()-1)];
            // Set the random weather for all players
            setWeather(randWeather);
            // Change SERVER_WEATHER string
            SERVER_WEATHER = randWeather;

            // Generate a new number when weather change will happen again
            // New count is between 20 and 75 in-game minutes.
            WEATHER_CHANGE_TRIGGER = 1;//random(20 * 60, 75 * 60);

            // Break out of the loop
            break;
        }
    }
});

// register auto weather sync on player spawn
event("onPlayerSpawn", function(playerid) {
    trigger(playerid, "onServerWeatherSync", SERVER_WEATHER);
});

