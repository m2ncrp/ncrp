include("modules/jobs/snowplower/commands.nut");

local count = 0;

acmd("snow", function(playerid) {
    if(!isPlayerInValidVehicle(playerid, 39)) { return msg(playerid, "You need Shubert SnowPlow."); }
    local vehicleid = getPlayerVehicle(playerid);
    local vehPos = getVehiclePosition(vehicleid);
    local vehRot = getVehicleRotation(vehicleid);

    local xR = vehRot[0];
    local x = vehPos[0];
    local y = vehPos[1];
    local x1 = 0;
    local x2 = 0;
    local y1 = 0;
    local y2 = 0;

    // when near 0
    if(xR > -5 && xR < 5) {
        x1 = x - 1.6;
        y1 = y + 1;
        x2 = x + 2;
        y2 = y - 1;
    }

    // when near 90
    else if(xR > 85 && xR < 95) {
        x1 = x + 1;
        y1 = y + 1.6;
        x2 = x - 1;
        y2 = y - 2;
    }

    // when near 180
    else if( (xR > 175 && xR < 180) || (xR < -175 && xR > -179.99) ) {
        x1 = x - 2;
        y1 = y + 1;
        x2 = x + 1.6;
        y2 = y - 1;
    }

    // when near -90
    else if(xR > -95 && xR < -85) {
        x1 = x - 1;
        y1 = y + 2;
        x2 = x + 1;
        y2 = y - 1.6;
    }

    dbg(    format("%.3f", round(vehPos[0], 3)) +",  "+    format("%.3f", round(vehPos[1], 3)) +",  "+   format("%.3f", round(vehPos[2], 3)) +",  "+   format("%.3f", round(x1, 3))  +",  "+   format("%.3f", round(y1, 3))   +",  "+  format("%.3f", round(x2, 3))   +",  "+  format("%.3f", round(y2, 3)));
    msg(playerid, "Place has been created.", CL_SUCCESS );
    createPlace("snowPlace"+count, x1, y1, x2, y2);
    count += 1;
});


//include("modules/jobs/snowplow/commands.nut");

local job_snowplow = {};
local job_snowplow_blocked = {};
local snowplowStops = {};
local routes = {};

local RADIUS_SNOWPLOW = 2.0;
local RADIUS_SNOWPLOW_SMALL = 1.0;
local SNOWPLOW_JOB_X = -388.442;
local SNOWPLOW_JOB_Y = 585.829;
local SNOWPLOW_JOB_Z = -10.2939;


local SNOWPLOW_JOB_TIMEOUT = 1800; // 30 minutes
local SNOWPLOW_JOB_SKIN = 87;
local SNOWPLOW_JOB_NAME = "snowplowdriver";
local SNOWPLOW_JOB_SNOWPLOWSTOP = "CHECKPOINT";
local SNOWPLOW_JOB_DISTANCE = 100;
local SNOWPLOW_JOB_LEVEL = 1;
      SNOWPLOW_JOB_COLOR <- CL_ROYALBLUE;
local SNOWPLOW_JOB_GET_HOUR_START        = 0  ;   // 6;
local SNOWPLOW_JOB_GET_HOUR_END          = 23 ;   // 9;
local SNOWPLOW_JOB_LEAVE_HOUR_START      = 0  ;   // 20;
local SNOWPLOW_JOB_LEAVE_HOUR_END        = 23 ;   // 22;
local SNOWPLOW_JOB_WORKING_HOUR_START    = 0  ;   // 6;
local SNOWPLOW_JOB_WORKING_HOUR_END      = 23 ;   // 21;
local SNOWPLOW_ROUTE_IN_HOUR = 4;
local SNOWPLOW_ROUTE_NOW = 4;

local routes_list_all = [ 1, 2, 3, 4, 5 ];
local routes_list = clone( routes_list_all );

alternativeTranslate({
    "en|job.snowplowdriver"                     :   "snowplow driver"
    "ru|job.snowplowdriver"                     :   "водитель снегоуборочной машины"

    "en|job.snowplow.needlevel"                 :   "[SNOWPLOW] You need level %d to become snowplow driver."
    "ru|job.snowplow.needlevel"                 :   "[SNOWPLOW] Стать водителем снегоуборочной машины можно, начиная с %d уровня."

    "en|job.snowplow.badworker"                 :   "[SNOWPLOW] You are a bad worker. We haven't job for you."
    "ru|job.snowplow.badworker"                 :   "[SNOWPLOW] Увы, но нам нужны только ответственные водители."

    "en|job.snowplow.badworker.onleave"         :   "[SNOWPLOW] You are a bad worker. Get out of here."
    "ru|job.snowplow.badworker.onleave"         :   "[SNOWPLOW] Плохой из тебя работник."

    "en|job.snowplow.goodluck"                  :   "[SNOWPLOW] Good luck, guy! Come if you need a job."
    "ru|job.snowplow.goodluck"                  :   "[SNOWPLOW] Удачи тебе! Приходи, если нужна работа."

    "en|job.snowplow.driver.not"                :   "[SNOWPLOW] You're not a snowplow driver."
    "ru|job.snowplow.driver.not"                :   "[SNOWPLOW] Ты не работаешь водителем снегоуборочной машины."

    "en|job.snowplow.driver.now"                :   "[SNOWPLOW] You're a snowplow driver now! Congratulations!"
    "ru|job.snowplow.driver.now"                :   "[SNOWPLOW] Ты стал водителем снегоуборочной машины!"

    "en|job.snowplow.driver.togetroute"         :   "Press E to get route."
    "ru|job.snowplow.driver.togetroute"         :   "Нажми клавишу E (латинская), чтобы получить маршрут."

    "en|job.snowplow.ifyouwantstart"            :   "[SNOWPLOW] You're snowplow driver. If you want to start route - take route at snowplow depot in Uptown."
    "ru|job.snowplow.ifyouwantstart"            :   "[SNOWPLOW] Ты работаешь водителем снегоуборочной машины. Если хочешь выйти в рейс - возьми маршрут."

    "en|job.snowplow.route.your"                :   "[SNOWPLOW] Your route:"
    "ru|job.snowplow.route.your"                :   "[SNOWPLOW] Твой текущий маршрут:"

    "en|job.snowplow.startroute"                :   "[SNOWPLOW] Sit into snowplow truck and drive along the route."
    "ru|job.snowplow.startroute"                :   "[SNOWPLOW] Садись в снегоуборочную машину и следуй по маршруту."

    "en|job.snowplow.startroute2"               :   "Speed limit for effective scavenging - 40 miles."
    "ru|job.snowplow.startroute2"               :   "Скоростное ограничение для эффективной уборки: 40 миль."

    "en|job.snowplow.route.needcomplete"        :   "[SNOWPLOW] Complete current route."
    "ru|job.snowplow.route.needcomplete"        :   "[SNOWPLOW] Заверши маршрут."

    "en|job.snowplow.needCompleteToLeave"       :   "[SNOWPLOW] You need to complete current route to leave job."
    "ru|job.snowplow.needCompleteToLeave"       :   "[SNOWPLOW] Чтобы уволиться, тебе надо завершить текущий маршрут."

    "en|job.snowplow.needsnowplow"              :   "[SNOWPLOW] You need a snowplow truck."
    "ru|job.snowplow.needsnowplow"              :   "[SNOWPLOW] Тебе нужна снегоуборочная машина."

    "en|job.snowplow.continuesnowplowstop"      :   "[SNOWPLOW] Continue the route."
    "ru|job.snowplow.continuesnowplowstop"      :   "[SNOWPLOW] Продолжай движение по маршруту."


    "en|job.snowplow.driving"                   :   "[SNOWPLOW] Reduce speed."
    "ru|job.snowplow.driving"                   :   "[SNOWPLOW] Снизь скорость."

    "en|job.snowplow.gototakemoney"             :   "[SNOWPLOW] Leave the snowplow truck and take your money."
    "ru|job.snowplow.gototakemoney"             :   "[SNOWPLOW] Вылезай из машины и забирай деньги за работу."

    "en|job.snowplow.nicejob"                   :   "[SNOWPLOW] Nice job! You earned $%.2f"
    "ru|job.snowplow.nicejob"                   :   "[SNOWPLOW] Отличная работа! Ты заработал $%.2f."



    "en|job.snowplow.help.title"            :   "Controls for snowplow driver:"
    "ru|job.snowplow.help.title"            :   "Управление для водителя снегоуборочной машины:"

    "en|job.snowplow.help.job"              :   "E button"
    "ru|job.snowplow.help.job"              :   "кнопка E"

    "en|job.snowplow.help.jobtext"          :   "Get snowplow driver job at snowplow station in Uptown"
    "ru|job.snowplow.help.jobtext"          :   "Устроиться на работу водителем снегоуборочной машины (напротив Полицейского Департамента)"

    "en|job.snowplow.help.jobleave"         :   "Q button"
    "ru|job.snowplow.help.jobleave"         :   "кнопка Q"

    "en|job.snowplow.help.jobleavetext"     :   "Leave snowplow driver job at snowplowing company in Uptown"
    "ru|job.snowplow.help.jobleavetext"     :   "Уволиться с работы (напротив Полицейского Департамента)"

});

