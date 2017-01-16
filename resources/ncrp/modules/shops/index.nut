include("modules/shops/fuelstations");
include("modules/shops/carshop");
include("modules/shops/repairshop");
include("modules/shops/restaurant");
include("modules/shops/washstations");
include("modules/shops/carsearch");
include("modules/shops/clothesshop");


// TODO(inlife): move to other place
event("onServerStarted", function() {
    create3DText(-645.075, 1293.6, 3.94464,         "HighbrookDinerRadio",              CL_WHITE);
    create3DText(-711.473, 1757.95, -14.9935,       "DiptonGasStationRadio",            CL_WHITE);
    create3DText(-711.197, 1758.35, -14.9964,       "DiptonGasstationPhone",            CL_WHITE);
    create3DText(-710.199, 1756.32, -15.0063,       "DiptonGasstaionRadio",             CL_WHITE);
    create3DText(-646.916, 1297.95, 3.94464,        "HighbrookDinerRadio(roomcenter)",  CL_WHITE);
    create3DText(-1294.3, 1705.27, 10.5592,         "KingstonClothesStorePhone",        CL_WHITE);
    create3DText(-1295.72, 1706.66, 10.5592,        "KingstonClothesStoreRadio",        CL_WHITE);
    create3DText(-1149.45, 1588.94, 6.25566,        "HillOfTaraRadio",                  CL_WHITE);
    create3DText(-1420.38, 961.661, -12.7543,       "GreenfieldDinerRadio",             CL_WHITE);
    create3DText(-1422.09, 959.477, -12.7543,       "GreenfieldDinerPhone",             CL_WHITE);
    create3DText(-1587.8, 941.463, -5.19652,        "GreenfieldGasstationPhone",        CL_WHITE);
    create3DText(-1585.75, 942.841, -5.20643,       "GreenfieldGasstationRadio",        CL_WHITE);
    create3DText(-1684.18, -230.827, -20.3181,      "SandIslantGasstationPhone",        CL_WHITE);
    create3DText(-1686.19, -231.996, -20.328,       "SandIslantGasstationRadio",        CL_WHITE);
    create3DText(-1588.4, 177.376, -12.4393,        "SandIslantDinerRadio",             CL_WHITE);
    create3DText(-1590.33, 175.516, -12.4393,       "SandIslantDinerPhone",             CL_WHITE);
    create3DText(-517.973, 871.842, -19.3224,       "UptownDressingShopRadio",          CL_WHITE);
    create3DText(-517.118, 873.251, -19.3223,       "UptownDressingShopPhone",          CL_WHITE);
    create3DText(339.648, 879.538, -21.2967,        "LittleItalyGasstationPhone",       CL_WHITE);
    create3DText(338.483, 881.513, -21.3066,        "LittleItalyGasstationRadio",       CL_WHITE);
    create3DText(429.584, 302.659, -20.1786,        "ChinaTownGasstationRadio",         CL_WHITE);
    create3DText(430.495, 304.263, -20.1786,        "ChinaTownGasstationPhone",         CL_WHITE);
    create3DText(543.76, 3.37411, -18.2392,         "OsterbayGasstationPhone",          CL_WHITE);
    create3DText(541.734, 2.07937, -18.2491,        "OsterbayGasstationRadio",          CL_WHITE);
    create3DText(-40.4981, 388.486, -13.9963,       "EastSideClothingShopPhone",        CL_WHITE);
    create3DText(-41.8942, 389.116, -13.9963,       "EastSideClothingShopRadio",        CL_WHITE);
    create3DText(107.752, 182.195, -20.0295,        "EastSideGasstaionPhone",           CL_WHITE);
    create3DText(105.723, 180.87, -20.0394,         "EastSideGasstaionRadio",           CL_WHITE);
    create3DText(-4.2169, 559.556, -19.4067,        "LittleItalyClothingShopPhone",     CL_WHITE);
    create3DText(-5.61307, 560.5, -19.4068,         "LittleItalyClothingShopRadio",     CL_WHITE);
    create3DText(-150.935, 606.023, -20.1787,       "LittleitalyGasstaion2Phone",       CL_WHITE);
    create3DText(-149.686, 604.01, -20.1886,        "LittleitalyGasstaion2Radio",       CL_WHITE);

    create3DText(240.014, 709.288, -24.0321,        "LittleitalyStellasDinerRadio",     CL_WHITE);
    create3DText(631.654, 897.374, -12.0138,        "LittleitalyBrialinBarRadio",       CL_WHITE);
    create3DText(-53.6405, 742.169, -21.9009,       "LittleitalyFreddysBarRadio",       CL_WHITE);
    create3DText(-8.8025, 741.246, -22.0582,        "LittleitalyGunshopNearFBRadio",    CL_WHITE); // near Freddy's Bar
    create3DText(631.654, 897.374, -12.0138,        "LittleitalyBrialinBarRadio",       CL_WHITE);
    create3DText(-168.989, 522.981, -16.0193,       "LittleitalyGiuseppesShopRadio",    CL_WHITE);

    create3DText(-771.725, -377.324, -20.4072,      "SouthPortIlliasBarRadio",          CL_WHITE);
    create3DText(-321.456, -590.863, -20.1043,      "SouthPortGunshopRadio",            CL_WHITE);
    create3DText(-376.9, -449.606, -17.2661,        "SouthPortDiptoApparelRadio",       CL_WHITE);
    
    create3DText(-251.738, -70.3595, -11.458,       "MidtownUangelsD&RClosingRadio",    CL_WHITE);
    create3DText(24.2735, -78.9135, -15.5926,       "MidtownTheMalteseFalconRadio",     CL_WHITE);

    create3DText(-631.257, -41.4123, 0.922398,      "WestSideFuelStationRadio",         CL_WHITE);
    create3DText(-639.262, 349.289, 1.34485,        "WestSideMonaLisaRadio",            CL_WHITE);

    create3DText(-1560.45, -163.092, -19.6113,      "niggabarradio",                    CL_WHITE);
    create3DText(-1394.48, -34.1276, -17.8468,      "SandIslandGunTelephone",           CL_WHITE);
    create3DText(-1393.34, -33.4857, -17.8468,      "SandIslandGunRadio",               CL_WHITE);
    create3DText(-1530.26, 2.99262, -17.8468,       "SandIslandClothesRadio",           CL_WHITE);
    create3DText(-1531.76, 2.55604, -17.8468,       "SandIslandClothesTelephone",       CL_WHITE);
    create3DText(-1424.84, 1299.52, -13.7195,       "GreenfieldClothesRadio",           CL_WHITE);
    create3DText(-1424.27, 1298.01, -13.7195,       "GreenfieldClothesTelephone",       CL_WHITE);
    create3DText(-1585.25, 1605.54, -5.22507,       "KingstonDinnerRadio",              CL_WHITE);
    create3DText(-1183.28, 1707.61, 11.0941,        "KingstonGunTelephone",             CL_WHITE);
    create3DText( -1184.48, 1707.1, 11.0941,        "KingstonGunRadio",                 CL_WHITE);
    create3DText(-288.33, 1628.95, -23.0758,        "RiversideGunTelephone",            CL_WHITE);
    create3DText(-289.424, 1628.11, -23.0758,       "RiversideGunRadio",                CL_WHITE);
    create3DText(415.377, -290.927, -20.1622,       "OysterBayClothesRadio",            CL_WHITE);
    create3DText( 413.931, -291.478, -20.1622,      "OysterBayClothesTelephone",        CL_WHITE);
    create3DText( 272.476, -454.776, -20.1636,      "OysterBayGunTelephone",            CL_WHITE);
    create3DText( 273.315, -455.838, -20.1636,      "OysterBayGunRadio",                CL_WHITE);
    create3DText( 140.116, -427.935, -19.429,       "OysterBayDinnerRadio",             CL_WHITE);
    create3DText( 281.13, -118.194, -12.2741,       "OysterBayGunTelephone2",           CL_WHITE);
    create3DText( 280.497, -117.119, -12.2741,      "OysterBayGunRadio2",               CL_WHITE);
    create3DText( 345.958, 39.9048, -24.1478,       "OysterBayDiptonApparelPhone",      CL_WHITE);
    create3DText( 344.533, 40.1885, -24.1478,       "OysterBayDiptonApparelRadio",      CL_WHITE);
    create3DText( -625.776, 290.397, -0.267075,     "WestSideDiptonAppearelPhone",      CL_WHITE);
    create3DText( -627.173, 290.769, -0.267081,     "WestSideDiptonAppearelRadio",      CL_WHITE);
    create3DText( -569.074, 310.33, 0.16808,        "WestSideGunshopTelephone",         CL_WHITE);
    create3DText( -566.002, 312.354, 0.168081,      "WestSideGunshopRadio",             CL_WHITE);
})
