include("modules/telephone/commands.nut");
include("modules/telephone/translations.nut");

local phone_nearest_blip = {};
local PHONE_CALL_PRICE = 0.50;

local telephonesd = {
    "0100": {"coords": [ -377.095, 794.644, -20.125 ], "name": "telephone45", "type": 0, "isCalling": false, "isRinging": false},
    "0101": {"coords": [ -375.991, 794.554, -20.125 ], "name": "telephone46", "type": 0, "isCalling": false, "isRinging": false},
    "0102": {"coords": [ -264.414, 678.893, -19.9448 ], "name": "telephone93", "type": 0, "isCalling": false, "isRinging": false},
};

function isPhoneRinging (number) {
    return telephonesd[number]["isRinging"];
}

local telephones = [
/*
0 - phone booth
1 - bussiness
2 - police alarm

 */
    [ -1021.87, 1643.44, 10.6318    , "telephone0"   , 0 ],
    [ -562.58, 1521.96, -16.1836    , "telephone1"   , 0 ],
    [ -310.62, 1694.98, -22.3772    , "telephone2"   , 0 ],
    [ -747.386, 1762.67, -15.0237   , "telephone3"   , 0 ],
    [ -724.814, 1647.21, -14.9223   , "telephone4"   , 0 ],
    [ -724.914, 1645.24, -14.9223   , "telephone5"   , 0 ],
    [ -1200.2, 1675.75, 11.3337     , "telephone6"   , 0 ],
    [ -1436.35, 1676.01, 6.14958    , "telephone7"   , 0 ],
    [ -1520.38, 1592.71, -6.04848   , "telephone8"   , 0 ],
    [ -1038.5, 1368.65, -13.5484    , "telephone9"   , 0 ],
    [ -1037.4, 1368.55, -13.5485    , "telephone10"  , 0 ],
    [ -1033.41, 1398.75, -13.5597   , "telephone11"  , 0 ],
    [ -903.212, 1412.57, -11.3637   , "telephone12"  , 0 ],
    [ -1170.64, 1578.32, 5.84166    , "telephone13"  , 0 ],
    [ -1297.43, 1491.66, -6.07104   , "telephone14"  , 0 ],
    [ -1297.38, 1492.68, -6.07106   , "telephone15"  , 0 ],
    [ -1229.36, 1457.89, -4.88868   , "telephone16"  , 0 ],
    [ -1228.24, 1457.91, -4.85487   , "telephone17"  , 0 ],
    [ -1046.37, 1429.04, -4.3155    , "telephone18"  , 0 ],
    [ -1047.67, 1429.08, -4.31618   , "telephone19"  , 0 ],
    [ -952.956, 1485.89, -4.74223   , "telephone20"  , 0 ],
    [ -1654.7, 1142.97, -7.10701    , "telephone21"  , 0 ],
    [ -1471.25, 1124.4, -11.7355    , "telephone22"  , 0 ],
    [ -1187.1, 1276.32, -13.5484    , "telephone23"  , 0 ],
    [ -1187.13, 1275.15, -13.5485   , "telephone24"  , 0 ],
    [ -1579.08, 940.472, -5.19268   , "telephone25"  , 0 ],
    [ -1416.07, 935.317, -13.6497   , "telephone26"  , 0 ],
    [ -1342.85, 1017.48, -17.6025   , "telephone27"  , 0 ],
    [ -1339.04, 916.051, -18.4358   , "telephone28"  , 0 ],
    [ -1344.78, 796.552, -14.6407   , "telephone29"  , 0 ],
    [ -1562.11, 527.842, -20.1475   , "telephone30"  , 0 ],
    [ -1712.73, 688.218, -10.2715   , "telephone31"  , 0 ],
    [ -1639.46, 382.508, -19.5393   , "telephone32"  , 0 ],
    [ -1559.83, 170.441, -13.267    , "telephone33"  , 0 ],
    [ -1401.38, 218.989, -24.7309   , "telephone34"  , 0 ],
    [ -1649.2, 65.497, -9.2241      , "telephone35"  , 0 ],
    [ -1777.09, -78.2523, -7.52374  , "telephone36"  , 0 ],
    [ -1421.37, -191.312, -20.3051  , "telephone37"  , 0 ],
    [ 139.144, 1226.56, 62.8896     , "telephone38"  , 0 ],
    [ -508.56, 910.732, -19.0552    , "telephone39"  , 0 ],
    [ -646.39, 923.879, -18.8975    , "telephone40"  , 0 ],
    [ -736.363, 832.825, -18.8975   , "telephone41"  , 0 ],
    [ -736.459, 831.573, -18.8976   , "telephone42"  , 0 ],
    [ -622.139, 815.393, -18.8975   , "telephone43"  , 0 ],
    [ -733.445, 691.414, -17.3997   , "telephone44"  , 0 ],
    [ -377.095, 794.644, -20.125    , "telephone45"  , 0, "555-0100" ],
    [ -375.991, 794.554, -20.125    , "telephone46"  , 0, "555-0101" ],
    [ -405.618, 913.88, -19.9786    , "telephone47"  , 0 ],
    [ -156.412, 770.867, -20.733    , "telephone48"  , 0 ],
    [ -8.69882, 625.297, -19.9222   , "telephone49"  , 0 ],
    [ -31.2744, 658.517, -20.1292   , "telephone50"  , 0 ],
    [ -123.964, 553.446, -20.2038   , "telephone51"  , 0 ],
    [ 35.6793, 563.377, -19.3029    , "telephone52"  , 0 ],
    [ 63.6219, 417.433, -13.9426    , "telephone53"  , 0 ],
    [ -6.95174, 381.727, -13.9651   , "telephone54"  , 0 ],
    [ 112.527, 847.265, -19.911     , "telephone55"  , 0 ],
    [ 257.777, 825.8, -20.001       , "telephone56"  , 0 ],
    [ 612.138, 845.592, -12.6475    , "telephone57"  , 0 ],
    [ 385.573, 680.05, -24.8659     , "telephone58"  , 0 ],
    [ 285.979, 612.951, -24.5618    , "telephone59"  , 0 ],
    [ 250.089, 494.022, -20.0461    , "telephone60"  , 0 ],
    [ 436.909, 391.101, -20.1926    , "telephone61"  , 0 ],
    [ 332.423, 232.168, -21.5327    , "telephone62"  , 0 ],
    [ 331.261, 232.113, -21.5326    , "telephone63"  , 0 ],
    [ 383.722, -111.622, -6.62286   , "telephone64"  , 0 ],
    [ 618.075, 32.9697, -18.2669    , "telephone65"  , 0 ],
    [ 747.702, 7.96036, -19.4605    , "telephone66"  , 0 ],
    [ 500.901, -265.225, -20.1588   , "telephone67"  , 0 ],
    [ 282.829, -388.466, -20.1362   , "telephone68"  , 0 ],
    [ 49.447, -456.087, -20.1363    , "telephone69"  , 0 ],
    [ -147.15, -596.099, -20.125    , "telephone70"  , 0 ],
    [ -315.458, -406.552, -14.393   , "telephone71"  , 0 ],
    [ -315.519, -407.59, -14.4268   , "telephone72"  , 0 ],
    [ -427.784, -307.159, -11.7241  , "telephone73"  , 0 ],
    [ 70.7739, -275.54, -20.1476    , "telephone74"  , 0 ],
    [ -68.1265, -199.786, -14.3818  , "telephone75"  , 0 ],
    [ -208.821, -45.6546, -12.0169  , "telephone76"  , 0 ],
    [ 29.1469, 34.0267, -12.5575    , "telephone77"  , 0 ],
    [ 68.3763, 237.33, -15.9921     , "telephone78"  , 0 ],
    [ 67.1935, 237.317, -15.9921    , "telephone79"  , 0 ],
    [ -78.6167, 233.374, -14.4043   , "telephone80"  , 0 ],
    [ -578.792, -481.143, -20.1363  , "telephone81"  , 0 ],
    [ -191.072, 165.4, -10.5756     , "telephone82"  , 0 ],
    [ -584.818, 89.3622, -0.215257  , "telephone83"  , 0 ],
    [ -655.417, 236.77, 1.0432      , "telephone84"  , 0 ],
    [ -515.485, 449.502, 0.971977   , "telephone85"  , 0 ],
    [ -653.472, 555.425, 1.04811    , "telephone86"  , 0 ],
    [ -373.309, 487.793, 1.05809    , "telephone87"  , 0 ],
    [ -373.36, 488.971, 1.05808     , "telephone88"  , 0 ],
    [ -353.737, 592.724, 1.05806    , "telephone89"  , 0 ],
    [ -469.515, 571.311, 1.04652    , "telephone90"  , 0 ],
    [ -470.609, 571.31, 1.04651     , "telephone91"  , 0 ],
    [ -408.296, 631.616, -12.3661   , "telephone92"  , 0 ],
    [ -264.414, 678.893, -19.9448   , "telephone93"  , 0 ],

    [ -352.354, -726.13, -15.4204   , "telephone94"  , 1 ],
    [ 81.3677, 892.368, -13.3204    , "telephone95"  , 1 ],
    [ 626.474, 898.527, -11.7137    , "telephone96"  , 1 ],
    [ -49.231, 740.707, -21.9009    , "telephone97"  , 1 ],
    [ 19.2317, -74.7028, -15.595    , "telephone98"  , 1 ],
    [ -254.039, -82.1033, -11.458   , "telephone99"  , 1 ],
    [ -637.16, 348.346, 1.34485     , "telephone100" , 1 ],
    [ -1386.91, 470.764, -22.1321   , "telephone101" , 1 ],
    [ -1559.92, -163.443, -19.6113  , "telephone102" , 1 ],
    [ -1146.3, 1591.19, 6.25566     , "telephone103" , 1 ],
    [ -1301.75, 996.284, -17.3339   , "telephone104" , 1 ],
    [ -651.048, 942.307, -7.93587   , "telephone105" , 1 ],
    [ 374.146, -290.937, -15.5799   , "telephone106" , 1 ],
    [ -161.972, -588.33, -16.1199   , "telephone107" , 1 ],

    [ 140.695, -427.998, -19.429    , "telephone108" , 1 ],
    [ -1590.33, 175.591, -12.4393   , "telephone109" , 1 ],
    [ -1584.37, 1605.48, -5.22507   , "telephone110" , 1 ],
    [ -645.304, 1293.91, 3.94464    , "telephone111" , 1 ],
    [  -1422.09, 959.373, -12.7543  , "telephone112" , 1 ],
    [  -563.005, 427.133, 1.02075   , "telephone113" , 1 ],
    [ 241.946, 710.54, -24.0321     , "telephone114" , 1 ],
    [  -773.044, -375.432, -20.4072 , "telephone115" , 1 ],

    [ -375.504, -449.881, -17.2661  , "telephone116" , 1 ],
    [-1294.3, 1705.27, 10.5592      , "telephone117" , 1 ],
    [-1424.27, 1298.01, -13.7195    , "telephone118" , 1 ],
    [ -625.776, 290.6, -0.267079    , "telephone119" , 1 ],
    [-517.118, 873.251, -19.3223    , "telephone120" , 1 ],
    [430.495, 304.263, -20.1786     , "telephone121" , 1 ],
    [-40.4981, 388.486, -13.9963    , "telephone122" , 1 ],
    [ 345.958, 39.9048, -24.1478    , "telephone123" , 1 ],
    [ 413.931, -291.478, -20.1622   , "telephone124" , 1 ],
    [-4.2169, 559.556, -19.4067     , "telephone125" , 1 ],
    [ 273.21, 774.425, -21.2439     , "telephone126" , 1 ],
    [ -1376.25, 387.643, -23.7368   , "telephone127" , 1 ],
    [ -1531.76, 2.28327, -17.8468   , "telephone128" , 1 ],
    [-1394.48, -34.1276, -17.8468   , "telephone129" , 1 ],
    [-1183.28, 1707.61, 11.0941     , "telephone130" , 1 ],
    [-288.33, 1628.95, -23.0758     , "telephone131" , 1 ],
    [ 272.476, -454.776, -20.1636   , "telephone132" , 1 ],
    [ 281.13, -118.194, -12.2741    , "telephone133" , 1 ],
    [ -569.074, 310.33, 0.16808     , "telephone134" , 1 ],
    [ -323.609, -587.756, -20.1043  , "telephone135" , 1 ],
    [ 69.4106, 140.001, -14.4583    , "telephone136" , 1 ],
    [ -11.8903, 739.111, -22.0582   , "telephone137" , 1 ],
    [ 405.023, 602.404, -24.9746    , "telephone138" , 1 ],
    [ -711.197, 1758.35, -14.9964   , "telephone139" , 1 ],
    [ -1587.8, 941.463, -5.19652    , "telephone140" , 1 ],
    [ -1684.18, -230.827, -20.3181  , "telephone141" , 1 ],
    [ 339.648, 879.538, -21.2967    , "telephone142" , 1 ],
    [ -150.935, 606.023, -20.1787   , "telephone143" , 1 ],
    [ 543.76, 3.37411, -18.2392     , "telephone144" , 1 ],
    [ 107.752, 182.195, -20.0295    , "telephone145" , 1 ],
    [  -629.376, -44.3486, 0.932261 , "telephone146" , 1 ],

    [ -1304.62, 1608.74, 1.22659    , "telephone147" , 1 ],
];

