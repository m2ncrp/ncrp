include("modules/telephone/commands.nut");
include("modules/telephone/translations.nut");

local phone_nearest_blip = {};
local PHONE_CALL_PRICE = 0.50;

local phoneUser = {};


function getUserPhone (charid) {
    return phoneUser[charid];
}

function deleteUserCall (charid) {
    return phoneUser[charid] <- null;
}

function isUsingPhone (charid) {
    if (charid in phoneUser){
        return phoneUser[charid] != null
    } else {
        return false;
    }
};



/*
0 - phone booth
1 - bussiness
*/
local telephones = {
    "0100": {"coords": [ -1021.87, 1643.44, 10.6318  ], "name": "telephone0"  , "type": 0},
    "0101": {"coords": [ -562.58, 1521.96, -16.1836  ], "name": "telephone1"  , "type": 0},
    "0102": {"coords": [ -310.62, 1694.98, -22.3772  ], "name": "telephone2"  , "type": 0},
    "0103": {"coords": [ -747.386, 1762.67, -15.0237 ], "name": "telephone3"  , "type": 0},
    "0104": {"coords": [ -724.814, 1647.21, -14.9223 ], "name": "telephone4"  , "type": 0},
    "0105": {"coords": [ -724.914, 1645.24, -14.9223 ], "name": "telephone5"  , "type": 0},
    "0106": {"coords": [ -1200.2, 1675.75, 11.3337   ], "name": "telephone6"  , "type": 0},
    "0107": {"coords": [ -1436.35, 1676.01, 6.14958  ], "name": "telephone7"  , "type": 0},
    "0108": {"coords": [ -1520.38, 1592.71, -6.04848 ], "name": "telephone8"  , "type": 0},
    "0109": {"coords": [ -1038.5, 1368.65, -13.5484  ], "name": "telephone9"  , "type": 0},
    "0110": {"coords": [ -1037.4, 1368.55, -13.5485  ], "name": "telephone10" , "type": 0},
    "0111": {"coords": [ -1033.41, 1398.75, -13.5597 ], "name": "telephone11" , "type": 0},
    "0112": {"coords": [ -903.212, 1412.57, -11.3637 ], "name": "telephone12" , "type": 0},
    "0113": {"coords": [ -1170.64, 1578.32, 5.84166  ], "name": "telephone13" , "type": 0},
    "0114": {"coords": [ -1297.43, 1491.66, -6.07104 ], "name": "telephone14" , "type": 0},
    "0115": {"coords": [ -1297.38, 1492.68, -6.07106 ], "name": "telephone15" , "type": 0},
    "0116": {"coords": [ -1229.36, 1457.89, -4.88868 ], "name": "telephone16" , "type": 0},
    "0117": {"coords": [ -1228.24, 1457.91, -4.85487 ], "name": "telephone17" , "type": 0},
    "0118": {"coords": [ -1046.37, 1429.04, -4.3155  ], "name": "telephone18" , "type": 0},
    "0119": {"coords": [ -1047.67, 1429.08, -4.31618 ], "name": "telephone19" , "type": 0},
    "0120": {"coords": [ -952.956, 1485.89, -4.74223 ], "name": "telephone20" , "type": 0},
    "0121": {"coords": [ -1654.7, 1142.97, -7.10701  ], "name": "telephone21" , "type": 0},
    "0122": {"coords": [ -1471.25, 1124.4, -11.7355  ], "name": "telephone22" , "type": 0},
    "0123": {"coords": [ -1187.1, 1276.32, -13.5484  ], "name": "telephone23" , "type": 0},
    "0124": {"coords": [ -1187.13, 1275.15, -13.5485 ], "name": "telephone24" , "type": 0},
    "0125": {"coords": [ -1579.08, 940.472, -5.19268 ], "name": "telephone25" , "type": 0},
    "0126": {"coords": [ -1416.07, 935.317, -13.6497 ], "name": "telephone26" , "type": 0},
    "0127": {"coords": [ -1342.85, 1017.48, -17.6025 ], "name": "telephone27" , "type": 0},
    "0128": {"coords": [ -1339.04, 916.051, -18.4358 ], "name": "telephone28" , "type": 0},
    "0129": {"coords": [ -1344.78, 796.552, -14.6407 ], "name": "telephone29" , "type": 0},
    "0130": {"coords": [ -1562.11, 527.842, -20.1475 ], "name": "telephone30" , "type": 0},
    "0131": {"coords": [ -1712.73, 688.218, -10.2715 ], "name": "telephone31" , "type": 0},
    "0132": {"coords": [ -1639.46, 382.508, -19.5393 ], "name": "telephone32" , "type": 0},
    "0133": {"coords": [ -1559.83, 170.441, -13.267  ], "name": "telephone33" , "type": 0},
    "0134": {"coords": [ -1401.38, 218.989, -24.7309 ], "name": "telephone34" , "type": 0},
    "0135": {"coords": [ -1649.2, 65.497, -9.2241    ], "name": "telephone35" , "type": 0},
    "0136": {"coords": [ -1777.09, -78.2523, -7.52374], "name": "telephone36" , "type": 0},
    "0137": {"coords": [ -1421.37, -191.312, -20.3051], "name": "telephone37" , "type": 0},
    "0138": {"coords": [ 139.144, 1226.56, 62.8896   ], "name": "telephone38" , "type": 0},
    "0139": {"coords": [ -508.56, 910.732, -19.0552  ], "name": "telephone39" , "type": 0},
    "0140": {"coords": [ -646.39, 923.879, -18.8975  ], "name": "telephone40" , "type": 0},
    "0141": {"coords": [ -736.363, 832.825, -18.8975 ], "name": "telephone41" , "type": 0},
    "0142": {"coords": [ -736.459, 831.573, -18.8976 ], "name": "telephone42" , "type": 0},
    "0143": {"coords": [ -622.139, 815.393, -18.8975 ], "name": "telephone43" , "type": 0},
    "0144": {"coords": [ -733.445, 691.414, -17.3997 ], "name": "telephone44" , "type": 0},
    "0145": {"coords": [ -377.095, 794.644, -20.125  ], "name": "telephone45" , "type": 0},
    "0146": {"coords": [ -375.991, 794.554, -20.125  ], "name": "telephone46" , "type": 0},
    "0147": {"coords": [ -405.618, 913.88, -19.9786  ], "name": "telephone47" , "type": 0},
    "0148": {"coords": [ -156.412, 770.867, -20.733  ], "name": "telephone48" , "type": 0},
    "0149": {"coords": [ -8.69882, 625.297, -19.9222 ], "name": "telephone49" , "type": 0},
    "0150": {"coords": [ -31.2744, 658.517, -20.1292 ], "name": "telephone50" , "type": 0},
    "0151": {"coords": [ -123.964, 553.446, -20.2038 ], "name": "telephone51" , "type": 0},
    "0152": {"coords": [ 35.6793, 563.377, -19.3029  ], "name": "telephone52" , "type": 0},
    "0153": {"coords": [ 63.6219, 417.433, -13.9426  ], "name": "telephone53" , "type": 0},
    "0154": {"coords": [ -6.95174, 381.727, -13.9651 ], "name": "telephone54" , "type": 0},
    "0155": {"coords": [ 112.527, 847.265, -19.911   ], "name": "telephone55" , "type": 0},
    "0156": {"coords": [ 257.777, 825.8, -20.001     ], "name": "telephone56" , "type": 0},
    "0157": {"coords": [ 612.138, 845.592, -12.6475  ], "name": "telephone57" , "type": 0},
    "0158": {"coords": [ 385.573, 680.05, -24.8659   ], "name": "telephone58" , "type": 0},
    "0159": {"coords": [ 285.979, 612.951, -24.5618  ], "name": "telephone59" , "type": 0},
    "0160": {"coords": [ 250.089, 494.022, -20.0461  ], "name": "telephone60" , "type": 0},
    "0161": {"coords": [ 436.909, 391.101, -20.1926  ], "name": "telephone61" , "type": 0},
    "0162": {"coords": [ 332.423, 232.168, -21.5327  ], "name": "telephone62" , "type": 0},
    "0163": {"coords": [ 331.261, 232.113, -21.5326  ], "name": "telephone63" , "type": 0},
    "0164": {"coords": [ 383.722, -111.622, -6.62286 ], "name": "telephone64" , "type": 0},
    "0165": {"coords": [ 618.075, 32.9697, -18.2669  ], "name": "telephone65" , "type": 0},
    "0166": {"coords": [ 747.702, 7.96036, -19.4605  ], "name": "telephone66" , "type": 0},
    "0167": {"coords": [ 500.901, -265.225, -20.1588 ], "name": "telephone67" , "type": 0},
    "0168": {"coords": [ 282.829, -388.466, -20.1362 ], "name": "telephone68" , "type": 0},
    "0169": {"coords": [ 49.447, -456.087, -20.1363  ], "name": "telephone69" , "type": 0},
    "0170": {"coords": [ -147.15, -596.099, -20.125  ], "name": "telephone70" , "type": 0},
    "0171": {"coords": [ -315.458, -406.552, -14.393 ], "name": "telephone71" , "type": 0},
    "0172": {"coords": [ -315.519, -407.59, -14.4268 ], "name": "telephone72" , "type": 0},
    "0173": {"coords": [ -427.784, -307.159, -11.7241], "name": "telephone73" , "type": 0},
    "0174": {"coords": [ 70.7739, -275.54, -20.1476  ], "name": "telephone74" , "type": 0},
    "0175": {"coords": [ -68.1265, -199.786, -14.3818], "name": "telephone75" , "type": 0},
    "0176": {"coords": [ -208.821, -45.6546, -12.0169], "name": "telephone76" , "type": 0},
    "0177": {"coords": [ 29.1469, 34.0267, -12.5575  ], "name": "telephone77" , "type": 0},
    "0178": {"coords": [ 68.3763, 237.33, -15.9921   ], "name": "telephone78" , "type": 0},
    "0179": {"coords": [ 67.1935, 237.317, -15.9921  ], "name": "telephone79" , "type": 0},
    "0180": {"coords": [ -78.6167, 233.374, -14.4043 ], "name": "telephone80" , "type": 0},
    "0181": {"coords": [ -578.792, -481.143, -20.1363], "name": "telephone81" , "type": 0},
    "0182": {"coords": [ -191.072, 165.4, -10.5756   ], "name": "telephone82" , "type": 0},
    "0183": {"coords": [ -584.818, 89.3622, -0.215257], "name": "telephone83" , "type": 0},
    "0184": {"coords": [ -655.417, 236.77, 1.0432    ], "name": "telephone84" , "type": 0},
    "0185": {"coords": [ -515.485, 449.502, 0.971977 ], "name": "telephone85" , "type": 0},
    "0186": {"coords": [ -653.472, 555.425, 1.04811  ], "name": "telephone86" , "type": 0},
    "0187": {"coords": [ -373.309, 487.793, 1.05809  ], "name": "telephone87" , "type": 0},
    "0188": {"coords": [ -373.36, 488.971, 1.05808   ], "name": "telephone88" , "type": 0},
    "0189": {"coords": [ -353.737, 592.724, 1.05806  ], "name": "telephone89" , "type": 0},
    "0190": {"coords": [ -469.515, 571.311, 1.04652  ], "name": "telephone90" , "type": 0},
    "0191": {"coords": [ -470.609, 571.31, 1.04651   ], "name": "telephone91" , "type": 0},
    "0193": {"coords": [ -408.296, 631.616, -12.3661 ], "name": "telephone92" , "type": 0},
    "0194": {"coords": [ -264.414, 678.893, -19.9448 ], "name": "telephone93" , "type": 0},
    "0400": {"coords": [ -352.354, -726.13, -15.4204 ], "name": "telephone94" , "type": 1},
    "0401": {"coords": [ 81.3677, 892.368, -13.3204  ], "name": "telephone95" , "type": 1},
    "0402": {"coords": [ 626.474, 898.527, -11.7137  ], "name": "telephone96" , "type": 1},
    "0403": {"coords": [ -49.231, 740.707, -21.9009  ], "name": "telephone97" , "type": 1},
    "0404": {"coords": [ 19.2317, -74.7028, -15.595  ], "name": "telephone98" , "type": 1},
    "0405": {"coords": [ -254.039, -82.1033, -11.458 ], "name": "telephone99" , "type": 1},
    "0406": {"coords": [ -637.16, 348.346, 1.34485   ], "name": "telephone100", "type": 1},
    "0407": {"coords": [ -1386.91, 470.764, -22.1321 ], "name": "telephone101", "type": 1},
    "0408": {"coords": [ -1559.92, -163.443, -19.6113], "name": "telephone102", "type": 1},
    "0409": {"coords": [ -1146.3, 1591.19, 6.25566   ], "name": "telephone103", "type": 1},
    "0410": {"coords": [ -1301.75, 996.284, -17.3339 ], "name": "telephone104", "type": 1},
    "0411": {"coords": [ -651.048, 942.307, -7.93587 ], "name": "telephone105", "type": 1},
    "0412": {"coords": [ 374.146, -290.937, -15.5799 ], "name": "telephone106", "type": 1},
    "0413": {"coords": [ -161.972, -588.33, -16.1199 ], "name": "telephone107", "type": 1},
    "0414": {"coords": [ 140.695, -427.998, -19.429   ], "name": "telephone108", "type": 1},
    "0415": {"coords": [ -1590.33, 175.591, -12.4393  ], "name": "telephone109", "type": 1},
    "0416": {"coords": [ -1584.37, 1605.48, -5.22507  ], "name": "telephone110", "type": 1},
    "0417": {"coords": [ -645.304, 1293.91, 3.94464   ], "name": "telephone111", "type": 1},
    "0418": {"coords": [  -1422.09, 959.373, -12.7543 ], "name": "telephone112", "type": 1},
    "0419": {"coords": [  -563.005, 427.133, 1.02075  ], "name": "telephone113", "type": 1},
    "0420": {"coords": [ 241.946, 710.54, -24.0321    ], "name": "telephone114", "type": 1},
    "0421": {"coords": [  -773.044, -375.432, -20.4072], "name": "telephone115", "type": 1},
    "0422": {"coords": [ -375.504, -449.881, -17.2661 ], "name": "telephone116", "type": 1},
    "0423": {"coords": [-1294.3, 1705.27, 10.5592     ], "name": "telephone117", "type": 1},
    "0424": {"coords": [-1424.27, 1298.01, -13.7195   ], "name": "telephone118", "type": 1},
    "0425": {"coords": [ -625.776, 290.6, -0.267079   ], "name": "telephone119", "type": 1},
    "0426": {"coords": [-517.118, 873.251, -19.3223   ], "name": "telephone120", "type": 1},
    "0427": {"coords": [430.495, 304.263, -20.1786    ], "name": "telephone121", "type": 1},
    "0428": {"coords": [-40.4981, 388.486, -13.9963   ], "name": "telephone122", "type": 1},
    "0429": {"coords": [ 345.958, 39.9048, -24.1478   ], "name": "telephone123", "type": 1},
    "0430": {"coords": [ 413.931, -291.478, -20.1622  ], "name": "telephone124", "type": 1},
    "0431": {"coords": [-4.2169, 559.556, -19.4067    ], "name": "telephone125", "type": 1},
    "0432": {"coords": [ 273.21, 774.425, -21.2439    ], "name": "telephone126", "type": 1},
    "0433": {"coords": [ -1376.25, 387.643, -23.7368  ], "name": "telephone127", "type": 1},
    "0434": {"coords": [ -1531.76, 2.28327, -17.8468  ], "name": "telephone128", "type": 1},
    "0435": {"coords": [-1394.48, -34.1276, -17.8468  ], "name": "telephone129", "type": 1},
    "0436": {"coords": [-1183.28, 1707.61, 11.0941    ], "name": "telephone130", "type": 1},
    "0437": {"coords": [-288.33, 1628.95, -23.0758    ], "name": "telephone131", "type": 1},
    "0438": {"coords": [ 272.476, -454.776, -20.1636  ], "name": "telephone132", "type": 1},
    "0439": {"coords": [ 281.13, -118.194, -12.2741   ], "name": "telephone133", "type": 1},
    "0440": {"coords": [ -569.074, 310.33, 0.16808    ], "name": "telephone134", "type": 1},
    "0441": {"coords": [ -323.609, -587.756, -20.1043 ], "name": "telephone135", "type": 1},
    "0442": {"coords": [ 69.4106, 140.001, -14.4583   ], "name": "telephone136", "type": 1},
    "0443": {"coords": [ -11.8903, 739.111, -22.0582  ], "name": "telephone137", "type": 1},
    "0444": {"coords": [ 405.023, 602.404, -24.9746   ], "name": "telephone138", "type": 1},
    "0445": {"coords": [ -711.197, 1758.35, -14.9964  ], "name": "telephone139", "type": 1},
    "0446": {"coords": [ -1587.8, 941.463, -5.19652   ], "name": "telephone140", "type": 1},
    "0447": {"coords": [ -1684.18, -230.827, -20.3181 ], "name": "telephone141", "type": 1},
    "0448": {"coords": [ 339.648, 879.538, -21.2967   ], "name": "telephone142", "type": 1},
    "0449": {"coords": [ -150.935, 606.023, -20.1787  ], "name": "telephone143", "type": 1},
    "0450": {"coords": [ 543.76, 3.37411, -18.2392    ], "name": "telephone144", "type": 1},
    "0451": {"coords": [ 107.752, 182.195, -20.0295   ], "name": "telephone145", "type": 1},
    "0452": {"coords": [  -629.376, -44.3486, 0.932261], "name": "telephone146", "type": 1},
    "0453": {"coords": [ -1304.62, 1608.74, 1.22659  ], "name": "telephone147", "type":  1},
};