event("onServerStarted", function() {
    log("[jobs] loading snowplow job...");

    createVehicle(39, -372.233, 593.342, -9.96686, -89.1468, 1.52338, 0.0686706);
    createVehicle(39, -374.524, 589.011, -9.96381, -56.7532, 1.17279, 0.934235);
    createVehicle(39, -380.797, 588.42, -9.95933, -56.3861, 1.20405, 0.900966);


  //snowplowStops[0]   <-                                         vehPos                         x1         y1           x2          y2
    snowplowStops[0]   <-  snowplowStop( snowplowv3( -380.799,    593.685,      -9.966),     -379.799,    595.285,    -381.799,    591.685);


    snowplowStops[1]   <-  snowplowStop( snowplowv3( -416.752,    587.172,    -9.96491),     -417.752,    589.172,    -415.752,    585.572);
    snowplowStops[2]   <-  snowplowStop( snowplowv3( -522.54,      586.85,    -5.21594),     -523.54,      588.85,     -521.54,     585.25);
    snowplowStops[3]   <-  snowplowStop( snowplowv3( -637.449,    586.973,    0.980519),     -638.449,    588.973,    -636.449,    585.373);
    snowplowStops[4]   <-  snowplowStop( snowplowv3( -674.036,    543.109,     1.20359),     -676.036,    544.109,    -672.436,    542.109);
    snowplowStops[5]   <-  snowplowStop( snowplowv3( -674.214,    307.085,    0.456963),     -676.214,    308.085,    -672.614,    306.085);
    snowplowStops[6]   <-  snowplowStop( snowplowv3( -674.197,   -26.1555,     1.20121),     -676.197,   -25.1555,    -672.597,   -27.1555);
    snowplowStops[7]   <-  snowplowStop( snowplowv3( -597.453,    -71.095,     1.20968),     -596.453,    -69.495,    -598.453,    -73.095);
    snowplowStops[8]   <-  snowplowStop( snowplowv3( -491.753,   -71.1395,    -1.27599),     -490.753,   -69.5395,    -492.753,   -73.1395);
    snowplowStops[9]   <-  snowplowStop( snowplowv3( -454.535,   -46.7609,    -1.95572),     -456.135,   -45.7609,    -452.535,   -47.7609);
    snowplowStops[10]   <-  snowplowStop( snowplowv3(-454.945,    129.885,    0.121022),     -456.545,    130.885,    -452.945,    128.885);
    snowplowStops[11]   <-  snowplowStop( snowplowv3(-455.049,    246.894,     1.20164),     -456.649,    247.894,    -453.049,    245.894);
    snowplowStops[12]   <-  snowplowStop( snowplowv3(-450.222,    293.875,     1.20087),     -451.822,    294.875,    -448.222,    292.875);
    snowplowStops[13]   <-  snowplowStop( snowplowv3(-450.161,    394.043,     1.19983),     -451.761,    395.043,    -448.161,    393.043);
    snowplowStops[14]   <-  snowplowStop( snowplowv3(-426.133,    514.137,    0.613793),     -425.133,    515.737,    -427.133,    512.137);
    snowplowStops[15]   <-  snowplowStop( snowplowv3(-388.315,    451.863,    -1.05962),     -390.315,    452.863,    -386.715,    450.863);
    snowplowStops[16]   <-  snowplowStop( snowplowv3(-329.738,    413.798,    -3.49611),     -328.738,    415.398,    -330.738,    411.798);
    snowplowStops[17]   <-  snowplowStop( snowplowv3(-238.371,    413.799,    -6.14484),     -237.371,    415.399,    -239.371,    411.799);
    snowplowStops[18]   <-  snowplowStop( snowplowv3(-215.665,     369.32,    -6.15691),     -217.665,     370.32,    -214.065,     368.32);
    snowplowStops[19]   <-  snowplowStop( snowplowv3(-215.671,    261.422,    -6.63686),     -217.671,    262.422,    -214.071,    260.422);
    snowplowStops[20]   <-  snowplowStop( snowplowv3(-215.602,    157.453,    -10.3785),     -217.602,    158.453,    -214.002,    156.453);
    snowplowStops[21]   <-  snowplowStop( snowplowv3( -215.66,    69.0457,    -11.1149),      -217.66,    70.0457,    -214.059,    68.0457);
    snowplowStops[22]   <-  snowplowStop( snowplowv3( -239.73,    -21.577,    -11.4076),      -240.73,    -19.577,     -238.73,    -23.177);
    snowplowStops[23]   <-  snowplowStop( snowplowv3(-391.442,   -21.5866,    -4.18524),     -392.442,   -19.5866,    -390.442,   -23.1866);
    snowplowStops[24]   <-  snowplowStop( snowplowv3(-450.501,   -1.87276,     -1.2012),     -452.101,  -0.872763,    -448.501,   -2.87276);
    snowplowStops[25]   <-  snowplowStop( snowplowv3(-450.267,    125.927,   0.0107612),     -451.867,    126.927,    -448.267,    124.927);
    snowplowStops[26]   <-  snowplowStop( snowplowv3(-450.415,     245.76,     1.20075),     -452.015,     246.76,    -448.415,     244.76);
    snowplowStops[27]   <-  snowplowStop( snowplowv3(-430.416,    269.901,     1.34267),     -429.416,    271.501,    -431.416,    267.901);
    snowplowStops[28]   <-  snowplowStop( snowplowv3(-336.471,     267.42,     2.22577),     -335.471,     269.02,    -337.471,     265.42);
    snowplowStops[29]   <-  snowplowStop( snowplowv3(-228.552,     286.79,    -5.91183),     -227.552,     288.39,    -229.552,     284.79);
    snowplowStops[30]   <-  snowplowStop( snowplowv3(-172.143,    280.461,    -8.92967),     -171.143,    282.061,    -173.143,    278.461);
    snowplowStops[31]   <-  snowplowStop( snowplowv3(-139.986,      246.2,    -13.4265),     -141.986,      247.2,    -138.386,      245.2);
    snowplowStops[32]   <-  snowplowStop( snowplowv3(-64.3596,    214.268,    -14.5636),     -63.3596,    215.868,    -65.3596,    212.268);
    snowplowStops[33]   <-  snowplowStop( snowplowv3( 82.4983,    214.261,    -17.3334),      83.4983,    215.861,     81.4983,    212.261);
    snowplowStops[34]   <-  snowplowStop( snowplowv3( 152.206,    214.009,    -19.8639),      153.206,    215.609,     151.206,    212.009);
    snowplowStops[35]   <-  snowplowStop( snowplowv3( 242.522,    260.182,    -21.1308),      243.522,    261.782,     241.522,    258.182);
    snowplowStops[36]   <-  snowplowStop( snowplowv3( 263.558,    243.499,    -22.2358),      261.558,    244.499,     265.158,    242.499);
    snowplowStops[37]   <-  snowplowStop( snowplowv3( 266.269,    190.339,     -22.627),      264.269,    191.339,     267.869,    189.339);
    snowplowStops[38]   <-  snowplowStop( snowplowv3( 183.685,    56.3474,    -20.1082),      181.685,    57.3474,     185.285,    55.3474);
    snowplowStops[39]   <-  snowplowStop( snowplowv3(   183.8,   -103.955,    -19.9996),        181.8,   -102.955,       185.4,   -104.955);
    snowplowStops[40]   <-  snowplowStop( snowplowv3( 180.515,   -139.864,    -19.9961),      178.515,   -138.864,     182.115,   -140.864);
    snowplowStops[41]   <-  snowplowStop( snowplowv3(  219.45,   -228.409,    -19.9936),       217.45,   -227.409,      221.05,   -229.409);
    snowplowStops[42]   <-  snowplowStop( snowplowv3(  155.54,   -266.965,    -20.0005),       154.54,   -264.965,      156.54,   -268.565);
    snowplowStops[43]   <-  snowplowStop( snowplowv3(  135.52,   -253.821,    -19.9867),       133.92,   -252.821,      137.52,   -254.821);
    snowplowStops[44]   <-  snowplowStop( snowplowv3( 135.398,   -130.975,     -19.888),      133.798,   -129.975,     137.398,   -131.975);
    snowplowStops[45]   <-  snowplowStop( snowplowv3( 113.027,    -111.87,    -19.8506),      112.027,    -109.87,     114.027,    -113.47);
    snowplowStops[46]   <-  snowplowStop( snowplowv3( 52.584,     -79.344,     -17.336),       50.984,    -78.344,      54.584,    -80.344);
    snowplowStops[47]   <-  snowplowStop( snowplowv3( 49.820,     -34.058,     -15.537),       48.220,    -33.058,      51.820,    -35.058);
    snowplowStops[48]   <-  snowplowStop( snowplowv3( -1.022,      49.642,     -13.197),       -2.022,     51.642,      -0.022,     48.042);
    snowplowStops[49]   <-  snowplowStop( snowplowv3( -57.076,    -60.148,     -14.288),      -59.076,    -59.148,     -55.476,    -61.148);
    snowplowStops[50]   <-  snowplowStop( snowplowv3(-178.678,   -106.146,    -11.9926),     -179.678,   -104.146,    -177.678,   -107.746);
    snowplowStops[51]   <-  snowplowStop( snowplowv3( -194.36,   -89.1226,    -11.8729),      -195.96,   -88.1226,     -192.36,   -90.1226);
    snowplowStops[52]   <-  snowplowStop( snowplowv3(-196.343,   -8.40271,    -11.8482),     -197.943,   -7.40271,    -194.343,   -9.40271);
    snowplowStops[53]   <-  snowplowStop( snowplowv3(-201.765,     127.69,    -10.5628),     -203.365,     128.69,    -199.765,     126.69);
    snowplowStops[54]   <-  snowplowStop( snowplowv3(-201.829,    248.473,    -7.25146),     -203.429,    249.473,    -199.829,    247.473);
    snowplowStops[55]   <-  snowplowStop( snowplowv3(-201.737,    374.059,    -6.17334),     -203.337,    375.059,    -199.737,    373.059);
    snowplowStops[56]   <-  snowplowStop( snowplowv3(-246.195,    429.435,    -6.15373),     -247.195,    431.435,    -245.195,    427.835);
    snowplowStops[57]   <-  snowplowStop( snowplowv3(-363.582,    429.173,    -1.59677),     -364.582,    431.173,    -362.582,    427.573);
    snowplowStops[58]   <-  snowplowStop( snowplowv3(-384.168,    476.679,    -1.05841),     -385.768,    477.679,    -382.168,    475.679);
    snowplowStops[59]   <-  snowplowStop( snowplowv3(-436.568,    518.282,    0.903664),     -437.568,    520.282,    -435.568,    516.682);
    snowplowStops[60]   <-  snowplowStop( snowplowv3(-482.567,    584.849,     1.19845),     -484.167,    585.849,    -480.567,    583.849);
    snowplowStops[61]   <-  snowplowStop( snowplowv3(-455.622,    613.108,   -0.909589),     -454.622,    614.708,    -456.622,    611.108);

    snowplowStops[62]   <-  snowplowStop( snowplowv3(-414.122,    618.843,    -9.43908),     -415.122,        620.843,        -413.122,        617.243);
    snowplowStops[63]   <-  snowplowStop( snowplowv3(-494.052,    587.972,     1.20166),     -496.052,        588.972,        -492.452,        586.972);
    snowplowStops[64]   <-  snowplowStop( snowplowv3(-463.651,    445.008,     1.20149),     -465.651,        446.008,        -462.051,        444.008);
    snowplowStops[65]   <-  snowplowStop( snowplowv3(-463.865,    198.194,     1.19694),     -465.865,        199.194,        -462.265,        197.194);
    snowplowStops[66]   <-  snowplowStop( snowplowv3(-463.626,    1.52669,    -1.18871),     -465.626,        2.52669,        -462.026,       0.526691);
    snowplowStops[67]   <-  snowplowStop( snowplowv3(-463.936,   -93.0661,    -3.17414),     -465.936,        -92.0661,        -462.336,      -94.0661);
    snowplowStops[68]   <-  snowplowStop( snowplowv3(-439.017,   -113.735,    -3.74975),     -438.017,        -112.135,        -440.017,      -115.735);
    snowplowStops[69]   <-  snowplowStop( snowplowv3(-246.471,   -113.839,    -11.4539),     -245.471,        -112.239,        -247.471,      -115.839);
    snowplowStops[70]   <-  snowplowStop( snowplowv3(-86.3582,   -113.919,    -13.9381),     -85.3582,        -112.319,        -87.3582,      -115.919);
    snowplowStops[71]   <-  snowplowStop( snowplowv3(20.1625,    -114.193,    -17.4769),      21.1625,        -112.593,        19.1625,       -116.193);
    snowplowStops[72]   <-  snowplowStop( snowplowv3(49.8983,    -95.4109,    -17.9578),      48.2984,        -94.4109,        51.8983,       -96.4109);
    snowplowStops[73]   <-  snowplowStop( snowplowv3(49.8637,     24.7243,    -13.2028),      48.2637,        25.7243,        51.8637,         23.7243);
    snowplowStops[74]   <-  snowplowStop( snowplowv3(49.8515,     201.848,    -15.8109),      48.2515,        202.848,        51.8515,         200.848);
    snowplowStops[75]   <-  snowplowStop( snowplowv3(52.9251,     246.728,    -15.6138),      51.3251,        247.728,        54.9251,         245.728);
    snowplowStops[76]   <-  snowplowStop( snowplowv3(52.7659,      344.75,    -13.9401),      51.1659,        345.75,        54.7659,           343.75);
    snowplowStops[77]   <-  snowplowStop( snowplowv3(77.593,      377.231,    -17.1208),       78.593,        378.831,        76.593,           375.231);
    snowplowStops[78]   <-  snowplowStop( snowplowv3(126.353,     314.239,     -20.901),      124.353,        315.239,        127.953,         313.239);
    snowplowStops[79]   <-  snowplowStop( snowplowv3(125.843,     133.164,    -19.8622),      123.843,        134.164,        127.443,         132.164);
    snowplowStops[80]   <-  snowplowStop( snowplowv3(126.071,   -0.107891,    -19.8575),      124.071,        0.892109,        127.671,       -1.10789);
    snowplowStops[81]   <-  snowplowStop( snowplowv3(125.917,    -146.808,    -19.8891),      123.917,        -145.808,        127.517,       -147.808);
    snowplowStops[82]   <-  snowplowStop( snowplowv3(128.492,    -209.172,    -19.9529),      126.492,        -208.172,        130.092,       -210.172);
    snowplowStops[83]   <-  snowplowStop( snowplowv3(126.5,      -261.694,    -19.9967),        124.5,        -260.694,            128.1,       -262.694);
    snowplowStops[84]   <-  snowplowStop( snowplowv3(93.9852,    -283.481,    -19.9955),      92.9852,        -281.481,        94.9852,       -285.081);
    snowplowStops[85]   <-  snowplowStop( snowplowv3(-50.4154,   -267.644,    -14.2238),     -52.0154,        -266.644,        -48.4154,     -268.644);
    snowplowStops[86]   <-  snowplowStop( snowplowv3(-53.0871,   -193.998,    -14.2822),     -54.6871,        -192.998,        -51.0871,     -194.998);
    snowplowStops[87]   <-  snowplowStop( snowplowv3(-53.6551,    1.14843,    -14.1847),     -55.2551,        2.14843,        -51.6551,      0.148428);
    snowplowStops[88]   <-  snowplowStop( snowplowv3(14.2208,     46.4082,    -13.0514),      15.2208,        48.0082,        13.2208,         44.4082);
    snowplowStops[89]   <-  snowplowStop( snowplowv3(40.4468,    -2.95571,    -14.4099),      38.4468,        -1.95571,        42.0468,       -3.95571);
    snowplowStops[90]   <-  snowplowStop( snowplowv3(5.35298,    -106.563,    -16.6891),      4.35298,        -104.563,        6.35298,       -108.163);
    snowplowStops[91]   <-  snowplowStop( snowplowv3(-175.152,   -106.403,    -12.0639),     -176.152,        -104.403,        -174.152,     -108.003);
    snowplowStops[92]   <-  snowplowStop( snowplowv3(-194.278,   -90.2247,    -11.8691),     -195.878,        -89.2247,        -192.278,     -91.2247);
    snowplowStops[93]   <-  snowplowStop( snowplowv3(-196.996,   -66.1171,    -11.8735),     -198.596,        -65.1171,        -194.996,     -67.1171);
    snowplowStops[94]   <-  snowplowStop( snowplowv3(-205.177,    68.3538,    -11.1223),     -206.777,        69.3538,        -203.177,       67.3538);
    snowplowStops[95]   <-  snowplowStop( snowplowv3(-205.312,    265.642,     -6.5085),     -206.912,        266.642,        -203.312,       264.642);
    snowplowStops[96]   <-  snowplowStop( snowplowv3(-237.655,    425.034,    -6.14126),     -238.655,        427.034,        -236.655,       423.434);
    snowplowStops[97]   <-  snowplowStop( snowplowv3(-384.129,     472.69,    -1.05868),     -385.729,        473.69,        -382.129,         471.69);
    snowplowStops[98]   <-  snowplowStop( snowplowv3(-476.607,    552.856,     1.20192),     -478.207,        553.856,        -474.607,       551.856);
    snowplowStops[99]   <-  snowplowStop( snowplowv3(-440.55,     613.078,    -4.23562),      -439.55,        614.678,        -441.55,         611.078);
    snowplowStops[100]   <-  snowplowStop( snowplowv3(-391.391,  635.126,  -10.376),   -392.991,  636.126,  -389.391,  634.126);
    snowplowStops[101]   <-  snowplowStop( snowplowv3(-391.257,  785.093,  -19.620),   -392.857,  786.093,  -389.257,  784.093);
    snowplowStops[102]   <-  snowplowStop( snowplowv3(-375.943,  800.877,  -19.977),  -374.943,  802.477,  -376.943,  798.877);
    snowplowStops[103]   <-  snowplowStop( snowplowv3(-254.001,  801.402,  -19.989),  -253.001,  803.002,  -255.001,  799.402);
    snowplowStops[104]   <-  snowplowStop( snowplowv3(-233.080,  775.812,  -19.991),  -235.080,  776.812,  -231.480,  774.812);
    snowplowStops[105]   <-  snowplowStop( snowplowv3(-233.188,  665.779,  -19.998),  -235.188,  666.779,  -231.588,  664.779);
    snowplowStops[106]   <-  snowplowStop( snowplowv3(-117.103,  635.933,  -19.876),  -116.103,  637.533,  -118.103,  633.933);
    snowplowStops[107]   <-  snowplowStop( snowplowv3(-85.113,  632.363,  -19.875),    -84.113,  633.963,  -86.113,  630.363);
    snowplowStops[108]   <-  snowplowStop( snowplowv3(19.086,  632.253,  -20.007),      20.086,  633.853,  18.086,  630.253);
    snowplowStops[109]   <-  snowplowStop( snowplowv3(39.495,  616.371,  -19.977),      37.495,  617.371,  41.095,  615.371);
    snowplowStops[110]   <-  snowplowStop( snowplowv3(40.260,  458.839,  -16.472),      38.260,  459.839,  41.860,  457.839);
    snowplowStops[111]   <-  snowplowStop( snowplowv3(9.396,  429.197,  -15.019),        8.396,  431.197,  10.396,  427.597);
    snowplowStops[112]   <-  snowplowStop( snowplowv3(-24.593,  393.616,  -13.822),    -26.593,  394.616,  -22.993,  392.616);
    snowplowStops[113]   <-  snowplowStop( snowplowv3(-7.684,  364.562,  -13.821),      -6.684,  366.162,  -8.684,  362.562);
    snowplowStops[114]   <-  snowplowStop( snowplowv3(25.823,  361.623,  -13.822),      26.823,  363.223,  24.823,  359.623);
    snowplowStops[115]   <-  snowplowStop( snowplowv3(40.420,  347.689,  -13.897),      38.420,  348.689,  42.020,  346.689);
    snowplowStops[116]   <-  snowplowStop( snowplowv3(43.181,  292.021,  -14.831),      41.181,  293.021,  44.781,  291.021);
    snowplowStops[117]   <-  snowplowStop( snowplowv3(43.204,  236.199,  -15.786),      41.204,  237.199,  44.804,  235.199);
    snowplowStops[118]   <-  snowplowStop( snowplowv3(73.080,  217.024,  -16.644),      74.080,  218.624,  72.080,  215.024);
    snowplowStops[119]   <-  snowplowStop( snowplowv3(162.483,  216.817,  -19.861),    163.483,  218.417,  161.483,  214.817);
    snowplowStops[120]   <-  snowplowStop( snowplowv3(242.347,  262.865,  -21.126),    243.347,  264.465,  241.347,  260.865);
    snowplowStops[121]   <-  snowplowStop( snowplowv3(270.795,  290.384,  -21.411),    269.195,  291.384,  272.795,  289.384);
    snowplowStops[122]   <-  snowplowStop( snowplowv3(273.901,  345.035,  -21.374),    272.301,  346.035,  275.901,  344.035);
    snowplowStops[123]   <-  snowplowStop( snowplowv3(273.377,  394.224,  -21.365),    271.777,  395.224,  275.377,  393.224);
    snowplowStops[124]   <-  snowplowStop( snowplowv3(272.898,  431.059,  -20.149),    271.298,  432.059,  274.898,  430.059);
    snowplowStops[125]   <-  snowplowStop( snowplowv3(292.780,  442.032,  -20.220),    293.780,  443.632,  291.780,  440.032);
    snowplowStops[126]   <-  snowplowStop( snowplowv3(326.995,  444.507,  -20.774),    327.995,  446.107,  325.995,  442.507);
    snowplowStops[127]   <-  snowplowStop( snowplowv3(429.566,  444.561,  -23.191),    430.566,  446.161,  428.566,  442.561);
    snowplowStops[128]   <-  snowplowStop( snowplowv3(446.324,  429.164,  -22.947),    444.324,  430.164,  447.924,  428.164);
    snowplowStops[129]   <-  snowplowStop( snowplowv3(446.399,  300.467,  -19.981),    444.399,  301.467,  447.999,  299.467);
    snowplowStops[130]   <-  snowplowStop( snowplowv3(446.435,  160.276,  -19.936),    444.435,  161.276,  448.035,  159.276);
    snowplowStops[131]   <-  snowplowStop( snowplowv3(407.410,  54.479,  -23.392),     406.410,  56.479,  408.410,  52.879);
    snowplowStops[132]   <-  snowplowStop( snowplowv3(358.631,  38.023,  -23.929),     356.631,  39.023,  360.231,  37.023);
    snowplowStops[133]   <-  snowplowStop( snowplowv3(336.941,  23.207,  -23.842),     335.941,  25.207,  337.941,  21.607);
    snowplowStops[134]   <-  snowplowStop( snowplowv3(280.963,  23.694,  -23.222),     279.963,  25.694,  281.963,  22.094);
    snowplowStops[135]   <-  snowplowStop( snowplowv3(261.505,  -0.058,  -22.607),     259.505,  0.942,  263.105,  -1.058);
    snowplowStops[136]   <-  snowplowStop( snowplowv3(261.999,  -145.503,  -12.035),   259.999,  -144.503,  263.599,  -146.503);
    snowplowStops[137]   <-  snowplowStop( snowplowv3(364.248,  -179.410,  -6.463),    365.248,  -177.810,  363.248,  -181.410);
    snowplowStops[138]   <-  snowplowStop( snowplowv3(417.531,  -155.612,  -7.046),    418.531,  -154.012,  416.531,  -157.612);
    snowplowStops[139]   <-  snowplowStop( snowplowv3(547.918,  -155.899,  -20.001),   548.918,  -154.299,  546.918,  -157.899);
    snowplowStops[140]   <-  snowplowStop( snowplowv3(564.354,  -182.311,  -19.998),   562.354,  -181.311,  565.954,  -183.311);
    snowplowStops[141]   <-  snowplowStop( snowplowv3(564.436,  -344.035,  -19.998),   562.436,  -343.035,  566.035,  -345.035);
    snowplowStops[142]   <-  snowplowStop( snowplowv3(537.142,  -390.023,  -19.997),   536.142,  -388.023,  538.142,  -391.623);
    snowplowStops[143]   <-  snowplowStop( snowplowv3(308.721,  -390.020,  -19.997),   307.721,  -388.020,  309.721,  -391.620);
    snowplowStops[144]   <-  snowplowStop( snowplowv3(292.701,  -376.173,  -19.998),   291.101,  -375.173,  294.701,  -377.173);
    snowplowStops[145]   <-  snowplowStop( snowplowv3(292.647,  -306.865,  -20.000),   291.047,  -305.865,  294.647,  -307.865);
    snowplowStops[146]   <-  snowplowStop( snowplowv3(261.981,  -285.424,  -19.998),   260.981,  -283.424,  262.981,  -287.024);
    snowplowStops[147]   <-  snowplowStop( snowplowv3(226.459,  -256.970,  -20.002),   224.859,  -255.970,  228.459,  -257.970);
    snowplowStops[148]   <-  snowplowStop( snowplowv3(187.497,  -143.292,  -20.001),   185.897,  -142.292,  189.497,  -144.292);
    snowplowStops[149]   <-  snowplowStop( snowplowv3(187.652,     3.577,  -20.001),   186.052,  4.577,  189.652,  2.577);
    snowplowStops[150]   <-  snowplowStop( snowplowv3(212.173,  110.113,  -19.184),    213.173,  111.713,  211.173,  108.113);
    snowplowStops[151]   <-  snowplowStop( snowplowv3(270.523,  173.542,  -21.800),    268.923,  174.542,  272.523,  172.542);
    snowplowStops[152]   <-  snowplowStop( snowplowv3(270.671,  251.638,  -22.224),    269.071,  252.638,  272.671,  250.638);
    snowplowStops[153]   <-  snowplowStop( snowplowv3(269.783,  423.642,  -20.444),    268.183,  424.642,  271.783,  422.642);
    snowplowStops[154]   <-  snowplowStop( snowplowv3(269.759,  602.345,  -24.400),    268.159,  603.345,  271.759,  601.345);
    snowplowStops[155]   <-  snowplowStop( snowplowv3(314.802,  621.124,  -24.506),    315.802,  622.724,  313.802,  619.124);
    snowplowStops[156]   <-  snowplowStop( snowplowv3(337.474,  660.299,  -24.645),    335.874,  661.299,  339.474,  659.299);
    snowplowStops[157]   <-  snowplowStop( snowplowv3(305.727,  692.520,  -24.690),    304.727,  694.520,  306.727,  690.920);
    snowplowStops[158]   <-  snowplowStop( snowplowv3(201.024,  692.698,  -22.601),    200.024,  694.698,  202.024,  691.098);
    snowplowStops[159]   <-  snowplowStop( snowplowv3(136.009,  659.358,  -18.550),    135.009,  661.358,  137.009,  657.758);
    snowplowStops[160]   <-  snowplowStop( snowplowv3(126.907,  710.699,  -16.429),    125.307,  711.699,  128.907,  709.699);
    snowplowStops[161]   <-  snowplowStop( snowplowv3(125.889,  801.956,  -19.503),    124.289,  802.956,  127.889,  800.956);
    snowplowStops[162]   <-  snowplowStop( snowplowv3(106.392,  826.151,  -20.030),    105.392,  828.151,  107.392,  824.551);
    snowplowStops[163]   <-  snowplowStop( snowplowv3(84.280,   830.551,  -21.605),     83.280,  832.551,  85.280,  828.951);
    snowplowStops[164]   <-  snowplowStop( snowplowv3(-18.241,  830.900,  -24.537),    -19.241,  832.900,  -17.241,  829.300);
    snowplowStops[165]   <-  snowplowStop( snowplowv3(-57.159,  826.369,  -24.269),    -58.159,  828.369,  -56.159,  824.769);
    snowplowStops[166]   <-  snowplowStop( snowplowv3(-148.337,  805.159,  -20.804),  -149.337,  807.159,  -147.337,  803.559);
    snowplowStops[167]   <-  snowplowStop( snowplowv3(-245.288,  804.506,  -19.988),  -246.288,  806.506,  -244.288,  802.906);
    snowplowStops[168]   <-  snowplowStop( snowplowv3(-376.600,  804.284,  -19.971),  -377.600,  806.284,  -375.600,  802.684);
    snowplowStops[169]   <-  snowplowStop( snowplowv3(-395.004,  782.633,  -19.474),  -397.004,  783.633,  -393.404,  781.633);
    snowplowStops[170]   <-  snowplowStop( snowplowv3(-395.326,  636.555,  -10.515),  -397.326,  637.555,  -393.726,  635.555);

    snowplowStops[171]   <-  snowplowStop( snowplowv3(-408.567,  618.420,   -9.935),    -409.567,  620.420,  -407.567,  616.820);
    snowplowStops[172]   <-  snowplowStop( snowplowv3(-467.227,  625.940,   0.853),    -468.227,  627.940,  -466.227,  624.340);
    snowplowStops[173]   <-  snowplowStop( snowplowv3(-551.210,  628.901,   3.396),    -552.210,  630.901,  -550.210,  627.301);
    snowplowStops[174]   <-  snowplowStop( snowplowv3(-825.024,  629.175,   18.815),   -826.024,  631.175,  -824.024,  627.575);
    snowplowStops[175]   <-  snowplowStop( snowplowv3(-1190.366,  629.182,   19.464),   -1191.366,  631.182,  -1189.366,  627.582);
    snowplowStops[176]   <-  snowplowStop( snowplowv3(-1447.902,  629.097,  -2.330),   -1448.902,  631.097,  -1446.902,  627.497);
    snowplowStops[177]   <-  snowplowStop( snowplowv3(-1583.056,  633.348,  -10.048),   -1584.056,  635.348,  -1582.056,  631.748);
    snowplowStops[178]   <-  snowplowStop( snowplowv3(-1602.409,  654.877,  -10.046),   -1604.009,  655.877,  -1600.409,  653.877);
    snowplowStops[179]   <-  snowplowStop( snowplowv3(-1586.415,  729.925,  -10.453),   -1585.415,  731.525,  -1587.415,  727.925);
    snowplowStops[180]   <-  snowplowStop( snowplowv3(-1433.917,  811.855,  -10.554),   -1432.917,  813.454,  -1434.917,  809.855);
    snowplowStops[181]   <-  snowplowStop( snowplowv3(-1393.709,  824.197,  -12.306),   -1395.309,  825.197,  -1391.709,  823.197);
    snowplowStops[182]   <-  snowplowStop( snowplowv3(-1347.240,  838.758,  -17.426),   -1346.240,  840.358,  -1348.240,  836.758);
    snowplowStops[183]   <-  snowplowStop( snowplowv3(-1326.986,  906.168,  -18.349),   -1328.586,  907.168,  -1324.986,  905.168);
    snowplowStops[184]   <-  snowplowStop( snowplowv3(-1326.859,  1079.251,  -18.356),   -1328.459,  1080.251,  -1324.859,  1078.251);
    snowplowStops[185]   <-  snowplowStop( snowplowv3(-1315.641,  1174.765,  -13.407),   -1314.641,  1176.365,  -1316.641,  1172.765);
    snowplowStops[186]   <-  snowplowStop( snowplowv3(-1194.965,  1231.632,  -13.410),   -1196.565,  1232.632,  -1192.965,  1230.632);
    snowplowStops[187]   <-  snowplowStop( snowplowv3(-1219.109,  1382.253,  -13.408),   -1220.109,  1384.253,  -1218.109,  1380.653);
    snowplowStops[188]   <-  snowplowStop( snowplowv3(-1292.285,  1422.554,  -10.683),   -1293.885,  1423.554,  -1290.285,  1421.554);
    snowplowStops[189]   <-  snowplowStop( snowplowv3(-1276.916,  1464.139,  -5.812),   -1275.916,  1465.739,  -1277.916,  1462.139);
    snowplowStops[190]   <-  snowplowStop( snowplowv3(-1194.391,  1464.496,  -4.441),   -1193.391,  1466.096,  -1195.391,  1462.496);
    snowplowStops[191]   <-  snowplowStop( snowplowv3(-1042.703,  1464.344,  -4.387),   -1041.703,  1465.944,  -1043.703,  1462.344);
    snowplowStops[192]   <-  snowplowStop( snowplowv3(-930.471,  1468.546,    -4.597),   -929.471,  1470.146,  -931.471,  1466.546);
    snowplowStops[193]   <-  snowplowStop( snowplowv3(-883.392,  1527.263,    0.812),   -884.992,  1528.263,  -881.392,  1526.263);
    snowplowStops[194]   <-  snowplowStop( snowplowv3(-895.983,  1570.502,    5.165),   -896.983,  1572.502,  -894.983,  1568.902);
    snowplowStops[195]   <-  snowplowStop( snowplowv3(-909.877,  1583.321,    5.222),   -911.477,  1584.321,  -907.877,  1582.321);
    snowplowStops[196]   <-  snowplowStop( snowplowv3(-1065.407,  1689.289,  10.744),   -1066.407,  1691.289,  -1064.407,  1687.689);
    snowplowStops[197]   <-  snowplowStop( snowplowv3(-1317.452,  1689.250,  10.694),   -1318.452,  1691.250,  -1316.452,  1687.650);
    snowplowStops[198]   <-  snowplowStop( snowplowv3(-1470.076,  1689.273,  5.394),   -1471.076,  1691.273,  -1469.076,  1687.673);
    snowplowStops[199]   <-  snowplowStop( snowplowv3(-1541.412,  1644.069,  -2.525),   -1543.412,  1645.069,  -1539.812,  1643.069);
    snowplowStops[200]   <-  snowplowStop( snowplowv3(-1563.766,  1571.859,  -5.987),   -1564.766,  1573.859,  -1562.766,  1570.259);
    snowplowStops[201]   <-  snowplowStop( snowplowv3(-1708.157,  1434.355,  -7.875),   -1710.157,  1435.355,  -1706.557,  1433.355);
    snowplowStops[202]   <-  snowplowStop( snowplowv3(-1757.814,  1395.608,  -4.665),   -1759.814,  1396.608,  -1756.214,  1394.608);
    snowplowStops[203]   <-  snowplowStop( snowplowv3(-1695.823,  1351.184,  -7.207),   -1697.823,  1352.184,  -1694.223,  1350.184);
    snowplowStops[204]   <-  snowplowStop( snowplowv3(-1743.688,  1300.341,  -4.179),   -1745.688,  1301.341,  -1742.088,  1299.341);
    snowplowStops[205]   <-  snowplowStop( snowplowv3(-1691.489,  1260.163,  -6.090),   -1693.489,  1261.163,  -1689.889,  1259.163);
    snowplowStops[206]   <-  snowplowStop( snowplowv3(-1741.398,  1214.971,  -3.328),   -1743.398,  1215.971,  -1739.798,  1213.971);
    snowplowStops[207]   <-  snowplowStop( snowplowv3(-1686.762,  1191.069,  -5.743),   -1688.762,  1192.069,  -1685.162,  1190.069);
    snowplowStops[208]   <-  snowplowStop( snowplowv3(-1580.460,  1129.214,  -8.009),   -1579.460,  1130.814,  -1581.460,  1127.214);
    snowplowStops[209]   <-  snowplowStop( snowplowv3(-1408.163,  1073.021,  -13.426),   -1410.163,  1074.021,  -1406.563,  1072.021);
    snowplowStops[210]   <-  snowplowStop( snowplowv3(-1436.701,  927.179,  -12.460),   -1437.701,  929.179,  -1435.701,  925.579);
    snowplowStops[211]   <-  snowplowStop( snowplowv3(-1618.478,  903.985,  -4.830),    -1620.478,  904.985,  -1616.878,  902.985);
    snowplowStops[212]   <-  snowplowStop( snowplowv3(-1615.556,  663.890,  -10.047),   -1617.556,  664.890,  -1613.956,  662.890);
    snowplowStops[213]   <-  snowplowStop( snowplowv3(-1586.061,  610.514,  -10.048),   -1585.061,  612.114,  -1587.061,  608.514);
    snowplowStops[214]   <-  snowplowStop( snowplowv3(-1171.069,  610.156,   20.306),   -1170.069,  611.756,  -1172.069,  608.156);
    snowplowStops[215]   <-  snowplowStop( snowplowv3(-903.011,  610.167,   21.003),    -902.011,  611.767,  -904.011,  608.167);
    snowplowStops[216]   <-  snowplowStop( snowplowv3(-571.990,  610.261,   4.876),     -570.990,  611.861,  -572.990,  608.261);
    snowplowStops[217]   <-  snowplowStop( snowplowv3(-433.815,  613.418,   -5.786),    -432.815,  615.018,  -434.815,  611.418);

    snowplowStops[218]   <-  snowplowStop( snowplowv3(-391.382,  641.204,  -10.820),  -392.982,  642.204,  -389.382,  640.204);
    snowplowStops[219]   <-  snowplowStop( snowplowv3(-391.165,  764.822,  -18.391),  -392.765,  765.822,  -389.165,  763.822);
    snowplowStops[220]   <-  snowplowStop( snowplowv3(-393.621,  900.013,  -19.839),  -394.621,  902.013,  -392.621,  898.413);
    snowplowStops[221]   <-  snowplowStop( snowplowv3(-424.919,  804.565,  -19.854),  -425.919,  806.565,  -423.919,  802.965);
    snowplowStops[222]   <-  snowplowStop( snowplowv3(-497.339,  888.792,  -19.018),  -498.939,  889.792,  -495.339,  887.792);
    snowplowStops[223]   <-  snowplowStop( snowplowv3(-390.525,  981.858,  -5.482),  -389.525,  983.458,  -391.525,  979.858);
    snowplowStops[224]   <-  snowplowStop( snowplowv3(-288.662,  1002.235,  5.301),  -290.262,  1003.235,  -286.662,  1001.235);
    snowplowStops[225]   <-  snowplowStop( snowplowv3(-448.666,  1025.644,  21.178),  -449.666,  1027.644,  -447.666,  1024.044);
    snowplowStops[226]   <-  snowplowStop( snowplowv3(-519.617,  1095.862,  30.996),  -521.217,  1096.862,  -517.617,  1094.862);
    snowplowStops[227]   <-  snowplowStop( snowplowv3(-429.757,  1250.582,  46.788),  -428.757,  1252.182,  -430.757,  1248.582);
    snowplowStops[228]   <-  snowplowStop( snowplowv3(-222.480,  1206.986,  53.198),  -224.480,  1207.986,  -220.880,  1205.986);
    snowplowStops[229]   <-  snowplowStop( snowplowv3(-476.072,  1148.105,  33.262),  -477.072,  1150.105,  -475.072,  1146.505);
    snowplowStops[230]   <-  snowplowStop( snowplowv3(-661.219,  1217.894,  23.177),  -662.819,  1218.894,  -659.219,  1216.894);
    snowplowStops[231]   <-  snowplowStop( snowplowv3(-504.521,  1314.679,  25.386),  -506.121,  1315.679,  -502.521,  1313.679);
    snowplowStops[232]   <-  snowplowStop( snowplowv3(-372.401,  1362.006,  40.277),  -371.401,  1363.606,  -373.401,  1360.006);
    snowplowStops[233]   <-  snowplowStop( snowplowv3(-284.469,  1267.526,  55.023),  -285.469,  1269.526,  -283.469,  1265.926);
    snowplowStops[234]   <-  snowplowStop( snowplowv3(-440.389,  1254.668,  45.773),  -441.389,  1256.668,  -439.389,  1253.068);
    snowplowStops[235]   <-  snowplowStop( snowplowv3(-468.143,  1141.499,  34.139),  -467.143,  1143.099,  -469.143,  1139.499);
    snowplowStops[236]   <-  snowplowStop( snowplowv3(-251.226,  1072.802,  48.836),  -252.826,  1073.802,  -249.226,  1071.802);
    snowplowStops[237]   <-  snowplowStop( snowplowv3(-190.795,  1258.566,  54.991),  -189.795,  1260.166,  -191.795,  1256.566);
    snowplowStops[238]   <-  snowplowStop( snowplowv3( 211.383,  1212.372,  62.299),  212.383,  1213.972,  210.383,  1210.372);
    snowplowStops[239]   <-  snowplowStop( snowplowv3( 286.673,  1244.599,  62.866),  285.073,  1245.599,  288.673,  1243.599);
    snowplowStops[240]   <-  snowplowStop( snowplowv3( 115.839,  1214.212,  64.614),  114.839,  1216.212,  116.839,  1212.612);
    snowplowStops[241]   <-  snowplowStop( snowplowv3(-193.076,  1262.575,  54.761),  -194.076,  1264.575,  -192.076,  1260.975);
    snowplowStops[242]   <-  snowplowStop( snowplowv3(-387.719,  1365.744,  38.777),  -388.719,  1367.744,  -386.719,  1364.144);
    snowplowStops[243]   <-  snowplowStop( snowplowv3(-504.530,  1320.329,  25.177),  -505.530,  1322.329,  -503.530,  1318.729);
    snowplowStops[244]   <-  snowplowStop( snowplowv3(-543.885,  1278.875,  22.120),  -544.885,  1280.875,  -542.885,  1277.275);
    snowplowStops[245]   <-  snowplowStop( snowplowv3(-562.949,  1148.872,  31.669),  -561.949,  1150.472,  -563.949,  1146.872);
    snowplowStops[246]   <-  snowplowStop( snowplowv3(-432.501,  1021.416,  19.831),  -431.501,  1023.016,  -433.501,  1019.416);
    snowplowStops[247]   <-  snowplowStop( snowplowv3(-398.115,  985.849,  -6.466),  -399.115,  987.849,  -397.115,  984.249);
    snowplowStops[248]   <-  snowplowStop( snowplowv3(-683.373,  919.209,  -18.752),  -684.373,  921.209,  -682.373,  917.609);
    snowplowStops[249]   <-  snowplowStop( snowplowv3(-685.079,  800.706,  -18.752),  -684.079,  802.306,  -686.079,  798.706);
    snowplowStops[250]   <-  snowplowStop( snowplowv3(-560.440,  915.430,  -18.902),  -559.440,  917.030,  -561.440,  913.430);
    snowplowStops[251]   <-  snowplowStop( snowplowv3(-501.113,  837.770,  -19.314),  -503.113,  838.770,  -499.513,  836.770);
    snowplowStops[252]   <-  snowplowStop( snowplowv3(-440.975,  800.683,  -19.747),  -439.975,  802.283,  -441.975,  798.683);
    snowplowStops[253]   <-  snowplowStop( snowplowv3(-395.368,  682.098,  -13.564),  -397.368,  683.098,  -393.768,  681.098);


  //routes[0] <- [zarplata, [stop1, stop2, stop3, ..., stop562]];
    routes[1] <- [7.4, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 0]];
    routes[2] <- [5.4,  [62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 0]];
    routes[3] <- [7.0, [100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 0]];
    routes[4] <- [8.2, [171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 0]];
    routes[5] <- [8.5, [218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 0]];


    //creating 3dtext for snowplow depot
    create3DText ( SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.35, "SNOW PLOWING COMPANY", CL_ROYALBLUE );
    create3DText ( SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.20, "Press E to action", CL_WHITE.applyAlpha(150), RADIUS_SNOWPLOW );

    registerPersonalJobBlip("snowplow", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y);

});


