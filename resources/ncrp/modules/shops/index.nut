include("modules/shops/fuelstations");
include("modules/shops/carshop");
include("modules/shops/repairshop");
include("modules/shops/restaurant");
include("modules/shops/washstations");
include("modules/shops/carsearch");
include("modules/shops/clothesshop");


// TODO(inlife): move to other place
event("onServerStarted", function() {
    create3DText(-645.075, 1293.6, 3.94464,         "1-HighbrookDinerRadio",               CL_WHITE, 100);

    create3DText(-711.197, 1758.35, -14.9964,       "3-DiptonGasstationPhone",             CL_WHITE, 100);
    create3DText(-710.199, 1756.32, -15.0063,       "4-DiptonGasstaionRadio",              CL_WHITE, 100);
    create3DText(-646.916, 1297.95, 3.94464,        "5-HighbrookDinerRadio(roomcenter)",   CL_WHITE, 100);
    create3DText(-1294.3, 1705.27, 10.5592,         "6-KingstonClothesStorePhone",         CL_WHITE, 100);
    create3DText(-1295.72, 1706.66, 10.5592,        "7-KingstonClothesStoreRadio",         CL_WHITE, 100);
    create3DText(-1149.45, 1588.94, 6.25566,        "8-HillOfTaraRadio",                   CL_WHITE, 100);
    create3DText(-1587.8, 941.463, -5.19652,        "11-GreenfieldGasstationPhone",        CL_WHITE, 100);
    create3DText(-1585.75, 942.841, -5.20643,       "12-GreenfieldGasstationRadio",        CL_WHITE, 100);
    create3DText(-1684.18, -230.827, -20.3181,      "13-SandIslantGasstationPhone",        CL_WHITE, 100);
    create3DText(-1686.19, -231.996, -20.328,       "14-SandIslantGasstationRadio",        CL_WHITE, 100);
    create3DText(-1588.4, 177.376, -12.4393,        "15-SandIslantDinerRadio",             CL_WHITE, 100);
    create3DText(-1590.33, 175.516, -12.4393,       "16-SandIslantDinerPhone",             CL_WHITE, 100);
    create3DText(-517.973, 871.842, -19.3224,       "17-UptownDressingShopRadio",          CL_WHITE, 100);
    create3DText(-517.118, 873.251, -19.3223,       "18-UptownDressingShopPhone",          CL_WHITE, 100);
    create3DText(339.648, 879.538, -21.2967,        "19-LittleItalyGasstationPhone",       CL_WHITE, 100);
    create3DText(338.483, 881.513, -21.3066,        "20-LittleItalyGasstationRadio",       CL_WHITE, 100);
    create3DText(429.584, 302.659, -20.1786,        "21-ChinaTownGasstationRadio",         CL_WHITE, 100);
    create3DText(430.495, 304.263, -20.1786,        "22-ChinaTownGasstationPhone",         CL_WHITE, 100);
    create3DText(543.76, 3.37411, -18.2392,         "23-OsterbayGasstationPhone",          CL_WHITE, 100);
    create3DText(541.734, 2.07937, -18.2491,        "24-OsterbayGasstationRadio",          CL_WHITE, 100);
    create3DText(-40.4981, 388.486, -13.9963,       "25-EastSideClothingShopPhone",        CL_WHITE, 100);
    create3DText(-41.8942, 389.116, -13.9963,       "26-EastSideClothingShopRadio",        CL_WHITE, 100);
    create3DText(107.752, 182.195, -20.0295,        "27-EastSideGasstaionPhone",           CL_WHITE, 100);
    create3DText(105.723, 180.87, -20.0394,         "28-EastSideGasstaionRadio",           CL_WHITE, 100);
    create3DText(-4.2169, 559.556, -19.4067,        "29-LittleItalyClothingShopPhone",     CL_WHITE, 100);
    create3DText(-5.61307, 560.5, -19.4068,         "30-LittleItalyClothingShopRadio",     CL_WHITE, 100);
    create3DText(-150.935, 606.023, -20.1787,       "31-LittleitalyGasstaion2Phone",       CL_WHITE, 100);
    create3DText(-149.686, 604.01, -20.1886,        "32-LittleitalyGasstaion2Radio",       CL_WHITE, 100);
    create3DText(240.014, 709.288, -24.0321,        "33-LittleitalyStellasDinerRadio",     CL_WHITE, 100);
    create3DText(631.654, 897.374, -12.0138,        "34-LittleitalyBrialinBarRadio",       CL_WHITE, 100);
    create3DText(-53.6405, 742.169, -21.9009,       "35-LittleitalyFreddysBarRadio",       CL_WHITE, 100);
    create3DText(-8.8025, 741.246, -22.0582,        "36-LittleitalyGunshopNearFBRadio",    CL_WHITE, 100); // near Freddy's Bar
    create3DText(-168.989, 522.981, -16.0193,       "38-LittleitalyGiuseppesShopRadio",    CL_WHITE, 100);
    create3DText(-771.725, -377.324, -20.4072,      "39-SouthPortIlliasBarRadio",          CL_WHITE, 100);
    create3DText(-321.456, -590.863, -20.1043,      "40-SouthPortGunshopRadio",            CL_WHITE, 100);
    create3DText(-377.02, -448.385, -17.2661,       "41-SouthPortDiptonApparelRadio",      CL_WHITE, 100);
    create3DText(-251.738, -70.3595, -11.458,       "42-MidtownUangelsD&RClosingRadio",    CL_WHITE, 100);
    create3DText(24.2735, -78.9135, -15.5926,       "43-MidtownTheMalteseFalconRadio",     CL_WHITE, 100);
    create3DText(-631.257, -41.4123, 0.922398,      "44-WestSideFuelStationRadio",         CL_WHITE, 100);
    create3DText(-639.262, 349.289, 1.34485,        "45-WestSideMonaLisaRadio",            CL_WHITE, 100);
    create3DText(-1558.92, -166.169, -19.6113,      "46-niggabarradio",                    CL_WHITE, 100);
    create3DText(-1394.48, -34.1276, -17.8468,      "47-SandIslandGunTelephone",           CL_WHITE, 100);
    create3DText(-1424.27, 1298.01, -13.7195,       "52-GreenfieldClothesTelephone",       CL_WHITE, 100);
    create3DText(-1183.28, 1707.61, 11.0941,        "54-KingstonGunTelephone",             CL_WHITE, 100);
    create3DText(-288.33, 1628.95, -23.0758,        "56-RiversideGunTelephone",            CL_WHITE, 100);
    create3DText(415.377, -290.927, -20.1622,       "58-OysterBayClothesRadio",            CL_WHITE, 100);
    create3DText( 413.931, -291.478, -20.1622,      "59-OysterBayClothesTelephone",        CL_WHITE, 100);
    create3DText( 272.476, -454.776, -20.1636,      "60-OysterBayGunTelephone",            CL_WHITE, 100);
    create3DText( 281.13, -118.194, -12.2741,       "63-OysterBayGunTelephone2",           CL_WHITE, 100);
    create3DText( 345.958, 39.9048, -24.1478,       "65-OysterBayDiptonApparelPhone",      CL_WHITE, 100);
    create3DText( -569.074, 310.33, 0.16808,        "69-WestSideGunshopTelephone",         CL_WHITE, 100);
    create3DText( -566.002, 312.354, 0.168081,      "70-WestSideGunshopRadio",             CL_WHITE, 100);

/*
        create3DText(-711.473, 1757.95, -14.9935,       "2-DiptonGasStationRadio",            CL_WHITE);
        create3DText(-1393.34, -33.4857, -17.8468,      "48-SandIslandGunRadio",               CL_WHITE);
        create3DText(-1530.26, 2.99262, -17.8468,       "49-SandIslandClothesRadio",           CL_WHITE);
        create3DText(-1424.84, 1299.52, -13.7195,       "51-GreenfieldClothesRadio",           CL_WHITE);
        create3DText(-1585.25, 1605.54, -5.22507,       "53-KingstonDinnerRadio",              CL_WHITE);
        create3DText( -1184.48, 1707.1, 11.0941,        "55-KingstonGunRadio",                 CL_WHITE);
        create3DText(-289.424, 1628.11, -23.0758,       "57-RiversideGunRadio",                CL_WHITE);
        create3DText( 273.315, -455.838, -20.1636,      "61-OysterBayGunRadio",                CL_WHITE);
        create3DText( 140.116, -427.935, -19.429,       "62-OysterBayDinnerRadio",             CL_WHITE);
        create3DText( 280.497, -117.119, -12.2741,      "64-OysterBayGunRadio2",               CL_WHITE);
*/
    create3DText( -629.376, -44.3486, 0.932261,                      "101-FuelWSPhone",                                       CL_WHITE, 100);
    create3DText( -773.044, -375.432, -20.4072,                      "102-IlliasPhone",                                       CL_WHITE, 100);
    create3DText( -323.609, -587.756, -20.1043,                      "103-SouthPortGunShopPhone",                             CL_WHITE, 100);
    create3DText( 69.4106, 140.001, -14.4583,                        "104-ESgunPhone",                                        CL_WHITE, 100);
    create3DText( -1304.62, 1608.74, 1.22659,                        "105-HarryPhone",                                        CL_WHITE, 100);
    create3DText( -625.776, 290.6, -0.267079,                        "106-WSDIptonApparelPhone",                              CL_WHITE, 100);
    create3DText( -563.005, 427.133, 1.02075,                        "107-WSStellaPhone",                                     CL_WHITE, 100);
    create3DText( -11.8903, 739.111, -22.0582,                       "108-LIgunPhone",                                        CL_WHITE, 100);
    create3DText( 273.21, 774.425, -21.2439,                         "109-LIDiptoApparelPhone",                               CL_WHITE, 100);
    create3DText( 405.023, 602.404, -24.9746,                        "110-LIWestgunPhone",                                    CL_WHITE, 100);
    create3DText( -1422.09, 959.373, -12.7543,                       "111-GreenfieldEmpireDinerPhone",                        CL_WHITE, 100);
    create3DText( -1376.25, 387.643, -23.7368,                       "112-HunterDiptonApparelPhone",                          CL_WHITE, 100);
    create3DText( -1531.76, 2.28327, -17.8468,                       "113-SIDiptonApparelPhone",                              CL_WHITE, 100);
    create3DText( 275.36, -452.657, -20.1636,                        "114-OysterBayGunshopRadio",                             CL_WHITE, 100);
    create3DText( 277.922, -120.387, -12.2741,                       "115-OysterBayGunshopRadio2",                            CL_WHITE, 100);
    create3DText( 344.479, 41.7052, -24.1478,                        "116-OysterBayDiptonApparel",                            CL_WHITE, 100);
    create3DText( 68.7955, 141.182, -14.4583,                        "117-ESgunRadio",                                        CL_WHITE, 100);
    create3DText( 66.3907, 137.906, -14.4583,                        "118-ESgunRadioCenter",                                  CL_WHITE, 100);
    create3DText( -627.297, 291.996, -0.267101,                      "119-WSDIptonApparelRadio",                              CL_WHITE, 100);
    create3DText( -561.204, 428.302, 1.02075,                        "120-WSStellaRadio",                                     CL_WHITE, 100);
    create3DText( 271.602, 775.99, -21.2439,                         "121-LIDiptoApparelRadiCenter",                          CL_WHITE, 100);
    create3DText( -1303.63, 1608.74, 1.22659,                        "122-HarryRadio",                                        CL_WHITE, 100);
    create3DText( 402.929, 605.669, -24.9746,                        "123-LIWestgunRadioCenter",                              CL_WHITE, 100);
    create3DText( -286.356, 1625.76, -23.0758,                       "124-RiverSideGunRadioCenter",                           CL_WHITE, 100);
    create3DText( -1306.47, 1612.38, 1.22659,                        "125-HarryRadioCenter",                                  CL_WHITE, 100);
    create3DText( -1181.47, 1704.52, 11.0941,                        "126-KingstonGunRadioCenter",                            CL_WHITE, 100);
    create3DText( -1425.68, 1296.22, -13.7195,                       "127-KingstonDiptonApparelRadioCEnter",                  CL_WHITE, 100);
    create3DText( -1582.61, 1603.15, -5.22507,                       "128-KingstonEmpireDinerRadio",                          CL_WHITE, 100);
    create3DText( -1419.72, 961.505, -12.7543,                       "129-GreenfieldEmpireDinerRadio",                        CL_WHITE, 100);
    create3DText( -1384.29, 470.847, -22.1321,                       "130-LoneStarRadioCenter",                               CL_WHITE, 100);
    create3DText( -1377.66, 386.016, -23.7368,                       "131-HunterDiptonApparelRadio",                          CL_WHITE, 100);
    create3DText( -1533.55, 3.86801, -17.8468,                       "132-SIDiptonApparelRadio",                              CL_WHITE, 100);
    create3DText( -1396.45, -30.9751, -17.8468,                      "133-SIgunRadioCenter",                                  CL_WHITE, 100);
    create3DText( -644.641, 1296.51, 3.94464, "134-HighbrookCenterRadio",                                                     CL_WHITE, 100);
    create3DText( 142.147, -430.395, -19.429, "135-OysterDinetRadioCenter",                                                   CL_WHITE, 100);

})