function getPhoneData (number) {
    return telephones[number];
}

function clearPhoneData(number) {
    telephones[number]["isCalling"] = false;
    telephones[number]["caller"] = null;
    telephones[number]["callee"] = null;
}

function isPhoneRinging (number) {
    return telephones[number]["isRinging"];
}

function getPhoneType(number) {
    return telephones[number]["type"];
}

function getPhoneCoords(number) {
    return telephones[number]["coords"];
}

local numbers = {
    "0192": "car rental",
    // "0000", searhing car services
    "1111": "empire custom"
    // "1863", // Tires and Rims
    // "6214", // Richard Beck
};

TELEPHONE_TEXT_COLOR <- CL_WAXFLOWER;

event("onServerStarted", function() {
    logStr("[jobs] loading telephone services job and telephone system...");
    foreach (idx, phone in telephones) {
        telephones[idx]["isCalling"] <- false;
        telephones[idx]["isRinging"] <- false;
        telephones[idx]["caller"] <- null;
        telephones[idx]["callee"] <- null;
    }
/*
    local ets1 = createVehicle(31, -1066.02, 1483.81, -3.79657, -90.8055, -1.36482, -0.105954);   // telephoneCAR1
    local ets2 = createVehicle(31, -1076.38, 1483.81, -3.51025, -89.5915, -1.332, -0.0857111);   // telephoneCAR2
    setVehicleColor(ets1, 102, 70, 18, 63, 36, 7);
    setVehicleColor(ets2, 102, 70, 18, 63, 36, 7);
    setVehiclePlateText(ets1, "ETS-01");
    setVehiclePlateText(ets2, "ETS-02");
*/



});