event("onPlayerConnect", function(playerid) {
    if ( ! (getPlayerName(playerid) in job_snowplow) ) {
     job_snowplow[getPlayerName(playerid)] <- {};
     job_snowplow[getPlayerName(playerid)]["route"] <- false;
     job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] <- [ null, null ];
     job_snowplow[getPlayerName(playerid)]["snowplowBlip"] <- null;
    }
});


event("onServerPlayerStarted", function( playerid ){

    if(isSnowplowDriver(playerid)) {
        if (getPlayerJobState(playerid) == "working") {
            local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][2][0];
            job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] = createPrivateSnowplowCheckpoint3DText(playerid, snowplowStops[snowplowID].coords);
            trigger(playerid, "setGPS", snowplowStops[snowplowID].coords.x, snowplowStops[snowplowID].coords.y);
            trigger(playerid, "hudDestroyTimer");
            msg( playerid, "job.snowplow.continuesnowplowstop", SNOWPLOW_JOB_COLOR );
        } else {
            msg( playerid, "job.snowplow.ifyouwantstart", SNOWPLOW_JOB_COLOR );
        }
        createText (playerid, "leavejob3dtext", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_SNOWPLOW_SMALL );
    }
});

event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
    if (!isPlayerVehicleSnowplow(playerid)) {
        return;
    }

    // skip check for non-drivers
    if (seat != 0) return;

    if(isSnowplowDriver(playerid) && getPlayerJobState(playerid) == "working") {
        unblockVehicle(vehicleid);
        repairVehicle(vehicleid);
        //delayedFunction(4500, function() {
            //snowplowJobReady(playerid);
        //});
    } else {
        blockVehicle(vehicleid);
    }
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (!isPlayerVehicleSnowplow(playerid)) {
        return;
    }

    // skip check for non-drivers
    if (seat != 0) return;

    blockVehicle(vehicleid);
});

