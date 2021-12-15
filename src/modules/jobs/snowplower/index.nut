include("modules/jobs/snowplower/commands.nut");
include("modules/jobs/snowplower/translations.nut");

/*
local count = 0;

key("n", function(playerid) {
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

    dbg( "snowplowv3( " + format("%.3f", round(vehPos[0], 3)) +",  "+    format("%.3f", round(vehPos[1], 3)) +",  "+   format("%.3f", round(vehPos[2], 3)) +" ), "+   format("%.3f", round(x1, 3))  +",  "+   format("%.3f", round(y1, 3))   +",  "+  format("%.3f", round(x2, 3))   +",  "+  format("%.3f", round(y2, 3)) + " ); ");
    msg(playerid, "Place has been created.", CL_SUCCESS );
    createPlace("snowPlace"+count, x1, y1, x2, y2);
    count += 1;
});
*/

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

local routes_list_all = [ 1, 2, 3, 4, 5, 6, 7 ];
local routes_list = clone( routes_list_all );


event("onServerStarted", function() {
    logStr("[jobs] loading snowplow job...");

    createVehicle(39, -372.233, 593.342, -9.96686, -89.1468, 1.52338, 0.0686706);
    createVehicle(39, -374.524, 589.011, -9.96381, -56.7532, 1.17279, 0.934235);
    createVehicle(39, -380.797, 588.42, -9.95933, -56.3861, 1.20405, 0.900966);

  //snowplowStops[0]   <-                                         vehPos                         x1         y1           x2          y2
    snowplowStops[0]   <-  snowplowStop( snowplowv3( -380.799,    593.685,      -9.966),     -379.799,    595.285,    -381.799,    591.685);

    // Route 1
    snowplowStops[1]   <-  snowplowStop( snowplowv3( -417.715,  587.210,  -9.966 ),      -418.715,  589.210,  -416.715,  585.610);  // первая точка налево вверх (не к мосту)
    snowplowStops[2]   <-  snowplowStop( snowplowv3( -470.229,  587.062,  -7.843 ),      -471.229,  589.062,  -469.229,  585.462);  // вторая точка налево вверх (не к мосту)
    snowplowStops[3]   <-  snowplowStop( snowplowv3( -523.579,  586.835,  -5.166 ),      -524.579,  588.835,  -522.579,  585.235);
    snowplowStops[4]   <-  snowplowStop( snowplowv3( -575.882,  586.884,  -2.396 ),      -576.882,  588.884,  -574.882,  585.284);
    snowplowStops[5]   <-  snowplowStop( snowplowv3( -649.879,  587.195,  1.201 ),      -650.879,  589.195,  -648.879,  585.595);
    snowplowStops[6]   <-  snowplowStop( snowplowv3( -673.944,  565.359,  1.190 ),      -675.944,  566.359,  -672.344,  564.359);
    snowplowStops[7]   <-  snowplowStop( snowplowv3( -674.191,  525.957,  1.198 ),      -676.191,  526.957,  -672.591,  524.957);
    snowplowStops[8]   <-  snowplowStop( snowplowv3( -674.372,  467.027,  1.200 ),      -676.372,  468.027,  -672.772,  466.027);
    snowplowStops[9]   <-  snowplowStop( snowplowv3( -653.736,  445.228,  1.194 ),      -652.736,  446.828,  -654.736,  443.228);
    snowplowStops[10]   <-  snowplowStop( snowplowv3( -604.320,  445.083,  1.200 ),      -603.320,  446.683,  -605.320,  443.083);
    snowplowStops[11]   <-  snowplowStop( snowplowv3( -566.473,  445.225,  1.203 ),      -565.473,  446.825,  -567.473,  443.225);
    snowplowStops[12]   <-  snowplowStop( snowplowv3( -483.208,  425.666,  1.130 ),      -482.208,  427.266,  -484.208,  423.666);
    snowplowStops[13]   <-  snowplowStop( snowplowv3( -467.987,  395.075,  1.199 ),      -469.987,  396.075,  -466.387,  394.075);
    snowplowStops[14]   <-  snowplowStop( snowplowv3( -468.046,  354.380,  1.200 ),      -470.046,  355.380,  -466.446,  353.380);
    snowplowStops[15]   <-  snowplowStop( snowplowv3( -463.646,  319.628,  1.206 ),      -465.646,  320.628,  -462.046,  318.628);
    snowplowStops[16]   <-  snowplowStop( snowplowv3( -463.928,  291.804,  1.201 ),      -465.928,  292.804,  -462.328,  290.804);
    snowplowStops[17]   <-  snowplowStop( snowplowv3( -435.164,  269.656,  1.279 ),      -434.164,  271.256,  -436.164,  267.656);
    snowplowStops[18]   <-  snowplowStop( snowplowv3( -391.031,  268.169,  1.879 ),      -390.031,  269.769,  -392.031,  266.169);
    snowplowStops[19]   <-  snowplowStop( snowplowv3( -336.967,  267.348,  2.225 ),      -335.967,  268.948,  -337.967,  265.348);
    snowplowStops[20]   <-  snowplowStop( snowplowv3( -292.101,  267.806,  2.255 ),      -291.101,  269.406,  -293.101,  265.806);
    snowplowStops[21]   <-  snowplowStop( snowplowv3( -227.516,  286.845,  -6.001 ),     -226.516,  288.445,  -228.516,  284.845);
    snowplowStops[22]   <-  snowplowStop( snowplowv3( -215.476,  273.079,  -6.244 ),     -217.476,  274.079,  -213.876,  272.079);
    snowplowStops[23]   <-  snowplowStop( snowplowv3( -215.704,  212.836,  -8.792 ),     -217.704,  213.836,  -214.104,  211.836);
    snowplowStops[24]   <-  snowplowStop( snowplowv3( -215.554,  145.309,  -10.395 ),     -217.554,  146.309,  -213.954,  144.309);
    snowplowStops[25]   <-  snowplowStop( snowplowv3( -215.499,  70.519,  -11.108 ),     -217.499,  71.519,  -213.899,  69.519);
    snowplowStops[26]   <-  snowplowStop( snowplowv3( -209.033,  -4.605,  -11.822 ),     -211.033,  -3.605,  -207.433,  -5.605);
    snowplowStops[27]   <-  snowplowStop( snowplowv3( -225.178,  -21.337,  -11.728 ),     -226.178,  -19.337,  -224.178,  -22.937);
    snowplowStops[28]   <-  snowplowStop( snowplowv3( -275.607,  -21.182,  -9.527 ),     -276.607,  -19.182,  -274.607,  -22.782);
    snowplowStops[29]   <-  snowplowStop( snowplowv3( -344.584,  -21.453,  -5.208 ),     -345.584,  -19.453,  -343.584,  -23.053);
    snowplowStops[30]   <-  snowplowStop( snowplowv3( -367.005,  -43.651,  -5.566 ),     -369.005,  -42.651,  -365.405,  -44.651);
    snowplowStops[31]   <-  snowplowStop( snowplowv3( -367.135,  -90.450,  -9.585 ),     -369.135,  -89.450,  -365.535,  -91.450);
    snowplowStops[32]   <-  snowplowStop( snowplowv3( -345.733,  -113.779,  -10.163 ),   -344.733,  -112.179,  -346.733,  -115.779);
    snowplowStops[33]   <-  snowplowStop( snowplowv3( -298.513,  -113.907,  -10.778 ),   -297.513,  -112.307,  -299.513,  -115.907);
    snowplowStops[34]   <-  snowplowStop( snowplowv3( -219.655,  -113.869,  -11.803 ),   -218.655,  -112.269,  -220.655,  -115.869);
    snowplowStops[35]   <-  snowplowStop( snowplowv3( -196.987,  -91.494,  -11.872 ),   -198.587,  -90.494,  -194.987,  -92.494);
    snowplowStops[36]   <-  snowplowStop( snowplowv3( -194.103,  -42.543,  -11.874 ),   -195.703,  -41.543,  -192.103,  -43.543);
    snowplowStops[37]   <-  snowplowStop( snowplowv3( -175.427,  -22.316,  -11.875 ),   -174.427,  -20.716,  -176.427,  -24.316);
    snowplowStops[38]   <-  snowplowStop( snowplowv3( -128.438,  -22.519,  -12.431 ),   -127.438,  -20.919,  -129.438,  -24.519);
    snowplowStops[39]   <-  snowplowStop( snowplowv3( -71.271,  -22.590,  -14.261 ),    -70.271,  -20.990,  -72.271,  -24.590);
    snowplowStops[40]   <-  snowplowStop( snowplowv3( -57.253,  -38.865,  -14.286 ),    -59.253,  -37.865,  -55.653,  -39.865);
    snowplowStops[41]   <-  snowplowStop( snowplowv3( -57.150,  -92.070,  -14.279 ),    -59.150,  -91.070,  -55.550,  -93.070);
    snowplowStops[42]   <-  snowplowStop( snowplowv3( -57.881,  -131.854,  -14.273 ),    -59.881,  -130.854,  -56.281,  -132.854);
    snowplowStops[43]   <-  snowplowStop( snowplowv3( -60.700,  -164.161,  -14.276 ),    -62.700,  -163.161,  -59.100,  -165.161);
    snowplowStops[44]   <-  snowplowStop( snowplowv3( -60.585,  -196.946,  -14.276 ),    -62.585,  -195.946,  -58.985,  -197.946);
    snowplowStops[45]   <-  snowplowStop( snowplowv3( -78.162,  -212.449,  -14.103 ),    -79.162,  -210.449,  -77.162,  -214.049);
    snowplowStops[46]   <-  snowplowStop( snowplowv3( -121.652,  -212.332,  -13.115 ),  -122.652,  -210.332,  -120.652,  -213.932);
    snowplowStops[47]   <-  snowplowStop( snowplowv3( -181.825,  -212.276,  -11.921 ),  -182.825,  -210.276,  -180.825,  -213.876);
    snowplowStops[48]   <-  snowplowStop( snowplowv3( -201.982,  -232.748,  -12.158 ),  -203.982,  -231.748,  -200.382,  -233.748);
    snowplowStops[49]   <-  snowplowStop( snowplowv3( -204.807,  -275.678,  -15.323 ),  -206.807,  -274.678,  -203.207,  -276.678);
    snowplowStops[50]   <-  snowplowStop( snowplowv3( -218.264,  -293.618,  -15.742 ),  -219.264,  -291.618,  -217.264,  -295.218);
    snowplowStops[51]   <-  snowplowStop( snowplowv3( -273.220,  -293.195,  -14.419 ),  -274.220,  -291.195,  -272.220,  -294.795);
    snowplowStops[52]   <-  snowplowStop( snowplowv3( -346.228,  -293.412,  -12.663 ),  -347.228,  -291.412,  -345.228,  -295.012);
    snowplowStops[53]   <-  snowplowStop( snowplowv3( -359.455,  -277.726,  -12.349 ),  -361.055,  -276.726,  -357.455,  -278.726);
    snowplowStops[54]   <-  snowplowStop( snowplowv3( -362.453,  -232.831,  -10.278 ),  -364.053,  -231.831,  -360.453,  -233.831);
    snowplowStops[55]   <-  snowplowStop( snowplowv3( -381.241,  -211.858,  -10.057 ),  -382.241,  -209.858,  -380.241,  -213.458);
    snowplowStops[56]   <-  snowplowStop( snowplowv3( -421.273,  -211.700,  -8.444 ),   -422.273,  -209.700,  -420.273,  -213.300);
    snowplowStops[57]   <-  snowplowStop( snowplowv3( -465.363,  -208.964,  -6.648 ),   -466.363,  -206.964,  -464.363,  -210.564);
    snowplowStops[58]   <-  snowplowStop( snowplowv3( -515.447,  -208.942,  -4.626 ),   -516.447,  -206.942,  -514.447,  -210.542);
    snowplowStops[59]   <-  snowplowStop( snowplowv3( -529.616,  -196.880,  -4.406 ),   -531.216,  -195.880,  -527.616,  -197.880);
    snowplowStops[60]   <-  snowplowStop( snowplowv3( -541.203,  -157.930,  -1.840 ),   -542.803,  -156.930,  -539.203,  -158.930);
    snowplowStops[61]   <-  snowplowStop( snowplowv3( -547.692,  -125.759,  0.050 ),    -549.292,  -124.759,  -545.692,  -126.759);
    snowplowStops[62]   <-  snowplowStop( snowplowv3( -547.180,  -87.667,  0.828 ),     -548.780,  -86.667,  -545.180,  -88.667);
    snowplowStops[63]   <-  snowplowStop( snowplowv3( -567.413,  -67.492,  1.202 ),     -568.413,  -65.492,  -566.413,  -69.092);
    snowplowStops[64]   <-  snowplowStop( snowplowv3( -614.935,  -67.108,  1.203 ),     -615.935,  -65.108,  -613.935,  -68.708);
    snowplowStops[65]   <-  snowplowStop( snowplowv3( -655.166,  -67.121,  1.194 ),     -656.166,  -65.121,  -654.166,  -68.721);
    snowplowStops[66]   <-  snowplowStop( snowplowv3( -670.185,  -50.157,  1.196 ),     -671.785,  -49.157,  -668.185,  -51.157);
    snowplowStops[67]   <-  snowplowStop( snowplowv3( -670.162,  -1.630,  1.198 ),      -671.762,  -0.630,  -668.162,  -2.630);
    snowplowStops[68]   <-  snowplowStop( snowplowv3( -669.954,  54.183,  1.200 ),      -671.554,  55.183,  -667.954,  53.183);
    snowplowStops[69]   <-  snowplowStop( snowplowv3( -669.963,  110.485,  1.201 ),     -671.563,  111.485,  -667.963,  109.485);
    snowplowStops[70]   <-  snowplowStop( snowplowv3( -670.152,  163.118,  1.202 ),     -671.752,  164.118,  -668.152,  162.118);
    snowplowStops[71]   <-  snowplowStop( snowplowv3( -670.081,  254.499,  0.055 ),     -671.681,  255.499,  -668.081,  253.499);
    snowplowStops[72]   <-  snowplowStop( snowplowv3( -655.069,  271.083,  -0.064 ),    -654.069,  272.683,  -656.069,  269.083);
    snowplowStops[73]   <-  snowplowStop( snowplowv3( -607.492,  270.960,  -0.103 ),    -606.492,  272.560,  -608.492,  268.960);
    snowplowStops[74]   <-  snowplowStop( snowplowv3( -565.221,  270.723,  -0.145 ),    -564.221,  272.323,  -566.221,  268.723);
    snowplowStops[75]   <-  snowplowStop( snowplowv3( -549.691,  255.168,  -0.020 ),    -551.691,  256.168,  -548.091,  254.168);
    snowplowStops[76]   <-  snowplowStop( snowplowv3( -549.504,  218.866,  0.788 ),     -551.504,  219.866,  -547.904,  217.866);
    snowplowStops[77]   <-  snowplowStop( snowplowv3( -549.627,  187.741,  1.485 ),     -551.627,  188.741,  -548.027,  186.741);
    snowplowStops[78]   <-  snowplowStop( snowplowv3( -549.615,  151.127,  1.099 ),     -551.615,  152.127,  -548.015,  150.127);
    snowplowStops[79]   <-  snowplowStop( snowplowv3( -549.542,  96.732,  -0.379 ),     -551.542,  97.732,  -547.942,  95.732);
    snowplowStops[80]   <-  snowplowStop( snowplowv3( -535.960,  77.786,  -0.575 ),     -534.960,  79.386,  -536.960,  75.786);
    snowplowStops[81]   <-  snowplowStop( snowplowv3( -484.133,  76.857,  -0.944 ),     -483.133,  78.457,  -485.133,  74.857);
    snowplowStops[82]   <-  snowplowStop( snowplowv3( -454.905,  94.572,  -0.881 ),     -456.505,  95.572,  -452.905,  93.572);
    snowplowStops[83]   <-  snowplowStop( snowplowv3( -450.486,  144.047,  0.524 ),     -452.086,  145.047,  -448.486,  143.047);
    snowplowStops[84]   <-  snowplowStop( snowplowv3( -450.243,  189.349,  1.201 ),     -451.843,  190.349,  -448.243,  188.349);
    snowplowStops[85]   <-  snowplowStop( snowplowv3( -450.191,  251.104,  1.203 ),     -451.791,  252.104,  -448.191,  250.104);
    snowplowStops[86]   <-  snowplowStop( snowplowv3( -450.214,  295.023,  1.202 ),     -451.814,  296.023,  -448.214,  294.023);
    snowplowStops[87]   <-  snowplowStop( snowplowv3( -454.941,  351.221,  1.201 ),     -456.541,  352.221,  -452.941,  350.221);
    snowplowStops[88]   <-  snowplowStop( snowplowv3( -483.686,  373.149,  1.202 ),     -484.686,  375.149,  -482.686,  371.549);
    snowplowStops[89]   <-  snowplowStop( snowplowv3( -534.336,  372.975,  1.204 ),     -535.336,  374.975,  -533.336,  371.375);
    snowplowStops[90]   <-  snowplowStop( snowplowv3( -549.329,  353.008,  1.079 ),     -551.329,  354.008,  -547.729,  352.008);
    snowplowStops[91]   <-  snowplowStop( snowplowv3( -549.509,  291.924,  -0.017 ),    -551.509,  292.924,  -547.909,  290.924);
    snowplowStops[92]   <-  snowplowStop( snowplowv3( -533.479,  270.826,  0.020 ),    -532.479,  272.426,  -534.479,  268.826);
    snowplowStops[93]   <-  snowplowStop( snowplowv3( -484.149,  270.626,  1.060 ),    -483.149,  272.226,  -485.149,  268.626);
    snowplowStops[94]   <-  snowplowStop( snowplowv3( -455.008,  289.924,  1.200 ),    -456.608,  290.924,  -453.008,  288.924);
    snowplowStops[95]   <-  snowplowStop( snowplowv3( -450.290,  338.848,  1.201 ),    -451.890,  339.848,  -448.290,  337.848);
    snowplowStops[96]   <-  snowplowStop( snowplowv3( -450.515,  389.914,  1.200 ),    -452.115,  390.914,  -448.515,  388.914);
    snowplowStops[97]   <-  snowplowStop( snowplowv3( -452.410,  441.507,  1.202 ),    -454.010,  442.507,  -450.410,  440.507);
    snowplowStops[98]   <-  snowplowStop( snowplowv3( -461.629,  498.527,  1.203 ),    -463.229,  499.527,  -459.629,  497.527);
    snowplowStops[99]   <-  snowplowStop( snowplowv3( -473.857,  540.121,  1.198 ),    -475.457,  541.121,  -471.857,  539.121);  // сразу после автобусов
    snowplowStops[100]   <-  snowplowStop( snowplowv3( -482.704,  595.720,  1.201 ),    -484.304,  596.720,  -480.704,  594.720); // перед поворотом направо
    snowplowStops[101]   <-  snowplowStop( snowplowv3( -463.792,  613.145,  0.481 ),    -462.792,  614.745,  -464.792,  611.145); // после поворота направо
    snowplowStops[102]   <-  snowplowStop( snowplowv3( -410.722,  613.360,  -9.773 ),   -409.722,  614.960,  -411.722,  611.360); // в самом низу спуска перед финишем

    // Route 2
    snowplowStops[103]   <-  snowplowStop( snowplowv3( -391.231,  600.650,  -10.105 ), -392.831,  601.650,  -389.231,  599.650); // выезд из депо
    snowplowStops[104]   <-  snowplowStop( snowplowv3( -409.713,  618.913,  -9.862 ), -410.713,  620.913,  -408.713,  617.313);  // подъём вверх сразу после поворота налево
    snowplowStops[105]   <-  snowplowStop( snowplowv3( -465.000,  626.097,  0.634 ), -466.000,  628.097,  -464.000,  624.497);   // на горе при повороте направо в сторону дороги на сауспорт
    snowplowStops[106]   <-  snowplowStop( snowplowv3( -482.750,  647.098,  1.243 ), -484.350,  648.098,  -480.750,  646.098);
    snowplowStops[107]   <-  snowplowStop( snowplowv3( -527.588,  695.417,  2.578 ), -528.588,  697.417,  -526.588,  693.817);
    snowplowStops[108]   <-  snowplowStop( snowplowv3( -538.375,  707.673,  2.782 ), -539.975,  708.673,  -536.375,  706.673);
    snowplowStops[109]   <-  snowplowStop( snowplowv3( -573.311,  733.975,  -0.993 ), -574.311,  735.975,  -572.311,  732.376);
    snowplowStops[110]   <-  snowplowStop( snowplowv3( -639.793,  733.968,  -10.075 ), -640.793,  735.968,  -638.793,  732.369);
    snowplowStops[111]   <-  snowplowStop( snowplowv3( -684.669,  734.041,  -12.589 ), -685.669,  736.041,  -683.669,  732.441);
    snowplowStops[112]   <-  snowplowStop( snowplowv3( -728.069,  734.068,  -16.880 ), -729.069,  736.068,  -727.069,  732.468); // до поворота на М-отель
    snowplowStops[113]   <-  snowplowStop( snowplowv3( -744.957,  713.429,  -17.131 ), -746.957,  714.429,  -743.357,  712.429);
    snowplowStops[114]   <-  snowplowStop( snowplowv3( -745.092,  669.362,  -17.661 ), -747.092,  670.362,  -743.492,  668.362);
    snowplowStops[115]   <-  snowplowStop( snowplowv3( -740.005,  610.043,  -19.041 ), -742.005,  611.043,  -738.405,  609.043);
    snowplowStops[116]   <-  snowplowStop( snowplowv3( -739.338,  527.208,  -20.103 ), -741.338,  528.208,  -737.738,  526.208);
    snowplowStops[117]   <-  snowplowStop( snowplowv3( -739.362,  450.697,  -20.105 ), -741.362,  451.697,  -737.762,  449.697);
    snowplowStops[118]   <-  snowplowStop( snowplowv3( -739.516,  384.249,  -20.101 ), -741.516,  385.249,  -737.916,  383.249);
    snowplowStops[119]   <-  snowplowStop( snowplowv3( -739.429,  305.521,  -20.101 ), -741.429,  306.521,  -737.829,  304.521);
    snowplowStops[120]   <-  snowplowStop( snowplowv3( -739.457,  219.941,  -20.101 ), -741.457,  220.941,  -737.857,  218.941);
    snowplowStops[121]   <-  snowplowStop( snowplowv3( -739.379,  149.694,  -20.101 ), -741.379,  150.694,  -737.779,  148.694);
    snowplowStops[122]   <-  snowplowStop( snowplowv3( -739.644,  76.143,  -20.100 ), -741.644,  77.143,  -738.044,  75.143);
    snowplowStops[123]   <-  snowplowStop( snowplowv3( -739.422,  7.261,  -20.101 ), -741.422,  8.261,  -737.822,  6.261);
    snowplowStops[124]   <-  snowplowStop( snowplowv3( -739.502,  -71.991,  -20.101 ), -741.502,  -70.991,  -737.902,  -72.991);
    snowplowStops[125]   <-  snowplowStop( snowplowv3( -739.493,  -144.384,  -20.101 ), -741.493,  -143.384,  -737.893,  -145.384);
    snowplowStops[126]   <-  snowplowStop( snowplowv3( -739.658,  -217.215,  -20.100 ), -741.658,  -216.215,  -738.058,  -218.215);
    snowplowStops[127]   <-  snowplowStop( snowplowv3( -745.101,  -296.930,  -20.093 ), -747.101,  -295.930,  -743.501,  -297.930);
    snowplowStops[128]   <-  snowplowStop( snowplowv3( -755.195,  -361.758,  -20.078 ), -757.195,  -360.758,  -753.595,  -362.758);
    snowplowStops[129]   <-  snowplowStop( snowplowv3( -755.765,  -449.953,  -22.601 ), -757.765,  -448.953,  -754.165,  -450.953);
    snowplowStops[130]   <-  snowplowStop( snowplowv3( -742.268,  -469.797,  -22.721 ), -741.268,  -468.197,  -743.268,  -471.797);
    snowplowStops[131]   <-  snowplowStop( snowplowv3( -701.425,  -469.961,  -22.098 ), -700.425,  -468.361,  -702.425,  -471.961);
    snowplowStops[132]   <-  snowplowStop( snowplowv3( -635.889,  -469.877,  -20.018 ), -634.889,  -468.277,  -636.889,  -471.877);
    snowplowStops[133]   <-  snowplowStop( snowplowv3( -586.118,  -469.995,  -20.016 ), -585.118,  -468.395,  -587.118,  -471.995);
    snowplowStops[134]   <-  snowplowStop( snowplowv3( -543.482,  -469.800,  -19.988 ), -542.482,  -468.200,  -544.482,  -471.800);
    snowplowStops[135]   <-  snowplowStop( snowplowv3( -495.921,  -472.794,  -19.993 ), -494.921,  -471.194,  -496.921,  -474.794);
    snowplowStops[136]   <-  snowplowStop( snowplowv3( -421.049,  -472.705,  -18.071 ), -420.049,  -471.105,  -422.049,  -474.705);
    snowplowStops[137]   <-  snowplowStop( snowplowv3( -407.382,  -486.329,  -17.960 ), -409.382,  -485.329,  -405.782,  -487.329);
    snowplowStops[138]   <-  snowplowStop( snowplowv3( -407.348,  -533.812,  -18.904 ), -409.348,  -532.812,  -405.748,  -534.812);
    snowplowStops[139]   <-  snowplowStop( snowplowv3( -404.656,  -583.688,  -19.890 ), -406.656,  -582.688,  -403.056,  -584.688);
    snowplowStops[140]   <-  snowplowStop( snowplowv3( -386.590,  -606.859,  -20.000 ), -385.590,  -605.259,  -387.590,  -608.859);
    snowplowStops[141]   <-  snowplowStop( snowplowv3( -326.051,  -606.880,  -20.000 ), -325.051,  -605.280,  -327.051,  -608.880);
    snowplowStops[142]   <-  snowplowStop( snowplowv3( -253.994,  -606.861,  -20.000 ), -252.994,  -605.261,  -254.994,  -608.861);
    snowplowStops[143]   <-  snowplowStop( snowplowv3( -188.598,  -607.019,  -20.000 ), -187.598,  -605.419,  -189.598,  -609.019);
    snowplowStops[144]   <-  snowplowStop( snowplowv3( -121.891,  -607.258,  -20.001 ), -120.891,  -605.658,  -122.891,  -609.258);
    snowplowStops[145]   <-  snowplowStop( snowplowv3( -104.432,  -590.581,  -19.910 ), -106.032,  -589.581,  -102.432,  -591.581);
    snowplowStops[146]   <-  snowplowStop( snowplowv3( -104.517,  -542.616,  -17.886 ), -106.117,  -541.616,  -102.517,  -543.616);
    snowplowStops[147]   <-  snowplowStop( snowplowv3( -104.330,  -482.837,  -14.932 ), -105.930,  -481.837,  -102.330,  -483.837);
    snowplowStops[148]   <-  snowplowStop( snowplowv3( -86.992,  -469.310,  -14.998 ), -85.992,  -467.710,  -87.992,  -471.310);
    snowplowStops[149]   <-  snowplowStop( snowplowv3( -31.310,  -469.802,  -16.514 ), -30.310,  -468.202,  -32.310,  -471.802);
    snowplowStops[150]   <-  snowplowStop( snowplowv3( 41.642,  -469.937,  -19.649 ), 42.642,  -468.337,  40.642,  -471.937);
    snowplowStops[151]   <-  snowplowStop( snowplowv3( 84.744,  -469.882,  -20.786 ), 85.744,  -468.282,  83.744,  -471.882);
    snowplowStops[152]   <-  snowplowStop( snowplowv3( 143.643,  -469.987,  -20.262 ), 144.643,  -468.387,  142.643,  -471.987);
    snowplowStops[153]   <-  snowplowStop( snowplowv3( 159.303,  -453.109,  -19.992 ), 157.703,  -452.109,  161.303,  -454.109);
    snowplowStops[154]   <-  snowplowStop( snowplowv3( 159.740,  -412.181,  -19.989 ), 158.140,  -411.181,  161.740,  -413.181);
    snowplowStops[155]   <-  snowplowStop( snowplowv3( 167.951,  -399.834,  -19.997 ), 168.951,  -398.234,  166.951,  -401.834);
    snowplowStops[156]   <-  snowplowStop( snowplowv3( 208.336,  -399.602,  -19.860 ), 209.336,  -398.002,  207.336,  -401.602);
    snowplowStops[157]   <-  snowplowStop( snowplowv3( 275.660,  -399.586,  -19.999 ), 276.660,  -397.986,  274.660,  -401.586);
    snowplowStops[158]   <-  snowplowStop( snowplowv3( 305.017,  -391.866,  -19.998 ), 306.017,  -390.266,  304.017,  -393.866);
    snowplowStops[159]   <-  snowplowStop( snowplowv3( 380.808,  -392.481,  -19.998 ), 381.808,  -390.881,  379.808,  -394.481);
    snowplowStops[160]   <-  snowplowStop( snowplowv3( 451.649,  -392.429,  -19.999 ), 452.649,  -390.829,  450.649,  -394.429);
    snowplowStops[161]   <-  snowplowStop( snowplowv3( 551.088,  -392.042,  -20.002 ), 552.088,  -390.442,  550.088,  -394.042);
    snowplowStops[162]   <-  snowplowStop( snowplowv3( 568.341,  -378.958,  -20.000 ), 566.741,  -377.958,  570.341,  -379.958);
    snowplowStops[163]   <-  snowplowStop( snowplowv3( 568.556,  -339.594,  -19.996 ), 566.956,  -338.594,  570.556,  -340.594);
    snowplowStops[164]   <-  snowplowStop( snowplowv3( 568.623,  -298.680,  -19.998 ), 567.023,  -297.680,  570.623,  -299.680);
    snowplowStops[165]   <-  snowplowStop( snowplowv3( 568.342,  -266.279,  -19.999 ), 566.742,  -265.279,  570.342,  -267.279);
    snowplowStops[166]   <-  snowplowStop( snowplowv3( 568.384,  -221.235,  -19.999 ), 566.784,  -220.235,  570.384,  -222.235);
    snowplowStops[167]   <-  snowplowStop( snowplowv3( 568.294,  -171.249,  -19.999 ), 566.694,  -170.249,  570.294,  -172.249);
    snowplowStops[168]   <-  snowplowStop( snowplowv3( 551.507,  -152.397,  -19.990 ), 550.507,  -150.397,  552.507,  -153.998);
    snowplowStops[169]   <-  snowplowStop( snowplowv3( 502.696,  -151.725,  -19.148 ), 501.696,  -149.725,  503.696,  -153.325);
    snowplowStops[170]   <-  snowplowStop( snowplowv3( 453.581,  -151.609,  -12.941 ), 452.581,  -149.609,  454.581,  -153.209);
    snowplowStops[171]   <-  snowplowStop( snowplowv3( 413.471,  -151.647,  -6.694 ), 412.471,  -149.647,  414.471,  -153.247);
    snowplowStops[172]   <-  snowplowStop( snowplowv3( 400.858,  -135.562,  -6.582 ), 399.258,  -134.562,  402.858,  -136.562);
    snowplowStops[173]   <-  snowplowStop( snowplowv3( 383.322,  -118.475,  -6.476 ), 382.322,  -116.475,  384.322,  -120.075);
    snowplowStops[174]   <-  snowplowStop( snowplowv3( 358.891,  -118.254,  -6.564 ), 357.891,  -116.254,  359.891,  -119.854);
    snowplowStops[175]   <-  snowplowStop( snowplowv3( 340.915,  -133.898,  -6.559 ), 338.915,  -132.898,  342.515,  -134.898);
    snowplowStops[176]   <-  snowplowStop( snowplowv3( 340.772,  -160.967,  -6.339 ), 338.772,  -159.967,  342.372,  -161.967);
    snowplowStops[177]   <-  snowplowStop( snowplowv3( 326.587,  -175.270,  -6.416 ), 325.587,  -173.270,  327.587,  -176.870);
    snowplowStops[178]   <-  snowplowStop( snowplowv3( 279.860,  -175.383,  -11.906 ), 278.860,  -173.383,  280.860,  -176.983);
    snowplowStops[179]   <-  snowplowStop( snowplowv3( 265.328,  -163.767,  -12.028 ), 263.728,  -162.767,  267.328,  -164.767);
    snowplowStops[180]   <-  snowplowStop( snowplowv3( 265.533,  -142.703,  -12.034 ), 263.933,  -141.703,  267.533,  -143.703);
    snowplowStops[181]   <-  snowplowStop( snowplowv3( 247.323,  -125.577,  -12.285 ), 246.323,  -123.577,  248.323,  -127.177);
    snowplowStops[182]   <-  snowplowStop( snowplowv3( 201.412,  -125.231,  -19.677 ), 200.412,  -123.231,  202.412,  -126.831);
    snowplowStops[183]   <-  snowplowStop( snowplowv3( 187.427,  -112.161,  -19.992 ), 185.827,  -111.161,  189.427,  -113.161);
    snowplowStops[184]   <-  snowplowStop( snowplowv3( 187.896,  -56.850,  -20.000 ), 186.296,  -55.850,  189.896,  -57.850);
    snowplowStops[185]   <-  snowplowStop( snowplowv3( 187.649,  6.861,  -19.999 ), 186.049,  7.861,  189.649,  5.861);
    snowplowStops[186]   <-  snowplowStop( snowplowv3( 187.483,  37.667,  -20.025 ), 185.883,  38.667,  189.483,  36.667);
    snowplowStops[187]   <-  snowplowStop( snowplowv3( 187.458,  76.640,  -19.992 ), 185.858,  77.640,  189.458,  75.640);
    snowplowStops[188]   <-  snowplowStop( snowplowv3( 210.097,  109.774,  -19.126 ), 211.097,  111.374,  209.097,  107.774);
    snowplowStops[189]   <-  snowplowStop( snowplowv3( 253.983,  125.050,  -20.676 ), 254.983,  126.650,  252.983,  123.050);
    snowplowStops[190]   <-  snowplowStop( snowplowv3( 270.544,  158.292,  -21.483 ), 268.944,  159.292,  272.544,  157.292);
    snowplowStops[191]   <-  snowplowStop( snowplowv3( 270.852,  200.811,  -23.148 ), 269.252,  201.811,  272.852,  199.811);
    snowplowStops[192]   <-  snowplowStop( snowplowv3( 284.121,  216.631,  -23.348 ), 285.121,  218.231,  283.121,  214.631);
    snowplowStops[193]   <-  snowplowStop( snowplowv3( 343.037,  216.212,  -21.725 ), 344.037,  217.812,  342.037,  214.212);
    snowplowStops[194]   <-  snowplowStop( snowplowv3( 383.389,  216.228,  -20.959 ), 384.389,  217.828,  382.389,  214.228);
    snowplowStops[195]   <-  snowplowStop( snowplowv3( 433.428,  216.256,  -20.046 ), 434.428,  217.856,  432.428,  214.256);
    snowplowStops[196]   <-  snowplowStop( snowplowv3( 450.154,  235.548,  -19.975 ), 448.554,  236.548,  452.154,  234.548);
    snowplowStops[197]   <-  snowplowStop( snowplowv3( 450.321,  292.863,  -19.942 ), 448.721,  293.863,  452.321,  291.863);
    snowplowStops[198]   <-  snowplowStop( snowplowv3( 450.309,  352.016,  -19.998 ), 448.709,  353.016,  452.309,  351.016);
    snowplowStops[199]   <-  snowplowStop( snowplowv3( 450.240,  430.653,  -22.945 ), 448.640,  431.653,  452.240,  429.653);
    snowplowStops[200]   <-  snowplowStop( snowplowv3( 433.314,  448.301,  -23.350 ), 432.314,  450.301,  434.314,  446.701);
    snowplowStops[201]   <-  snowplowStop( snowplowv3( 377.877,  448.382,  -21.303 ), 376.877,  450.382,  378.877,  446.782);
    snowplowStops[202]   <-  snowplowStop( snowplowv3( 330.049,  448.668,  -20.822 ), 329.049,  450.668,  331.049,  447.068);
    snowplowStops[203]   <-  snowplowStop( snowplowv3( 282.777,  448.361,  -20.058 ), 281.777,  450.361,  283.777,  446.761);
    snowplowStops[204]   <-  snowplowStop( snowplowv3( 265.902,  430.292,  -20.177 ), 263.902,  431.292,  267.502,  429.292);
    snowplowStops[205]   <-  snowplowStop( snowplowv3( 266.192,  370.053,  -21.391 ), 264.192,  371.053,  267.792,  369.053);
    snowplowStops[206]   <-  snowplowStop( snowplowv3( 266.363,  323.021,  -21.407 ), 264.363,  324.021,  267.963,  322.021);
    snowplowStops[207]   <-  snowplowStop( snowplowv3( 266.353,  284.062,  -21.431 ), 264.353,  285.062,  267.953,  283.062);
    snowplowStops[208]   <-  snowplowStop( snowplowv3( 251.794,  270.423,  -21.351 ), 250.794,  272.423,  252.794,  268.823);
    snowplowStops[209]   <-  snowplowStop( snowplowv3( 219.744,  270.474,  -20.059 ), 218.744,  272.474,  220.744,  268.874);
    snowplowStops[210]   <-  snowplowStop( snowplowv3( 192.717,  244.767,  -19.964 ), 190.717,  245.767,  194.317,  243.767);
    snowplowStops[211]   <-  snowplowStop( snowplowv3( 176.862,  224.406,  -19.875 ), 175.862,  226.406,  177.862,  222.806);
    snowplowStops[212]   <-  snowplowStop( snowplowv3( 142.685,  224.376,  -19.858 ), 141.685,  226.376,  143.685,  222.776);
    snowplowStops[213]   <-  snowplowStop( snowplowv3( 133.092,  236.753,  -20.765 ), 131.492,  237.753,  135.092,  235.753);
    snowplowStops[214]   <-  snowplowStop( snowplowv3( 133.287,  284.276,  -20.980 ), 131.687,  285.276,  135.287,  283.276);
    snowplowStops[215]   <-  snowplowStop( snowplowv3( 133.219,  351.176,  -21.064 ), 131.619,  352.176,  135.219,  350.176);
    snowplowStops[216]   <-  snowplowStop( snowplowv3( 112.803,  376.808,  -20.331 ), 111.803,  378.808,  113.803,  375.208);
    snowplowStops[217]   <-  snowplowStop( snowplowv3( 65.594,  383.232,  -14.469 ), 64.594,  385.232,  66.594,  381.632);
    snowplowStops[218]   <-  snowplowStop( snowplowv3( 50.484,  382.959,  -13.796 ), 49.484,  384.959,  51.484,  381.359);
    snowplowStops[219]   <-  snowplowStop( snowplowv3( 43.028,  348.302,  -13.868 ), 41.028,  349.302,  44.628,  347.302);
    snowplowStops[220]   <-  snowplowStop( snowplowv3( 43.087,  316.422,  -14.419 ), 41.087,  317.422,  44.687,  315.422);
    snowplowStops[221]   <-  snowplowStop( snowplowv3( 40.325,  270.668,  -15.212 ), 38.325,  271.668,  41.925,  269.668);
    snowplowStops[222]   <-  snowplowStop( snowplowv3( 40.387,  236.079,  -15.802 ), 38.387,  237.079,  41.987,  235.079);
    snowplowStops[223]   <-  snowplowStop( snowplowv3( 28.924,  224.336,  -15.842 ), 27.924,  226.336,  29.924,  222.736);
    snowplowStops[224]   <-  snowplowStop( snowplowv3( -8.198,  224.436,  -15.334 ), -9.198,  226.436,  -7.198,  222.836);
    snowplowStops[225]   <-  snowplowStop( snowplowv3( -63.714,  224.567,  -14.569 ), -64.714,  226.567,  -62.714,  222.967);
    snowplowStops[226]   <-  snowplowStop( snowplowv3( -117.411,  224.552,  -13.834 ), -118.411,  226.552,  -116.411,  222.952);
    snowplowStops[227]   <-  snowplowStop( snowplowv3( -127.964,  234.546,  -13.770 ), -129.564,  235.546,  -125.964,  233.546);
    snowplowStops[228]   <-  snowplowStop( snowplowv3( -130.925,  273.257,  -12.039 ), -132.525,  274.257,  -128.925,  272.257);
    snowplowStops[229]   <-  snowplowStop( snowplowv3( -152.389,  290.231,  -11.696 ), -153.389,  292.231,  -151.389,  288.631);
    snowplowStops[230]   <-  snowplowStop( snowplowv3( -192.201,  294.305,  -6.363 ), -193.201,  296.305,  -191.201,  292.705);
    snowplowStops[231]   <-  snowplowStop( snowplowv3( -201.709,  304.967,  -6.288 ), -203.309,  305.967,  -199.709,  303.967);
    snowplowStops[232]   <-  snowplowStop( snowplowv3( -201.498,  358.276,  -6.198 ), -203.098,  359.276,  -199.498,  357.276);
    snowplowStops[233]   <-  snowplowStop( snowplowv3( -201.736,  399.754,  -6.124 ), -203.336,  400.754,  -199.736,  398.754);
    snowplowStops[234]   <-  snowplowStop( snowplowv3( -225.717,  429.088,  -6.132 ), -226.717,  431.088,  -224.717,  427.488);
    snowplowStops[235]   <-  snowplowStop( snowplowv3( -270.485,  429.506,  -6.174 ), -271.485,  431.506,  -269.485,  427.906);
    snowplowStops[236]   <-  snowplowStop( snowplowv3( -318.787,  429.385,  -4.180 ), -319.787,  431.385,  -317.787,  427.785);
    snowplowStops[237]   <-  snowplowStop( snowplowv3( -369.648,  429.615,  -1.295 ), -370.648,  431.615,  -368.648,  428.015);
    snowplowStops[238]   <-  snowplowStop( snowplowv3( -383.661,  443.503,  -1.054 ), -385.261,  444.503,  -381.661,  442.503); // первая метка после повоторота к автобусам с востока
    snowplowStops[239]   <-  snowplowStop( snowplowv3( -384.124,  499.362,  -1.054 ), -385.724,  500.362,  -382.124,  498.362);
    snowplowStops[240]   <-  snowplowStop( snowplowv3( -400.909,  518.184,  -0.887 ), -401.909,  520.184,  -399.909,  516.584);
    snowplowStops[241]   <-  snowplowStop( snowplowv3( -453.875,  518.362,  1.166 ), -454.875,  520.362,  -452.875,  516.762);  // метка перед поворотом направо от автобусов


    // Route 3
    snowplowStops[242]   <-  snowplowStop( snowplowv3( -391.234,  634.039,  -10.290 ), -392.834,  635.039,  -389.234,  633.039 );
    snowplowStops[243]   <-  snowplowStop( snowplowv3( -391.146,  672.151,  -12.910 ), -392.746,  673.151,  -389.146,  671.151 );
    snowplowStops[244]   <-  snowplowStop( snowplowv3( -391.225,  720.035,  -15.742 ), -392.825,  721.035,  -389.225,  719.035 );
    snowplowStops[245]   <-  snowplowStop( snowplowv3( -391.102,  785.083,  -19.628 ), -392.702,  786.083,  -389.102,  784.083 );
    snowplowStops[246]   <-  snowplowStop( snowplowv3( -377.599,  800.645,  -19.981 ), -376.599,  802.245,  -378.599,  798.645 );
    snowplowStops[247]   <-  snowplowStop( snowplowv3( -329.238,  801.319,  -19.985 ), -328.238,  802.919,  -330.238,  799.319 );
    snowplowStops[248]   <-  snowplowStop( snowplowv3( -281.142,  801.329,  -19.991 ), -280.142,  802.929,  -282.142,  799.329 );
    snowplowStops[249]   <-  snowplowStop( snowplowv3( -242.478,  801.231,  -19.991 ), -241.478,  802.831,  -243.478,  799.231 );
    snowplowStops[250]   <-  snowplowStop( snowplowv3( -185.855,  801.293,  -20.553 ), -184.855,  802.893,  -186.855,  799.293 );
    snowplowStops[251]   <-  snowplowStop( snowplowv3( -168.038,  785.042,  -20.658 ), -170.038,  786.042,  -166.438,  784.042 );
    snowplowStops[252]   <-  snowplowStop( snowplowv3( -167.964,  747.656,  -20.465 ), -169.964,  748.656,  -166.364,  746.656 );
    snowplowStops[253]   <-  snowplowStop( snowplowv3( -167.869,  706.518,  -20.244 ), -169.869,  707.518,  -166.269,  705.518 );
    snowplowStops[254]   <-  snowplowStop( snowplowv3( -150.436,  688.120,  -20.209 ), -149.436,  689.720,  -151.436,  686.120 );
    snowplowStops[255]   <-  snowplowStop( snowplowv3( -119.599,  702.146,  -20.740 ), -118.599,  703.746,  -120.599,  700.146 );
    snowplowStops[256]   <-  snowplowStop( snowplowv3( -86.201,  716.297,  -21.361 ), -85.201,  717.897,  -87.201,  714.297 );
    snowplowStops[257]   <-  snowplowStop( snowplowv3( -53.743,  716.332,  -21.800 ), -52.743,  717.932,  -54.743,  714.332 );
    snowplowStops[258]   <-  snowplowStop( snowplowv3( -38.756,  704.837,  -21.822 ), -40.756,  705.837,  -37.156,  703.837 );
    snowplowStops[259]   <-  snowplowStop( snowplowv3( -39.062,  682.238,  -21.415 ), -41.062,  683.238,  -37.462,  681.238 );
    snowplowStops[260]   <-  snowplowStop( snowplowv3( -39.319,  656.978,  -19.963 ), -41.319,  657.978,  -37.719,  655.978 );
    snowplowStops[261]   <-  snowplowStop( snowplowv3( -57.393,  641.253,  -19.984 ), -58.393,  643.253,  -56.393,  639.653 );
    snowplowStops[262]   <-  snowplowStop( snowplowv3( -98.782,  641.560,  -19.858 ), -99.782,  643.560,  -97.782,  639.960 );
    snowplowStops[263]   <-  snowplowStop( snowplowv3( -148.029,  641.427,  -19.973 ), -149.029,  643.427,  -147.029,  639.827 );
    snowplowStops[264]   <-  snowplowStop( snowplowv3( -168.239,  620.260,  -20.014 ), -170.239,  621.260,  -166.639,  619.260 );
    snowplowStops[265]   <-  snowplowStop( snowplowv3( -167.871,  584.719,  -20.133 ), -169.871,  585.719,  -166.271,  583.719 );
    snowplowStops[266]   <-  snowplowStop( snowplowv3( -125.701,  541.703,  -20.082 ), -124.701,  543.303,  -126.701,  539.703 );
    snowplowStops[267]   <-  snowplowStop( snowplowv3( -65.874,  541.594,  -19.656 ), -64.874,  543.194,  -66.874,  539.594 );
    snowplowStops[268]   <-  snowplowStop( snowplowv3( -14.812,  541.715,  -19.284 ), -13.812,  543.315,  -15.812,  539.715 );
    snowplowStops[269]   <-  snowplowStop( snowplowv3( 25.217,  542.035,  -18.994 ), 26.217,  543.635,  24.217,  540.035 );
    snowplowStops[270]   <-  snowplowStop( snowplowv3( 49.060,  556.728,  -19.007 ), 47.460,  557.728,  51.060,  555.728 );
    snowplowStops[271]   <-  snowplowStop( snowplowv3( 52.581,  588.643,  -19.800 ), 50.981,  589.643,  54.581,  587.643 );
    snowplowStops[272]   <-  snowplowStop( snowplowv3( 52.544,  620.492,  -19.965 ), 50.944,  621.492,  54.544,  619.492 );
    snowplowStops[273]   <-  snowplowStop( snowplowv3( 65.132,  633.384,  -19.917 ), 66.132,  634.984,  64.132,  631.384 );
    snowplowStops[274]   <-  snowplowStop( snowplowv3( 106.874,  658.057,  -19.238 ), 105.274,  659.057,  108.874,  657.057 );
    snowplowStops[275]   <-  snowplowStop( snowplowv3( 121.982,  658.595,  -18.394 ), 122.982,  660.195,  120.982,  656.595 );
    snowplowStops[276]   <-  snowplowStop( snowplowv3( 147.998,  660.564,  -19.332 ), 146.398,  661.564,  149.998,  659.564 );
    snowplowStops[277]   <-  snowplowStop( snowplowv3( 182.094,  689.054,  -21.867 ), 183.094,  690.654,  181.094,  687.054 );
    snowplowStops[278]   <-  snowplowStop( snowplowv3( 248.351,  688.942,  -24.263 ), 249.351,  690.542,  247.351,  686.942 );
    snowplowStops[279]   <-  snowplowStop( snowplowv3( 284.392,  688.916,  -24.657 ), 285.392,  690.516,  283.392,  686.916 );
    snowplowStops[280]   <-  snowplowStop( snowplowv3( 317.272,  688.939,  -24.716 ), 318.272,  690.539,  316.272,  686.939 );
    snowplowStops[281]   <-  snowplowStop( snowplowv3( 353.432,  688.890,  -24.732 ), 354.432,  690.490,  352.432,  686.890 );
    snowplowStops[282]   <-  snowplowStop( snowplowv3( 380.768,  688.541,  -24.727 ), 381.768,  690.141,  379.768,  686.541 );
    snowplowStops[283]   <-  snowplowStop( snowplowv3( 397.418,  673.108,  -24.728 ), 395.418,  674.108,  399.018,  672.108 );
    snowplowStops[284]   <-  snowplowStop( snowplowv3( 397.440,  636.774,  -24.732 ), 395.440,  637.774,  399.040,  635.774 );
    snowplowStops[285]   <-  snowplowStop( snowplowv3( 385.479,  624.800,  -24.722 ), 384.479,  626.800,  386.479,  623.200 );
    snowplowStops[286]   <-  snowplowStop( snowplowv3( 353.139,  624.977,  -24.567 ), 352.139,  626.977,  354.139,  623.377 );
    snowplowStops[287]   <-  snowplowStop( snowplowv3( 318.336,  624.988,  -24.522 ), 317.336,  626.988,  319.336,  623.388 );
    snowplowStops[288]   <-  snowplowStop( snowplowv3( 284.212,  625.073,  -24.419 ), 283.212,  627.073,  285.212,  623.473 );
    snowplowStops[289]   <-  snowplowStop( snowplowv3( 265.910,  606.649,  -24.402 ), 263.910,  607.649,  267.510,  605.649 );
    snowplowStops[290]   <-  snowplowStop( snowplowv3( 265.711,  567.510,  -24.364 ), 263.711,  568.510,  267.311,  566.510 );
    snowplowStops[291]   <-  snowplowStop( snowplowv3( 265.670,  530.240,  -22.978 ), 263.670,  531.240,  267.270,  529.240 );
    snowplowStops[292]   <-  snowplowStop( snowplowv3( 265.613,  462.586,  -20.179 ), 263.613,  463.586,  267.213,  461.586 );
    snowplowStops[293]   <-  snowplowStop( snowplowv3( 282.135,  444.669,  -20.041 ), 283.135,  446.269,  281.135,  442.669 );
    snowplowStops[294]   <-  snowplowStop( snowplowv3( 341.816,  444.687,  -21.014 ), 342.816,  446.287,  340.816,  442.687 );
    snowplowStops[295]   <-  snowplowStop( snowplowv3( 432.650,  444.594,  -23.317 ), 433.650,  446.194,  431.650,  442.594 );
    snowplowStops[296]   <-  snowplowStop( snowplowv3( 446.231,  429.696,  -22.983 ), 444.231,  430.696,  447.831,  428.696 );
    snowplowStops[297]   <-  snowplowStop( snowplowv3( 446.167,  391.346,  -20.321 ), 444.167,  392.346,  447.767,  390.346 );
    snowplowStops[298]   <-  snowplowStop( snowplowv3( 446.276,  346.151,  -19.993 ), 444.276,  347.151,  447.876,  345.151 );
    snowplowStops[299]   <-  snowplowStop( snowplowv3( 446.190,  303.086,  -19.982 ), 444.190,  304.086,  447.790,  302.086 );
    snowplowStops[300]   <-  snowplowStop( snowplowv3( 446.120,  236.740,  -19.994 ), 444.120,  237.740,  447.720,  235.740 );
    snowplowStops[301]   <-  snowplowStop( snowplowv3( 446.202,  200.794,  -19.997 ), 444.202,  201.794,  447.802,  199.794 );
    snowplowStops[302]   <-  snowplowStop( snowplowv3( 446.171,  163.592,  -19.930 ), 444.171,  164.592,  447.771,  162.592 );
    snowplowStops[303]   <-  snowplowStop( snowplowv3( 446.254,  124.107,  -20.109 ), 444.254,  125.107,  447.854,  123.107 );
    snowplowStops[304]   <-  snowplowStop( snowplowv3( 446.369,  67.552,  -22.818 ), 444.369,  68.552,  447.969,  66.552 );
    snowplowStops[305]   <-  snowplowStop( snowplowv3( 435.211,  54.272,  -23.042 ), 434.211,  56.272,  436.211,  52.672 );
    snowplowStops[306]   <-  snowplowStop( snowplowv3( 406.711,  54.573,  -23.400 ), 405.711,  56.573,  407.711,  52.973 );
    snowplowStops[307]   <-  snowplowStop( snowplowv3( 372.615,  54.727,  -23.835 ), 371.615,  56.727,  373.615,  53.127 );
    snowplowStops[308]   <-  snowplowStop( snowplowv3( 358.259,  36.837,  -23.969 ), 356.259,  37.837,  359.859,  35.837 );
    snowplowStops[309]   <-  snowplowStop( snowplowv3( 374.418,  19.340,  -24.259 ), 375.418,  20.940,  373.418,  17.340 );
    snowplowStops[310]   <-  snowplowStop( snowplowv3( 429.570,  19.213,  -24.907 ), 430.570,  20.813,  428.570,  17.213 );
    snowplowStops[311]   <-  snowplowStop( snowplowv3( 442.355,  5.896,  -24.926 ), 440.355,  6.896,  443.955,  4.896 );
    snowplowStops[312]   <-  snowplowStop( snowplowv3( 437.571,  -33.617,  -20.111 ), 435.571,  -32.617,  439.171,  -34.617 );
    snowplowStops[313]   <-  snowplowStop( snowplowv3( 412.460,  -69.237,  -12.418 ), 410.460,  -68.237,  414.060,  -70.237 );
    snowplowStops[314]   <-  snowplowStop( snowplowv3( 397.471,  -105.596,  -6.712 ), 395.471,  -104.596,  399.071,  -106.596 );
    snowplowStops[315]   <-  snowplowStop( snowplowv3( 397.175,  -134.897,  -6.538 ), 395.175,  -133.897,  398.775,  -135.897 );
    snowplowStops[316]   <-  snowplowStop( snowplowv3( 397.046,  -163.776,  -6.461 ), 395.046,  -162.776,  398.646,  -164.776 );
    snowplowStops[317]   <-  snowplowStop( snowplowv3( 384.986,  -175.412,  -6.454 ), 383.986,  -173.412,  385.986,  -177.012 );
    snowplowStops[318]   <-  snowplowStop( snowplowv3( 356.202,  -175.216,  -6.461 ), 355.202,  -173.216,  357.202,  -176.816 );
    snowplowStops[319]   <-  snowplowStop( snowplowv3( 329.749,  -175.282,  -6.291 ), 328.749,  -173.282,  330.749,  -176.882 );
    snowplowStops[320]   <-  snowplowStop( snowplowv3( 277.054,  -175.435,  -11.978 ), 276.054,  -173.435,  278.054,  -177.035 );
    snowplowStops[321]   <-  snowplowStop( snowplowv3( 265.780,  -164.310,  -12.024 ), 264.180,  -163.310,  267.780,  -165.310 );
    snowplowStops[322]   <-  snowplowStop( snowplowv3( 265.496,  -142.111,  -12.036 ), 263.896,  -141.111,  267.496,  -143.111 );
    snowplowStops[323]   <-  snowplowStop( snowplowv3( 265.511,  -113.704,  -12.129 ), 263.911,  -112.704,  267.511,  -114.704 );
    snowplowStops[324]   <-  snowplowStop( snowplowv3( 265.253,  -60.991,  -16.591 ), 263.653,  -59.991,  267.253,  -61.991 );
    snowplowStops[325]   <-  snowplowStop( snowplowv3( 265.678,  6.114,  -22.943 ), 264.078,  7.114,  267.678,  5.114 );
    snowplowStops[326]   <-  snowplowStop( snowplowv3( 249.092,  23.580,  -22.999 ), 248.092,  25.580,  250.092,  21.980 );
    snowplowStops[327]   <-  snowplowStop( snowplowv3( 200.602,  23.829,  -20.179 ), 199.602,  25.829,  201.602,  22.229 );
    snowplowStops[328]   <-  snowplowStop( snowplowv3( 183.768,  7.571,  -19.990 ), 181.768,  8.571,  185.368,  6.571 );
    snowplowStops[329]   <-  snowplowStop( snowplowv3( 183.927,  -54.709,  -20.002 ), 181.927,  -53.709,  185.527,  -55.709 );
    snowplowStops[330]   <-  snowplowStop( snowplowv3( 183.921,  -111.794,  -20.000 ), 181.921,  -110.794,  185.521,  -112.794 );
    snowplowStops[331]   <-  snowplowStop( snowplowv3( 184.120,  -141.579,  -20.003 ), 182.120,  -140.579,  185.720,  -142.579 );
    snowplowStops[332]   <-  snowplowStop( snowplowv3( 200.656,  -177.533,  -19.999 ), 198.656,  -176.533,  202.256,  -178.533 );
    snowplowStops[333]   <-  snowplowStop( snowplowv3( 219.656,  -228.330,  -20.009 ), 217.656,  -227.330,  221.256,  -229.330 );
    snowplowStops[334]   <-  snowplowStop( snowplowv3( 203.825,  -261.547,  -19.999 ), 201.825,  -260.547,  205.425,  -262.547 );
    snowplowStops[335]   <-  snowplowStop( snowplowv3( 175.198,  -268.900,  -19.998 ), 174.198,  -266.900,  176.198,  -270.500 );
    snowplowStops[336]   <-  snowplowStop( snowplowv3( 144.003,  -268.724,  -19.996 ), 143.003,  -266.724,  145.003,  -270.324 );
    snowplowStops[337]   <-  snowplowStop( snowplowv3( 133.736,  -258.919,  -19.990 ), 132.136,  -257.919,  135.736,  -259.919 );
    snowplowStops[338]   <-  snowplowStop( snowplowv3( 133.673,  -212.215,  -19.953 ), 132.073,  -211.215,  135.673,  -213.215 );
    snowplowStops[339]   <-  snowplowStop( snowplowv3( 133.802,  -169.726,  -19.917 ), 132.202,  -168.726,  135.802,  -170.726 );
    snowplowStops[340]   <-  snowplowStop( snowplowv3( 133.573,  -122.833,  -19.878 ), 131.973,  -121.833,  135.573,  -123.833 );
    snowplowStops[341]   <-  snowplowStop( snowplowv3( 133.494,  -77.802,  -19.861 ), 131.894,  -76.802,  135.494,  -78.802 );
    snowplowStops[342]   <-  snowplowStop( snowplowv3( 133.529,  -28.140,  -19.859 ), 131.929,  -27.140,  135.529,  -29.140 );
    snowplowStops[343]   <-  snowplowStop( snowplowv3( 133.799,  28.083,  -19.862 ), 132.199,  29.083,  135.799,  27.083 );
    snowplowStops[344]   <-  snowplowStop( snowplowv3( 114.390,  50.026,  -19.294 ), 113.390,  52.026,  115.390,  48.426 );
    snowplowStops[345]   <-  snowplowStop( snowplowv3( 66.006,  54.167,  -13.263 ), 65.006,  56.167,  67.006,  52.567 );
    snowplowStops[346]   <-  snowplowStop( snowplowv3( 52.777,  64.010,  -12.851 ), 51.177,  65.010,  54.777,  63.010 );
    snowplowStops[347]   <-  snowplowStop( snowplowv3( 52.625,  125.684,  -14.070 ), 51.025,  126.684,  54.625,  124.684 );
    snowplowStops[348]   <-  snowplowStop( snowplowv3( 52.580,  202.833,  -15.834 ), 50.980,  203.833,  54.580,  201.833 );
    snowplowStops[349]   <-  snowplowStop( snowplowv3( 52.594,  233.314,  -15.828 ), 50.994,  234.314,  54.594,  232.314 );
    snowplowStops[350]   <-  snowplowStop( snowplowv3( 52.435,  281.762,  -15.017 ), 50.835,  282.762,  54.435,  280.762 );
    snowplowStops[351]   <-  snowplowStop( snowplowv3( 49.789,  321.398,  -14.336 ), 48.189,  322.398,  51.789,  320.398 );
    snowplowStops[352]   <-  snowplowStop( snowplowv3( 49.764,  348.372,  -13.872 ), 48.164,  349.372,  51.764,  347.372 );
    snowplowStops[353]   <-  snowplowStop( snowplowv3( 30.005,  368.805,  -13.821 ), 29.005,  370.805,  31.005,  367.205 );
    snowplowStops[354]   <-  snowplowStop( snowplowv3( -5.680,  369.281,  -13.821 ), -6.680,  371.281,  -4.680,  367.681 );
    snowplowStops[355]   <-  snowplowStop( snowplowv3( -37.021,  369.361,  -13.827 ), -38.021,  371.361,  -36.021,  367.761 );
    snowplowStops[356]   <-  snowplowStop( snowplowv3( -72.107,  369.126,  -13.823 ), -73.107,  371.126,  -71.107,  367.526 );
    snowplowStops[357]   <-  snowplowStop( snowplowv3( -119.296,  369.268,  -13.822 ), -120.296,  371.268,  -118.296,  367.668 );
    snowplowStops[358]   <-  snowplowStop( snowplowv3( -136.657,  353.822,  -13.823 ), -138.657,  354.822,  -135.057,  352.822 );
    snowplowStops[359]   <-  snowplowStop( snowplowv3( -136.833,  303.323,  -12.062 ), -138.833,  304.323,  -135.233,  302.323 );
    snowplowStops[360]   <-  snowplowStop( snowplowv3( -136.957,  274.812,  -12.036 ), -138.957,  275.812,  -135.357,  273.812 );
    snowplowStops[361]   <-  snowplowStop( snowplowv3( -137.029,  232.566,  -13.821 ), -139.029,  233.566,  -135.429,  231.566 );
    snowplowStops[362]   <-  snowplowStop( snowplowv3( -118.460,  216.841,  -13.834 ), -117.460,  218.441,  -119.460,  214.841 );
    snowplowStops[363]   <-  snowplowStop( snowplowv3( -74.370,  216.754,  -14.420 ), -73.370,  218.354,  -75.370,  214.754 );
    snowplowStops[364]   <-  snowplowStop( snowplowv3( -28.649,  214.114,  -15.053 ), -27.649,  215.714,  -29.649,  212.114 );
    snowplowStops[365]   <-  snowplowStop( snowplowv3( 29.608,  214.187,  -15.848 ), 30.608,  215.787,  28.608,  212.187 );
    snowplowStops[366]   <-  snowplowStop( snowplowv3( 40.074,  204.227,  -15.852 ), 38.074,  205.227,  41.674,  203.227 );
    snowplowStops[367]   <-  snowplowStop( snowplowv3( 40.228,  127.276,  -14.161 ), 38.228,  128.276,  41.828,  126.276 );
    snowplowStops[368]   <-  snowplowStop( snowplowv3( 40.300,  63.137,  -12.862 ), 38.300,  64.137,  41.900,  62.137 );
    snowplowStops[369]   <-  snowplowStop( snowplowv3( 25.898,  50.002,  -12.914 ), 24.898,  52.002,  26.898,  48.402 );
    snowplowStops[370]   <-  snowplowStop( snowplowv3( -24.224,  49.957,  -13.458 ), -25.224,  51.957,  -23.224,  48.357 );
    snowplowStops[371]   <-  snowplowStop( snowplowv3( -56.593,  22.789,  -13.910 ), -58.593,  23.789,  -54.993,  21.789 );
    snowplowStops[372]   <-  snowplowStop( snowplowv3( -57.039,  -8.026,  -14.284 ), -59.039,  -7.026,  -55.439,  -9.026 );
    snowplowStops[373]   <-  snowplowStop( snowplowv3( -67.864,  -19.128,  -14.268 ), -68.864,  -17.128,  -66.864,  -20.728 );
    snowplowStops[374]   <-  snowplowStop( snowplowv3( -123.517,  -19.151,  -12.722 ), -124.517,  -17.151,  -122.517,  -20.751 );
    snowplowStops[375]   <-  snowplowStop( snowplowv3( -183.282,  -19.221,  -11.877 ), -184.282,  -17.221,  -182.282,  -20.821 );
    snowplowStops[376]   <-  snowplowStop( snowplowv3( -196.061,  -7.354,  -11.842 ), -197.661,  -6.354,  -194.061,  -8.354 );
    snowplowStops[377]   <-  snowplowStop( snowplowv3( -201.603,  61.230,  -11.193 ), -203.203,  62.230,  -199.603,  60.230 );
    snowplowStops[378]   <-  snowplowStop( snowplowv3( -205.103,  107.296,  -10.762 ), -206.703,  108.296,  -203.103,  106.296 );
    snowplowStops[379]   <-  snowplowStop( snowplowv3( -205.134,  161.515,  -10.378 ), -206.734,  162.515,  -203.134,  160.515 );
    snowplowStops[380]   <-  snowplowStop( snowplowv3( -205.308,  262.391,  -6.649 ), -206.908,  263.391,  -203.308,  261.391 );
    snowplowStops[381]   <-  snowplowStop( snowplowv3( -205.269,  303.805,  -6.285 ), -206.869,  304.805,  -203.269,  302.805 );
    snowplowStops[382]   <-  snowplowStop( snowplowv3( -205.333,  347.188,  -6.215 ), -206.933,  348.188,  -203.333,  346.188 );
    snowplowStops[383]   <-  snowplowStop( snowplowv3( -205.608,  396.105,  -6.127 ), -207.208,  397.105,  -203.608,  395.105 );
    snowplowStops[384]   <-  snowplowStop( snowplowv3( -223.436,  425.255,  -6.118 ), -224.436,  427.255,  -222.436,  423.655 );
    snowplowStops[385]   <-  snowplowStop( snowplowv3( -272.580,  424.880,  -6.179 ), -273.580,  426.880,  -271.580,  423.280 );
    snowplowStops[386]   <-  snowplowStop( snowplowv3( -370.468,  425.114,  -1.253 ), -371.468,  427.114,  -369.468,  423.514 );

    // Route 4
    snowplowStops[387]   <-  snowplowStop( snowplowv3( -508.554,  629.084,  1.414 ), -509.554,  631.084,  -507.554,  627.484 );
    snowplowStops[388]   <-  snowplowStop( snowplowv3( -576.171,  628.978,  5.191 ), -577.171,  630.978,  -575.171,  627.378 );
    snowplowStops[389]   <-  snowplowStop( snowplowv3( -647.106,  633.431,  10.120 ), -648.106,  635.431,  -646.106,  631.831 );
    snowplowStops[390]   <-  snowplowStop( snowplowv3( -720.401,  633.134,  14.353 ), -721.401,  635.134,  -719.401,  631.534 );
    snowplowStops[391]   <-  snowplowStop( snowplowv3( -793.115,  633.143,  17.640 ), -794.115,  635.143,  -792.115,  631.543 );
    snowplowStops[392]   <-  snowplowStop( snowplowv3( -861.903,  633.318,  19.975 ), -862.903,  635.318,  -860.903,  631.718 );
    snowplowStops[393]   <-  snowplowStop( snowplowv3( -930.541,  633.250,  21.568 ), -931.541,  635.250,  -929.541,  631.650 );
    snowplowStops[394]   <-  snowplowStop( snowplowv3( -1002.642,  633.222,  22.349 ), -1003.642,  635.222,  -1001.642,  631.622 );
    snowplowStops[395]   <-  snowplowStop( snowplowv3( -1071.702,  633.403,  22.328 ), -1072.702,  635.403,  -1070.702,  631.803 );
    snowplowStops[396]   <-  snowplowStop( snowplowv3( -1150.730,  633.420,  20.985 ), -1151.730,  635.420,  -1149.730,  631.820 );
    snowplowStops[397]   <-  snowplowStop( snowplowv3( -1223.594,  633.292,  17.670 ), -1224.594,  635.292,  -1222.594,  631.692 );
    snowplowStops[398]   <-  snowplowStop( snowplowv3( -1349.232,  633.313,  7.443 ), -1350.232,  635.313,  -1348.232,  631.713 );
    snowplowStops[399]   <-  snowplowStop( snowplowv3( -1447.146,  633.323,  -2.259 ), -1448.146,  635.323,  -1446.146,  631.723 );
    snowplowStops[400]   <-  snowplowStop( snowplowv3( -1588.159,  633.377,  -10.060 ), -1589.159,  635.377,  -1587.159,  631.777 );
    snowplowStops[401]   <-  snowplowStop( snowplowv3( -1602.355,  645.144,  -10.051 ), -1603.955,  646.144,  -1600.355,  644.144 );
    snowplowStops[402]   <-  snowplowStop( snowplowv3( -1602.020,  711.589,  -10.047 ), -1603.620,  712.589,  -1600.020,  710.589 );
    snowplowStops[403]   <-  snowplowStop( snowplowv3( -1602.293,  745.862,  -9.897 ), -1603.893,  746.862,  -1600.293,  744.862 );
    snowplowStops[404]   <-  snowplowStop( snowplowv3( -1602.484,  808.713,  -5.060 ), -1604.084,  809.713,  -1600.484,  807.713 );
    snowplowStops[405]   <-  snowplowStop( snowplowv3( -1606.361,  908.171,  -4.846 ), -1607.961,  909.171,  -1604.361,  907.171 );
    snowplowStops[406]   <-  snowplowStop( snowplowv3( -1614.454,  970.928,  -5.488 ), -1616.054,  971.928,  -1612.454,  969.928 );
    snowplowStops[407]   <-  snowplowStop( snowplowv3( -1624.595,  1020.722,  -5.993 ), -1626.195,  1021.722,  -1622.595,  1019.722 );
    snowplowStops[408]   <-  snowplowStop( snowplowv3( -1614.915,  1032.969,  -6.045 ), -1613.915,  1034.569,  -1615.915,  1030.969 );
    snowplowStops[409]   <-  snowplowStop( snowplowv3( -1531.449,  1032.712,  -9.211 ), -1530.449,  1034.312,  -1532.449,  1030.712 );
    snowplowStops[410]   <-  snowplowStop( snowplowv3( -1417.967,  1032.869,  -13.429 ), -1416.967,  1034.469,  -1418.967,  1030.869 );
    snowplowStops[411]   <-  snowplowStop( snowplowv3( -1408.075,  1022.382,  -13.423 ), -1410.075,  1023.382,  -1406.475,  1021.382 );
    snowplowStops[412]   <-  snowplowStop( snowplowv3( -1408.256,  937.701,  -13.503 ), -1410.256,  938.701,  -1406.656,  936.701 );
    snowplowStops[413]   <-  snowplowStop( snowplowv3( -1396.874,  923.836,  -13.758 ), -1395.874,  925.436,  -1397.874,  921.836 );
    snowplowStops[414]   <-  snowplowStop( snowplowv3( -1339.039,  923.627,  -18.315 ), -1338.039,  925.227,  -1340.039,  921.627 );
    snowplowStops[415]   <-  snowplowStop( snowplowv3( -1331.144,  915.460,  -18.345 ), -1333.144,  916.460,  -1329.544,  914.460 );
    snowplowStops[416]   <-  snowplowStop( snowplowv3( -1330.887,  853.535,  -18.357 ), -1332.887,  854.535,  -1329.287,  852.535 );
    snowplowStops[417]   <-  snowplowStop( snowplowv3( -1342.100,  842.876,  -18.078 ), -1343.100,  844.876,  -1341.100,  841.276 );
    snowplowStops[418]   <-  snowplowStop( snowplowv3( -1381.382,  842.858,  -12.756 ), -1382.382,  844.858,  -1380.382,  841.258 );
    snowplowStops[419]   <-  snowplowStop( snowplowv3( -1398.402,  826.574,  -12.208 ), -1400.402,  827.574,  -1396.802,  825.574 );
    snowplowStops[420]   <-  snowplowStop( snowplowv3( -1408.636,  813.175,  -11.825 ), -1409.636,  815.175,  -1407.636,  811.575 );
    snowplowStops[421]   <-  snowplowStop( snowplowv3( -1438.869,  814.974,  -10.222 ), -1439.869,  816.974,  -1437.869,  813.374 );
    snowplowStops[422]   <-  snowplowStop( snowplowv3( -1448.842,  800.687,  -10.447 ), -1450.842,  801.687,  -1447.242,  799.687 );
    snowplowStops[423]   <-  snowplowStop( snowplowv3( -1449.249,  742.544,  -12.749 ), -1451.249,  743.544,  -1447.649,  741.544 );
    snowplowStops[424]   <-  snowplowStop( snowplowv3( -1449.101,  689.049,  -15.000 ), -1451.101,  690.049,  -1447.501,  688.049 );
    snowplowStops[425]   <-  snowplowStop( snowplowv3( -1434.213,  676.126,  -15.173 ), -1433.213,  677.726,  -1435.213,  674.126 );
    snowplowStops[426]   <-  snowplowStop( snowplowv3( -1331.538,  676.337,  -19.519 ), -1330.538,  677.937,  -1332.538,  674.337 );
    snowplowStops[427]   <-  snowplowStop( snowplowv3( -1310.180,  685.271,  -19.186 ), -1311.780,  686.271,  -1308.180,  684.271 );
    snowplowStops[428]   <-  snowplowStop( snowplowv3( -1324.749,  759.598,  -15.325 ), -1326.349,  760.598,  -1322.749,  758.598 );
    snowplowStops[429]   <-  snowplowStop( snowplowv3( -1383.505,  808.354,  -13.103 ), -1384.505,  810.354,  -1382.505,  806.754 );
    snowplowStops[430]   <-  snowplowStop( snowplowv3( -1393.807,  825.335,  -12.291 ), -1395.407,  826.335,  -1391.807,  824.335 );
    snowplowStops[431]   <-  snowplowStop( snowplowv3( -1381.392,  838.635,  -12.760 ), -1380.392,  840.235,  -1382.392,  836.635 );
    snowplowStops[432]   <-  snowplowStop( snowplowv3( -1342.305,  838.589,  -18.046 ), -1341.305,  840.189,  -1343.305,  836.589 );
    snowplowStops[433]   <-  snowplowStop( snowplowv3( -1326.707,  854.213,  -18.363 ), -1328.307,  855.213,  -1324.707,  853.213 );
    snowplowStops[434]   <-  snowplowStop( snowplowv3( -1326.904,  913.849,  -18.357 ), -1328.504,  914.849,  -1324.904,  912.849 );
    snowplowStops[435]   <-  snowplowStop( snowplowv3( -1326.934,  986.998,  -18.357 ), -1328.534,  987.998,  -1324.934,  985.998 );
    snowplowStops[436]   <-  snowplowStop( snowplowv3( -1326.648,  1049.154,  -18.355 ), -1328.248,  1050.154,  -1324.648,  1048.154 );
    snowplowStops[437]   <-  snowplowStop( snowplowv3( -1326.747,  1115.580,  -18.356 ), -1328.346,  1116.580,  -1324.747,  1114.580 );
    snowplowStops[438]   <-  snowplowStop( snowplowv3( -1326.680,  1167.215,  -13.466 ), -1328.280,  1168.215,  -1324.680,  1166.215 );
    snowplowStops[439]   <-  snowplowStop( snowplowv3( -1336.770,  1177.294,  -13.412 ), -1337.770,  1179.294,  -1335.770,  1175.694 );
    snowplowStops[440]   <-  snowplowStop( snowplowv3( -1391.893,  1177.370,  -13.418 ), -1392.893,  1179.370,  -1390.893,  1175.770 );
    snowplowStops[441]   <-  snowplowStop( snowplowv3( -1408.177,  1166.034,  -13.425 ), -1410.177,  1167.034,  -1406.577,  1165.034 );
    snowplowStops[442]   <-  snowplowStop( snowplowv3( -1408.267,  1141.741,  -13.435 ), -1410.267,  1142.741,  -1406.667,  1140.741 );
    snowplowStops[443]   <-  snowplowStop( snowplowv3( -1408.406,  1121.319,  -13.427 ), -1410.406,  1122.319,  -1406.806,  1120.319 );
    snowplowStops[444]   <-  snowplowStop( snowplowv3( -1408.173,  1049.049,  -13.429 ), -1410.173,  1050.049,  -1406.573,  1048.049 );
    snowplowStops[445]   <-  snowplowStop( snowplowv3( -1418.835,  1036.253,  -13.418 ), -1419.835,  1038.253,  -1417.835,  1034.653 );
    snowplowStops[446]   <-  snowplowStop( snowplowv3( -1531.093,  1036.099,  -9.235 ), -1532.093,  1038.099,  -1530.093,  1034.499 );
    snowplowStops[447]   <-  snowplowStop( snowplowv3( -1615.691,  1036.293,  -6.086 ), -1616.691,  1038.293,  -1614.691,  1034.694 );
    snowplowStops[448]   <-  snowplowStop( snowplowv3( -1637.738,  1019.687,  -6.013 ), -1639.738,  1020.687,  -1636.138,  1018.687 );
    snowplowStops[449]   <-  snowplowStop( snowplowv3( -1622.515,  938.589,  -5.180 ), -1624.515,  939.589,  -1620.915,  937.589 );
    snowplowStops[450]   <-  snowplowStop( snowplowv3( -1597.352,  923.972,  -4.941 ), -1596.352,  925.572,  -1598.352,  921.972 );
    snowplowStops[451]   <-  snowplowStop( snowplowv3( -1524.787,  924.061,  -6.942 ), -1523.787,  925.661,  -1525.787,  922.061 );
    snowplowStops[452]   <-  snowplowStop( snowplowv3( -1423.781,  923.894,  -13.458 ), -1422.781,  925.494,  -1424.781,  921.894 );
    snowplowStops[453]   <-  snowplowStop( snowplowv3( -1404.797,  938.540,  -13.487 ), -1406.397,  939.540,  -1402.797,  937.540 );
    snowplowStops[454]   <-  snowplowStop( snowplowv3( -1404.684,  988.355,  -13.426 ), -1406.284,  989.355,  -1402.684,  987.355 );
    snowplowStops[455]   <-  snowplowStop( snowplowv3( -1404.677,  1048.009,  -13.435 ), -1406.277,  1049.009,  -1402.677,  1047.009 );
    snowplowStops[456]   <-  snowplowStop( snowplowv3( -1397.976,  1059.342,  -13.310 ), -1396.976,  1060.942,  -1398.976,  1057.342 );
    snowplowStops[457]   <-  snowplowStop( snowplowv3( -1389.917,  1052.842,  -13.363 ), -1391.917,  1053.842,  -1388.317,  1051.842 );
    snowplowStops[458]   <-  snowplowStop( snowplowv3( -1390.027,  1030.673,  -13.363 ), -1392.027,  1031.673,  -1388.427,  1029.673 );
    snowplowStops[459]   <-  snowplowStop( snowplowv3( -1377.171,  1007.573,  -15.290 ), -1379.171,  1008.573,  -1375.571,  1006.573 );
    snowplowStops[460]   <-  snowplowStop( snowplowv3( -1369.612,  991.754,  -15.363 ), -1371.612,  992.754,  -1368.012,  990.754 );
    snowplowStops[461]   <-  snowplowStop( snowplowv3( -1358.841,  989.180,  -15.470 ), -1360.841,  990.180,  -1357.241,  988.180 );
    snowplowStops[462]   <-  snowplowStop( snowplowv3( -1344.545,  969.210,  -17.310 ), -1346.545,  970.210,  -1342.945,  968.210 );
    snowplowStops[463]   <-  snowplowStop( snowplowv3( -1343.738,  945.889,  -17.320 ), -1345.738,  946.889,  -1342.138,  944.889 );
    snowplowStops[464]   <-  snowplowStop( snowplowv3( -1349.847,  940.799,  -17.043 ), -1350.847,  942.799,  -1348.847,  939.199 );
    snowplowStops[465]   <-  snowplowStop( snowplowv3( -1384.438,  940.719,  -13.787 ), -1385.438,  942.719,  -1383.438,  939.119 );
    snowplowStops[466]   <-  snowplowStop( snowplowv3( -1390.212,  945.959,  -13.368 ), -1391.812,  946.959,  -1388.212,  944.959 );
    snowplowStops[467]   <-  snowplowStop( snowplowv3( -1390.300,  968.157,  -13.364 ), -1391.900,  969.157,  -1388.300,  967.157 );
    snowplowStops[468]   <-  snowplowStop( snowplowv3( -1376.170,  991.122,  -15.339 ), -1377.770,  992.122,  -1374.170,  990.122 );
    snowplowStops[469]   <-  snowplowStop( snowplowv3( -1369.229,  1005.300,  -15.360 ), -1368.229,  1006.900,  -1370.229,  1003.300 );
    snowplowStops[470]   <-  snowplowStop( snowplowv3( -1358.993,  1008.042,  -15.438 ), -1360.593,  1009.042,  -1356.993,  1007.042 );
    snowplowStops[471]   <-  snowplowStop( snowplowv3( -1345.622,  1025.525,  -17.282 ), -1347.221,  1026.525,  -1343.622,  1024.525 );
    snowplowStops[472]   <-  snowplowStop( snowplowv3( -1348.295,  1033.030,  -17.077 ), -1349.295,  1035.030,  -1347.295,  1031.430 );
    snowplowStops[473]   <-  snowplowStop( snowplowv3( -1358.072,  1033.468,  -16.159 ), -1359.072,  1035.468,  -1357.072,  1031.868 );
    snowplowStops[474]   <-  snowplowStop( snowplowv3( -1365.930,  1040.240,  -16.111 ), -1366.930,  1042.240,  -1364.930,  1038.640 );
    snowplowStops[475]   <-  snowplowStop( snowplowv3( -1372.759,  1033.786,  -16.126 ), -1374.759,  1034.786,  -1371.159,  1032.786 );
    snowplowStops[476]   <-  snowplowStop( snowplowv3( -1366.260,  1026.476,  -16.119 ), -1365.260,  1028.076,  -1367.260,  1024.476 );
    snowplowStops[477]   <-  snowplowStop( snowplowv3( -1367.722,  1033.449,  -16.121 ), -1368.722,  1035.449,  -1366.722,  1031.849 );
    snowplowStops[478]   <-  snowplowStop( snowplowv3( -1387.542,  1033.236,  -13.699 ), -1388.542,  1035.236,  -1386.542,  1031.636 );
    snowplowStops[479]   <-  snowplowStop( snowplowv3( -1390.396,  1026.542,  -13.363 ), -1392.396,  1027.542,  -1388.796,  1025.542 );
    snowplowStops[480]   <-  snowplowStop( snowplowv3( -1390.204,  993.618,  -13.369 ), -1392.204,  994.618,  -1388.604,  992.618 );
    snowplowStops[481]   <-  snowplowStop( snowplowv3( -1390.251,  968.958,  -13.367 ), -1392.251,  969.958,  -1388.651,  967.958 );
    snowplowStops[482]   <-  snowplowStop( snowplowv3( -1385.388,  964.480,  -14.160 ), -1384.388,  966.080,  -1386.388,  962.480 );
    snowplowStops[483]   <-  snowplowStop( snowplowv3( -1376.929,  964.540,  -15.858 ), -1375.929,  966.140,  -1377.929,  962.540 );
    snowplowStops[484]   <-  snowplowStop( snowplowv3( -1366.714,  958.616,  -16.124 ), -1365.714,  960.216,  -1367.714,  956.616 );
    snowplowStops[485]   <-  snowplowStop( snowplowv3( -1359.603,  964.202,  -16.114 ), -1361.203,  965.202,  -1357.603,  963.202 );
    snowplowStops[486]   <-  snowplowStop( snowplowv3( -1367.043,  971.215,  -16.115 ), -1368.043,  973.215,  -1366.043,  969.615 );
    snowplowStops[487]   <-  snowplowStop( snowplowv3( -1367.514,  964.388,  -16.107 ), -1366.514,  965.988,  -1368.514,  962.388 );
    snowplowStops[488]   <-  snowplowStop( snowplowv3( -1350.324,  964.651,  -16.857 ), -1349.324,  966.251,  -1351.324,  962.651 );
    snowplowStops[489]   <-  snowplowStop( snowplowv3( -1344.638,  969.279,  -17.319 ), -1346.238,  970.279,  -1342.638,  968.279 );
    snowplowStops[490]   <-  snowplowStop( snowplowv3( -1344.003,  996.874,  -17.323 ), -1345.602,  997.874,  -1342.003,  995.874 );
    snowplowStops[491]   <-  snowplowStop( snowplowv3( -1344.685,  1029.644,  -17.320 ), -1346.284,  1030.644,  -1342.685,  1028.644 );
    snowplowStops[492]   <-  snowplowStop( snowplowv3( -1343.886,  1054.321,  -17.319 ), -1345.486,  1055.321,  -1341.886,  1053.321 );
    snowplowStops[493]   <-  snowplowStop( snowplowv3( -1349.136,  1058.671,  -17.087 ), -1350.136,  1060.671,  -1348.136,  1057.071 );
    snowplowStops[494]   <-  snowplowStop( snowplowv3( -1383.805,  1059.201,  -13.478 ), -1384.805,  1061.201,  -1382.805,  1057.601 );
    snowplowStops[495]   <-  snowplowStop( snowplowv3( -1398.182,  1059.230,  -13.312 ), -1399.182,  1061.230,  -1397.182,  1057.630 );
    snowplowStops[496]   <-  snowplowStop( snowplowv3( -1405.091,  1067.720,  -13.425 ), -1406.691,  1068.720,  -1403.091,  1066.720 );
    snowplowStops[497]   <-  snowplowStop( snowplowv3( -1405.076,  1120.023,  -13.426 ), -1406.676,  1121.023,  -1403.076,  1119.023 );
    snowplowStops[498]   <-  snowplowStop( snowplowv3( -1419.514,  1132.551,  -13.419 ), -1420.514,  1134.551,  -1418.514,  1130.951 );
    snowplowStops[499]   <-  snowplowStop( snowplowv3( -1495.149,  1132.673,  -10.683 ), -1496.149,  1134.673,  -1494.149,  1131.073 );
    snowplowStops[500]   <-  snowplowStop( snowplowv3( -1560.233,  1132.795,  -8.645 ), -1561.233,  1134.795,  -1559.233,  1131.195 );
    snowplowStops[501]   <-  snowplowStop( snowplowv3( -1647.913,  1132.561,  -6.980 ), -1648.913,  1134.561,  -1646.913,  1130.961 );
    snowplowStops[502]   <-  snowplowStop( snowplowv3( -1662.287,  1142.130,  -6.975 ), -1663.887,  1143.130,  -1660.287,  1141.130 );
    snowplowStops[503]   <-  snowplowStop( snowplowv3( -1672.917,  1195.316,  -5.733 ), -1674.517,  1196.316,  -1670.917,  1194.316 );
    snowplowStops[504]   <-  snowplowStop( snowplowv3( -1677.595,  1278.007,  -6.339 ), -1679.195,  1279.007,  -1675.595,  1277.007 );
    snowplowStops[505]   <-  snowplowStop( snowplowv3( -1683.568,  1365.112,  -7.191 ), -1685.168,  1366.112,  -1681.568,  1364.112 );
    snowplowStops[506]   <-  snowplowStop( snowplowv3( -1694.130,  1430.845,  -7.782 ), -1695.730,  1431.845,  -1692.130,  1429.845 );
    snowplowStops[507]   <-  snowplowStop( snowplowv3( -1631.437,  1521.728,  -12.015 ), -1633.037,  1522.728,  -1629.437,  1520.728 );
    snowplowStops[508]   <-  snowplowStop( snowplowv3( -1561.783,  1556.980,  -5.922 ), -1560.783,  1558.580,  -1562.783,  1554.980 );
    snowplowStops[509]   <-  snowplowStop( snowplowv3( -1509.006,  1514.941,  -9.112 ), -1511.006,  1515.941,  -1507.406,  1513.941 );
    snowplowStops[510]   <-  snowplowStop( snowplowv3( -1486.930,  1436.689,  -12.713 ), -1488.930,  1437.689,  -1485.330,  1435.689 );
    snowplowStops[511]   <-  snowplowStop( snowplowv3( -1420.945,  1387.591,  -13.490 ), -1419.945,  1389.191,  -1421.945,  1385.591 );
    snowplowStops[512]   <-  snowplowStop( snowplowv3( -1408.755,  1367.675,  -13.521 ), -1410.755,  1368.675,  -1407.155,  1366.675 );
    snowplowStops[513]   <-  snowplowStop( snowplowv3( -1408.597,  1291.759,  -13.409 ), -1410.597,  1292.759,  -1406.997,  1290.759 );
    snowplowStops[514]   <-  snowplowStop( snowplowv3( -1408.355,  1186.324,  -13.411 ), -1410.355,  1187.324,  -1406.755,  1185.324 );
    snowplowStops[515]   <-  snowplowStop( snowplowv3( -1392.561,  1174.219,  -13.404 ), -1391.561,  1175.819,  -1393.561,  1172.219 );
    snowplowStops[516]   <-  snowplowStop( snowplowv3( -1337.887,  1174.097,  -13.408 ), -1336.887,  1175.697,  -1338.887,  1172.097 );
    snowplowStops[517]   <-  snowplowStop( snowplowv3( -1331.660,  1166.068,  -13.510 ), -1333.660,  1167.068,  -1330.060,  1165.068 );
    snowplowStops[518]   <-  snowplowStop( snowplowv3( -1331.351,  1116.254,  -18.354 ), -1333.351,  1117.254,  -1329.751,  1115.254 );
    snowplowStops[519]   <-  snowplowStop( snowplowv3( -1331.390,  1050.341,  -18.364 ), -1333.390,  1051.341,  -1329.790,  1049.341 );
    snowplowStops[520]   <-  snowplowStop( snowplowv3( -1331.516,  986.880,  -18.351 ), -1333.516,  987.880,  -1329.916,  985.880 );
    snowplowStops[521]   <-  snowplowStop( snowplowv3( -1331.347,  933.814,  -18.354 ), -1333.347,  934.814,  -1329.747,  932.814 );
    snowplowStops[522]   <-  snowplowStop( snowplowv3( -1339.239,  928.070,  -18.301 ), -1340.239,  930.070,  -1338.239,  926.470 );
    snowplowStops[523]   <-  snowplowStop( snowplowv3( -1394.836,  928.066,  -13.935 ), -1395.836,  930.066,  -1393.836,  926.466 );
    snowplowStops[524]   <-  snowplowStop( snowplowv3( -1423.590,  927.912,  -13.438 ), -1424.590,  929.912,  -1422.590,  926.312 );
    snowplowStops[525]   <-  snowplowStop( snowplowv3( -1511.473,  927.819,  -7.794 ), -1512.473,  929.819,  -1510.473,  926.219 );
    snowplowStops[526]   <-  snowplowStop( snowplowv3( -1596.995,  927.769,  -4.933 ), -1597.995,  929.769,  -1595.995,  926.169 );
    snowplowStops[527]   <-  snowplowStop( snowplowv3( -1619.432,  910.581,  -4.894 ), -1621.432,  911.581,  -1617.832,  909.581 );
    snowplowStops[528]   <-  snowplowStop( snowplowv3( -1615.103,  823.785,  -4.211 ), -1617.103,  824.785,  -1613.503,  822.785 );
    snowplowStops[529]   <-  snowplowStop( snowplowv3( -1615.120,  745.842,  -9.889 ), -1617.120,  746.842,  -1613.520,  744.842 );
    snowplowStops[530]   <-  snowplowStop( snowplowv3( -1615.060,  649.308,  -10.047 ), -1617.060,  650.308,  -1613.460,  648.308 );
    snowplowStops[531]   <-  snowplowStop( snowplowv3( -1615.031,  620.966,  -10.043 ), -1617.031,  621.966,  -1613.431,  619.966 );
    snowplowStops[532]   <-  snowplowStop( snowplowv3( -1588.813,  610.263,  -10.046 ), -1587.813,  611.863,  -1589.813,  608.263 );
    snowplowStops[533]   <-  snowplowStop( snowplowv3( -1527.642,  610.304,  -8.231 ), -1526.642,  611.904,  -1528.642,  608.304 );
    snowplowStops[534]   <-  snowplowStop( snowplowv3( -1462.368,  610.262,  -3.712 ), -1461.368,  611.862,  -1463.368,  608.262 );
    snowplowStops[535]   <-  snowplowStop( snowplowv3( -1392.179,  610.299,  3.298 ), -1391.179,  611.899,  -1393.179,  608.299 );
    snowplowStops[536]   <-  snowplowStop( snowplowv3( -1322.505,  610.193,  9.845 ), -1321.505,  611.793,  -1323.505,  608.193 );
    snowplowStops[537]   <-  snowplowStop( snowplowv3( -1251.756,  610.520,  15.654 ), -1250.756,  612.120,  -1252.756,  608.520 );
    snowplowStops[538]   <-  snowplowStop( snowplowv3( -1182.731,  610.116,  19.888 ), -1181.731,  611.716,  -1183.731,  608.116 );
    snowplowStops[539]   <-  snowplowStop( snowplowv3( -1114.985,  610.404,  21.830 ), -1113.985,  612.004,  -1115.985,  608.404 );
    snowplowStops[540]   <-  snowplowStop( snowplowv3( -1042.932,  610.388,  22.435 ), -1041.932,  611.988,  -1043.932,  608.388 );
    snowplowStops[541]   <-  snowplowStop( snowplowv3( -974.013,  610.101,  22.154 ), -973.013,  611.701,  -975.013,  608.101 );
    snowplowStops[542]   <-  snowplowStop( snowplowv3( -906.720,  610.035,  21.080 ), -905.720,  611.635,  -907.720,  608.035 );
    snowplowStops[543]   <-  snowplowStop( snowplowv3( -833.574,  610.246,  19.109 ), -832.574,  611.846,  -834.574,  608.246 );
    snowplowStops[544]   <-  snowplowStop( snowplowv3( -764.161,  610.182,  16.454 ), -763.161,  611.782,  -765.161,  608.182 );
    snowplowStops[545]   <-  snowplowStop( snowplowv3( -696.112,  610.297,  13.027 ), -695.112,  611.897,  -697.112,  608.297 );
    snowplowStops[546]   <-  snowplowStop( snowplowv3( -625.681,  610.347,  8.717 ), -624.681,  611.947,  -626.681,  608.347 );
    snowplowStops[547]   <-  snowplowStop( snowplowv3( -558.082,  610.293,  3.827 ), -557.082,  611.893,  -559.082,  608.293 );
    snowplowStops[548]   <-  snowplowStop( snowplowv3( -511.563,  610.226,  1.517 ), -510.563,  611.826,  -512.563,  608.226 );

    // Route 5
    snowplowStops[549]   <-  snowplowStop( snowplowv3( -378.818,  614.172,  -10.261 ), -377.818,  615.772,  -379.818,  612.172 ); // спуск вниз направо 1
    snowplowStops[550]   <-  snowplowStop( snowplowv3( -320.779,  640.056,  -16.782 ), -319.779,  641.656,  -321.779,  638.056 ); // спуск вниз направо 2
    snowplowStops[551]   <-  snowplowStop( snowplowv3( -283.347,  686.835,  -19.930 ), -282.347,  688.435,  -284.347,  684.835 ); // спуск вниз направо 3
    snowplowStops[552]   <-  snowplowStop( snowplowv3( -243.208,  689.001,  -19.984 ), -242.208,  690.601,  -244.208,  687.001 ); // спуск вниз направо 4 у арки
    snowplowStops[553]   <-  snowplowStop( snowplowv3( -230.135,  700.445,  -19.995 ), -231.735,  701.445,  -228.135,  699.445 ); // после арки налево 1
    snowplowStops[554]   <-  snowplowStop( snowplowv3( -229.847,  785.937,  -19.992 ), -231.447,  786.937,  -227.847,  784.937 ); // после арки налево 2
    snowplowStops[555]   <-  snowplowStop( snowplowv3( -242.572,  803.727,  -19.981 ), -243.572,  805.727,  -241.572,  802.127 );
    snowplowStops[556]   <-  snowplowStop( snowplowv3( -304.638,  803.880,  -19.988 ), -305.638,  805.880,  -303.638,  802.280 );
    snowplowStops[557]   <-  snowplowStop( snowplowv3( -377.359,  803.959,  -19.985 ), -378.359,  805.959,  -376.359,  802.359 );
    snowplowStops[558]   <-  snowplowStop( snowplowv3( -408.324,  804.199,  -19.959 ), -409.324,  806.199,  -407.324,  802.599 );
    snowplowStops[559]   <-  snowplowStop( snowplowv3( -390.836,  816.655,  -19.956 ), -392.436,  817.655,  -388.836,  815.655 );
    snowplowStops[560]   <-  snowplowStop( snowplowv3( -390.675,  879.278,  -19.841 ), -392.275,  880.278,  -388.675,  878.278 );
    snowplowStops[561]   <-  snowplowStop( snowplowv3( -391.329,  898.241,  -19.837 ), -392.329,  900.241,  -390.329,  896.641 );
    snowplowStops[562]   <-  snowplowStop( snowplowv3( -396.152,  878.983,  -19.834 ), -398.152,  879.983,  -394.552,  877.983 );
    snowplowStops[563]   <-  snowplowStop( snowplowv3( -395.836,  816.886,  -19.957 ), -397.836,  817.886,  -394.236,  815.886 );
    snowplowStops[564]   <-  snowplowStop( snowplowv3( -407.962,  804.454,  -19.950 ), -408.962,  806.454,  -406.962,  802.854 );
    snowplowStops[565]   <-  snowplowStop( snowplowv3( -464.473,  804.836,  -19.599 ), -465.473,  806.836,  -463.473,  803.236 );
    snowplowStops[566]   <-  snowplowStop( snowplowv3( -496.763,  831.610,  -19.342 ), -498.363,  832.610,  -494.763,  830.610 );
    snowplowStops[567]   <-  snowplowStop( snowplowv3( -497.075,  907.692,  -18.922 ), -498.675,  908.692,  -495.075,  906.692 );
    snowplowStops[568]   <-  snowplowStop( snowplowv3( -488.827,  922.764,  -18.800 ), -487.827,  924.364,  -489.827,  920.764 );
    snowplowStops[569]   <-  snowplowStop( snowplowv3( -397.951,  981.665,  -6.436 ), -396.951,  983.265,  -398.951,  979.665 );
    snowplowStops[570]   <-  snowplowStop( snowplowv3( -288.791,  1003.502,  5.357 ), -290.391,  1004.502,  -286.791,  1002.502 );
    snowplowStops[571]   <-  snowplowStop( snowplowv3( -362.239,  1030.026,  13.807 ), -363.239,  1032.026,  -361.239,  1028.426 );
    snowplowStops[572]   <-  snowplowStop( snowplowv3( -446.313,  1025.439,  20.980 ), -447.313,  1027.439,  -445.313,  1023.839 );
    snowplowStops[573]   <-  snowplowStop( snowplowv3( -515.182,  1053.704,  28.812 ), -516.782,  1054.704,  -513.182,  1052.704 );
    snowplowStops[574]   <-  snowplowStop( snowplowv3( -518.678,  1135.102,  32.141 ), -520.278,  1136.102,  -516.678,  1134.102 );
    snowplowStops[575]   <-  snowplowStop( snowplowv3( -533.134,  1151.863,  32.186 ), -534.134,  1153.863,  -532.134,  1150.263 );
    snowplowStops[576]   <-  snowplowStop( snowplowv3( -599.848,  1157.503,  30.635 ), -600.848,  1159.503,  -598.848,  1155.904 );
    snowplowStops[577]   <-  snowplowStop( snowplowv3( -661.317,  1220.980,  22.911 ), -662.917,  1221.980,  -659.317,  1219.980 );
    snowplowStops[578]   <-  snowplowStop( snowplowv3( -601.409,  1262.281,  20.167 ), -600.409,  1263.881,  -602.409,  1260.281 );
    snowplowStops[579]   <-  snowplowStop( snowplowv3( -505.842,  1310.361,  25.328 ), -507.442,  1311.361,  -503.842,  1309.361 );
    snowplowStops[580]   <-  snowplowStop( snowplowv3( -493.383,  1317.017,  26.601 ), -492.383,  1318.617,  -494.383,  1315.017 );
    snowplowStops[581]   <-  snowplowStop( snowplowv3( -458.481,  1334.654,  30.864 ), -457.481,  1336.253,  -459.481,  1332.654 );
    snowplowStops[582]   <-  snowplowStop( snowplowv3( -379.919,  1362.230,  39.531 ), -378.919,  1363.830,  -380.919,  1360.230 );
    snowplowStops[583]   <-  snowplowStop( snowplowv3( -294.427,  1353.026,  46.933 ), -293.427,  1354.626,  -295.427,  1351.026 );
    snowplowStops[584]   <-  snowplowStop( snowplowv3( -220.257,  1277.531,  54.096 ), -222.257,  1278.531,  -218.657,  1276.531 );
    snowplowStops[585]   <-  snowplowStop( snowplowv3( -201.133,  1258.197,  54.162 ), -200.133,  1259.797,  -202.133,  1256.197 );
    snowplowStops[586]   <-  snowplowStop( snowplowv3( -115.811,  1261.585,  63.158 ), -114.811,  1263.185,  -116.811,  1259.585 );
    snowplowStops[587]   <-  snowplowStop( snowplowv3( -48.788,  1254.543,  64.722 ), -47.788,  1256.143,  -49.788,  1252.543 );
    snowplowStops[588]   <-  snowplowStop( snowplowv3( 13.204,  1226.067,  66.648 ), 14.204,  1227.667,  12.204,  1224.067 );
    snowplowStops[589]   <-  snowplowStop( snowplowv3( 75.619,  1211.015,  66.845 ), 76.619,  1212.615,  74.619,  1209.015 );
    snowplowStops[590]   <-  snowplowStop( snowplowv3( 133.131,  1211.113,  63.237 ), 134.131,  1212.713,  132.131,  1209.113 );
    snowplowStops[591]   <-  snowplowStop( snowplowv3( 177.864,  1211.983,  61.999 ), 178.864,  1213.583,  176.864,  1209.983 );
    snowplowStops[592]   <-  snowplowStop( snowplowv3( 221.472,  1212.184,  62.739 ), 222.472,  1213.784,  220.472,  1210.184 );
    snowplowStops[593]   <-  snowplowStop( snowplowv3( 273.870,  1212.403,  63.557 ), 274.870,  1214.003,  272.870,  1210.403 );
    snowplowStops[594]   <-  snowplowStop( snowplowv3( 286.668,  1228.531,  63.537 ), 285.068,  1229.531,  288.668,  1227.531 );
    snowplowStops[595]   <-  snowplowStop( snowplowv3( 277.069,  1275.378,  60.319 ), 276.069,  1277.378,  278.069,  1273.778 );
    snowplowStops[596]   <-  snowplowStop( snowplowv3( 215.878,  1274.510,  57.096 ), 214.878,  1276.510,  216.878,  1272.910 );
    snowplowStops[597]   <-  snowplowStop( snowplowv3( 150.539,  1269.267,  59.243 ), 149.539,  1271.267,  151.539,  1267.667 );
    snowplowStops[598]   <-  snowplowStop( snowplowv3( 142.466,  1227.241,  63.112 ), 140.466,  1228.241,  144.066,  1226.241 );
    snowplowStops[599]   <-  snowplowStop( snowplowv3( 132.618,  1214.851,  63.256 ), 131.618,  1216.851,  133.618,  1213.251 );
    snowplowStops[600]   <-  snowplowStop( snowplowv3( 75.615,  1215.286,  66.819 ), 74.615,  1217.286,  76.615,  1213.686 );
    snowplowStops[601]   <-  snowplowStop( snowplowv3( 10.753,  1231.814,  66.278 ), 9.753,  1233.814,  11.753,  1230.214 );
    snowplowStops[602]   <-  snowplowStop( snowplowv3( -80.268,  1265.898,  64.176 ), -81.268,  1267.898,  -79.268,  1264.298 );
    snowplowStops[603]   <-  snowplowStop( snowplowv3( -141.392,  1264.892,  61.698 ), -142.392,  1266.892,  -140.392,  1263.292 );
    snowplowStops[604]   <-  snowplowStop( snowplowv3( -200.579,  1262.228,  54.180 ), -201.579,  1264.228,  -199.579,  1260.628 );
    snowplowStops[605]   <-  snowplowStop( snowplowv3( -219.991,  1243.822,  53.952 ), -221.991,  1244.822,  -218.391,  1242.822 );
    snowplowStops[606]   <-  snowplowStop( snowplowv3( -225.889,  1172.411,  52.520 ), -227.889,  1173.411,  -224.289,  1171.411 );
    snowplowStops[607]   <-  snowplowStop( snowplowv3( -243.104,  1092.357,  50.168 ), -245.104,  1093.357,  -241.504,  1091.357 );
    snowplowStops[608]   <-  snowplowStop( snowplowv3( -311.207,  1063.574,  45.652 ), -312.207,  1065.574,  -310.207,  1061.974 );
    snowplowStops[609]   <-  snowplowStop( snowplowv3( -372.008,  1078.815,  44.234 ), -373.008,  1080.815,  -371.008,  1077.215 );
    snowplowStops[610]   <-  snowplowStop( snowplowv3( -445.954,  1136.961,  36.621 ), -446.954,  1138.961,  -444.954,  1135.361 );
    snowplowStops[611]   <-  snowplowStop( snowplowv3( -507.991,  1151.956,  32.212 ), -508.991,  1153.956,  -506.991,  1150.356 );
    snowplowStops[612]   <-  snowplowStop( snowplowv3( -518.907,  1166.693,  32.324 ), -520.507,  1167.693,  -516.907,  1165.693 );
    snowplowStops[613]   <-  snowplowStop( snowplowv3( -504.286,  1234.353,  38.434 ), -505.886,  1235.353,  -502.286,  1233.353 );
    snowplowStops[614]   <-  snowplowStop( snowplowv3( -459.640,  1249.611,  43.830 ), -458.640,  1251.211,  -460.640,  1247.611 );
    snowplowStops[615]   <-  snowplowStop( snowplowv3( -384.150,  1250.514,  50.453 ), -383.150,  1252.114,  -385.150,  1248.514 );
    snowplowStops[616]   <-  snowplowStop( snowplowv3( -313.956,  1261.314,  54.392 ), -312.956,  1262.914,  -314.956,  1259.314 );
    snowplowStops[617]   <-  snowplowStop( snowplowv3( -232.148,  1257.885,  54.193 ), -231.148,  1259.485,  -233.148,  1255.885 );
    snowplowStops[618]   <-  snowplowStop( snowplowv3( -215.787,  1277.927,  54.097 ), -217.387,  1278.927,  -213.787,  1276.927 );
    snowplowStops[619]   <-  snowplowStop( snowplowv3( -242.606,  1345.758,  51.257 ), -243.606,  1347.758,  -241.606,  1344.158 );
    snowplowStops[620]   <-  snowplowStop( snowplowv3( -292.471,  1357.060,  47.076 ), -293.471,  1359.060,  -291.471,  1355.460 );
    snowplowStops[621]   <-  snowplowStop( snowplowv3( -379.065,  1366.382,  39.617 ), -380.065,  1368.382,  -378.065,  1364.782 );
    snowplowStops[622]   <-  snowplowStop( snowplowv3( -460.219,  1338.740,  30.929 ), -461.219,  1340.740,  -459.219,  1337.140 );
    snowplowStops[623]   <-  snowplowStop( snowplowv3( -493.361,  1320.852,  26.607 ), -494.361,  1322.852,  -492.361,  1319.252 );
    snowplowStops[624]   <-  snowplowStop( snowplowv3( -509.690,  1312.527,  25.050 ), -511.690,  1313.527,  -508.090,  1311.527 );
    snowplowStops[625]   <-  snowplowStop( snowplowv3( -599.609,  1266.792,  20.210 ), -600.609,  1268.792,  -598.609,  1265.192 );
    snowplowStops[626]   <-  snowplowStop( snowplowv3( -665.889,  1220.140,  23.003 ), -667.889,  1221.140,  -664.289,  1219.140 );
    snowplowStops[627]   <-  snowplowStop( snowplowv3( -598.867,  1152.417,  30.718 ), -597.867,  1154.017,  -599.867,  1150.417 );
    snowplowStops[628]   <-  snowplowStop( snowplowv3( -533.818,  1147.581,  32.178 ), -532.818,  1149.181,  -534.818,  1145.581 );
    snowplowStops[629]   <-  snowplowStop( snowplowv3( -523.315,  1134.878,  32.133 ), -525.315,  1135.878,  -521.715,  1133.878 );
    snowplowStops[630]   <-  snowplowStop( snowplowv3( -519.093,  1053.028,  28.861 ), -521.093,  1054.028,  -517.493,  1052.028 );
    snowplowStops[631]   <-  snowplowStop( snowplowv3( -446.639,  1021.301,  20.993 ), -445.639,  1022.901,  -447.639,  1019.301 );
    snowplowStops[632]   <-  snowplowStop( snowplowv3( -362.420,  1025.834,  13.829 ), -361.420,  1027.434,  -363.420,  1023.834 );
    snowplowStops[633]   <-  snowplowStop( snowplowv3( -294.907,  1003.788,  5.385 ), -296.907,  1004.788,  -293.307,  1002.788 );
    snowplowStops[634]   <-  snowplowStop( snowplowv3( -397.724,  985.754,  -6.419 ), -398.724,  987.754,  -396.724,  984.154 );
    snowplowStops[635]   <-  snowplowStop( snowplowv3( -489.840,  927.296,  -18.820 ), -490.840,  929.296,  -488.840,  925.696 );
    snowplowStops[636]   <-  snowplowStop( snowplowv3( -511.883,  918.811,  -18.906 ), -512.883,  920.811,  -510.883,  917.211 );
    snowplowStops[637]   <-  snowplowStop( snowplowv3( -572.054,  918.806,  -18.903 ), -573.054,  920.806,  -571.054,  917.206 );
    snowplowStops[638]   <-  snowplowStop( snowplowv3( -621.987,  919.154,  -18.760 ), -622.987,  921.154,  -620.987,  917.554 );
    snowplowStops[639]   <-  snowplowStop( snowplowv3( -633.579,  905.404,  -18.752 ), -635.579,  906.404,  -631.979,  904.404 );
    snowplowStops[640]   <-  snowplowStop( snowplowv3( -633.721,  867.672,  -18.754 ), -635.721,  868.672,  -632.121,  866.672 );
    snowplowStops[641]   <-  snowplowStop( snowplowv3( -633.714,  815.356,  -18.751 ), -635.714,  816.356,  -632.114,  814.356 );
    snowplowStops[642]   <-  snowplowStop( snowplowv3( -646.041,  804.126,  -18.749 ), -647.041,  806.126,  -645.041,  802.526 );
    snowplowStops[643]   <-  snowplowStop( snowplowv3( -678.706,  804.126,  -18.752 ), -679.706,  806.126,  -677.706,  802.526 );
    snowplowStops[644]   <-  snowplowStop( snowplowv3( -731.169,  804.017,  -18.753 ), -732.169,  806.017,  -730.169,  802.417 );
    snowplowStops[645]   <-  snowplowStop( snowplowv3( -744.676,  789.705,  -18.692 ), -746.676,  790.705,  -743.076,  788.705 );
    snowplowStops[646]   <-  snowplowStop( snowplowv3( -744.779,  740.364,  -17.121 ), -746.779,  741.364,  -743.179,  739.364 );
    snowplowStops[647]   <-  snowplowStop( snowplowv3( -729.913,  730.245,  -17.013 ), -728.913,  731.845,  -730.913,  728.245 );
    snowplowStops[648]   <-  snowplowStop( snowplowv3( -686.082,  729.755,  -12.676 ), -685.082,  731.355,  -687.082,  727.755 );
    snowplowStops[649]   <-  snowplowStop( snowplowv3( -673.930,  716.917,  -12.114 ), -675.930,  717.917,  -672.330,  715.917 );
    snowplowStops[650]   <-  snowplowStop( snowplowv3( -674.273,  671.167,  -6.410 ), -676.273,  672.167,  -672.673,  670.167 );
    snowplowStops[651]   <-  snowplowStop( snowplowv3( -674.256,  599.183,  1.049 ), -676.256,  600.183,  -672.656,  598.183 );
    snowplowStops[652]   <-  snowplowStop( snowplowv3( -655.770,  582.935,  1.196 ), -654.770,  584.535,  -656.770,  580.935 );
    snowplowStops[653]   <-  snowplowStop( snowplowv3( -600.096,  582.867,  -1.065 ), -599.096,  584.467,  -601.096,  580.867 );
    snowplowStops[654]   <-  snowplowStop( snowplowv3( -545.930,  582.965,  -4.007 ), -544.930,  584.564,  -546.930,  580.965 );
    snowplowStops[655]   <-  snowplowStop( snowplowv3( -485.002,  582.927,  -7.102 ), -484.002,  584.527,  -486.002,  580.927 );
    snowplowStops[656]   <-  snowplowStop( snowplowv3( -416.893,  583.142,  -9.963 ), -415.893,  584.742,  -417.893,  581.142 );

    // Route 6
    snowplowStops[657]   <-  snowplowStop( snowplowv3( -219.067,  800.898,  -20.019 ), -218.067,  802.498,  -220.067,  798.898 );
    snowplowStops[658]   <-  snowplowStop( snowplowv3( -185.320,  801.166,  -20.568 ), -184.320,  802.766,  -186.320,  799.166 );
    snowplowStops[659]   <-  snowplowStop( snowplowv3( -149.292,  801.504,  -20.811 ), -148.292,  803.104,  -150.292,  799.504 );
    snowplowStops[660]   <-  snowplowStop( snowplowv3( -94.695,  813.330,  -22.702 ), -93.695,  814.930,  -95.695,  811.330 );
    snowplowStops[661]   <-  snowplowStop( snowplowv3( -54.601,  823.026,  -24.312 ), -53.601,  824.626,  -55.601,  821.026 );
    snowplowStops[662]   <-  snowplowStop( snowplowv3( -39.192,  806.069,  -24.054 ), -41.192,  807.069,  -37.592,  805.069 );
    snowplowStops[663]   <-  snowplowStop( snowplowv3( -39.137,  772.327,  -21.915 ), -41.137,  773.327,  -37.537,  771.327 );
    snowplowStops[664]   <-  snowplowStop( snowplowv3( -39.057,  732.756,  -21.835 ), -41.057,  733.756,  -37.457,  731.756 );
    snowplowStops[665]   <-  snowplowStop( snowplowv3( -39.031,  718.475,  -21.826 ), -41.031,  719.475,  -37.431,  717.475 );
    snowplowStops[666]   <-  snowplowStop( snowplowv3( -22.138,  705.868,  -21.818 ), -21.138,  707.468,  -23.138,  703.868 );
    snowplowStops[667]   <-  snowplowStop( snowplowv3( 20.700,  705.896,  -21.727 ), 21.700,  707.496,  19.700,  703.896 );
    snowplowStops[668]   <-  snowplowStop( snowplowv3( 37.193,  723.921,  -21.838 ), 35.593,  724.921,  39.193,  722.921 );
    snowplowStops[669]   <-  snowplowStop( snowplowv3( 33.204,  805.181,  -24.196 ), 31.604,  806.181,  35.204,  804.181 );
    snowplowStops[670]   <-  snowplowStop( snowplowv3( 43.927,  818.848,  -24.411 ), 44.927,  820.448,  42.927,  816.848 );
    snowplowStops[671]   <-  snowplowStop( snowplowv3( 77.344,  823.299,  -22.039 ), 78.344,  824.899,  76.344,  821.299 );
    snowplowStops[672]   <-  snowplowStop( snowplowv3( 113.624,  823.285,  -19.553 ), 114.624,  824.885,  112.624,  821.285 );
    snowplowStops[673]   <-  snowplowStop( snowplowv3( 126.304,  841.644,  -19.639 ), 124.704,  842.644,  128.304,  840.644 );
    snowplowStops[674]   <-  snowplowStop( snowplowv3( 126.345,  894.451,  -21.796 ), 124.745,  895.451,  128.345,  893.451 );
    snowplowStops[675]   <-  snowplowStop( snowplowv3( 126.377,  938.589,  -22.090 ), 124.777,  939.589,  128.377,  937.589 );
    snowplowStops[676]   <-  snowplowStop( snowplowv3( 91.001,  990.793,  -18.745 ), 89.401,  991.793,  93.001,  989.793 );
    snowplowStops[677]   <-  snowplowStop( snowplowv3( 44.868,  1000.588,  -14.811 ), 43.868,  1002.588,  45.868,  998.988 );
    snowplowStops[678]   <-  snowplowStop( snowplowv3( -22.676,  1029.284,  -11.009 ), -24.276,  1030.284,  -20.676,  1028.284 );
    snowplowStops[679]   <-  snowplowStop( snowplowv3( -46.997,  1091.273,  -10.992 ), -48.597,  1092.273,  -44.997,  1090.273 );
    snowplowStops[680]   <-  snowplowStop( snowplowv3( -82.928,  1203.184,  -13.629 ), -84.528,  1204.184,  -80.928,  1202.184 );
    snowplowStops[681]   <-  snowplowStop( snowplowv3( -117.032,  1302.424,  -15.138 ), -118.632,  1303.424,  -115.032,  1301.424 );
    snowplowStops[682]   <-  snowplowStop( snowplowv3( -118.122,  1388.627,  -15.143 ), -119.722,  1389.627,  -116.122,  1387.627 );
    snowplowStops[683]   <-  snowplowStop( snowplowv3( -117.918,  1458.643,  -15.144 ), -119.518,  1459.643,  -115.918,  1457.643 );
    snowplowStops[684]   <-  snowplowStop( snowplowv3( -152.716,  1541.564,  -18.031 ), -154.316,  1542.564,  -150.716,  1540.564 );
    snowplowStops[685]   <-  snowplowStop( snowplowv3( -231.177,  1575.400,  -24.161 ), -232.177,  1577.400,  -230.177,  1573.800 );
    snowplowStops[686]   <-  snowplowStop( snowplowv3( -291.328,  1575.899,  -23.448 ), -292.328,  1577.899,  -290.328,  1574.299 );
    snowplowStops[687]   <-  snowplowStop( snowplowv3( -299.425,  1589.434,  -23.342 ), -301.025,  1590.434,  -297.425,  1588.434 );
    snowplowStops[688]   <-  snowplowStop( snowplowv3( -288.549,  1606.029,  -23.100 ), -287.549,  1607.628,  -289.549,  1604.029 );
    snowplowStops[689]   <-  snowplowStop( snowplowv3( -241.185,  1606.417,  -22.675 ), -240.185,  1608.017,  -242.185,  1604.417 );
    snowplowStops[690]   <-  snowplowStop( snowplowv3( -199.780,  1607.589,  -23.424 ), -198.780,  1609.189,  -200.780,  1605.589 );
    snowplowStops[691]   <-  snowplowStop( snowplowv3( -181.250,  1593.241,  -23.425 ), -183.250,  1594.241,  -179.650,  1592.241 );
    snowplowStops[692]   <-  snowplowStop( snowplowv3( -160.574,  1566.395,  -23.422 ), -159.574,  1567.995,  -161.574,  1564.395 );
    snowplowStops[693]   <-  snowplowStop( snowplowv3( -130.036,  1568.647,  -23.415 ), -129.036,  1570.247,  -131.036,  1566.647 );
    snowplowStops[694]   <-  snowplowStop( snowplowv3( -85.702,  1595.506,  -22.514 ), -84.702,  1597.106,  -86.702,  1593.506 );
    snowplowStops[695]   <-  snowplowStop( snowplowv3( -41.320,  1629.300,  -19.742 ), -40.320,  1630.900,  -42.320,  1627.300 );
    snowplowStops[696]   <-  snowplowStop( snowplowv3( -10.202,  1649.957,  -19.912 ), -9.202,  1651.557,  -11.202,  1647.957 );
    snowplowStops[697]   <-  snowplowStop( snowplowv3( -8.637,  1668.964,  -19.816 ), -10.237,  1669.964,  -6.637,  1667.964 );
    snowplowStops[698]   <-  snowplowStop( snowplowv3( 4.372,  1658.342,  -19.901 ), 3.372,  1660.342,  5.372,  1656.742 );
    snowplowStops[699]   <-  snowplowStop( snowplowv3( -12.545,  1653.269,  -19.908 ), -13.545,  1655.269,  -11.545,  1651.669 );
    snowplowStops[700]   <-  snowplowStop( snowplowv3( -45.313,  1632.284,  -19.854 ), -46.313,  1634.284,  -44.313,  1630.685 );
    snowplowStops[701]   <-  snowplowStop( snowplowv3( -95.607,  1596.331,  -23.017 ), -96.607,  1598.331,  -94.607,  1594.731 );
    snowplowStops[702]   <-  snowplowStop( snowplowv3( -132.352,  1574.478,  -23.412 ), -133.352,  1576.478,  -131.352,  1572.878 );
    snowplowStops[703]   <-  snowplowStop( snowplowv3( -160.522,  1572.974,  -23.423 ), -161.522,  1574.974,  -159.522,  1571.374 );
    snowplowStops[704]   <-  snowplowStop( snowplowv3( -174.232,  1593.323,  -23.424 ), -175.832,  1594.323,  -172.232,  1592.323 );
    snowplowStops[705]   <-  snowplowStop( snowplowv3( -200.399,  1612.886,  -23.431 ), -201.399,  1614.886,  -199.399,  1611.286 );
    snowplowStops[706]   <-  snowplowStop( snowplowv3( -241.369,  1613.050,  -22.667 ), -242.369,  1615.050,  -240.369,  1611.450 );
    snowplowStops[707]   <-  snowplowStop( snowplowv3( -289.008,  1613.971,  -23.102 ), -290.008,  1615.971,  -288.008,  1612.371 );
    snowplowStops[708]   <-  snowplowStop( snowplowv3( -299.898,  1624.274,  -23.086 ), -301.498,  1625.274,  -297.898,  1623.274 );
    snowplowStops[709]   <-  snowplowStop( snowplowv3( -300.061,  1665.796,  -22.115 ), -301.661,  1666.796,  -298.061,  1664.796 );
    snowplowStops[710]   <-  snowplowStop( snowplowv3( -300.210,  1728.770,  -22.713 ), -301.810,  1729.770,  -298.210,  1727.770 );
    snowplowStops[711]   <-  snowplowStop( snowplowv3( -299.731,  1784.456,  -23.391 ), -301.331,  1785.456,  -297.731,  1783.456 );
    snowplowStops[712]   <-  snowplowStop( snowplowv3( -314.308,  1796.333,  -23.412 ), -315.308,  1798.333,  -313.308,  1794.733 );
    snowplowStops[713]   <-  snowplowStop( snowplowv3( -371.424,  1796.126,  -23.431 ), -372.424,  1798.126,  -370.424,  1794.526 );
    snowplowStops[714]   <-  snowplowStop( snowplowv3( -406.859,  1796.807,  -23.428 ), -407.859,  1798.807,  -405.859,  1795.207 );
    snowplowStops[715]   <-  snowplowStop( snowplowv3( -460.925,  1796.647,  -19.243 ), -461.925,  1798.647,  -459.925,  1795.047 );
    snowplowStops[716]   <-  snowplowStop( snowplowv3( -502.280,  1796.695,  -15.150 ), -503.280,  1798.695,  -501.280,  1795.095 );
    snowplowStops[717]   <-  snowplowStop( snowplowv3( -563.376,  1796.744,  -14.942 ), -564.376,  1798.744,  -562.376,  1795.144 );
    snowplowStops[718]   <-  snowplowStop( snowplowv3( -620.365,  1796.697,  -14.934 ), -621.365,  1798.697,  -619.365,  1795.097 );
    snowplowStops[719]   <-  snowplowStop( snowplowv3( -700.159,  1796.529,  -14.902 ), -701.159,  1798.529,  -699.159,  1794.929 );
    snowplowStops[720]   <-  snowplowStop( snowplowv3( -734.144,  1776.538,  -14.888 ), -736.144,  1777.538,  -732.544,  1775.538 );
    snowplowStops[721]   <-  snowplowStop( snowplowv3( -739.462,  1753.963,  -14.882 ), -741.462,  1754.963,  -737.862,  1752.963 );
    snowplowStops[722]   <-  snowplowStop( snowplowv3( -739.555,  1700.608,  -14.802 ), -741.555,  1701.608,  -737.955,  1699.608 );
    snowplowStops[723]   <-  snowplowStop( snowplowv3( -739.563,  1647.868,  -14.770 ), -741.563,  1648.868,  -737.963,  1646.868 );
    snowplowStops[724]   <-  snowplowStop( snowplowv3( -735.329,  1612.609,  -13.905 ), -737.329,  1613.609,  -733.729,  1611.609 );
    snowplowStops[725]   <-  snowplowStop( snowplowv3( -728.584,  1577.835,  -12.470 ), -730.584,  1578.835,  -726.984,  1576.835 );
    snowplowStops[726]   <-  snowplowStop( snowplowv3( -708.615,  1562.186,  -13.572 ), -707.615,  1563.786,  -709.615,  1560.186 );
    snowplowStops[727]   <-  snowplowStop( snowplowv3( -650.575,  1564.130,  -16.355 ), -649.575,  1565.730,  -651.575,  1562.130 );
    snowplowStops[728]   <-  snowplowStop( snowplowv3( -577.107,  1564.252,  -16.731 ), -576.107,  1565.852,  -578.107,  1562.252 );
    snowplowStops[729]   <-  snowplowStop( snowplowv3( -522.555,  1564.546,  -14.952 ), -521.555,  1566.146,  -523.555,  1562.546 );
    snowplowStops[730]   <-  snowplowStop( snowplowv3( -505.430,  1576.547,  -16.103 ), -504.430,  1578.147,  -506.430,  1574.547 );
    snowplowStops[731]   <-  snowplowStop( snowplowv3( -503.235,  1591.515,  -16.445 ), -504.835,  1592.515,  -501.235,  1590.515 );
    snowplowStops[732]   <-  snowplowStop( snowplowv3( -517.351,  1598.660,  -15.913 ), -518.351,  1600.660,  -516.351,  1597.060 );
    snowplowStops[733]   <-  snowplowStop( snowplowv3( -531.480,  1593.755,  -16.296 ), -532.480,  1595.755,  -530.480,  1592.155 );
    snowplowStops[734]   <-  snowplowStop( snowplowv3( -551.662,  1594.086,  -16.302 ), -552.662,  1596.086,  -550.662,  1592.486 );
    snowplowStops[735]   <-  snowplowStop( snowplowv3( -563.397,  1599.634,  -16.290 ), -564.397,  1601.634,  -562.397,  1598.034 );
    snowplowStops[736]   <-  snowplowStop( snowplowv3( -585.008,  1599.904,  -16.294 ), -586.008,  1601.904,  -584.008,  1598.304 );
    snowplowStops[737]   <-  snowplowStop( snowplowv3( -598.805,  1595.049,  -16.307 ), -599.805,  1597.049,  -597.805,  1593.449 );
    snowplowStops[738]   <-  snowplowStop( snowplowv3( -632.513,  1593.990,  -16.480 ), -633.513,  1595.990,  -631.513,  1592.390 );
    snowplowStops[739]   <-  snowplowStop( snowplowv3( -643.887,  1582.262,  -16.485 ), -645.887,  1583.262,  -642.287,  1581.262 );
    snowplowStops[740]   <-  snowplowStop( snowplowv3( -652.625,  1575.561,  -16.476 ), -653.625,  1577.561,  -651.625,  1573.961 );
    snowplowStops[741]   <-  snowplowStop( snowplowv3( -709.663,  1572.830,  -13.717 ), -710.663,  1574.830,  -708.663,  1571.230 );
    snowplowStops[742]   <-  snowplowStop( snowplowv3( -744.594,  1562.723,  -10.854 ), -745.594,  1564.723,  -743.594,  1561.123 );
    snowplowStops[743]   <-  snowplowStop( snowplowv3( -788.918,  1545.887,  -6.281 ), -789.918,  1547.887,  -787.918,  1544.287 );
    snowplowStops[744]   <-  snowplowStop( snowplowv3( -832.575,  1527.161,  -5.902 ), -833.575,  1529.161,  -831.575,  1525.561 );
    snowplowStops[745]   <-  snowplowStop( snowplowv3( -848.910,  1502.344,  -5.541 ), -850.910,  1503.344,  -847.310,  1501.344 );
    snowplowStops[746]   <-  snowplowStop( snowplowv3( -873.512,  1480.256,  -4.836 ), -874.512,  1482.256,  -872.512,  1478.656 );
    snowplowStops[747]   <-  snowplowStop( snowplowv3( -883.349,  1493.212,  -4.327 ), -884.949,  1494.212,  -881.349,  1492.212 );
    snowplowStops[748]   <-  snowplowStop( snowplowv3( -883.204,  1557.402,  5.097 ), -884.804,  1558.402,  -881.204,  1556.402 );
    snowplowStops[749]   <-  snowplowStop( snowplowv3( -899.569,  1570.643,  5.168 ), -900.569,  1572.643,  -898.569,  1569.043 );
    snowplowStops[750]   <-  snowplowStop( snowplowv3( -928.367,  1570.861,  5.169 ), -929.367,  1572.861,  -927.367,  1569.261 );
    snowplowStops[751]   <-  snowplowStop( snowplowv3( -1009.442,  1570.855,  5.164 ), -1010.442,  1572.855,  -1008.442,  1569.255 );
    snowplowStops[752]   <-  snowplowStop( snowplowv3( -1024.873,  1554.683,  4.811 ), -1026.873,  1555.683,  -1023.273,  1553.683 );
    snowplowStops[753]   <-  snowplowStop( snowplowv3( -1025.487,  1491.422,  -4.375 ), -1027.487,  1492.422,  -1023.887,  1490.422 );
    snowplowStops[754]   <-  snowplowStop( snowplowv3( -1037.394,  1479.855,  -4.535 ), -1038.394,  1481.855,  -1036.394,  1478.255 );
    snowplowStops[755]   <-  snowplowStop( snowplowv3( -1103.467,  1479.687,  -2.713 ), -1104.467,  1481.687,  -1102.467,  1478.087 );
    snowplowStops[756]   <-  snowplowStop( snowplowv3( -1115.323,  1491.737,  -2.381 ), -1116.923,  1492.737,  -1113.323,  1490.737 );
    snowplowStops[757]   <-  snowplowStop( snowplowv3( -1115.367,  1556.244,  6.932 ), -1116.967,  1557.244,  -1113.367,  1555.244 );
    snowplowStops[758]   <-  snowplowStop( snowplowv3( -1132.015,  1570.965,  6.998 ), -1133.015,  1572.965,  -1131.015,  1569.365 );
    snowplowStops[759]   <-  snowplowStop( snowplowv3( -1197.462,  1571.138,  5.236 ), -1198.462,  1573.138,  -1196.462,  1569.538 );
    snowplowStops[760]   <-  snowplowStop( snowplowv3( -1213.567,  1556.467,  5.003 ), -1215.567,  1557.467,  -1211.967,  1555.467 );
    snowplowStops[761]   <-  snowplowStop( snowplowv3( -1213.611,  1492.351,  -4.289 ), -1215.611,  1493.351,  -1212.011,  1491.351 );
    snowplowStops[762]   <-  snowplowStop( snowplowv3( -1226.076,  1479.576,  -4.656 ), -1227.076,  1481.576,  -1225.076,  1477.976 );
    snowplowStops[763]   <-  snowplowStop( snowplowv3( -1253.079,  1475.372,  -5.272 ), -1254.079,  1477.372,  -1252.079,  1473.772 );
    snowplowStops[764]   <-  snowplowStop( snowplowv3( -1280.958,  1475.327,  -5.906 ), -1281.958,  1477.327,  -1279.958,  1473.727 );
    snowplowStops[765]   <-  snowplowStop( snowplowv3( -1299.827,  1469.587,  -5.946 ), -1300.827,  1471.587,  -1298.827,  1467.987 );
    snowplowStops[766]   <-  snowplowStop( snowplowv3( -1304.140,  1451.669,  -6.315 ), -1306.140,  1452.669,  -1302.540,  1450.669 );
    snowplowStops[767]   <-  snowplowStop( snowplowv3( -1308.258,  1406.593,  -13.058 ), -1310.258,  1407.593,  -1306.658,  1405.593 );
    snowplowStops[768]   <-  snowplowStop( snowplowv3( -1320.256,  1393.909,  -13.403 ), -1321.256,  1395.909,  -1319.256,  1392.309 );
    snowplowStops[769]   <-  snowplowStop( snowplowv3( -1391.915,  1397.795,  -13.405 ), -1392.915,  1399.795,  -1390.915,  1396.195 );
    snowplowStops[770]   <-  snowplowStop( snowplowv3( -1449.431,  1413.382,  -13.409 ), -1450.431,  1415.382,  -1448.431,  1411.782 );
    snowplowStops[771]   <-  snowplowStop( snowplowv3( -1477.696,  1454.940,  -12.215 ), -1479.296,  1455.940,  -1475.696,  1453.940 );
    snowplowStops[772]   <-  snowplowStop( snowplowv3( -1497.637,  1526.131,  -8.783 ), -1499.237,  1527.131,  -1495.637,  1525.131 );
    snowplowStops[773]   <-  snowplowStop( snowplowv3( -1528.337,  1562.834,  -6.313 ), -1529.337,  1564.834,  -1527.337,  1561.234 );
    snowplowStops[774]   <-  snowplowStop( snowplowv3( -1537.698,  1578.947,  -5.775 ), -1539.298,  1579.947,  -1535.698,  1577.947 );
    snowplowStops[775]   <-  snowplowStop( snowplowv3( -1537.579,  1619.419,  -4.650 ), -1539.179,  1620.419,  -1535.579,  1618.419 );
    snowplowStops[776]   <-  snowplowStop( snowplowv3( -1537.328,  1672.970,  -0.122 ), -1538.928,  1673.970,  -1535.328,  1671.970 );
    snowplowStops[777]   <-  snowplowStop( snowplowv3( -1525.492,  1685.384,  0.092 ), -1524.492,  1686.984,  -1526.492,  1683.384 );
    snowplowStops[778]   <-  snowplowStop( snowplowv3( -1460.531,  1685.255,  6.213 ), -1459.531,  1686.855,  -1461.531,  1683.255 );
    snowplowStops[779]   <-  snowplowStop( snowplowv3( -1449.191,  1672.425,  6.172 ), -1451.191,  1673.425,  -1447.591,  1671.425 );
    snowplowStops[780]   <-  snowplowStop( snowplowv3( -1449.209,  1630.630,  4.396 ), -1451.209,  1631.630,  -1447.609,  1629.630 );
    snowplowStops[781]   <-  snowplowStop( snowplowv3( -1430.223,  1584.075,  1.599 ), -1432.223,  1585.075,  -1428.623,  1583.075 );
    snowplowStops[782]   <-  snowplowStop( snowplowv3( -1419.155,  1528.265,  -1.239 ), -1421.155,  1529.265,  -1417.555,  1527.265 );
    snowplowStops[783]   <-  snowplowStop( snowplowv3( -1408.096,  1481.212,  -4.161 ), -1410.096,  1482.212,  -1406.496,  1480.212 );
    snowplowStops[784]   <-  snowplowStop( snowplowv3( -1321.696,  1476.080,  -5.942 ), -1320.696,  1477.680,  -1322.696,  1474.080 );
    snowplowStops[785]   <-  snowplowStop( snowplowv3( -1304.488,  1491.974,  -5.653 ), -1306.088,  1492.974,  -1302.488,  1490.974 );
    snowplowStops[786]   <-  snowplowStop( snowplowv3( -1304.160,  1554.731,  3.453 ), -1305.760,  1555.731,  -1302.160,  1553.731 );
    snowplowStops[787]   <-  snowplowStop( snowplowv3( -1291.763,  1567.542,  3.865 ), -1290.763,  1569.142,  -1292.763,  1565.542 );
    snowplowStops[788]   <-  snowplowStop( snowplowv3( -1225.159,  1567.136,  5.117 ), -1224.159,  1568.736,  -1226.159,  1565.136 );
    snowplowStops[789]   <-  snowplowStop( snowplowv3( -1210.117,  1582.776,  5.289 ), -1211.717,  1583.776,  -1208.117,  1581.776 );
    snowplowStops[790]   <-  snowplowStop( snowplowv3( -1209.434,  1623.953,  8.050 ), -1211.034,  1624.953,  -1207.434,  1622.953 );
    snowplowStops[791]   <-  snowplowStop( snowplowv3( -1209.582,  1673.329,  11.348 ), -1211.182,  1674.329,  -1207.582,  1672.329 );
    snowplowStops[792]   <-  snowplowStop( snowplowv3( -1197.442,  1685.223,  11.456 ), -1196.442,  1686.823,  -1198.442,  1683.223 );
    snowplowStops[793]   <-  snowplowStop( snowplowv3( -1144.808,  1685.202,  11.175 ), -1143.808,  1686.802,  -1145.808,  1683.202 );
    snowplowStops[794]   <-  snowplowStop( snowplowv3( -1097.012,  1685.372,  10.910 ), -1096.012,  1686.972,  -1098.012,  1683.372 );
    snowplowStops[795]   <-  snowplowStop( snowplowv3( -1036.040,  1685.250,  10.581 ), -1035.040,  1686.850,  -1037.040,  1683.250 );
    snowplowStops[796]   <-  snowplowStop( snowplowv3( -991.241,  1667.135,  8.984 ), -990.241,  1668.735,  -992.241,  1665.135 );
    snowplowStops[797]   <-  snowplowStop( snowplowv3( -943.439,  1618.201,  6.178 ), -945.439,  1619.201,  -941.839,  1617.201 );
    snowplowStops[798]   <-  snowplowStop( snowplowv3( -918.230,  1591.577,  5.497 ), -920.230,  1592.577,  -916.630,  1590.577 );
    snowplowStops[799]   <-  snowplowStop( snowplowv3( -913.847,  1577.876,  5.173 ), -915.847,  1578.876,  -912.247,  1576.876 );
    snowplowStops[800]   <-  snowplowStop( snowplowv3( -899.500,  1566.732,  5.165 ), -898.500,  1568.332,  -900.500,  1564.732 );
    snowplowStops[801]   <-  snowplowStop( snowplowv3( -887.597,  1556.827,  5.065 ), -889.597,  1557.827,  -885.997,  1555.827 );
    snowplowStops[802]   <-  snowplowStop( snowplowv3( -887.340,  1492.696,  -4.331 ), -889.340,  1493.696,  -885.740,  1491.696 );
    snowplowStops[803]   <-  snowplowStop( snowplowv3( -887.548,  1454.548,  -4.763 ), -889.548,  1455.548,  -885.948,  1453.548 );
    snowplowStops[804]   <-  snowplowStop( snowplowv3( -887.463,  1417.167,  -11.042 ), -889.463,  1418.167,  -885.863,  1416.167 );
    snowplowStops[805]   <-  snowplowStop( snowplowv3( -899.075,  1406.644,  -11.174 ), -900.075,  1408.644,  -898.075,  1405.044 );
    snowplowStops[806]   <-  snowplowStop( snowplowv3( -944.899,  1406.689,  -12.093 ), -945.899,  1408.689,  -943.899,  1405.089 );
    snowplowStops[807]   <-  snowplowStop( snowplowv3( -1010.709,  1406.641,  -13.412 ), -1011.709,  1408.641,  -1009.709,  1405.041 );
    snowplowStops[808]   <-  snowplowStop( snowplowv3( -1025.399,  1393.298,  -13.417 ), -1027.399,  1394.298,  -1023.799,  1392.298 );
    snowplowStops[809]   <-  snowplowStop( snowplowv3( -1009.929,  1377.937,  -13.407 ), -1008.929,  1379.537,  -1010.929,  1375.937 );
    snowplowStops[810]   <-  snowplowStop( snowplowv3( -970.127,  1378.184,  -13.897 ), -969.127,  1379.784,  -971.127,  1376.184 );
    snowplowStops[811]   <-  snowplowStop( snowplowv3( -927.954,  1378.314,  -21.490 ), -926.954,  1379.914,  -928.954,  1376.314 );
    snowplowStops[812]   <-  snowplowStop( snowplowv3( -881.683,  1378.557,  -23.667 ), -880.683,  1380.157,  -882.683,  1376.557 );
    snowplowStops[813]   <-  snowplowStop( snowplowv3( -792.533,  1378.538,  -31.802 ), -791.533,  1380.138,  -793.533,  1376.538 );
    snowplowStops[814]   <-  snowplowStop( snowplowv3( -672.738,  1363.065,  -35.076 ), -671.738,  1364.665,  -673.738,  1361.065 );
    snowplowStops[815]   <-  snowplowStop( snowplowv3( -563.533,  1293.002,  -31.983 ), -565.533,  1294.002,  -561.933,  1292.002 );
    snowplowStops[816]   <-  snowplowStop( snowplowv3( -512.051,  1208.157,  -25.280 ), -514.051,  1209.157,  -510.451,  1207.157 );
    snowplowStops[817]   <-  snowplowStop( snowplowv3( -504.946,  1117.481,  -19.721 ), -506.946,  1118.481,  -503.346,  1116.481 );
    snowplowStops[818]   <-  snowplowStop( snowplowv3( -501.523,  994.051,  -15.974 ), -503.523,  995.051,  -499.923,  993.051 );
    snowplowStops[819]   <-  snowplowStop( snowplowv3( -500.830,  930.927,  -18.913 ), -502.830,  931.927,  -499.230,  929.927 );
    snowplowStops[820]   <-  snowplowStop( snowplowv3( -501.078,  903.736,  -18.938 ), -503.078,  904.736,  -499.478,  902.736 ); // у телефонной будки
    snowplowStops[821]   <-  snowplowStop( snowplowv3( -501.360,  839.395,  -19.305 ), -503.360,  840.395,  -499.760,  838.395 ); // вдоль магазинов
    snowplowStops[822]   <-  snowplowStop( snowplowv3( -487.314,  807.221,  -19.493 ), -486.314,  808.821,  -488.314,  805.221 ); // на повороте у хотдогов
    snowplowStops[823]   <-  snowplowStop( snowplowv3( -457.144,  800.460,  -19.643 ), -456.144,  802.060,  -458.144,  798.460 ); // у бюро
    snowplowStops[824]   <-  snowplowStop( snowplowv3( -407.290,  800.622,  -19.962 ), -406.290,  802.222,  -408.290,  798.622 ); // перед перекрёстком
    snowplowStops[825]   <-  snowplowStop( snowplowv3( -395.081,  787.674,  -19.777 ), -397.081,  788.674,  -393.481,  786.674 ); // после поворота в сторону ПД снизу от бюро 1
    snowplowStops[826]   <-  snowplowStop( snowplowv3( -395.359,  714.952,  -15.507 ), -397.359,  715.952,  -393.759,  713.952 ); // после поворота в сторону ПД снизу от бюро 2
    snowplowStops[827]   <-  snowplowStop( snowplowv3( -395.789,  631.756,  -10.203 ), -397.789,  632.756,  -394.189,  630.756 ); // после поворота в сторону ПД снизу от бюро 3
    snowplowStops[828]   <-  snowplowStop( snowplowv3( -396.086,  602.248,  -10.103 ), -398.086,  603.248,  -394.486,  601.248 ); // въезд в депо

snowplowStops[829]   <-  snowplowStop( snowplowv3( -741.248,  744.748,  -17.176 ), -742.848,  745.748,  -739.248,  743.748 );
snowplowStops[830]   <-  snowplowStop( snowplowv3( -741.398,  788.334,  -18.655 ), -742.998,  789.334,  -739.398,  787.334 );
snowplowStops[831]   <-  snowplowStop( snowplowv3( -741.904,  815.119,  -18.753 ), -743.504,  816.119,  -739.904,  814.119 );
snowplowStops[832]   <-  snowplowStop( snowplowv3( -741.987,  850.286,  -18.752 ), -743.587,  851.286,  -739.987,  849.286 );
snowplowStops[833]   <-  snowplowStop( snowplowv3( -742.010,  902.792,  -18.764 ), -743.610,  903.792,  -740.010,  901.792 );
snowplowStops[834]   <-  snowplowStop( snowplowv3( -731.423,  915.641,  -18.750 ), -730.423,  917.241,  -732.423,  913.641 );
snowplowStops[835]   <-  snowplowStop( snowplowv3( -698.398,  915.847,  -18.759 ), -697.398,  917.447,  -699.398,  913.847 );
snowplowStops[836]   <-  snowplowStop( snowplowv3( -645.398,  916.052,  -18.757 ), -644.398,  917.652,  -646.398,  914.052 );
snowplowStops[837]   <-  snowplowStop( snowplowv3( -621.160,  916.079,  -18.773 ), -620.160,  917.679,  -622.160,  914.079 );
snowplowStops[838]   <-  snowplowStop( snowplowv3( -573.388,  916.133,  -18.894 ), -572.388,  917.733,  -574.388,  914.133 );
snowplowStops[839]   <-  snowplowStop( snowplowv3( -509.037,  916.074,  -18.912 ), -508.037,  917.674,  -510.037,  914.074 );
snowplowStops[840]   <-  snowplowStop( snowplowv3( -505.029,  1148.343,  32.210 ), -504.029,  1149.943,  -506.029,  1146.343 );
snowplowStops[841]   <-  snowplowStop( snowplowv3( -442.174,  1130.139,  37.418 ), -441.174,  1131.739,  -443.174,  1128.139 );
snowplowStops[842]   <-  snowplowStop( snowplowv3( -396.202,  1097.791,  42.495 ), -395.202,  1099.391,  -397.202,  1095.791 );
snowplowStops[843]   <-  snowplowStop( snowplowv3( -329.002,  1059.792,  45.085 ), -328.002,  1061.392,  -330.002,  1057.792 );
snowplowStops[844]   <-  snowplowStop( snowplowv3( -247.046,  1076.876,  49.249 ), -246.046,  1078.476,  -248.046,  1074.876 );
snowplowStops[845]   <-  snowplowStop( snowplowv3( -222.585,  1166.275,  52.408 ), -224.185,  1167.275,  -220.585,  1165.275 );
snowplowStops[846]   <-  snowplowStop( snowplowv3( -216.056,  1244.526,  53.977 ), -217.656,  1245.526,  -214.056,  1243.526 );
snowplowStops[847]   <-  snowplowStop( snowplowv3( -231.591,  1261.759,  54.174 ), -232.591,  1263.759,  -230.591,  1260.159 );
snowplowStops[848]   <-  snowplowStop( snowplowv3( -302.691,  1266.747,  54.726 ), -303.691,  1268.747,  -301.691,  1265.147 );
snowplowStops[849]   <-  snowplowStop( snowplowv3( -389.578,  1254.328,  50.109 ), -390.578,  1256.328,  -388.578,  1252.728 );
snowplowStops[850]   <-  snowplowStop( snowplowv3( -472.435,  1252.474,  42.527 ), -473.435,  1254.474,  -471.435,  1250.874 );
snowplowStops[851]   <-  snowplowStop( snowplowv3( -520.231,  1219.673,  36.256 ), -522.231,  1220.673,  -518.631,  1218.673 );
snowplowStops[852]   <-  snowplowStop( snowplowv3( -522.842,  1165.121,  32.272 ), -524.842,  1166.121,  -521.242,  1164.121 );

snowplowStops[853]   <-  snowplowStop( snowplowv3( -514.603,  1327.105,  23.498 ), -516.203,  1328.105,  -512.603,  1326.105 );
snowplowStops[854]   <-  snowplowStop( snowplowv3( -525.801,  1362.995,  18.762 ), -527.401,  1363.995,  -523.801,  1361.995 );
snowplowStops[855]   <-  snowplowStop( snowplowv3( -549.557,  1382.622,  16.056 ), -550.557,  1384.622,  -548.557,  1381.022 );
snowplowStops[856]   <-  snowplowStop( snowplowv3( -574.351,  1353.417,  12.947 ), -576.351,  1354.417,  -572.751,  1352.417 );
snowplowStops[857]   <-  snowplowStop( snowplowv3( -573.948,  1301.404,  9.425 ), -574.948,  1303.404,  -572.948,  1299.804 );
snowplowStops[858]   <-  snowplowStop( snowplowv3( -614.225,  1301.429,  4.807 ), -615.225,  1303.429,  -613.225,  1299.829 );
snowplowStops[859]   <-  snowplowStop( snowplowv3( -652.791,  1341.338,  2.394 ), -654.391,  1342.338,  -650.791,  1340.338 );
snowplowStops[860]   <-  snowplowStop( snowplowv3( -713.961,  1414.803,  2.395 ), -715.561,  1415.803,  -711.961,  1413.803 );
snowplowStops[861]   <-  snowplowStop( snowplowv3( -796.400,  1518.029,  -6.027 ), -798.000,  1519.029,  -794.400,  1517.029 );
snowplowStops[862]   <-  snowplowStop( snowplowv3( -790.269,  1528.362,  -6.038 ), -789.269,  1529.961,  -791.269,  1526.362 );
snowplowStops[863]   <-  snowplowStop( snowplowv3( -732.259,  1555.768,  -11.737 ), -731.259,  1557.367,  -733.259,  1553.768 );
snowplowStops[864]   <-  snowplowStop( snowplowv3( -725.330,  1582.096,  -12.852 ), -726.930,  1583.096,  -723.330,  1581.096 );
snowplowStops[865]   <-  snowplowStop( snowplowv3( -731.972,  1639.932,  -14.807 ), -733.572,  1640.932,  -729.972,  1638.932 );
snowplowStops[866]   <-  snowplowStop( snowplowv3( -731.846,  1701.066,  -14.835 ), -733.446,  1702.066,  -729.846,  1700.066 );
snowplowStops[867]   <-  snowplowStop( snowplowv3( -731.744,  1756.282,  -14.864 ), -733.344,  1757.282,  -729.744,  1755.282 );
snowplowStops[868]   <-  snowplowStop( snowplowv3( -700.299,  1789.113,  -14.881 ), -699.299,  1790.713,  -701.299,  1787.113 );
snowplowStops[869]   <-  snowplowStop( snowplowv3( -612.617,  1789.162,  -14.893 ), -611.617,  1790.762,  -613.617,  1787.162 );
snowplowStops[870]   <-  snowplowStop( snowplowv3( -560.309,  1789.344,  -14.917 ), -559.309,  1790.944,  -561.309,  1787.344 );
snowplowStops[871]   <-  snowplowStop( snowplowv3( -505.365,  1789.155,  -14.935 ), -504.365,  1790.755,  -506.365,  1787.155 );
snowplowStops[872]   <-  snowplowStop( snowplowv3( -459.922,  1786.526,  -19.318 ), -458.922,  1788.126,  -460.922,  1784.526 );
snowplowStops[873]   <-  snowplowStop( snowplowv3( -405.406,  1786.636,  -23.426 ), -404.406,  1788.236,  -406.406,  1784.636 );
snowplowStops[874]   <-  snowplowStop( snowplowv3( -397.229,  1775.675,  -23.360 ), -399.229,  1776.675,  -395.629,  1774.675 );
snowplowStops[875]   <-  snowplowStop( snowplowv3( -397.470,  1724.423,  -22.955 ), -399.470,  1725.423,  -395.870,  1723.423 );
snowplowStops[876]   <-  snowplowStop( snowplowv3( -397.395,  1661.038,  -23.173 ), -399.395,  1662.038,  -395.795,  1660.038 );
snowplowStops[877]   <-  snowplowStop( snowplowv3( -397.430,  1584.477,  -23.424 ), -399.430,  1585.477,  -395.830,  1583.477 );
snowplowStops[878]   <-  snowplowStop( snowplowv3( -408.178,  1575.586,  -23.317 ), -409.178,  1577.586,  -407.178,  1573.986 );
snowplowStops[879]   <-  snowplowStop( snowplowv3( -484.832,  1575.419,  -17.578 ), -485.832,  1577.419,  -483.832,  1573.819 );
snowplowStops[880]   <-  snowplowStop( snowplowv3( -523.769,  1575.084,  -14.930 ), -524.769,  1577.084,  -522.769,  1573.484 );
snowplowStops[881]   <-  snowplowStop( snowplowv3( -569.329,  1575.330,  -16.600 ), -570.329,  1577.330,  -568.329,  1573.730 );
snowplowStops[882]   <-  snowplowStop( snowplowv3( -625.040,  1575.204,  -16.499 ), -626.040,  1577.204,  -624.040,  1573.604 );
snowplowStops[883]   <-  snowplowStop( snowplowv3( -636.988,  1584.205,  -16.487 ), -638.588,  1585.205,  -634.988,  1583.205 );
snowplowStops[884]   <-  snowplowStop( snowplowv3( -628.235,  1589.661,  -16.467 ), -627.235,  1591.261,  -629.235,  1587.661 );
snowplowStops[885]   <-  snowplowStop( snowplowv3( -599.941,  1588.396,  -16.317 ), -598.941,  1589.996,  -600.941,  1586.396 );
snowplowStops[886]   <-  snowplowStop( snowplowv3( -587.167,  1584.839,  -16.286 ), -586.167,  1586.439,  -588.167,  1582.839 );
snowplowStops[887]   <-  snowplowStop( snowplowv3( -563.948,  1584.723,  -16.282 ), -562.948,  1586.323,  -564.948,  1582.723 );
snowplowStops[888]   <-  snowplowStop( snowplowv3( -552.308,  1589.543,  -16.285 ), -551.308,  1591.143,  -553.308,  1587.543 );
snowplowStops[889]   <-  snowplowStop( snowplowv3( -531.323,  1589.190,  -16.303 ), -530.323,  1590.790,  -532.323,  1587.190 );
snowplowStops[890]   <-  snowplowStop( snowplowv3( -519.127,  1594.823,  -15.940 ), -518.127,  1596.423,  -520.127,  1592.823 );
snowplowStops[891]   <-  snowplowStop( snowplowv3( -508.959,  1582.659,  -16.011 ), -510.959,  1583.659,  -507.359,  1581.659 );
snowplowStops[892]   <-  snowplowStop( snowplowv3( -495.816,  1564.173,  -16.754 ), -494.816,  1565.773,  -496.816,  1562.173 );
snowplowStops[893]   <-  snowplowStop( snowplowv3( -454.383,  1560.145,  -19.890 ), -453.383,  1561.745,  -455.383,  1558.145 );
snowplowStops[894]   <-  snowplowStop( snowplowv3( -407.738,  1559.699,  -23.334 ), -406.738,  1561.299,  -408.738,  1557.699 );
snowplowStops[895]   <-  snowplowStop( snowplowv3( -397.231,  1548.403,  -23.411 ), -399.231,  1549.403,  -395.631,  1547.403 );
snowplowStops[896]   <-  snowplowStop( snowplowv3( -397.572,  1534.520,  -23.466 ), -399.572,  1535.520,  -395.972,  1533.520 );
snowplowStops[897]   <-  snowplowStop( snowplowv3( -405.365,  1527.363,  -23.534 ), -406.365,  1529.363,  -404.365,  1525.763 );
snowplowStops[898]   <-  snowplowStop( snowplowv3( -444.680,  1516.444,  -22.212 ), -445.680,  1518.444,  -443.680,  1514.844 );
snowplowStops[899]   <-  snowplowStop( snowplowv3( -507.742,  1518.519,  -19.651 ), -508.742,  1520.519,  -506.742,  1516.919 );
snowplowStops[900]   <-  snowplowStop( snowplowv3( -566.172,  1507.745,  -16.023 ), -567.172,  1509.745,  -565.172,  1506.145 );
snowplowStops[901]   <-  snowplowStop( snowplowv3( -623.109,  1505.976,  -13.383 ), -624.109,  1507.976,  -622.109,  1504.376 );
snowplowStops[902]   <-  snowplowStop( snowplowv3( -672.190,  1505.121,  -12.172 ), -673.190,  1507.121,  -671.190,  1503.521 );
snowplowStops[903]   <-  snowplowStop( snowplowv3( -694.490,  1512.061,  -9.559 ), -696.090,  1513.061,  -692.490,  1511.061 );
snowplowStops[904]   <-  snowplowStop( snowplowv3( -696.706,  1549.824,  -14.113 ), -698.306,  1550.824,  -694.706,  1548.824 );
snowplowStops[905]   <-  snowplowStop( snowplowv3( -688.473,  1559.720,  -15.332 ), -687.473,  1561.320,  -689.473,  1557.720 );
snowplowStops[906]   <-  snowplowStop( snowplowv3( -631.748,  1560.079,  -16.434 ), -630.748,  1561.679,  -632.748,  1558.079 );
snowplowStops[907]   <-  snowplowStop( snowplowv3( -575.645,  1560.063,  -16.738 ), -574.645,  1561.663,  -576.645,  1558.063 );
snowplowStops[908]   <-  snowplowStop( snowplowv3( -524.763,  1559.911,  -14.920 ), -523.763,  1561.511,  -525.763,  1557.911 );
snowplowStops[909]   <-  snowplowStop( snowplowv3( -496.152,  1559.854,  -16.721 ), -495.152,  1561.454,  -497.152,  1557.854 );
snowplowStops[910]   <-  snowplowStop( snowplowv3( -454.993,  1564.312,  -19.833 ), -453.993,  1565.912,  -455.993,  1562.312 );
snowplowStops[911]   <-  snowplowStop( snowplowv3( -408.127,  1564.548,  -23.314 ), -407.127,  1566.148,  -409.127,  1562.548 );
snowplowStops[912]   <-  snowplowStop( snowplowv3( -390.526,  1585.152,  -23.417 ), -392.126,  1586.152,  -388.526,  1584.152 );
snowplowStops[913]   <-  snowplowStop( snowplowv3( -390.206,  1661.937,  -23.168 ), -391.806,  1662.937,  -388.206,  1660.937 );
snowplowStops[914]   <-  snowplowStop( snowplowv3( -387.553,  1725.346,  -22.960 ), -389.153,  1726.346,  -385.553,  1724.346 );
snowplowStops[915]   <-  snowplowStop( snowplowv3( -387.890,  1775.601,  -23.328 ), -389.490,  1776.601,  -385.890,  1774.601 );
snowplowStops[916]   <-  snowplowStop( snowplowv3( -374.213,  1792.202,  -23.427 ), -373.213,  1793.802,  -375.213,  1790.202 );
snowplowStops[917]   <-  snowplowStop( snowplowv3( -312.911,  1792.351,  -23.409 ), -311.911,  1793.951,  -313.911,  1790.351 );
snowplowStops[918]   <-  snowplowStop( snowplowv3( -292.348,  1792.876,  -23.426 ), -291.348,  1794.476,  -293.348,  1790.876 );
snowplowStops[919]   <-  snowplowStop( snowplowv3( -253.607,  1801.269,  -24.044 ), -252.607,  1802.869,  -254.607,  1799.269 );
snowplowStops[920]   <-  snowplowStop( snowplowv3( -232.817,  1816.825,  -21.200 ), -234.417,  1817.825,  -230.817,  1815.825 );
snowplowStops[921]   <-  snowplowStop( snowplowv3( -210.924,  1823.431,  -20.387 ), -209.924,  1825.031,  -211.924,  1821.431 );
snowplowStops[922]   <-  snowplowStop( snowplowv3( -190.839,  1819.916,  -20.383 ), -189.839,  1821.516,  -191.839,  1817.916 );
snowplowStops[923]   <-  snowplowStop( snowplowv3( -196.017,  1833.830,  -20.388 ), -197.017,  1835.830,  -195.017,  1832.230 );
snowplowStops[924]   <-  snowplowStop( snowplowv3( -239.706,  1827.682,  -20.945 ), -240.706,  1829.682,  -238.706,  1826.082 );
snowplowStops[925]   <-  snowplowStop( snowplowv3( -268.817,  1805.508,  -23.357 ), -269.817,  1807.508,  -267.817,  1803.908 );
snowplowStops[926]   <-  snowplowStop( snowplowv3( -292.137,  1797.134,  -23.420 ), -293.137,  1799.134,  -291.137,  1795.534 );
snowplowStops[927]   <-  snowplowStop( snowplowv3( -303.163,  1783.655,  -23.371 ), -305.163,  1784.655,  -301.563,  1782.655 );
snowplowStops[928]   <-  snowplowStop( snowplowv3( -303.558,  1733.203,  -22.647 ), -305.558,  1734.203,  -301.958,  1732.203 );
snowplowStops[929]   <-  snowplowStop( snowplowv3( -303.473,  1677.348,  -22.126 ), -305.473,  1678.348,  -301.873,  1676.348 );
snowplowStops[930]   <-  snowplowStop( snowplowv3( -303.298,  1585.614,  -23.409 ), -305.298,  1586.614,  -301.698,  1584.614 );
snowplowStops[931]   <-  snowplowStop( snowplowv3( -289.792,  1564.136,  -23.465 ), -288.792,  1565.736,  -290.792,  1562.136 );
snowplowStops[932]   <-  snowplowStop( snowplowv3( -236.221,  1563.554,  -24.424 ), -235.221,  1565.154,  -237.221,  1561.554 );
snowplowStops[933]   <-  snowplowStop( snowplowv3( -161.597,  1532.572,  -18.027 ), -163.597,  1533.572,  -159.997,  1531.572 );
snowplowStops[934]   <-  snowplowStop( snowplowv3( -130.884,  1455.690,  -15.142 ), -132.884,  1456.690,  -129.284,  1454.690 );
snowplowStops[935]   <-  snowplowStop( snowplowv3( -130.704,  1389.555,  -15.142 ), -132.704,  1390.555,  -129.104,  1388.555 );
snowplowStops[936]   <-  snowplowStop( snowplowv3( -136.098,  1326.358,  -15.149 ), -138.098,  1327.358,  -134.498,  1325.358 );
snowplowStops[937]   <-  snowplowStop( snowplowv3( -136.904,  1286.747,  -15.183 ), -138.904,  1287.747,  -135.304,  1285.747 );
snowplowStops[938]   <-  snowplowStop( snowplowv3( -111.607,  1213.181,  -14.121 ), -113.607,  1214.181,  -110.007,  1212.181 );
snowplowStops[939]   <-  snowplowStop( snowplowv3( -76.655,  1124.615,  -11.378 ), -78.655,  1125.615,  -75.055,  1123.615 );
snowplowStops[940]   <-  snowplowStop( snowplowv3( -58.078,  1044.211,  -11.013 ), -60.078,  1045.211,  -56.478,  1043.211 );
snowplowStops[941]   <-  snowplowStop( snowplowv3( -69.906,  980.745,  -12.444 ), -70.906,  982.745,  -68.906,  979.145 );
snowplowStops[942]   <-  snowplowStop( snowplowv3( -109.189,  954.237,  -15.574 ), -111.189,  955.237,  -107.589,  953.237 );
snowplowStops[943]   <-  snowplowStop( snowplowv3( -162.876,  882.439,  -20.235 ), -164.876,  883.439,  -161.276,  881.439 );
snowplowStops[944]   <-  snowplowStop( snowplowv3( -168.175,  814.805,  -20.696 ), -170.175,  815.805,  -166.575,  813.805 );
snowplowStops[945]   <-  snowplowStop( snowplowv3( -179.935,  803.966,  -20.639 ), -180.935,  805.966,  -178.935,  802.366 );
snowplowStops[946]   <-  snowplowStop( snowplowv3( -221.903,  804.191,  -20.004 ), -222.903,  806.191,  -220.903,  802.591 );
snowplowStops[947]   <-  snowplowStop( snowplowv3( -232.468,  791.569,  -19.997 ), -234.468,  792.569,  -230.868,  790.569 );
snowplowStops[948]   <-  snowplowStop( snowplowv3( -232.542,  753.238,  -19.996 ), -234.542,  754.238,  -230.942,  752.238 );
snowplowStops[949]   <-  snowplowStop( snowplowv3( -232.765,  702.992,  -19.995 ), -234.765,  703.992,  -231.165,  701.992 );
snowplowStops[950]   <-  snowplowStop( snowplowv3( -243.481,  694.009,  -19.977 ), -244.481,  696.009,  -242.481,  692.409 );
snowplowStops[951]   <-  snowplowStop( snowplowv3( -270.902,  693.230,  -19.797 ), -271.902,  695.230,  -269.902,  691.630 );
snowplowStops[952]   <-  snowplowStop( snowplowv3( -305.378,  669.139,  -19.136 ), -307.378,  670.139,  -303.778,  668.139 );
snowplowStops[953]   <-  snowplowStop( snowplowv3( -378.714,  620.386,  -10.265 ), -379.714,  622.386,  -377.714,  618.786 );

  //routes[0] <- [zarplata, [stop1, stop2, stop3, ..., stop562]];
    routes[1] <- {
        cost = 18.0,
        points = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 828, 0]
    };

    routes[2] <- {
        cost = 18.0,
        points = [103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 99, 100, 101, 102, 828, 0]
    };

    routes[3] <- {
        cost = 18.0,
        points = [103, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 238, 239, 240, 241, 99, 100, 101, 102, 828, 0]
    };

    routes[4] <- {
        cost = 18.0,
        points = [103, 104, 105, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 101, 102, 828, 0]
    };

    routes[5] <- {
        cost = 18.0,
        points = [103, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656, 0]
    };

    routes[6] <- {
        cost = 18.0,
        points = [103, 549, 550, 551, 552, 553, 554, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669, 670, 671, 672, 673, 674, 675, 676, 677, 678, 679, 680, 681, 682, 683, 684, 685, 686, 687, 688, 689, 690, 691, 692, 693, 694, 695, 696, 697, 698, 699, 700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 724, 725, 726, 727, 728, 729, 730, 731, 732, 733, 734, 735, 736, 737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 748, 749, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791, 792, 793, 794, 795, 796, 797, 798, 799, 800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822, 823, 824, 825, 826, 827, 828, 0]
    };

    routes[7] <- {
        cost = 18.0,
        points = [103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 829, 830, 831, 832, 833, 834, 835, 836, 837, 838, 839, 568, 569, 570, 571, 572, 573, 574, 840, 841, 842, 843, 844, 845, 846, 847, 848, 849, 850, 851, 852, 575, 576, 577, 578, 579, 853, 854, 855, 856, 857, 858, 859, 860, 861, 862, 863, 864, 865, 866, 867, 868, 869, 870, 871, 872, 873, 874, 875, 876, 877, 878, 879, 880, 881, 882, 883, 884, 885, 886, 887, 888, 889, 890, 891, 892, 893, 894, 895, 896, 897, 898, 899, 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911, 912, 913, 914, 915, 916, 917, 918, 919, 920, 921, 922, 923, 924, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 947, 948, 949, 950, 951, 952, 953, 828, 0]
    };

    //creating 3dtext for snowplow depot
    create3DText ( SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.35, "SNOW PLOWING COMPANY", CL_ROYALBLUE );
    create3DText ( SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.20, "Press E to action", CL_WHITE.applyAlpha(150), RADIUS_SNOWPLOW );

    registerPersonalJobBlip("snowplowdriver", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y);

});


