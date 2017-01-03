include("modules/jobs/telephone/commands.nut");

local phone_nearest_blip = {};

local telephones = [
    [ -1021.87, 1643.44, 10.6318    , "telephone0"   ],
    [ -562.58, 1521.96, -16.1836    , "telephone1"   ],
    [ -310.62, 1694.98, -22.3772    , "telephone2"   ],
    [ -747.386, 1762.67, -15.0237   , "telephone3"   ],
    [ -724.814, 1647.21, -14.9223   , "telephone4"   ],
    [ -724.914, 1645.24, -14.9223   , "telephone5"   ],
    [ -1200.2, 1675.75, 11.3337     , "telephone6"   ],
    [ -1436.35, 1676.01, 6.14958    , "telephone7"   ],
    [ -1520.38, 1592.71, -6.04848   , "telephone8"   ],
    [ -1038.5, 1368.65, -13.5484    , "telephone9"   ],
    [ -1037.4, 1368.55, -13.5485    , "telephone10"  ],
    [ -1033.41, 1398.75, -13.5597   , "telephone11"  ],
    [ -903.212, 1412.57, -11.3637   , "telephone12"  ],
    [ -1170.64, 1578.32, 5.84166    , "telephone13"  ],
    [ -1297.43, 1491.66, -6.07104   , "telephone14"  ],
    [ -1297.38, 1492.68, -6.07106   , "telephone15"  ],
    [ -1229.36, 1457.89, -4.88868   , "telephone16"  ],
    [ -1228.24, 1457.91, -4.85487   , "telephone17"  ],
    [ -1046.37, 1429.04, -4.3155    , "telephone18"  ],
    [ -1047.67, 1429.08, -4.31618   , "telephone19"  ],
    [ -952.956, 1485.89, -4.74223   , "telephone20"  ],
    [ -1654.7, 1142.97, -7.10701    , "telephone21"  ],
    [ -1471.25, 1124.4, -11.7355    , "telephone22"  ],
    [ -1187.1, 1276.32, -13.5484    , "telephone23"  ],
    [ -1187.13, 1275.15, -13.5485   , "telephone24"  ],
    [ -1579.08, 940.472, -5.19268   , "telephone25"  ],
    [ -1416.07, 935.317, -13.6497   , "telephone26"  ],
    [ -1342.85, 1017.48, -17.6025   , "telephone27"  ],
    [ -1339.04, 916.051, -18.4358   , "telephone28"  ],
    [ -1344.78, 796.552, -14.6407   , "telephone29"  ],
    [ -1562.11, 527.842, -20.1475   , "telephone30"  ],
    [ -1712.73, 688.218, -10.2715   , "telephone31"  ],
    [ -1639.46, 382.508, -19.5393   , "telephone32"  ],
    [ -1559.83, 170.441, -13.267    , "telephone33"  ],
    [ -1401.38, 218.989, -24.7309   , "telephone34"  ],
    [ -1649.2, 65.497, -9.2241      , "telephone35"  ],
    [ -1777.09, -78.2523, -7.52374  , "telephone36"  ],
    [ -1421.37, -191.312, -20.3051  , "telephone37"  ],
    [ 139.144, 1226.56, 62.8896     , "telephone38"  ],
    [ -508.56, 910.732, -19.0552    , "telephone39"  ],
    [ -646.39, 923.879, -18.8975    , "telephone40"  ],
    [ -736.363, 832.825, -18.8975   , "telephone41"  ],
    [ -736.459, 831.573, -18.8976   , "telephone42"  ],
    [ -622.139, 815.393, -18.8975   , "telephone43"  ],
    [ -733.445, 691.414, -17.3997   , "telephone44"  ],
    [ -377.095, 794.644, -20.125    , "telephone45"  ],
    [ -375.991, 794.554, -20.125    , "telephone46"  ],
    [ -405.618, 913.88, -19.9786    , "telephone47"  ],
    [ -156.412, 770.867, -20.733    , "telephone48"  ],
    [ -8.69882, 625.297, -19.9222   , "telephone49"  ],
    [ -31.2744, 658.517, -20.1292   , "telephone50"  ],
    [ -123.964, 553.446, -20.2038   , "telephone51"  ],
    [ 35.6793, 563.377, -19.3029    , "telephone52"  ],
    [ 63.6219, 417.433, -13.9426    , "telephone53"  ],
    [ -6.95174, 381.727, -13.9651   , "telephone54"  ],
    [ 112.527, 847.265, -19.911     , "telephone55"  ],
    [ 257.777, 825.8, -20.001       , "telephone56"  ],
    [ 612.138, 845.592, -12.6475    , "telephone57"  ],
    [ 385.573, 680.05, -24.8659     , "telephone58"  ],
    [ 285.979, 612.951, -24.5618    , "telephone59"  ],
    [ 250.089, 494.022, -20.0461    , "telephone60"  ],
    [ 436.909, 391.101, -20.1926    , "telephone61"  ],
    [ 332.423, 232.168, -21.5327    , "telephone62"  ],
    [ 331.261, 232.113, -21.5326    , "telephone63"  ],
    [ 383.722, -111.622, -6.62286   , "telephone64"  ],
    [ 618.075, 32.9697, -18.2669    , "telephone65"  ],
    [ 747.702, 7.96036, -19.4605    , "telephone66"  ],
    [ 500.901, -265.225, -20.1588   , "telephone67"  ],
    [ 282.829, -388.466, -20.1362   , "telephone68"  ],
    [ 49.447, -456.087, -20.1363    , "telephone69"  ],
    [ -147.15, -596.099, -20.125    , "telephone70"  ],
    [ -315.458, -406.552, -14.393   , "telephone71"  ],
    [ -315.519, -407.59, -14.4268   , "telephone72"  ],
    [ -427.784, -307.159, -11.7241  , "telephone73"  ],
    [ 70.7739, -275.54, -20.1476    , "telephone74"  ],
    [ -68.1265, -199.786, -14.3818  , "telephone75"  ],
    [ -208.821, -45.6546, -12.0169  , "telephone76"  ],
    [ 29.1469, 34.0267, -12.5575    , "telephone77"  ],
    [ 68.3763, 237.33, -15.9921     , "telephone78"  ],
    [ 67.1935, 237.317, -15.9921    , "telephone79"  ],
    [ -78.6167, 233.374, -14.4043   , "telephone80"  ],
    [ -578.792, -481.143, -20.1363  , "telephone81"  ],
    [ -191.072, 165.4, -10.5756     , "telephone82"  ],
    [ -584.818, 89.3622, -0.215257  , "telephone83"  ],
    [ -655.417, 236.77, 1.0432      , "telephone84"  ],
    [ -515.485, 449.502, 0.971977   , "telephone85"  ],
    [ -653.472, 555.425, 1.04811    , "telephone86"  ],
    [ -373.309, 487.793, 1.05809    , "telephone87"  ],
    [ -373.36, 488.971, 1.05808     , "telephone88"  ],
    [ -353.737, 592.724, 1.05806    , "telephone89"  ],
    [ -469.515, 571.311, 1.04652    , "telephone90"  ],
    [ -470.609, 571.31, 1.04651     , "telephone91"  ],
    [ -408.296, 631.616, -12.3661   , "telephone92"  ],
    [ -264.414, 678.893, -19.9448   , "telephone93"  ],

    [ -352.354, -726.13, -15.4204   , "telephone94"  ],
    [ 81.3677, 892.368, -13.3204    , "telephone95"  ],
    [ 626.474, 898.527, -11.7137    , "telephone96"  ],
    [ -49.231, 740.707, -21.9009    , "telephone97"  ],
    [ 19.2317, -74.7028, -15.595    , "telephone98"  ],
    [ -254.039, -82.1033, -11.458   , "telephone99"  ],
    [ -637.16, 348.346, 1.34485     , "telephone100" ],
    [ -1386.91, 470.764, -22.1321   , "telephone101" ],
    [ -1559.92, -163.443, -19.6113  , "telephone102" ],
    [ -1146.3, 1591.19, 6.25566     , "telephone103" ],
    [ -1301.75, 996.284, -17.3339   , "telephone104" ],
    [ -651.048, 942.307, -7.93587   , "telephone105" ],
    [ 374.146, -290.937, -15.5799   , "telephone106" ],
    [ -161.972, -588.33, -16.1199   , "telephone107" ]

];