event("onServerHourChange", function() {
    SNOWPLOW_ROUTE_NOW = SNOWPLOW_ROUTE_IN_HOUR + random(-2, 1);
});

function snowplowStop(a, b, c, d, e) {
    return {coords = a, x1 = b, y1 = c, x2 = d, y2 = e};
}

function snowplowv3(a, b, c) {
    return {x = a.tofloat(), y = b.tofloat(), z = c.tofloat() };
}


/**
 * Create private 3DTEXT for current snowplow stop
 * @param  {int}  playerid
 * @return {array} [idtext1, id3dtext2]
 */
function createPrivateSnowplowCheckpoint3DText(playerid, snowplowstop) {
    return [
        createText( playerid, "snowplow_3dtext", snowplowstop.x, snowplowstop.y, snowplowstop.z+0.20, SNOWPLOW_JOB_SNOWPLOWSTOP, CL_RIPELEMON, SNOWPLOW_JOB_DISTANCE )
    ];
}

/**
 * Remove private 3DTEXT AND BLIP for current snowplow stop
 * @param  {int}  playerid
 */
function snowplowJobRemovePrivateBlipText ( playerid ) {

}

/**
 * Check is player is a snowplow
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isSnowplowDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "snowplowdriver"));
}

/**
 * Check is player's vehicle is a snowplow truck
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleSnowplow(playerid) {
    return (isPlayerInValidVehicle(playerid, 39));
}

/**
Event: JOB - Snowplow driver - Already have job
*/
key("e", function(playerid) {

    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    if (getPlayerJob(playerid) && getPlayerJob(playerid) != SNOWPLOW_JOB_NAME) {
        return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), SNOWPLOW_JOB_COLOR );
    }
})



