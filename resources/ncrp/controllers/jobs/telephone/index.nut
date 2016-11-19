include("controllers/jobs/telephone/commands.nut");

addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading telephone services job and telephone system...");
    createVehicle(31, -1066.02, 1483.81, -3.79657, -90.8055, -1.36482, -0.105954),   // telephoneCAR1
    createVehicle(31, -1076.38, 1483.81, -3.51025, -89.5915, -1.332, -0.0857111),   // telephoneCAR2
});

local telephones = [
    [ -1021.87, 1643.44, 10.6318 ],     //  Telephone0 | Kingston. Near our prison.
    [ -562.58, 1521.96, -16.1836 ],     //  Telephone1 | Dipton. Taxi Parking.
    [ -310.62, 1694.98, -22.3772 ],     //  Telephone2 | Riverside.
    [ -747.386, 1762.67, -15.0237 ],    //  Telephone3 | Dipton. Gas Station.
    [ -724.814, 1647.21, -14.9223 ],    //  Telephone4 | Dipton. Road to Gas Station. Pair box.
    [ -724.914, 1645.24, -14.9223 ],    //  Telephone5 | Dipton. Road to Gas Station. Pair box.
    [ -1200.2, 1675.75, 11.3337 ],      //  Telephone6 | Kingston. Gun Shop.
    [ -1436.35, 1676.01, 6.14958 ],     //  Telephone7 | Kingston. West of last north street.
    [ -1520.38, 1592.71, -6.04848 ],    //  Telephone8 | Kingston. Empire Diner.
    [ -1038.5, 1368.65, -13.5484 ],     //  Telephone9 | Kingston. Enter to Kingston-Uptown Tunnel. Pair box.
    [ -1037.4, 1368.55, -13.5485 ],     //  Telephone10 | Kingston. Enter to Kingston-Uptown Tunnel. Pair box.
    [ -1033.41, 1398.75, -13.5597 ],    //  Telephone11 | Kingston. Enter to Kingston-Uptown Tunnel.
    [ -903.212, 1412.57, -11.3637 ],    //  Telephone12 | Kingston. From tunnel to River Street.
    [ -1170.64, 1578.32, 5.84166 ],     //  Telephone13 | Kingston. The Hill of Tara.
    [ -1297.43, 1491.66, -6.07104 ],    //  Telephone14 | Kingston. River Street, opposite to Kingston Stadium. Pair box.
    [ -1297.38, 1492.68, -6.07106 ],    //  Telephone15 | Kingston. River Street, opposite to Kingston Stadium. Pair box.
    [ -1229.36, 1457.89, -4.88868 ],    //  Telephone16 | Kingston. Center of River Street. Pair box.
    [ -1228.24, 1457.91, -4.85487 ],    //  Telephone17 | Kingston. Center of River Street. Pair box.
    [ -1046.37, 1429.04, -4.3155 ],     //  Telephone18 | Kingston. River Street, top of ladder to Kingston-Uptown Tunnel. Pair box.
    [ -1047.67, 1429.08, -4.31618 ],    //  Telephone19 | Kingston. River Street, top of ladder to Kingston-Uptown Tunnel. Pair box.
    [ -952.956, 1485.89, -4.74223 ],    //  Telephone20 | Kingston. East of River Street.
    [ -1654.7, 1142.97, -7.10701 ],     //  Telephone21 | Greenfield. Highway.
    [ -1471.25, 1124.4, -11.7355 ],     //  Telephone22 | Greenfield. Oak Street.
    [ -1187.1, 1276.32, -13.5484 ],     //  Telephone23 | Kingston. Kingston Stadium. Pair box.
    [ -1187.13, 1275.15, -13.5485 ],    //  Telephone24 | Kingston. Kingston Stadium. Pair box.
    [ -1579.08, 940.472, -5.19268 ],    //  Telephone25 | Greenfield. Gas Station.
    [ -1416.07, 935.317, -13.6497 ],    //  Telephone26 | Greenfield. Empire Diner.
    [ -1342.85, 1017.48, -17.6025 ],    //  Telephone27 | Greenfield. Greenfield Park.
    [ -1339.04, 916.051, -18.4358 ],    //  Telephone28 | Greenfield. Near Greenfield Park.
    [ -1344.78, 796.552, -14.6407 ],    //  Telephone29 | Hunters Point. Near Evergreen Street.
    [ -1562.11, 527.842, -20.1475 ],    //  Telephone30 | Hunters Point. Springboard from planks.
    [ -1712.73, 688.218, -10.2715 ],    //  Telephone31 | Hunters Point. After small bridge over subway.
    [ -1639.46, 382.508, -19.5393 ],    //  Telephone32 | Hunters Point. Heart of region.
    [ -1559.83, 170.441, -13.267 ],     //  Telephone33 | Sand Island. Empire Diner.
    [ -1401.38, 218.989, -24.7309 ],    //  Telephone34 | Hunters Point. Border with Sand Island.
    [ -1649.2, 65.497, -9.2241 ],       //  Telephone35 | Sand Island. Under Subway.
    [ -1777.09, -78.2523, -7.52374 ],   //  Telephone36 | Sand Island. West.
    [ -1421.37, -191.312, -20.3051 ],   //  Telephone37 | Sand Island. Near Misery Lane.
    [ 139.144, 1226.56, 62.8896 ],      //  Telephone38 | Hillwood
    [ -508.56, 910.732, -19.0552 ],     //  Telephone39 | Uptown. Enter to Uptown-Kingston Tunnel.
    [ -646.39, 923.879, -18.8975 ],     //  Telephone40 | Uptown. House 174.
    [ -736.363, 832.825, -18.8975 ],    //  Telephone41 | Uptown. View on the Culver River. Pair box.
    [ -736.459, 831.573, -18.8976 ],    //  Telephone42 | Uptown. View on the Culver River. Pair box.
    [ -622.139, 815.393, -18.8975 ],    //  Telephone43 | Uptown. Avenue.
    [ -733.445, 691.414, -17.3997 ],    //  Telephone44 | Uptown. Bottom street to Southport.
    [ -377.095, 794.644, -20.125 ],     //  Telephone45 | Uptown. Near Office of Price Administration. Pair box.
    [ -375.991, 794.554, -20.125 ],     //  Telephone46 | Uptown. Near Office of Price Administration. Pair box.
    [ -405.618, 913.88, -19.9786 ],     //  Telephone47 | Uptown. Empire General Hospital.
    [ -156.412, 770.867, -20.733 ],     //  Telephone48 | Little Italy. Near Diamond Motors.
    [ -8.69882, 625.297, -19.9222 ],    //  Telephone49 | Little Italy. Avenue.
    [ -31.2744, 658.517, -20.1292 ],    //  Telephone50 | Little Italy. Near Freddy's Bar.
    [ -123.964, 553.446, -20.2038 ],    //  Telephone51 | Little Italy. Near Giuseppe's Shop.
    [ 35.6793, 563.377, -19.3029 ],     //  Telephone52 | Little Italy. Road to East Side.
    [ 63.6219, 417.433, -13.9426 ],     //  Telephone53 | East Side. Border with Little Italy.
    [ -6.95174, 381.727, -13.9651 ],    //  Telephone54 | East Side. Near shop of men's wear Dipton Apparel.
    [ 112.527, 847.265, -19.911 ],      //  Telephone55 | Little Italy. Joe's Apartment.
    [ 257.777, 825.8, -20.001 ],        //  Telephone56 | Little Italy. Scaletta Family Apartment.
    [ 612.138, 845.592, -12.6475 ],     //  Telephone57 | North Millville. Car rental and bar The Dragstrip.
    [ 385.573, 680.05, -24.8659 ],      //  Telephone58 | Little Italy. Maria Agnello's Apartment.
    [ 285.979, 612.951, -24.5618 ],     //  Telephone59 | Little Italy. Border with Chinatown.
    [ 250.089, 494.022, -20.0461 ],     //  Telephone60 | Chinatown. West.
    [ 436.909, 391.101, -20.1926 ],     //  Telephone61 | Chinatown. East.
    [ 332.423, 232.168, -21.5327 ],     //  Telephone62 | Chinatown. Heart of region. Pair box.
    [ 331.261, 232.113, -21.5326 ],     //  Telephone63 | Chinatown. Heart of region. Pair box.
    [ 383.722, -111.622, -6.62286 ],    //  Telephone64 | Oyster Bay. Cafeteria on the hill.
    [ 618.075, 32.9697, -18.2669 ],     //  Telephone65 | South Millville. Near Gas Station.
    [ 747.702, 7.96036, -19.4605 ],     //  Telephone66 | South Millville. The Printery.
    [ 500.901, -265.225, -20.1588 ],    //  Telephone67 | Oyster Bay. Trago Oil Co.
    [ 282.829, -388.466, -20.1362 ],    //  Telephone68 | Oyster Bay. Near Gun Shop.
    [ 49.447, -456.087, -20.1363 ],     //  Telephone69 | Southport. Charlie's Service Station.
    [ -147.15, -596.099, -20.125 ],     //  Telephone70 | Southport. Palisade Street. Near Bruno's Office.
    [ -315.458, -406.552, -14.393 ],    //  Telephone71 | Southport. Pair box.
    [ -315.519, -407.59, -14.4268 ],    //  Telephone72 | Southport. Pair box.
    [ -427.784, -307.159, -11.7241 ],   //  Telephone73 | Midtown. Bus stop.
    [ 70.7739, -275.54, -20.1476 ],     //  Telephone74 | Midtown. Grand Imperial Bank.
    [ -68.1265, -199.786, -14.3818 ],   //  Telephone75 | Midtown. Church.
    [ -208.821, -45.6546, -12.0169 ],   //  Telephone76 | Midtown. Near upscale clothing store Vangel's.
    [ 29.1469, 34.0267, -12.5575 ],     //  Telephone77 | East Side. Near The Maltese Falcon.
    [ 68.3763, 237.33, -15.9921 ],      //  Telephone78 | East Side. Near avenue. Pair box.
    [ 67.1935, 237.317, -15.9921 ],     //  Telephone79 | East Side. Near avenue. Pair box.
    [ -78.6167, 233.374, -14.4043 ],    //  Telephone80 | East Side. Opposite to automotive repair shop.
    [ -578.792, -481.143, -20.1363 ],   //  Telephone81 | Southport. Road to Southport Tunnel.
    [ -191.072, 165.4, -10.5756 ],      //  Telephone81 | East Side. Near Linkoln Park.
    [ -584.818, 89.3622, -0.215257 ],   //  Telephone82 | West Side. Backyard of West Side Mall (Market Arcade).
    [ -655.417, 236.77, 1.0432 ],       //  Telephone83 | West Side. Near automotive repair shop.
    [ -515.485, 449.502, 0.971977 ],    //  Telephone84 | Uptown. Hieroglyph sculpture.
    [ -653.472, 555.425, 1.04811 ],     //  Telephone85 | Uptown. Backyard of Uptown Parking.
    [ -373.309, 487.793, 1.05809 ],     //  Telephone86 | Uptown. Bus station. Pair box.
    [ -373.36, 488.971, 1.05808 ],      //  Telephone87 | Uptown. Bus station. Pair box.
    [ -353.737, 592.724, 1.05806 ],     //  Telephone88 | Uptown. View on the Police Department.
    [ -469.515, 571.311, 1.04652 ],     //  Telephone89 | Uptown. Near Uptown Parking and Grand Upper Bridge. Pair box.
    [ -470.609, 571.31, 1.04651 ],      //  Telephone90 | Uptown. Near Uptown Parking and Grand Upper Bridge. Pair box.
    [ -408.296, 631.616, -12.3661 ],    //  Telephone91 | Uptown. Opposite to Police Department.
    [ -264.414, 678.893, -19.9448 ]     //  Telephone92 | Uptown. Near arch to Little Italy.
];


function callByPhone(playerid) {
    local check = false;
    foreach (key, value in telephones) {
        if (isPlayerInValidPoint3D(playerid, value[0], value[1], value[2], 0.3)) {
        check = true;
        break;
        }
    }
    if(check) {
        msg(playerid, "Telephohe working");
    } else {
        msg(playerid, "Telephohe doesn't working");
    }
}

function goToPhone(playerid, phoneid) {
    local phoneid = phoneid.tointeger();
    setPlayerPosition( playerid, telephones[phoneid][0], telephones[phoneid][1], telephones[phoneid][2] );
}

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