event("onPlayerConnect", function(playerid){
    phone_nearest_blip[playerid] <- {};
    phone_nearest_blip[playerid]["blip3dtext"] <- null;
});

event("onServerPlayerStarted", function( playerid ){
    //creating public 3dtext
    foreach (phone, key in telephones) {
        createPrivate3DText ( playerid, key["coords"][0], key["coords"][1], key["coords"][2]+0.35, plocalize(playerid, "TELEPHONE"), CL_RIPELEMON, 2.0);
        createPrivate3DText ( playerid, key["coords"][0], key["coords"][1], key["coords"][2]+0.20, plocalize(playerid, "3dtext.job.press.Q"), CL_WHITE.applyAlpha(150), 0.4 );
    }
});

function getPlayerPhoneName(playerid) {
    local check = false;
    local obj = null;
    foreach (key, value in telephones) {
        if (isPlayerInValidPoint3D(playerid, value["coords"][0], value["coords"][1], value["coords"][2], 0.4)) {
        check = true;
        //name = value[3];
        obj = key;
        break;
        }
    }
    if(check) {
        return obj;
        //return plocalize(playerid, name);
    } else {
        return false;
    }
}

function phoneFindNearest( playerid ) {
    local pos = getPlayerPositionObj( playerid );
    local dis = 2000;
    local phoneid = null;
    foreach (key, value in telephones) {
        local distance = getDistanceBetweenPoints2D( pos.x, pos.y, value["coords"][0], value["coords"][1] );
        if (distance < dis && value[4] == 0) {
           dis = distance;
           phoneid = key;
        }
    }
    return phoneid;
}


