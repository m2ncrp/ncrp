include("modules/jobs/telephone/commands.nut");

local phone_nearest_blip = {};

local telephones = [
/*
0 - phone booth
1 - bussiness
2 - police alarm

 */
    [ -1021.87, 1643.44, 10.6318    , "telephone0"   , 0],
    [ -562.58, 1521.96, -16.1836    , "telephone1"   , 0],
    [ -310.62, 1694.98, -22.3772    , "telephone2"   , 0],
    [ -747.386, 1762.67, -15.0237   , "telephone3"   , 0],
    [ -724.814, 1647.21, -14.9223   , "telephone4"   , 0],
    [ -724.914, 1645.24, -14.9223   , "telephone5"   , 0],
    [ -1200.2, 1675.75, 11.3337     , "telephone6"   , 0],
    [ -1436.35, 1676.01, 6.14958    , "telephone7"   , 0],
    [ -1520.38, 1592.71, -6.04848   , "telephone8"   , 0],
    [ -1038.5, 1368.65, -13.5484    , "telephone9"   , 0],
    [ -1037.4, 1368.55, -13.5485    , "telephone10"  , 0],
    [ -1033.41, 1398.75, -13.5597   , "telephone11"  , 0],
    [ -903.212, 1412.57, -11.3637   , "telephone12"  , 0],
    [ -1170.64, 1578.32, 5.84166    , "telephone13"  , 0],
    [ -1297.43, 1491.66, -6.07104   , "telephone14"  , 0],
    [ -1297.38, 1492.68, -6.07106   , "telephone15"  , 0],
    [ -1229.36, 1457.89, -4.88868   , "telephone16"  , 0],
    [ -1228.24, 1457.91, -4.85487   , "telephone17"  , 0],
    [ -1046.37, 1429.04, -4.3155    , "telephone18"  , 0],
    [ -1047.67, 1429.08, -4.31618   , "telephone19"  , 0],
    [ -952.956, 1485.89, -4.74223   , "telephone20"  , 0],
    [ -1654.7, 1142.97, -7.10701    , "telephone21"  , 0],
    [ -1471.25, 1124.4, -11.7355    , "telephone22"  , 0],
    [ -1187.1, 1276.32, -13.5484    , "telephone23"  , 0],
    [ -1187.13, 1275.15, -13.5485   , "telephone24"  , 0],
    [ -1579.08, 940.472, -5.19268   , "telephone25"  , 0],
    [ -1416.07, 935.317, -13.6497   , "telephone26"  , 0],
    [ -1342.85, 1017.48, -17.6025   , "telephone27"  , 0],
    [ -1339.04, 916.051, -18.4358   , "telephone28"  , 0],
    [ -1344.78, 796.552, -14.6407   , "telephone29"  , 0],
    [ -1562.11, 527.842, -20.1475   , "telephone30"  , 0],
    [ -1712.73, 688.218, -10.2715   , "telephone31"  , 0],
    [ -1639.46, 382.508, -19.5393   , "telephone32"  , 0],
    [ -1559.83, 170.441, -13.267    , "telephone33"  , 0],
    [ -1401.38, 218.989, -24.7309   , "telephone34"  , 0],
    [ -1649.2, 65.497, -9.2241      , "telephone35"  , 0],
    [ -1777.09, -78.2523, -7.52374  , "telephone36"  , 0],
    [ -1421.37, -191.312, -20.3051  , "telephone37"  , 0],
    [ 139.144, 1226.56, 62.8896     , "telephone38"  , 0],
    [ -508.56, 910.732, -19.0552    , "telephone39"  , 0],
    [ -646.39, 923.879, -18.8975    , "telephone40"  , 0],
    [ -736.363, 832.825, -18.8975   , "telephone41"  , 0],
    [ -736.459, 831.573, -18.8976   , "telephone42"  , 0],
    [ -622.139, 815.393, -18.8975   , "telephone43"  , 0],
    [ -733.445, 691.414, -17.3997   , "telephone44"  , 0],
    [ -377.095, 794.644, -20.125    , "telephone45"  , 0],
    [ -375.991, 794.554, -20.125    , "telephone46"  , 0],
    [ -405.618, 913.88, -19.9786    , "telephone47"  , 0],
    [ -156.412, 770.867, -20.733    , "telephone48"  , 0],
    [ -8.69882, 625.297, -19.9222   , "telephone49"  , 0],
    [ -31.2744, 658.517, -20.1292   , "telephone50"  , 0],
    [ -123.964, 553.446, -20.2038   , "telephone51"  , 0],
    [ 35.6793, 563.377, -19.3029    , "telephone52"  , 0],
    [ 63.6219, 417.433, -13.9426    , "telephone53"  , 0],
    [ -6.95174, 381.727, -13.9651   , "telephone54"  , 0],
    [ 112.527, 847.265, -19.911     , "telephone55"  , 0],
    [ 257.777, 825.8, -20.001       , "telephone56"  , 0],
    [ 612.138, 845.592, -12.6475    , "telephone57"  , 0],
    [ 385.573, 680.05, -24.8659     , "telephone58"  , 0],
    [ 285.979, 612.951, -24.5618    , "telephone59"  , 0],
    [ 250.089, 494.022, -20.0461    , "telephone60"  , 0],
    [ 436.909, 391.101, -20.1926    , "telephone61"  , 0],
    [ 332.423, 232.168, -21.5327    , "telephone62"  , 0],
    [ 331.261, 232.113, -21.5326    , "telephone63"  , 0],
    [ 383.722, -111.622, -6.62286   , "telephone64"  , 0],
    [ 618.075, 32.9697, -18.2669    , "telephone65"  , 0],
    [ 747.702, 7.96036, -19.4605    , "telephone66"  , 0],
    [ 500.901, -265.225, -20.1588   , "telephone67"  , 0],
    [ 282.829, -388.466, -20.1362   , "telephone68"  , 0],
    [ 49.447, -456.087, -20.1363    , "telephone69"  , 0],
    [ -147.15, -596.099, -20.125    , "telephone70"  , 0],
    [ -315.458, -406.552, -14.393   , "telephone71"  , 0],
    [ -315.519, -407.59, -14.4268   , "telephone72"  , 0],
    [ -427.784, -307.159, -11.7241  , "telephone73"  , 0],
    [ 70.7739, -275.54, -20.1476    , "telephone74"  , 0],
    [ -68.1265, -199.786, -14.3818  , "telephone75"  , 0],
    [ -208.821, -45.6546, -12.0169  , "telephone76"  , 0],
    [ 29.1469, 34.0267, -12.5575    , "telephone77"  , 0],
    [ 68.3763, 237.33, -15.9921     , "telephone78"  , 0],
    [ 67.1935, 237.317, -15.9921    , "telephone79"  , 0],
    [ -78.6167, 233.374, -14.4043   , "telephone80"  , 0],
    [ -578.792, -481.143, -20.1363  , "telephone81"  , 0],
    [ -191.072, 165.4, -10.5756     , "telephone82"  , 0],
    [ -584.818, 89.3622, -0.215257  , "telephone83"  , 0],
    [ -655.417, 236.77, 1.0432      , "telephone84"  , 0],
    [ -515.485, 449.502, 0.971977   , "telephone85"  , 0],
    [ -653.472, 555.425, 1.04811    , "telephone86"  , 0],
    [ -373.309, 487.793, 1.05809    , "telephone87"  , 0],
    [ -373.36, 488.971, 1.05808     , "telephone88"  , 0],
    [ -353.737, 592.724, 1.05806    , "telephone89"  , 0],
    [ -469.515, 571.311, 1.04652    , "telephone90"  , 0],
    [ -470.609, 571.31, 1.04651     , "telephone91"  , 0],
    [ -408.296, 631.616, -12.3661   , "telephone92"  , 0],
    [ -264.414, 678.893, -19.9448   , "telephone93"  , 0],

    [ -352.354, -726.13, -15.4204   , "telephone94"  , 1],
    [ 81.3677, 892.368, -13.3204    , "telephone95"  , 1],
    [ 626.474, 898.527, -11.7137    , "telephone96"  , 1],
    [ -49.231, 740.707, -21.9009    , "telephone97"  , 1],
    [ 19.2317, -74.7028, -15.595    , "telephone98"  , 1],
    [ -254.039, -82.1033, -11.458   , "telephone99"  , 1],
    [ -637.16, 348.346, 1.34485     , "telephone100" , 1],
    [ -1386.91, 470.764, -22.1321   , "telephone101" , 1],
    [ -1559.92, -163.443, -19.6113  , "telephone102" , 1],
    [ -1146.3, 1591.19, 6.25566     , "telephone103" , 1],
    [ -1301.75, 996.284, -17.3339   , "telephone104" , 1],
    [ -651.048, 942.307, -7.93587   , "telephone105" , 1],
    [ 374.146, -290.937, -15.5799   , "telephone106" , 1],
    [ -161.972, -588.33, -16.1199   , "telephone107" , 1],

    [ 140.695, -427.998, -19.429    , "telephone108"  ],
    [ -1590.33, 175.591, -12.4393   , "telephone109"  ],
    [ -1584.37, 1605.48, -5.22507   , "telephone110"  ],
    [ -645.304, 1293.91, 3.94464    , "telephone111"  ],
    [ 241.946, 710.54, -24.0321     , "telephone112"  ],
    [ -375.504, -449.881, -17.2661  , "telephone113"  ],

    [-371.573,   1787.89, -23.589   , "policeAlarm1" , 2 ],
    [-1292.88,   1484.98, -6.11190  , "policeAlarm2" , 2 ],
    [-1176.64,   1457.64, -4.12012  , "policeAlarm3" , 2 ],
    [-1171.7,    1387.29, -13.6239  , "policeAlarm4" , 2 ],
    [-1317.53,   1402.58, -13.5725  , "policeAlarm5" , 2 ],
    [-1299.35,   751.584, -15.7788  , "policeAlarm6" , 2 ],
    [-1417.24,   497.773, -21.4151  , "policeAlarm7" , 2 ],
    [ 36.4554,   235.118, -16.0193  , "policeAlarm8" , 2 ],
    [-639.445,  -76.2884,  1.03814  , "policeAlarm9" , 2 ],
    [-680.221,   182.574,  1.03806  , "policeAlarm10", 2 ],
    [-474.135,   185.611,  1.02381  , "policeAlarm11", 2 ],
    [-477.684,   382.254,  1.03808  , "policeAlarm12", 2 ],
    [-477.376,   439.521,  1.03657  , "policeAlarm13", 2 ],
    [-661.801,   455.444,  1.03789  , "policeAlarm14", 2 ],
    [-512.606,   810.714, -19.6019  , "policeAlarm15", 2 ],
    [-196.664,   382.899, -6.32934  , "policeAlarm16", 2 ],
    [-191.619,   297.732, -6.45726  , "policeAlarm17", 2 ],
    [-195.883,   162.1,   -10.5431  , "policeAlarm18", 2 ],
    [-196.463,   82.5475, -11.1609  , "policeAlarm19", 2 ],
    [-123.769,   232.632, -13.9932  , "policeAlarm20", 2 ],
    [-122.238,   355.647, -13.9932  , "policeAlarm21", 2 ],
    [-9.27437,   413.96,  -13.9914  , "policeAlarm22", 2 ],
    [-69.3858,   723.144, -21.9343  , "policeAlarm23", 2 ],
    [ 131.276,   780.688, -18.9663  , "policeAlarm24", 2 ],
    [ 118.093,   904.171, -22.3053  , "policeAlarm25", 2 ],
    [ 335.894,   829.788, -21.2524  , "policeAlarm26", 2 ],
    [ 370.317,   808.668, -21.2487  , "policeAlarm27", 2 ],
    [ 394.804,   797.771, -21.2487  , "policeAlarm28", 2 ],
    [ 451.982,   751.116, -21.2541  , "policeAlarm29", 2 ],
    [ 407.519,   674.809, -24.8892  , "policeAlarm30", 2 ],
    [ 276.342,   606.728, -24.5672  , "policeAlarm31", 2 ],
    [ 259.641,   466.762, -20.1637  , "policeAlarm32", 2 ],
    [ 259.739,   333.152, -21.6012  , "policeAlarm33", 2 ],
    [ 259.682,   399.147, -21.5767  , "policeAlarm34", 2 ],
    [ 255.309,   31.6091, -23.3979  , "policeAlarm35", 2 ],
    [  264.94,   841.694,   -20.38  , "policeAlarm36", 2 ],
];

