include("modules/shops/fuelstations");
include("modules/shops/carshop");
include("modules/shops/repairshop");
include("modules/shops/restaurant");
include("modules/shops/washstations");
include("modules/shops/carsearch");
include("modules/shops/clothesshop");


// TODO(inlife): move to other place
event("onServerStarted", function() {
    create3DText(-645.075, 1293.6, 3.94464,         "HighbrookDinerRadio",              CL_WHITE);
    create3DText(-711.473, 1757.95, -14.9935,       "DiptonGasStationRadio",            CL_WHITE);
    create3DText(-711.197, 1758.35, -14.9964,       "DiptonGasstationPhone",            CL_WHITE);
    create3DText(-710.199, 1756.32, -15.0063,       "DiptonGasstaionRadio",             CL_WHITE);
    create3DText(-646.916, 1297.95, 3.94464,        "HighbrookDinerRadio(roomcenter)",  CL_WHITE);
    create3DText(-1294.3, 1705.27, 10.5592,         "KingstonClothesStorePhone",        CL_WHITE);
    create3DText(-1295.72, 1706.66, 10.5592,        "KingstonClothesStoreRadio",        CL_WHITE);
    create3DText(-1149.45, 1588.94, 6.25566,        "HillOfTaraRadio",                  CL_WHITE);
    create3DText(-1420.38, 961.661, -12.7543,       "GreenfieldDinerRadio",             CL_WHITE);
    create3DText(-1422.09, 959.477, -12.7543,       "GreenfieldDinerPhone",             CL_WHITE);
    create3DText(-1587.8, 941.463, -5.19652,        "GreenfieldGasstationPhone",        CL_WHITE);
    create3DText(-1585.75, 942.841, -5.20643,       "GreenfieldGasstationRadio",        CL_WHITE);
    create3DText(-1684.18, -230.827, -20.3181,      "SandIslantGasstationPhone",        CL_WHITE);
    create3DText(-1686.19, -231.996, -20.328,       "SandIslantGasstationRadio",        CL_WHITE);
    create3DText(-1588.4, 177.376, -12.4393,        "SandIslantDinerRadio",             CL_WHITE);
    create3DText(-1590.33, 175.516, -12.4393,       "SandIslantDinerPhone",             CL_WHITE);
    create3DText(-517.973, 871.842, -19.3224,       "UptownDressingShopRadio",          CL_WHITE);
    create3DText(-517.118, 873.251, -19.3223,       "UptownDressingShopPhone",          CL_WHITE);
    create3DText(339.648, 879.538, -21.2967,        "LittleItalyGasstationPhone",       CL_WHITE);
    create3DText(338.483, 881.513, -21.3066,        "LittleItalyGasstationRadio",       CL_WHITE);
    create3DText(429.584, 302.659, -20.1786,        "ChinaTownGasstationRadio",         CL_WHITE);
    create3DText(430.495, 304.263, -20.1786,        "ChinaTownGasstationPhone",         CL_WHITE);
    create3DText(543.76, 3.37411, -18.2392,         "OsterbayGasstationPhone",          CL_WHITE);
    create3DText(541.734, 2.07937, -18.2491,        "OsterbayGasstationRadio",          CL_WHITE);
    create3DText(-40.4981, 388.486, -13.9963,       "EastSideClothingShopPhone",        CL_WHITE);
    create3DText(-41.8942, 389.116, -13.9963,       "EastSideClothingShopRadio",        CL_WHITE);
    create3DText(107.752, 182.195, -20.0295,        "EastSideGasstaionPhone",           CL_WHITE);
    create3DText(105.723, 180.87, -20.0394,         "EastSideGasstaionRadio",           CL_WHITE);
    create3DText(-4.2169, 559.556, -19.4067,        "LittleItalyClothingShopPhone",     CL_WHITE);
    create3DText(-5.61307, 560.5, -19.4068,         "LittleItalyClothingShopRadio",     CL_WHITE);
    create3DText(-150.935, 606.023, -20.1787,       "LittleitalyGasstaion2Phone",       CL_WHITE);
    create3DText(-149.686, 604.01, -20.1886,        "LittleitalyGasstaion2Radio",       CL_WHITE);
})


local musiclist = [
    "m01_part1",
    "m01_part2",
    "m01_action",
    "m02_ride_to_freddys_bar",
    "m02_way_to_mother",
    "m02_Bombers_fight",
    "m03_PriceOffice_music_stealth",
    "m03_PriceOffice_music_suspiction",
    "m03_PriceOffice_music_fighting",
    "m03_sq_deepthroat1",
    "m03_sq_deepthroat2",
    "m04_Elbox_music",
    "m04_Jewellery_music",
    "m04_Escape_music",
    "m04_Roof_music",
    "m05_Distilery_Street",
    "m05_Distilery_Firstfloor",
    "m05_Distilery_Surprise",
    "m05_Distilery_Secondfloor",
    "m06_Prison_arrival",
    "m06_Prison_welcome",
    "m06_Prison_fight_with_Brian",
    "m06_Prison_fight_with_rapists",
    "m06_Prison_final_fight",
    "m06_Prison_yard_first",
    "m07_grave_departure",
    "m08_Hot_Rod_chase",
    "m08_Storming_foundry_outside",
    "m08_Storming_foundry_inside",
    "m09_Sewers",
    "m09_Sneaking",
    "m09_Fight_torturers",
    "m09_Fight_reinforcements",
    "m09_Prisoners",
    "m09_Pursuit",
    "m09_Close_combat",
    "m09_Fredy_bar",
    "m10_Skyscraper_action",
    "m10_Basement_action",
    "m10_Car_chase",
    "m10_Roof_fight",
    "m10_lift_music",
    "m10_lift_music2",
    "m11_Race",
    "m11_Hiding",
    "m12_Ambush",
    "m12_Fight_inside",
    "m13_Park_fight",
    "m13_Following_the_car",
    "m13_Storming_the_restaurant",
    "m13_Opium_Lair",
    "m13_Laboratory_Fight",
    "m14_SQ_Garage_Fight",
    "m14_Sneaking",
    "m14_CS_Fight",
    "m14_SQ_Kill_Derek_1",
    "m14_SQ_Kill_Derek_2",
    "m15_Planetarium_Action",
    "m15_Planetarium_BossFight",
    "RtR_prison_break",
    "GCD_fist_fight",
    "GCD_stealth",
    "GCD_guard_fight",
];

local musicplayer = {};

acmd("mu", function(playerid, step = 1) {
    if (!(playerid in musicplayer)) {
        musicplayer[playerid] <- 0;
    } else {
        stopSoundForPlayer(playerid);
    }

    local track = musiclist[musicplayer[playerid]];

    playSoundForPlayer(playerid, track);
    msg(playerid, "now playing: " + track, CL_INFO);

    musicplayer[playerid] = musicplayer[playerid] + step.tointeger();

    if (musicplayer[playerid] >= musiclist.len()) {
        musicplayer[playerid] = 0;
    }
});