translation("en", {
"telephone0"  : "Kingston. Near our prison"
"telephone1"  : "Dipton. Taxi Parking"
"telephone2"  : "Riverside"
"telephone3"  : "Dipton. Gas Station"
"telephone4"  : "Dipton. Road to Gas Station. Pair box"
"telephone5"  : "Dipton. Road to Gas Station. Pair box"
"telephone6"  : "Kingston. Gun Shop"
"telephone7"  : "Kingston. West of last north street"
"telephone8"  : "Kingston. Empire Diner"
"telephone9"  : "Kingston. Enter to Kingston-Uptown Tunnel. Pair box"
"telephone10" : "Kingston. Enter to Kingston-Uptown Tunnel. Pair box"
"telephone11" : "Kingston. Enter to Kingston-Uptown Tunnel"
"telephone12" : "Kingston. From tunnel to River Street"
"telephone13" : "Kingston. The Hill of Tara"
"telephone14" : "Kingston. River Street, opposite to Kingston Stadium. Pair box"
"telephone15" : "Kingston. River Street, opposite to Kingston Stadium. Pair box"
"telephone16" : "Kingston. Center of River Street. Pair box"
"telephone17" : "Kingston. Center of River Street. Pair box"
"telephone18" : "Kingston. River Street, top of ladder to Kingston-Uptown Tunnel. Pair box"
"telephone19" : "Kingston. River Street, top of ladder to Kingston-Uptown Tunnel. Pair box"
"telephone20" : "Kingston. East of River Street"
"telephone21" : "Greenfield. Highway"
"telephone22" : "Greenfield. Oak Street"
"telephone23" : "Kingston. Kingston Stadium. Pair box"
"telephone24" : "Kingston. Kingston Stadium. Pair box"
"telephone25" : "Greenfield. Gas Station"
"telephone26" : "Greenfield. Empire Diner"
"telephone27" : "Greenfield. Greenfield Park"
"telephone28" : "Greenfield. Near Greenfield Park"
"telephone29" : "Hunters Point. Near Evergreen Street"
"telephone30" : "Hunters Point. Springboard from planks"
"telephone31" : "Hunters Point. After small bridge over subway"
"telephone32" : "Hunters Point. Heart of region"
"telephone33" : "Sand Island. Empire Diner"
"telephone34" : "Hunters Point. Border with Sand Island"
"telephone35" : "Sand Island. Under Subway"
"telephone36" : "Sand Island. West"
"telephone37" : "Sand Island. Near Misery Lane"
"telephone38" : "Hillwood"
"telephone39" : "Uptown. Enter to Uptown-Kingston Tunnel"
"telephone40" : "Uptown. House 174"
"telephone41" : "Uptown. View on the Culver River. Pair box"
"telephone42" : "Uptown. View on the Culver River. Pair box"
"telephone43" : "Uptown. Avenue"
"telephone44" : "Uptown. Bottom street to Southport"
"telephone45" : "Uptown. Near Office of Price Administration. Pair box"
"telephone46" : "Uptown. Near Office of Price Administration. Pair box"
"telephone47" : "Uptown. Empire General Hospital"
"telephone48" : "Little Italy. Near Diamond Motors"
"telephone49" : "Little Italy. Avenue"
"telephone50" : "Little Italy. Near Freddy's Bar"
"telephone51" : "Little Italy. Near Giuseppe's Shop"
"telephone52" : "Little Italy. Road to East Side"
"telephone53" : "East Side. Border with Little Italy"
"telephone54" : "East Side. Near shop of men's wear Dipton Apparel"
"telephone55" : "Little Italy. Joe's Apartment"
"telephone56" : "Little Italy. Scaletta Family Apartment"
"telephone57" : "North Millville. Car rental and bar The Dragstrip"
"telephone58" : "Little Italy. Maria Agnello's Apartment"
"telephone59" : "Little Italy. Border with Chinatown"
"telephone60" : "Chinatown. West"
"telephone61" : "Chinatown. East"
"telephone62" : "Chinatown. Heart of region. Pair box"
"telephone63" : "Chinatown. Heart of region. Pair box"
"telephone64" : "Oyster Bay. Cafeteria on the hill"
"telephone65" : "South Millville. Near Gas Station"
"telephone66" : "South Millville. The Printery"
"telephone67" : "Oyster Bay. Trago Oil Co"
"telephone68" : "Oyster Bay. Near Gun Shop"
"telephone69" : "Southport. Charlie's Service Station"
"telephone70" : "Southport. Palisade Street. Near Bruno's Office"
"telephone71" : "Southport. Pair box"
"telephone72" : "Southport. Pair box"
"telephone73" : "Midtown. Bus stop"
"telephone74" : "Midtown. Grand Imperial Bank"
"telephone75" : "Midtown. Church"
"telephone76" : "Midtown. Near upscale clothing store Vangel's"
"telephone77" : "East Side. Near The Maltese Falcon"
"telephone78" : "East Side. Near avenue. Pair box"
"telephone79" : "East Side. Near avenue. Pair box"
"telephone80" : "East Side. Opposite to automotive repair shop"
"telephone81" : "Southport. Road to Southport Tunnel"
"telephone82" : "East Side. Near Linkoln Park"
"telephone83" : "West Side. Backyard of West Side Mall (Market Arcade)"
"telephone84" : "West Side. Near automotive repair shop"
"telephone85" : "Uptown. Hieroglyph sculpture"
"telephone86" : "Uptown. Backyard of Uptown Parking"
"telephone87" : "Uptown. Bus station. Pair box"
"telephone88" : "Uptown. Bus station. Pair box"
"telephone89" : "Uptown. View on the Police Department"
"telephone90" : "Uptown. Near Uptown Parking and Grand Upper Bridge. Pair box"
"telephone91" : "Uptown. Near Uptown Parking and Grand Upper Bridge. Pair box"
"telephone92" : "Uptown. Opposite to Police Department"
"telephone93" : "Uptown. Near arch to Little Italy"

"telephone94" :  "Port Office"
"telephone95" :  "Joe's Apartment"
"telephone96" :  "Dragstrip"
"telephone97" :  "Freddy's Bar"
"telephone98" :  "Maltese Falkon"
"telephone99" :  "Vangelis"
"telephone100" : "Mona Lisa"
"telephone101" : "Lone Star"
"telephone102" : "Steaks & Chops"
"telephone103" : "Hill Of Tara"
"telephone104" : "Villa Scaletta"
"telephone105" : "Scaletta Apartment"
"telephone106" : "Marty's Apartment"
"telephone107" : "Bruno's Office"

"telephone.findphone"   : "You can see nearest phone booth on radar for 15 seconds."
"telephone.findalready" : "Nearest phone booth already displayed on radar."
"telephone.needphone"   : "You need a telephone to call."
"telephone.neednumber"  : "You need enter telephone number to call: /call 555-XXXX"
"telephone.youcall"     : "You call by number %s from %s."
"telephone.incorrect"   : "Incorrect number. Use: /call 555-XXXX"
"telephone.notregister" : "This phone number isn't registered."

});

