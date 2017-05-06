include("modules/policealarm/commands.nut");

local policeAlarms = [

    [-371.573,   1787.89, -23.589   , "policeAlarm1"  ],
    [-1292.88,   1484.98, -6.11190  , "policeAlarm2"  ],
    [-1176.64,   1457.64, -4.12012  , "policeAlarm3"  ],
    [-1171.7,    1387.29, -13.6239  , "policeAlarm4"  ],
    [-1317.53,   1402.58, -13.5725  , "policeAlarm5"  ],
    [-1299.35,   751.584, -15.7788  , "policeAlarm6"  ],
    [-1417.24,   497.773, -21.4151  , "policeAlarm7"  ],
    [ 36.4554,   235.118, -16.0193  , "policeAlarm8"  ],
    [-639.445,  -76.2884,  1.03814  , "policeAlarm9"  ],
    [-680.221,   182.574,  1.03806  , "policeAlarm10" ],
    [-474.135,   185.611,  1.02381  , "policeAlarm11" ],
    [-477.684,   382.254,  1.03808  , "policeAlarm12" ],
    [-477.376,   439.521,  1.03657  , "policeAlarm13" ],
    [-661.801,   455.444,  1.03789  , "policeAlarm14" ],
    [-512.606,   810.714, -19.6019  , "policeAlarm15" ],
    [-196.664,   382.899, -6.32934  , "policeAlarm16" ],
    [-191.619,   297.732, -6.45726  , "policeAlarm17" ],
    [-195.883,   162.1,   -10.5431  , "policeAlarm18" ],
    [-196.463,   82.5475, -11.1609  , "policeAlarm19" ],
    [-123.769,   232.632, -13.9932  , "policeAlarm20" ],
    [-122.238,   355.647, -13.9932  , "policeAlarm21" ],
    [-9.27437,   413.96,  -13.9914  , "policeAlarm22" ],
    [-69.3858,   723.144, -21.9343  , "policeAlarm23" ],
    [ 131.276,   780.688, -18.9663  , "policeAlarm24" ],
    [ 118.093,   904.171, -22.3053  , "policeAlarm25" ],
    [ 335.894,   829.788, -21.2524  , "policeAlarm26" ],
    [ 370.317,   808.668, -21.2487  , "policeAlarm27" ],
    [ 394.804,   797.771, -21.2487  , "policeAlarm28" ],
    [ 451.982,   751.116, -21.2541  , "policeAlarm29" ],
    [ 407.519,   674.809, -24.8892  , "policeAlarm30" ],
    [ 276.342,   606.728, -24.5672  , "policeAlarm31" ],
    [ 259.641,   466.762, -20.1637  , "policeAlarm32" ],
    [ 259.739,   333.152, -21.6012  , "policeAlarm33" ],
    [ 259.682,   399.147, -21.5767  , "policeAlarm34" ],
    [ 255.309,   31.6091, -23.3979  , "policeAlarm35" ],
    [  264.94,   841.694,   -20.38  , "policeAlarm36" ],
];