local numbers = [
    "0192", //car rental
    // "0000", searhing car services
    "1111", // empire custom
    // "1863", // Tires and Rims
    // "6214", // Richard Beck
];

TELEPHONE_TEXT_COLOR <- CL_WAXFLOWER;

event("onServerStarted", function() {
    logStr("[jobs] loading telephone services job and telephone system...");
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
    foreach (phone in telephones) {
        createPrivate3DText ( playerid, phone[0], phone[1], phone[2]+0.35, plocalize(playerid, "TELEPHONE"), CL_RIPELEMON, 2.0);
        createPrivate3DText ( playerid, phone[0], phone[1], phone[2]+0.20, plocalize(playerid, "3dtext.job.press.Q"), CL_WHITE.applyAlpha(150), 0.4 );
    }
});

function getPhoneObj(phoneName) {
    return telephones[phoneName.slice(9).tointeger()];
}


function getPlayerPhoneName(playerid) {
    local check = false;
    local obj = null;
    foreach (key, value in telephones) {
        if (isPlayerInValidPoint3D(playerid, value[0], value[1], value[2], 0.4)) {
        check = true;
        //name = value[3];
        obj = value;
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

function getPlayerPhoneNameNew(playerid) {
    local check = false;
    local obj = null;
    foreach (key, value in telephonesd) {
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
        local distance = getDistanceBetweenPoints2D( pos.x, pos.y, value[0], value[1] );
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
        local phonehash = createPrivateBlip(playerid, telephones[phoneid][0], telephones[phoneid][1], ICON_RED, 1000.0);
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
    local phoneid = phoneid.tointeger();
    setPlayerPosition( playerid, telephones[phoneid][0], telephones[phoneid][1], telephones[phoneid][2] );
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

    if (budka[4] == 0) {
        if(!canMoneyBeSubstracted(playerid, PHONE_CALL_PRICE)) {
            return msg(playerid, "telephone.notenoughmoney");
        }
        subPlayerMoney(playerid, PHONE_CALL_PRICE);
        addWorldMoney(PHONE_CALL_PRICE);
    }

    if(number == "taxi" || number == "police" || number == "dispatch" || number == "towtruck" ) {
        return trigger("onPlayerPhoneCall", playerid, number, budka[3] /*plocalize(playerid, budka[3])*/ );
    }

    local number = str_replace("555-", "", number);
    if(isNumeric(number) && number.len() == 4) {
        trigger(playerid, "onServerShowChatTrigger");
        msg(playerid, "telephone.youcall", ["555-"+number]);
        delayedFunction(3000, function () {
            local check = false;
            if (number in telephonesd) {
                check = true;
            } else {
                foreach (idx, num in numbers) {
                    if (num == number) { check = true; }
                }
            }
            if(check) {
                trigger("onPlayerPhoneCall", playerid, number, plocalize(playerid, budka[3]));
            } else {
                msg(playerid, "telephone.notregister");
                delayedFunction(1000, function() { phoneStartCall (playerid, null, null); });
            }
        });
    } else {
        msg(playerid, "telephone.incorrect");
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
    triggerClientEvent(playerid, "showPhoneGUI", windowText, label0Callto, label1insertNumber, button0Police, button1Taxi, button2Call, button3Refuse, input0exampleNumber);
}

event("onPlayerPhoneCall", function(playerid, number, place) {
    if  (number == getPlayerPhoneNameNew(playerid)) return msg(playerid, "telephone.callyourself", CL_WARNING);
    if (number in numbers == false) {
    msg(playerid, telephonesd[number]["name"].tostring());
    telephonesd[getPlayerPhoneNameNew(playerid)]["isCalling"] = true;
    telephonesd[number]["isRinging"] = true;
    local coords = telephonesd[number]["coords"];
    createPlace(format("phone_%s", number), coords[0] + 10, coords[1] + 10, coords[0] - 10, coords[1] - 10);
    delayedFunction(60000, function() {
        if (telephonesd[number]["isRinging"]) {
            telephonesd[number]["isRinging"] = false;
            telephonesd[getPlayerPhoneNameNew(playerid)]["isCalling"] = false;
            removePlace(format("phone_%s", number));
            msg(playerid, "telephone.noanswer", CL_WARNING);
        }
    });
    }
});


event("onPlayerPlaceEnter", function(playerid, name) {
    local data = split(name, "_");
    dbg(isPhoneRinging(data[1]));
    if (data[0] == "phone") {
        if (isPhoneRinging(data[1])) {
            triggerClientEvent(playerid, "ringPhone", true);
        }
    }
});

event("onPlayerPlaceExit", function(playerid, name) {
    local data = split(name, "_");
    if (data[0] == "phone") {
        triggerClientEvent(playerid, "ringPhone", false);
    }
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