function showBlipNearestPhoneForPlayer ( playerid ) {
    if (phone_nearest_blip[playerid]["blip3dtext"] == null) {
        local phoneid = phoneFindNearest( playerid );
        local phonehash = createPrivateBlip(playerid, telephones[phoneid]["coords"][0], telephones[phoneid]["coords"][1], ICON_RED, 1000.0);
        phone_nearest_blip[playerid]["blip3dtext"] = true;
        msg( playerid, "telephone.findphone");
        delayedFunction(20000, function() {
            removeBlip(phonehash);
            phone_nearest_blip[playerid]["blip3dtext"] = null;
        });

    } else {
        msg( playerid, "telephone.findalready");
    }
}

function goToPhone(playerid, phoneid) {
    local phoneid = phoneid;
    setPlayerPosition( playerid, telephones[phoneid]["coords"][0], telephones[phoneid]["coords"][1], telephones[phoneid]["coords"][2] );
}


function phoneStartCall(playerid, number, isbind) {
    local budka = getPlayerPhoneName(playerid);

    if (budka == false && isbind == true) {
        return;
    }

    // need phonebooth
    if (budka == false && isbind == false) {
        msg(playerid, "");
        msg(playerid, "telephone.needphone");
        showBlipNearestPhoneForPlayer (playerid);
        return;
    }

    showPhoneGUI(playerid);
}