translation("en", {
    "policeAlarm1"      : "Riverside. Police Alarm"
    "policeAlarm2"      : "Kingston. River Street, opposite to Kingston Stadium. Police Alarm"
    "policeAlarm3"      : "Kingston. Center of River Street. Police Alarm"
    "policeAlarm4"      : "Kingston. Sculpture of a rider. Police Alarm"
    "policeAlarm5"      : "Kingston. Kingston Stadium. Police Alarm"
    "policeAlarm6"      : "Hunters Point. North of Evergreen Street. Police Alarm"
    "policeAlarm7"      : "Hunters Point. Near bar Lone Star. Police Alarm"
    "policeAlarm8"      : "East Side. Near boulevard. Police Alarm"
    "policeAlarm9"      : "West Side. Near fuel station. Police Alarm"
    "policeAlarm10"     : "West Side. Near automotive repair shop. Police Alarm"
    "policeAlarm11"     : "West Side. Near Linkoln Park. South-West. Police Alarm"
    "policeAlarm12"     : "West Side. Near Linkoln Park. North-West. Police Alarm"
    "policeAlarm13"     : "Uptown. Opposite to bus station. Police Alarm"
    "policeAlarm14"     : "West Side. North. Police Alarm"
    "policeAlarm15"     : "East Side. Avenue. Police Alarm"
    "policeAlarm16"     : "East Side. Near Linkoln Park. North-East. Police Alarm"
    "policeAlarm17"     : "East Side. Near Linkoln Park. East entrance. Police Alarm"
    "policeAlarm18"     : "East Side. Near Linkoln Park. East. Police Alarm"
    "policeAlarm19"     : "East Side. Near Linkoln Park. South-East. Police Alarm"
    "policeAlarm20"     : "East Side. Corner near automotive repair shop. Police Alarm"
    "policeAlarm21"     : "East Side. Taxi Parking. Police Alarm"
    "policeAlarm22"     : "East Side. Corner road to Little Italy. Police Alarm"
    "policeAlarm23"     : "Little Italy. Near Freddy's Bar. Police Alarm"
    "policeAlarm24"     : "Little Italy. Center. Police Alarm"
    "policeAlarm25"     : "Little Italy. Near Joe's Apartment. Police Alarm"
    "policeAlarm26"     : "Little Italy. East. Near fuel station. Police Alarm"
    "policeAlarm27"     : "Little Italy. East. Police Alarm"
    "policeAlarm28"     : "Little Italy. East. Police Alarm"
    "policeAlarm29"     : "Little Italy. East. Near bus stop. Police Alarm"
    "policeAlarm30"     : "Little Italy. Near Maria Agnello's Apartment. Police Alarm"
    "policeAlarm31"     : "Little Italy. Border with Chinatown. Police Alarm"
    "policeAlarm32"     : "Chinatown. West. Police Alarm"
    "policeAlarm33"     : "Chinatown. Center. Police Alarm"
    "policeAlarm34"     : "Chinatown. Subway. Police Alarm"
    "policeAlarm35"     : "Oyster Bay. Near gentlemen's club Garden of Eden. Police Alarm"
    "policeAlarm36"     : "Little Italy. Near Scaletta Apartment. Police Alarm"

});


event("onServerStarted", function() {
    log("[jobs] loading police alarm box...");

    //creating public 3dtext
    foreach (policeAlarm in policeAlarms) {
        create3DText ( policeAlarm[0], policeAlarm[1], policeAlarm[2]+0.35, "POLICE ALARM", CL_MALIBU, 6.0);
        create3DText ( policeAlarm[0], policeAlarm[1], policeAlarm[2]+0.20, "Press E", CL_WHITE.applyAlpha(150), 0.4 );
    }

});


function getPoliceAlarmObj(playerid) {
    local check = false;
    local obj = null;
    foreach (key, value in policeAlarms) {
        if (isPlayerInValidPoint3D(playerid, value[0], value[1], value[2], 0.4)) {
        check = true;
        obj = value;
        break;
        }
    }
    if(check) {
        return obj;
    } else {
        return false;
    }
}

local police_alarm_block = {};
function callPoliceByAlarm (playerid) {
    local policeAlarm = getPoliceAlarmObj(playerid);

    if (policeAlarm == false) {
        return;
    }

    local plaName = getPlayerName(playerid);
    if (!(plaName in police_alarm_block)) {
        police_alarm_block[plaName] <- null;
    }
    if (police_alarm_block[plaName] != "block") {
        police_alarm_block[plaName] = "block";
                trigger("onPlayerPhoneCall", playerid, "police", policeAlarm[3]);
        delayedFunction(180000, function() {
            police_alarm_block[plaName] = null;
        });
    } else {
        msg(playerid, "organizations.police.alarm.alreadyCall");
    }
}