function snowplowJobGet( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    // если у игрока недостаточный уровень
    if(!isPlayerLevelValid ( playerid, SNOWPLOW_JOB_LEVEL )) {
        return msg(playerid, "job.snowplow.needlevel", SNOWPLOW_JOB_LEVEL, SNOWPLOW_JOB_COLOR );
    }

    local hour = getHour();
    if(hour < SNOWPLOW_JOB_GET_HOUR_START || hour >= SNOWPLOW_JOB_GET_HOUR_END) {
        return msg( playerid, "job.closed", [ SNOWPLOW_JOB_GET_HOUR_START.tostring(), SNOWPLOW_JOB_GET_HOUR_END.tostring()], SNOWPLOW_JOB_COLOR );
    }

    if (getPlayerName(playerid) in job_snowplow_blocked) {
        if (getTimestamp() - job_snowplow_blocked[getPlayerName(playerid)] < SNOWPLOW_JOB_TIMEOUT) {
            return msg( playerid, "job.snowplow.badworker", SNOWPLOW_JOB_COLOR);
        }
    }
    msg( playerid, "job.snowplow.driver.now", SNOWPLOW_JOB_COLOR );
    msg( playerid, "job.snowplow.driver.togetroute", CL_LYNCH );
    setPlayerJob( playerid, "snowplowdriver");
    setPlayerJobState( playerid, null);

    //snowplowJobStartRoute( playerid );
    createText (playerid, "leavejob3dtext", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_SNOWPLOW_SMALL );
}
addJobEvent("e", null,    null, snowplowJobGet);
addJobEvent("e", null, "nojob", snowplowJobGet);