event("onPlayerConnect", function(playerid) {
    if ( ! (getCharacterIdFromPlayerId(playerid) in job_snowplow) ) {
     job_snowplow[getCharacterIdFromPlayerId(playerid)] <- {};
     job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"] <- false;
     job_snowplow[getCharacterIdFromPlayerId(playerid)]["snowplow3dtext"] <- [ null, null ];
     job_snowplow[getCharacterIdFromPlayerId(playerid)]["snowplowBlip"] <- null;
    }
});


event("onServerPlayerStarted", function( playerid ){

    if(isSnowplowDriver(playerid)) {

        createText (playerid, "leavejob3dtext", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_SNOWPLOW_SMALL );

        if (getPlayerJobState(playerid) == "working") {
            local snowplowID = job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"].points[0];
            job_snowplow[getCharacterIdFromPlayerId(playerid)]["snowplow3dtext"] = createPrivateSnowplowCheckpoint3DText(playerid, snowplowStops[snowplowID].coords);
            trigger(playerid, "setGPS", snowplowStops[snowplowID].coords.x, snowplowStops[snowplowID].coords.y);
            msg( playerid, "job.snowplow.continuesnowplowstop", SNOWPLOW_JOB_COLOR );
            return;
        }

        if (getPlayerJobState(playerid) == "complete") {
            return msg( playerid, "job.snowplow.takeyourmoney", SNOWPLOW_JOB_COLOR );
        }

        msg( playerid, "job.snowplow.ifyouwantstart", SNOWPLOW_JOB_COLOR );
        //restorePlayerModel(playerid);
        setPlayerJobState(playerid, null);
    }
});