local numbers = [
    "0192", //car rental
    //"1863", // Tires and Rims
];



event("onServerStarted", function() {
    log("[jobs] loading telephone services job and telephone system...");
    local ets1 = createVehicle(31, -1066.02, 1483.81, -3.79657, -90.8055, -1.36482, -0.105954);   // telephoneCAR1
    local ets2 = createVehicle(31, -1076.38, 1483.81, -3.51025, -89.5915, -1.332, -0.0857111);   // telephoneCAR2
    setVehicleColor(ets1, 102, 70, 18, 63, 36, 7);
    setVehicleColor(ets2, 102, 70, 18, 63, 36, 7);
    setVehiclePlateText(ets1, "ETS-01");
    setVehiclePlateText(ets2, "ETS-02");

    //creating public 3dtext
    foreach (phone in telephones) {
        create3DText ( phone[0], phone[1], phone[2]+0.35, "TELEPHONE", CL_RIPELEMON, 20 );
        create3DText ( phone[0], phone[1], phone[2]+0.20, "/call", CL_WHITE.applyAlpha(150), 0.3 );
    }


});

event("onPlayerConnect", function(playerid){
    phone_nearest_blip[playerid] <- {};
    phone_nearest_blip[playerid]["blip3dtext"] <- null;
});


function phoneCreatePrivateBlipText(playerid, x, y, z, text, cmd) {
    return [
            createPrivate3DText (playerid, x, y, z+0.35, text, CL_RIPELEMON, 20 ),
            createPrivate3DText (playerid, x, y, z+0.20, cmd, CL_WHITE.applyAlpha(150), 0.3 ),
            createPrivateBlip (playerid, x, y, ICON_PHONE, 200.0)
    ];
}

