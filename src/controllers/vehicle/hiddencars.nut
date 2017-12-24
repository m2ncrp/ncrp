local spawnToday = true;
local vehicleid = null;
local placeid = null;
local hiddenCars = [1, 9, 12, 13, 14, 22, 23, 25, 41, 43, 44, 48, 50, 53];
local currentPlaces = [];
local places = [
    [-1627.32, 1645.56, -5.05577, 90.3447, -0.702742, 0.131718 ],      // hidecarKINGSTON2
    [-1167.93, 1535.59, 6.75869, 90.1127, -0.194945, 0.194562 ],       // hidecarKINGSTON3
    [-1246.96, 1415.97, -13.354, 91.5345, -0.216031, 0.210321 ],       // hidecarKINGSTON4
    [-860.818, 1408.71, -8.86715, -91.7262, 1.3883, 1.85035 ],         // hidecarDIPTON1
    [-823.367, 1401.19, -7.8902, -88.019, 5.00623, -1.51217 ],         // hidecarDIPTON2
    [-746.848, 1489.95, -6.61237, 51.312, 0.378565, 0.522005 ],        // hidecarDIPTON3
    [-722.669, 1510.33, -8.56713, 49.8464, -0.392658, 0.180098 ],      // hidecarDIPTON4
    [-485.104, 1496.65, -21.6763, -87.8148, -0.191008, -2.27022 ],     // hidecarDIPTON5
    [-495.478, 1806.59, -22.9813, 89.231, -0.613512, -1.16456 ],       // hidecarDIPTON7
    [-500.821, 1754.67, -22.8047, 90.867, -0.290889, -0.264927 ],      // hidecarDIPTON8
    [-393.916, 1817.13, -23.2812, 90.2181, -0.265438, 0.264429 ],      // hidecarDIPTON9
    [-231.534, 1705.61, -21.8598, 178.714, -2.59383, 2.43337 ],        // hidecarRIVERSIDE1
    [-189.971, 1714.43, -21.3152, -93.381, 4.03973, 7.6452 ],          // hidecarRIVERSIDE2
    [-327.659, 1718.12, -22.5486, 1.03351, 0.400995, 1.17679 ],        // hidecarRIVERSIDE3
    [8.71478, 1754.8, -17.6406, 179.768, -0.127289, 0.00025808 ],      // hidecarRIVERSIDE4
    [59.416, 964.322, -19.664, 92.1532, -0.258859, -4.9428 ],          // hidecarLITTLEITALY2
    [84.1692, 955.036, -19.6549, -90.0461, 0.590109, -0.509185 ],      // hidecarLITTLEITALY3
    [63.968, 720.172, -21.7338, -177.387, -0.2528, -0.117091 ],        // hidecarLITTLEITALY4
    [63.968, 720.172, -21.7338, -177.387, -0.2528, -0.117091 ],        // hidecarLITTLEITALY4
    [15.2698, 603.41, -19.8512, -178.789, -0.302853, 0.185591 ],       // hidecarLITTLEITALY5
    [-34.406, 517.954, -19.301, -178.648, 0.293109, 0.017303 ],        // hidecarLITTLEITALY6
    [-93.0941, 515.279, -19.9505, -179.605, 0.284576, -0.67834 ],      // hidecarLITTLEITALY7
    [-7.01017, 148.722, -14.2307, -174.563, -0.496804, 0.137248 ],     // hidecarEASTSIDE1
    [20.6615, -14.0635, -14.8878, -89.2837, 0.34423, 0.0821031 ],      // hidecarMIDTOWN1
    [106.23, 115.035, -19.7548, -179.248, -0.153168, 0.724965 ],       // hidecarEASTSIDE2_only_model_43
    [15.0203, -199.243, -13.2051, 74.2742, -0.107593, 0.142072 ],      // hidecarMIDTOWN2
    [-441.77, -257.86, -9.8204, 87.0312, -1.82224, -1.40051 ],         // hidecarMIDTOWN3
    [-664.529, -297.726, -11.2298, 178.162, 7.21629, 1.64286 ],        // hidecarSOUTHPORT1_Hotel
    [-707.241, 697.601, -16.8859, 0.812141, -0.00128875, 0.181838 ],   // hidecarUPTOWN1
    [-524.63, 817.647, -19.2905, 179.066, -0.590028, -0.494291 ],      // hidecarUPTOWN2
    [-28.5707, -350.242, -17.4556, -90.4635, 0.298107, -0.360696 ],    // hidecarSOUTHPORT2
    [-221.937, -414.228, -14.5576, -88.3188, 1.48041, -0.25942 ],      // hidecarSOUTHPORT3
    [-117.491, 755.546, -20.726, -90.6748, -0.245013, -0.242144 ],     // hidecarLITTLEITALY_1
    [352.381, 737.792, -21.0269, 90.3574, -0.257122, 0.255523 ],       // hidecarLITTLEITALY_2
    [224.839, 651.515, -21.2313, -179.774, -0.0559646, -0.330701 ],    // hidecarLITTLEITALY_3
    [593.432, 248.835, -11.0971, 87.2992, -7.25706, 4.83042 ],         // hidecarNORTHMILLVILLE_1
    [571.188, 55.3682, -11.8592, 1.80628, 0.00096278, -0.0610743 ],    // hidecarSOUTHMILLVILLE_1
    [602.093, -348.215, -18.2537, 91.5365, -0.0419392, 0.347122 ],     // hidecarSOUTHMILLVILLE_2
    [979.952, -142.123, -19.1494, 2.25831, 0.363896, 0.0967743 ],      // hidecarSOUTHMILLVILLE_X_unreal
    [733.159, -515.147, -25.166, -89.894, 0.0588615, -0.209097 ],      // hidecarSOUTHMILLVILLE_3_podpristan
    [429.334, 412.957, -22.0615, 2.32316, 0.305292, 0.336873 ],        // hidecarCHINATOWN_1
    [171.364, -746.245, -21.5712, -154.914, -0.425446, -0.206679 ],    // hidecarPORT_1
    [271.319, -814.711, -21.5596, -178.389, -1.17779, -0.0972661 ],    // hidecarPORT_2
    [227.818, -1038.72, -21.5168, 59.0594, -0.153473, 0.270934 ],      // hidecarPORT_3
    [-483.884, -711.434, -21.5109, 0.390971, 0.25924, 0.268989 ],      // hidecarPORT_4
    [-1338.81, -321.658, -20.1178, -1.099, 0.00207533, 0.216386 ],     // hidecarSANDISLAND_1
    [-1448.36, 234.979, -24.3309, -179.096, -0.46894, 0.19363 ],       // hidecarHUNTERS_1
    [-1547.57, 186.937, -13.07, 90.1567, -0.243804, 0.243139 ],        // hidecarHUNTERS_2
    [-1635.24, -47.0192, -12.9027, 90.4028, -0.0320528, -9.77731 ],    // hidecarSANDISLAND_2
    [-1644.69, 211.852, -12.3863, 26.8258, 0.509682, 0.544256 ],       // hidecarHUNTERS_3
    [-1412.24, 552.415, -21.4715, 90.2057, -3.06524, 0.401655 ],       // hidecarHUNTERS_4
    [-1665.6, 605.747, -9.94369, -88.7153, 0.267255, -0.206687 ],      // hidecarHUNTERS_5
    [-412.918, 1084.09, 36.7875, -39.3045, 11.9901, -15.591 ],         // hiddencar_HIGHBROOK
    [-1319.32, 1148.75, -21.4747, 90.5301, -0.497622, 0.493039 ],      // hiddencar_KINGSTON00
    [395.36, 825.04, -21.0089, -179.543, -0.319333, -0.572326 ],       // hiddencar_LITTTLE_ITALY_NEW
    [-1077.74, 1547.77, -3.97771, -118.113, -0.130776, -0.845459 ]     // hiddencar_KINGSTON
];


addEventHandlerEx("onServerStarted", function() {
    log("[vehicles] spawning hidden cars...");
    currentPlaces = places;
});


addEventHandlerEx("onServerDayChange", function() {
    local modelid = hiddenCars[random(0, hiddenCars.len() - 1)];
    placeid = random(0, currentPlaces.len() - 1);

    if(spawnToday) {
        vehicleid = createVehicle(modelid, currentPlaces[placeid][0], currentPlaces[placeid][1], currentPlaces[placeid][2], currentPlaces[placeid][3], currentPlaces[placeid][4], currentPlaces[placeid][5]);
    } else {
        if (isVehicleEmpty(vehicleid)) {
            destroyVehicle(vehicleid);
            currentPlaces.remove(placeid);
        }
    }
    spawnToday = !spawnToday;
});


// ADMIN
// Usage: /gotocar <vehicleid>
acmd("gotocar", function(playerid, vehicleid) {
    setPlayerPositionObj( playerid, getVehiclePositionObj(vehicleid.tointeger()));
});