/**
Event: JOB - Snowplow driver - Need complete
*/
function snowplowJobNeedComplete( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    msg( playerid, "job.snowplow.route.needcomplete", SNOWPLOW_JOB_COLOR );
}
addJobEvent("e", SNOWPLOW_JOB_NAME,  "working", snowplowJobNeedComplete);


/**
Event: JOB - Snowplow driver - Completed
*/
function snowplowJobCompleted( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    setPlayerJobState(playerid, null);
    snowplowGetSalary( playerid );
    job_snowplow[getPlayerName(playerid)]["route"] = false;
    jobRestorePlayerModel(playerid);
    return;
}
addJobEvent("e", SNOWPLOW_JOB_NAME,  "complete", snowplowJobCompleted);


/**
Event: JOB - Snowplow driver - Leave job
*/
function snowplowJobLeave( playerid ) {
    if(!isSnowplowDriver(playerid)) {
        return;
    }

    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW_SMALL)) {
        return;
    }

    local hour = getHour();
    if(hour < SNOWPLOW_JOB_LEAVE_HOUR_START || hour >= SNOWPLOW_JOB_LEAVE_HOUR_END) {
        return msg( playerid, "job.closed", [ SNOWPLOW_JOB_LEAVE_HOUR_START.tostring(), SNOWPLOW_JOB_LEAVE_HOUR_END.tostring()], SNOWPLOW_JOB_COLOR );
    }

    if(getPlayerJobState(playerid) == null) {
        msg( playerid, "job.snowplow.goodluck", SNOWPLOW_JOB_COLOR);
    }

    if(getPlayerJobState(playerid) == "working") {
        return msg( playerid, "job.snowplow.needCompleteToLeave", SNOWPLOW_JOB_COLOR );
    }

    if(getPlayerJobState(playerid) == "complete") {
        setPlayerJobState(playerid, null);
        snowplowGetSalary( playerid );
        job_snowplow[getPlayerName(playerid)]["route"] = false;
        msg( playerid, "job.snowplow.goodluck", SNOWPLOW_JOB_COLOR);
    }

    removeText(playerid, "leavejob3dtext");
    trigger(playerid, "removeGPS");

    setPlayerJob( playerid, null );

    msg( playerid, "job.leave", SNOWPLOW_JOB_COLOR );

    // remove private blip job
    removePersonalJobBlip ( playerid );

}
addJobEvent("q", SNOWPLOW_JOB_NAME,       null, snowplowJobLeave);
addJobEvent("q", SNOWPLOW_JOB_NAME,  "working", snowplowJobLeave);
addJobEvent("q", SNOWPLOW_JOB_NAME, "complete", snowplowJobLeave);