function stopRinging(number) {
        telephones[number]["isRinging"] = false;
        local coords = getPhoneCoords(number);
        foreach (idx, value in players) {
            if (isInArea(format("phone_%s", number), value.x, value.y)){
                if (getPhoneType(number) == 1){
                    triggerClientEvent(idx, "ringPhoneStatic", false, coords[0], coords[1], coords[2]);
                } else {
                    triggerClientEvent(idx, "ringPhone", false);
                }
            }
        }
        removeArea(format("phone_%s", number));
}

function callByPhone (playerid, number = null, isbind = false) {
    local budka = getPlayerPhoneName(playerid);

    if (budka == false && isbind == true) {
        return;
    }

    // need phonebooth
    if (budka == false && isbind == false) {
        msg(playerid, "");
        msg(playerid, "telephone.needphone");
        showBlipNearestPhoneForPlayer ( playerid );
        return;
    }

    // number empty
    if (number == null) {
        return msg(playerid, "telephone.neednumber");
    }

    if (telephones[budka]["type"] == 0) {
        if(!canMoneyBeSubstracted(playerid, PHONE_CALL_PRICE)) {
            return msg(playerid, "telephone.notenoughmoney");
        }
        subPlayerMoney(playerid, PHONE_CALL_PRICE);
        addWorldMoney(PHONE_CALL_PRICE);
    }

    if(number == "taxi" || number == "police" || number == "dispatch" || number == "towtruck" ) {
        return trigger("onPlayerPhoneCall", playerid, number, telephones[budka]["name"] /*plocalize(playerid, budka[3])*/ );
    }
    local number = str_replace("555-", "", number);
    if(isNumeric(number) && number.len() == 4) {
        trigger(playerid, "onServerShowChatTrigger");
        msg(playerid, "telephone.youcall", ["555-"+number]);
        delayedFunction(3000, function () {
            local check = false;
            if (number in telephones) {
                trigger("onPlayerPhoneCall", playerid, number, plocalize(playerid, telephones[budka]["name"]));
                check = true;
                return;
            } else {
                if (number in numbers) {
                    trigger("onPlayerPhoneCallNPC", playerid, number, plocalize(playerid, telephones[budka]["name"]));
                    check = true;
                    return;
                }
            }
            if (!check){
                msg(playerid, "telephone.notregister");
                animatedPut(playerid);
                delayedFunction(1000, function() { phoneStartCall (playerid, null, null); });
            }
        });
    } else {
        msg(playerid, "telephone.incorrect");
        animatedPut(playerid);
    }
}