event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
    if (!isPlayerVehicleSnowplow(playerid)) {
        return;
    }

    // skip check for non-drivers
    if (seat != 0) return;

    if(isSnowplowDriver(playerid) && getPlayerJobState(playerid) == "working") {
        unblockDriving(vehicleid);
        repairVehicle(vehicleid);
        //delayedFunction(4500, function() {
            //snowplowJobReady(playerid);
        //});
    } else {
        blockDriving(playerid, vehicleid);
    }
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (!isPlayerVehicleSnowplow(playerid)) {
        return;
    }

    // skip check for non-drivers
    if (seat != 0) return;

    blockDriving(playerid, vehicleid);
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

    //return msg(playerid, "job.not-available", CL_ERROR );

    if(!isPlayerHaveValidPassport(playerid)) {
               msg(playerid, "job.needpassport", SNOWPLOW_JOB_COLOR );
        return msg(playerid, "passport.toofar", CL_LYNCH );
    }

    // если у игрока недостаточный уровень
    // if(!isPlayerLevelValid ( playerid, SNOWPLOW_JOB_LEVEL )) {
    //     return msg(playerid, "job.snowplow.needlevel", SNOWPLOW_JOB_LEVEL, SNOWPLOW_JOB_COLOR );
    // }

    if (getCharacterIdFromPlayerId(playerid) in job_snowplow_blocked) {
        if (getTimestamp() - job_snowplow_blocked[getCharacterIdFromPlayerId(playerid)] < SNOWPLOW_JOB_TIMEOUT) {
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
    job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"] = false;
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

    if(getPlayerJobState(playerid) == null) {
        msg( playerid, "job.snowplow.goodluck", SNOWPLOW_JOB_COLOR);
    }

    if(getPlayerJobState(playerid) == "working") {
        return msg( playerid, "job.snowplow.needCompleteToLeave", SNOWPLOW_JOB_COLOR );
    }

    if(getPlayerJobState(playerid) == "complete") {
        setPlayerJobState(playerid, null);
        snowplowGetSalary( playerid );
        job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"] = false;
        msg( playerid, "job.snowplow.goodluck", SNOWPLOW_JOB_COLOR);
    }

    removeText(playerid, "leavejob3dtext");
    trigger(playerid, "removeGPS");

    setPlayerJob( playerid, null );
    jobRestorePlayerModel(playerid);
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
    local amount = job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"].cost + getSalaryBonus();
    players[playerid].data.jobs.snowplowdriver.count += 1;
    addPlayerMoney(playerid, amount);
    subTreasuryMoney(amount);
    local moneyInTreasuryNow = getTreasuryMoney();
    msg(playerid, "job.snowplow.nicejob", amount, SNOWPLOW_JOB_COLOR);
    nano({
        "path": "discord",
        "server": "gov",
        "channel": "treasury",
        "action": "sub",
        "author": getPlayerName(playerid),
        "description": "Расход",
        "color": "red",
        "datetime": getVirtualDate(),
        "direction": false,
        "fields": [
            ["Сумма", format("$ %.2f", amount)],
            ["Основание", "Заработная плата водителю снегоуборочной машины за пройденный маршрут"],
            ["Баланс", format("$ %.2f", moneyInTreasuryNow)],
        ]
    })
}

/**
Event: JOB - SNOWPLOW driver - Start route
*/
function snowplowJobStartRoute( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    if(!isPlayerHaveValidPassport(playerid)) {
               msg(playerid, "job.needpassport", SNOWPLOW_JOB_COLOR );
        return msg(playerid, "passport.toofar", CL_LYNCH );
    }

    if(SNOWPLOW_ROUTE_NOW < 1) {
        return msg( playerid, "job.nojob", SNOWPLOW_JOB_COLOR );
    }

    setPlayerJobState( playerid, "working");
    //jobSetPlayerModel( playerid, SNOWPLOW_JOB_SKIN );

    local idx = random(1, routes_list.len()-1);
    local routeNumber = routes_list[idx];
    routes_list.remove(idx);
    if(routes_list.len() == 0) routes_list = clone( routes_list_all );

    job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"] <- {
        id = routeNumber,
        cost = routes[routeNumber].cost,
        points = clone routes[routeNumber].points //create clone of route
    };

    local snowplowID = job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"].points[0];

    msg( playerid, "Route: %d", [routeNumber] );
    msg( playerid, "job.snowplow.startroute" , SNOWPLOW_JOB_COLOR );
    msg( playerid, "job.snowplow.startroute2", SNOWPLOW_JOB_COLOR );
    job_snowplow[getCharacterIdFromPlayerId(playerid)]["snowplow3dtext"] = createPrivateSnowplowCheckpoint3DText(playerid, snowplowStops[snowplowID].coords);

    createPrivatePlace(playerid, "snowplowZone", snowplowStops[snowplowID].x1, snowplowStops[snowplowID].y1, snowplowStops[snowplowID].x2, snowplowStops[snowplowID].y2);

    trigger(playerid, "setGPS", snowplowStops[snowplowID].coords.x, snowplowStops[snowplowID].coords.y);
}
addJobEvent("e", SNOWPLOW_JOB_NAME, null, snowplowJobStartRoute);