/**
Event: JOB - Snowplow driver - Get salary
*/
function snowplowGetSalary( playerid ) {
    local amount = job_snowplow[getPlayerName(playerid)]["route"][1];
    addMoneyToPlayer(playerid, amount);
    msg( playerid, "job.snowplow.nicejob", amount, SNOWPLOW_JOB_COLOR );
}

/**
Event: JOB - SNOWPLOW driver - Start route
*/
function snowplowJobStartRoute( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    local hour = getHour();
    if(hour < SNOWPLOW_JOB_WORKING_HOUR_START || hour >= SNOWPLOW_JOB_WORKING_HOUR_END) {
        return msg( playerid, "job.closed", [ SNOWPLOW_JOB_WORKING_HOUR_START.tostring(), SNOWPLOW_JOB_WORKING_HOUR_END.tostring()], SNOWPLOW_JOB_COLOR );
    }

    if(SNOWPLOW_ROUTE_NOW < 1) {
        return msg( playerid, "job.nojob", SNOWPLOW_JOB_COLOR );
    }

    setPlayerJobState( playerid, "working");
    jobSetPlayerModel( playerid, SNOWPLOW_JOB_SKIN );

    local rand = random(0, routes_list.len()-1);
    local route = routes_list[rand];
    routes_list.remove(rand);
    if(routes_list.len() == 0) routes_list = clone( routes_list_all );

    job_snowplow[getPlayerName(playerid)]["route"] <- [route, routes[route][0], clone routes[route][1]]; //create clone of route

    local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][2][0];

    msg( playerid, "job.snowplow.startroute" , SNOWPLOW_JOB_COLOR );
    msg( playerid, "job.snowplow.startroute2", SNOWPLOW_JOB_COLOR );
    job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] = createPrivateSnowplowCheckpoint3DText(playerid, snowplowStops[snowplowID].coords);

    createPrivatePlace(playerid, "snowplowZone", snowplowStops[snowplowID].x1, snowplowStops[snowplowID].y1, snowplowStops[snowplowID].x2, snowplowStops[snowplowID].y2);

    trigger(playerid, "setGPS", snowplowStops[snowplowID].coords.x, snowplowStops[snowplowID].coords.y);
}
addJobEvent("e", SNOWPLOW_JOB_NAME, null, snowplowJobStartRoute);