/* -------------------------------------------------------------------------------------------------------- */

event("PhoneCallGUI", function (playerid, number) {
    callByPhone(playerid, number);
});

function showPhoneGUI(playerid){
    local windowText            =  plocalize(playerid, "phone.gui.window");
    local label0Callto          =  plocalize(playerid, "phone.gui.callto");
    local label1insertNumber    =  plocalize(playerid, "phone.gui.insertNumber");
    local button0Police         =  plocalize(playerid, "phone.gui.buttonPolice");
    local button1Taxi           =  plocalize(playerid, "phone.gui.buttonTaxi");
    local button2Call           =  plocalize(playerid, "phone.gui.buttonCall");
    local button3Refuse         =  plocalize(playerid, "phone.gui.buttonRefuse");
    local input0exampleNumber   =  plocalize(playerid, "phone.gui.exampleNumber");
    animatedPickUp(playerid);
    delayedFunction(2000, function() {
        triggerClientEvent(playerid, "showPhoneGUI", windowText, label0Callto, label1insertNumber, button0Police, button1Taxi, button2Call, button3Refuse, input0exampleNumber);
    });
}

event("onPlayerPhoneCall", function(playerid, number, place) {
    if  (number == getPlayerPhoneName(playerid)) {
        msg(playerid, "telephone.callyourself", CL_WARNING);
        animatedPut(playerid);
        return;
    }
    if (telephones[number]["isCalling"]){
        animatedPut(playerid);
        return msg(playerid, "telephone.lineinuse", CL_WARNING);
        }

    if (!(number in numbers) && (number != "police")) {
        local phone = getPlayerPhoneName(playerid);
        phoneUser[getCharacterIdFromPlayerId(playerid)] <- phone;
        telephones[phone]["isCalling"] = true;
        telephones[number]["isCalling"] = true;
        telephones[phone]["callee"] = getCharacterIdFromPlayerId(playerid);
        telephones[number]["isRinging"] = true;
        local coords = telephones[number]["coords"];
        createPlace(format("phone_%s", number), coords[0] + 10, coords[1] + 10, coords[0] - 10, coords[1] - 10);
        telephones[number]["caller"] = getCharacterIdFromPlayerId(playerid);
        delayedFunction(10000, function() {
            if (telephones[number]["isRinging"]) {
                stopRinging(number);
                animatedPut(playerid);
                deleteUserCall(getCharacterIdFromPlayerId(playerid));
                clearPhoneData(phone);
                clearPhoneData(number);
                msg(playerid, "telephone.noanswer", CL_WARNING);
            }
        });
    };
});