event("onPlayerAreaEnter", function(playerid, name) {
    if (isSnowplowDriver(playerid) && isPlayerVehicleSnowplow(playerid) && getPlayerJobState(playerid) == "working") {
        if(name == "snowplowZone") {
            local vehicleid = getPlayerVehicle(playerid);
            local speed = getVehicleSpeed(vehicleid);
            local maxsp = max(fabs(speed[0]), fabs(speed[1]));
            if(maxsp > 14) return msg(playerid, "job.snowplow.driving", CL_RED);
 //msg(playerid, "#"+job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"].points[0]);
            removePrivateArea(playerid, "snowplowZone");
            removeText( playerid, "snowplow_3dtext");
            trigger(playerid, "removeGPS");
						// msg(playerid, format("Point: %d", job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"].points[0]));
            job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"].points.remove(0);
            if (job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"].points.len() == 0) {

                blockDriving(playerid, vehicleid);
                msg( playerid, "job.snowplow.gototakemoney", SNOWPLOW_JOB_COLOR );
                setPlayerJobState(playerid, "complete");
                return;
            }
            local snowplowID = job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"].points[0];
            trigger(playerid, "setGPS", snowplowStops[snowplowID].coords.x, snowplowStops[snowplowID].coords.y);
            job_snowplow[getCharacterIdFromPlayerId(playerid)]["snowplow3dtext"] = createPrivateSnowplowCheckpoint3DText(playerid, snowplowStops[snowplowID].coords);
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