event("onPlayerPlaceEnter", function(playerid, name) {
    if (isSnowplowDriver(playerid) && isPlayerVehicleSnowplow(playerid) && getPlayerJobState(playerid) == "working") {
        if(name == "snowplowZone") {
            local vehicleid = getPlayerVehicle(playerid);
            local speed = getVehicleSpeed(vehicleid);
            local maxsp = max(fabs(speed[0]), fabs(speed[1]));
            if(maxsp > 14) return msg(playerid, "job.snowplow.driving", CL_RED);
 //msg(playerid, "#"+job_snowplow[getPlayerName(playerid)]["route"][2][0]);
            removePrivatePlace(playerid, "snowplowZone");
            removeText( playerid, "snowplow_3dtext");
            trigger(playerid, "removeGPS");
            job_snowplow[getPlayerName(playerid)]["route"][2].remove(0);
            if (job_snowplow[getPlayerName(playerid)]["route"][2].len() == 0) {

                blockVehicle(vehicleid);
                msg( playerid, "job.snowplow.gototakemoney", SNOWPLOW_JOB_COLOR );
                setPlayerJobState(playerid, "complete");
                return;
            }
            local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][2][0];
            trigger(playerid, "setGPS", snowplowStops[snowplowID].coords.x, snowplowStops[snowplowID].coords.y);
            job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] = createPrivateSnowplowCheckpoint3DText(playerid, snowplowStops[snowplowID].coords);
            createPrivatePlace(playerid, "snowplowZone", snowplowStops[snowplowID].x1, snowplowStops[snowplowID].y1, snowplowStops[snowplowID].x2, snowplowStops[snowplowID].y2);
        }
    }
});


event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (isSnowplowDriver(playerid) && getVehicleModel(vehicleid) == 39 && getPlayerJobState(playerid) == "complete") {
        delayedFunction(6000, function () {
            tryRespawnVehicleById(vehicleid, true);
        });
    }
});


function getNearestSnowplowStationForPlayer(playerid) {
    local pos = getPlayerPositionObj( playerid );
    local dis = 5;
    local snowplowStopid = null;
    foreach (key, value in snowplowStops) {
        local distance = getDistanceBetweenPoints3D( pos.x, pos.y, pos.z, value.public.x, value.public.y, value.public.z );
        if (distance < dis) {
           dis = distance;
           snowplowStopid = key;
        }
    }
    return snowplowStopid;
}

acmd("snow", "setroutesall", function(playerid, ...) {
    if (!vargv.len()) msg(playerid, "Need to write numbers of snowplower routes separated by space.");

    routes_list_all = [];
    foreach (idx, value in vargv) {
        routes_list_all.push(value.tointeger());
    }
    routes_list = clone (routes_list_all);
    msg(playerid, "New list of snowplower routes: "+concat(routes_list_all) );
});


acmd("snow", "getroutes", function(playerid) {
    msg(playerid, "List of available snowplower routes: "+concat(routes_list) );
});

acmd("snow", "getroutesall", function(playerid) {
    msg(playerid, "List of all snowplower routes: "+concat(routes_list_all) );
});