event("onPlayerPhonePickUp", function(playerid, number) {
    local charId = getCharacterIdFromPlayerId(playerid);
    phoneUser[charId] <- number;
    stopRinging(number);
    telephones[number]["isCalling"] = true;
    telephones[number]["callee"] = charId;
    local caller = telephones[number]["caller"];
    telephones[phoneUser[caller]]["caller"] = charId;
    msg(playerid, "telephone.callstart", CL_SUCCESS);
    msg(getPlayerIdFromCharacterId(caller), "telephone.callstart", CL_SUCCESS);
});


event("onPlayerPlaceEnter", function(playerid, name) {
    local data = split(name, "_");
    if (data[0] == "phone") {
        if (isPhoneRinging(data[1])) {
            if (getPhoneType(data[1]) == 1){
                local coords = getPhoneCoords(data[1]);
                triggerClientEvent(playerid, "ringPhoneStatic", true, coords[0], coords[1], coords[2]);
            } else {
                triggerClientEvent(playerid, "ringPhone", true);
            }
        }
    }
});

event("onPlayerPlaceExit", function(playerid, name) {
    local data = split(name, "_");
    if (data[0] == "phone") {
        if (isPhoneRinging(data[1])) {
            if (getPhoneType(data[1]) == 1){
                local coords = getPhoneCoords(data[1]);
                triggerClientEvent(playerid, "ringPhoneStatic", false, coords[0], coords[1], coords[2]);
            } else {
                triggerClientEvent(playerid, "ringPhone", false);
            }
        }
    }
});