/**
 * Remove private 3DTEXT AND BLIP
 * @param  {int}  playerid
 */
function phoneJobRemovePrivateBlipText ( phone ) {
        remove3DText ( phone[0] );
        remove3DText ( phone[1] );
        removeBlip   ( phone[2] );
}


function getPlayerPhoneName(playerid) {
    local check = false;
    local name = null;
    foreach (key, value in telephones) {
        if (isPlayerInValidPoint3D(playerid, value[0], value[1], value[2], 0.3)) {
        check = true;
        name = value[3];
        break;
        }
    }
    if(check) {
        return plocalize(playerid, name);
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
        if (distance < dis) {
           dis = distance;
           phoneid = key;
        }
    }
    return phoneid;
}


function showBlipNearestPhoneForPlayer ( playerid ) {
    if (phone_nearest_blip[playerid]["blip3dtext"] == null) {
        local phoneid = phoneFindNearest( playerid );
        local phonehash = phoneCreatePrivateBlipText(playerid, telephones[phoneid][0], telephones[phoneid][1], telephones[phoneid][2], "TELEPHONE", "/call");
        phone_nearest_blip[playerid]["blip3dtext"] = true;
        msg( playerid, "telephone.findphone");
        delayedFunction(15000, function() {
            phoneJobRemovePrivateBlipText ( phonehash );
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


function callByPhone (playerid, number = null) {
    local place = getPlayerPhoneName(playerid);
    if (place != false) {
        if (number != null) {

            if(number == "taxi" || number == "police") {
                return trigger("onPlayerPhoneCall", playerid, number, place);
            }

            local number = str_replace("555-", "", number);
            if(isNumeric(number) && number.len() == 4) {
                msg(playerid, "telephone.youcall", ["555-"+number, place]);
                delayedFunction(3000, function () {
                    local check = false;
                    foreach (idx, num in numbers) {
                        if (num == number) { check = true; }
                    }
                    if(check) {
                        trigger("onPlayerPhoneCall", playerid, number, place);
                    } else {
                        msg(playerid, "telephone.notregister");
                    }
                });
            } else {
                msg(playerid, "telephone.incorrect");
            }

        } else {
            msg(playerid, "telephone.neednumber");
        }
    } else {
        msg(playerid, "telephone.needphone");
    }
}

/*
event("onPlayerPhoneCall", function(playerid, number, place) {

});
*/


    //showBlipNearestPhoneForPlayer ( playerid );
/* don't remove

addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading telephone services job...");
    local teleservicescars = [
        createVehicle(31, -1066.02, 1483.81, -3.79657, -90.8055, -1.36482, -0.105954),   // telephoneCAR1
        createVehicle(31, -1076.38, 1483.81, -3.51025, -89.5915, -1.332, -0.0857111),   // telephoneCAR2
    ];

    foreach(key, value in teleservicescars ) {
        setVehicleColour( value, 125, 60, 20, 125, 60, 20 );
    }
});

*/