translation("en", {
"telephone0"  : "Kingston. Near our prison"
"telephone1"  : "Dipton. Opposite to Union Station"
"telephone2"  : "Riverside"
"telephone3"  : "Dipton. Near Gas Station"
"telephone4"  : "Dipton. Road to Gas Station. Pair box"
"telephone5"  : "Dipton. Road to Gas Station. Pair box"
"telephone6"  : "Kingston. Near Gun Shop"
"telephone7"  : "Kingston. West of last north street"
"telephone8"  : "Kingston. Near Empire Diner"
"telephone9"  : "Kingston. Enter to Uptown Tunnel. Pair box"
"telephone10" : "Kingston. Enter to Uptown Tunnel. Pair box"
"telephone11" : "Kingston. Enter to Uptown Tunnel"
"telephone12" : "Kingston. From tunnel to River Street"
"telephone13" : "Kingston. Near the Hill of Tara"
"telephone14" : "Kingston. River Street, opposite to Kingston Stadium. Pair box"
"telephone15" : "Kingston. River Street, opposite to Kingston Stadium. Pair box"
"telephone16" : "Kingston. Center of River Street. Pair box"
"telephone17" : "Kingston. Center of River Street. Pair box"
"telephone18" : "Kingston. River Street, top of ladder to Uptown Tunnel. Pair box"
"telephone19" : "Kingston. River Street, top of ladder to Uptown Tunnel. Pair box"
"telephone20" : "Kingston. East of River Street"
"telephone21" : "Greenfield. Highway"
"telephone22" : "Greenfield. Oak Street"
"telephone23" : "Kingston. Kingston Stadium. Pair box"
"telephone24" : "Kingston. Kingston Stadium. Pair box"
"telephone25" : "Greenfield. Near Gas Station"
"telephone26" : "Greenfield. Near Empire Diner"
"telephone27" : "Greenfield. Near Greenfield Park"
"telephone28" : "Greenfield. Near Greenfield Park"
"telephone29" : "Hunters Point. Near Evergreen Street"
"telephone30" : "Hunters Point. Springboard from planks"
"telephone31" : "Hunters Point. After small bridge over subway"
"telephone32" : "Hunters Point. Heart of region"
"telephone33" : "Sand Island. Near Empire Diner"
"telephone34" : "Hunters Point. Border with Sand Island"
"telephone35" : "Sand Island. Under Subway"
"telephone36" : "Sand Island. West"
"telephone37" : "Sand Island. Near Misery Lane"
"telephone38" : "Hillwood"
"telephone39" : "Uptown. Enter to Uptown Tunnel"
"telephone40" : "Uptown. Near house 174"
"telephone41" : "Uptown. View on the Culver River. Pair box"
"telephone42" : "Uptown. View on the Culver River. Pair box"
"telephone43" : "Uptown. Avenue"
"telephone44" : "Uptown. Bottom street to Southport"
"telephone45" : "Uptown. Near Office of Price Administration. Pair box"
"telephone46" : "Uptown. Near Office of Price Administration. Pair box"
"telephone47" : "Uptown. Near Empire General Hospital"
"telephone48" : "Little Italy. Near Diamond Motors"
"telephone49" : "Little Italy. Boulevard"
"telephone50" : "Little Italy. Near Freddy's Bar"
"telephone51" : "Little Italy. Near Giuseppe's Shop"
"telephone52" : "Little Italy. Road to East Side"
"telephone53" : "East Side. Border with Little Italy"
"telephone54" : "East Side. Near shop of men's wear Dipton Apparel"
"telephone55" : "Little Italy. Near Joe's Apartment"
"telephone56" : "Little Italy. Near Scaletta Family Apartment"
"telephone57" : "North Millville. Near Car Rental"
"telephone58" : "Little Italy. Near Maria Agnello's Apartment"
"telephone59" : "Little Italy. Border with Chinatown"
"telephone60" : "Chinatown. West"
"telephone61" : "Chinatown. East"
"telephone62" : "Chinatown. Heart of region. Pair box"
"telephone63" : "Chinatown. Heart of region. Pair box"
"telephone64" : "Oyster Bay. Cafeteria on the hill"
"telephone65" : "South Millville. Near Gas Station"
"telephone66" : "South Millville. Near the Printery"
"telephone67" : "Oyster Bay. Near Trago Oil Co"
"telephone68" : "Oyster Bay. Near Gun Shop"
"telephone69" : "Southport. Near Charlie's Service Station"
"telephone70" : "Southport. Palisade Street. Near Bruno's Office"
"telephone71" : "Southport. Pair box"
"telephone72" : "Southport. Pair box"
"telephone73" : "Midtown. Bus stop"
"telephone74" : "Midtown. Near Grand Imperial Bank"
"telephone75" : "Midtown. Near church"
"telephone76" : "Midtown. Near upscale clothing store Vangel's"
"telephone77" : "East Side. Near The Maltese Falcon"
"telephone78" : "East Side. Near boulevard. Pair box"
"telephone79" : "East Side. Near boulevard. Pair box"
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

"telephone94" :  "Port. Port Office"
"telephone95" :  "Little Italy. Joe's Apartment"
"telephone96" :  "North Millville. Dragstrip"
"telephone97" :  "Little Italy. Freddy's Bar"
"telephone98" :  "Midtown. Maltese Falcon"
"telephone99" :  "Midtown. Vangelis"
"telephone100" : "West Side. Mona Lisa"
"telephone101" : "Hunters Point. Lone Star"
"telephone102" : "Sand Island. Steaks & Chops"
"telephone103" : "Kingston. Hill Of Tara"
"telephone104" : "Greenfield. Villa Scaletta"
"telephone105" : "Uptown. Scaletta Apartment"
"telephone106" : "Oyster Bay. Marty's Apartment"
"telephone107" : "Southport. Bruno's Office"

"telephone108" : "Oyster Bay. Empire Diner"
"telephone109" : "Sand Island. Empire Diner"
"telephone110" : "Kingston. Empire Diner"
"telephone111" : "Highbrook. Empire Diner"
"telephone112" : "Little Italy. Stella's diner"
"telephone113" : "Southport. Dipton Apparel"

"telephone.findphone"   : "You can see nearest phone booth on radar for 15 seconds."
"telephone.findalready" : "Nearest phone booth already displayed on radar."
"telephone.needphone"   : "You need a telephone to call."
"telephone.neednumber"  : "You need enter telephone number to call: /call 555-XXXX"
"telephone.youcall"     : "You call by number %s."
"telephone.incorrect"   : "Incorrect number. Use: /call 555-XXXX"
"telephone.notregister" : "This phone number isn't registered."

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

local numbers = [
    "0192", //car rental
    "0000", // searhing car services
    "1111" // empire custom
    //"1863", // Tires and Rims
];

TELEPHONE_TEXT_COLOR <- CL_WAXFLOWER;

event("onServerStarted", function() {
    log("[jobs] loading telephone services job and telephone system...");
/*
    local ets1 = createVehicle(31, -1066.02, 1483.81, -3.79657, -90.8055, -1.36482, -0.105954);   // telephoneCAR1
    local ets2 = createVehicle(31, -1076.38, 1483.81, -3.51025, -89.5915, -1.332, -0.0857111);   // telephoneCAR2
    setVehicleColor(ets1, 102, 70, 18, 63, 36, 7);
    setVehicleColor(ets2, 102, 70, 18, 63, 36, 7);
    setVehiclePlateText(ets1, "ETS-01");
    setVehiclePlateText(ets2, "ETS-02");
*/
    //creating public 3dtext
    foreach (phone in telephones) {
        if (phone.len() == 5) {
            if (phone[4] == 2) {
                create3DText ( phone[0], phone[1], phone[2]+0.35, "POLICE ALARM" /* localize(phone[3], [], "en") */, CL_MALIBU, 6.0);
                create3DText ( phone[0], phone[1], phone[2]+0.20, "Press E", CL_WHITE.applyAlpha(150), 0.4 );
                continue;
            }
        }
        create3DText ( phone[0], phone[1], phone[2]+0.35, "TELEPHONE", CL_RIPELEMON, 6.0);
        create3DText ( phone[0], phone[1], phone[2]+0.20, "/call", CL_WHITE.applyAlpha(150), 0.3 );
    }


});

event("onPlayerConnect", function(playerid){
    phone_nearest_blip[playerid] <- {};
    phone_nearest_blip[playerid]["blip3dtext"] <- null;
});


function phoneCreatePrivateBlipText(playerid, x, y, z, text, cmd) {
    return [
            createPrivateBlip (playerid, x, y, ICON_RED, 1000.0)
            //createPrivate3DText (playerid, x, y, z+0.35, text, CL_RIPELEMON, 20 ),
            //createPrivate3DText (playerid, x, y, z+0.20, cmd, CL_WHITE.applyAlpha(150), 0.3 ),
            
    ];
}

/**
 * Remove private 3DTEXT AND BLIP
 * @param  {int}  playerid
 */
function phoneJobRemovePrivateBlipText ( phone ) {
        removeBlip   ( phone[0] );
        //remove3DText ( phone[1] );
        //remove3DText ( phone[2] );
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


function callByPhone (playerid, number = null, isbind = false) {
    local budka = getPlayerPhoneName(playerid);
    local type = (budka) ? budka[4] : false;

    //dbg(budka+", "+type+", "+isbind);
    if ((budka == false && isbind == true) || (isbind == true && type != 2)) {
        return;
    }

    if (budka == false || (isbind == false && type == 2)) {
        msg(playerid, "telephone.needphone");
        showBlipNearestPhoneForPlayer ( playerid );
        return;
    }

    if (number == null) {
        return msg(playerid, "telephone.neednumber");
    }

    if(number == "taxi" || number == "police" || number == "dispatch" ) {
        return trigger("onPlayerPhoneCall", playerid, number, plocalize(playerid, budka[3]));
    }

    local number = str_replace("555-", "", number);
    if(isNumeric(number) && number.len() == 4) {
        msg(playerid, "telephone.youcall", ["555-"+number]);
        delayedFunction(3000, function () {
            local check = false;
            foreach (idx, num in numbers) {
                if (num == number) { check = true; }
            }
            if(check) {
                trigger("onPlayerPhoneCall", playerid, number, plocalize(playerid, budka[3]));
            } else {
                msg(playerid, "telephone.notregister");
            }
        });
    } else {
        msg(playerid, "telephone.incorrect");
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