event("onPlayerDisconnect", function(playerid, reason) {
    if (getCharacterIdFromPlayerId(playerid) in phoneUser) {
        stopCall(playerid);
    }
});

event("onPlayerDeath", function(playerid) {
    if (getCharacterIdFromPlayerId(playerid) in phoneUser) {
        stopCall(playerid);
    }
});

function animatedPickUp(playerid) {
    local type = getPhoneType(getPlayerPhoneName(playerid)) == 1;
    local animation1 = ( type ? "Phone.PickUp": "PhoneBooth.PickUp");
    local animation2 = ( type ? "Phone.Static" : "PhoneBooth.Static");
    local model = ( type ? 118 : 1);
    animateGlobal(playerid, {"animation": animation1, "unblock": false, "model": model}, 2000);
    delayedFunction(2000, function() {
        animateGlobal(playerid, {"animation": animation2, "endless": true, "block": false, "model": model});
    });
}

function animatedPut(playerid) {
    clearAnimPlace(playerid);
    local type = getPhoneType(getPlayerPhoneName(playerid)) == 1;
    local animation = ( type ? "Phone.Put": "PhoneBooth.Put");
    local model = ( type ? 118 : 1);
    animateGlobal(playerid, {"animation": animation, "model": model}, 1)
    delayedFunction(50, function() {
        animateGlobal(playerid, {"animation": animation, "model": model}, 1000)
    });
}


function stopCall(playerid) {
    local charId = getCharacterIdFromPlayerId(playerid);
    if (!isUsingPhone(charId)) return;
    local number = phoneUser[charId];
    if (number == null) return;
    local data = getPhoneData(number);
    local callerId = getPlayerIdFromCharacterId(data.caller);
    local calleeId = getPlayerIdFromCharacterId(data.callee);
    msg(callerId, "telephone.callend", CL_WARNING)
    msg(calleeId, "telephone.callend", CL_WARNING);
    if (callerId == playerid) {
        animatedPut(calleeId);
    } else {
        animatedPut(callerId);
    }
    clearPhoneData(phoneUser[data.caller]);
    clearPhoneData(phoneUser[data.callee]);
    deleteUserCall(getCharacterIdFromPlayerId(callerId));
    deleteUserCall(getCharacterIdFromPlayerId(calleeId));
    clearAnimPlace(playerid);
}

event("PhonePutGUI", function (playerid) {
    animatedPut(playerid);
});
    //showBlipNearestPhoneForPlayer ( playerid );
/* don't remove

addEventHandlerEx("onServerStarted", function() {
    logStr("[jobs] loading telephone services job...");
    local teleservicescars = [
        createVehicle(31, -1066.02, 1483.81, -3.79657, -90.8055, -1.36482, -0.105954),   // telephoneCAR1
        createVehicle(31, -1076.38, 1483.81, -3.51025, -89.5915, -1.332, -0.0857111),   // telephoneCAR2
    ];

    foreach(key, value in teleservicescars ) {
        setVehicleColour( value, 125, 60, 20, 125, 60, 20 );
    }
});

*/
