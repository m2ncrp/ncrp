// TODO(inlife): move to other place
event("onServerStarted", function() {

// координаты центров помещений для радио:
/*    create3DText(-1295.72, 1706.66, 10.5592,        "01-KingstonClothesStoreRadio"           , CL_YELLOW, 2000);
    create3DText(-1149.45, 1588.94, 6.25566,        "02-HillOfTaraRadio"                     , CL_YELLOW, 2000);
    create3DText(-1585.75, 942.841, -5.20643,       "03-GreenfieldGasstationRadio"           , CL_YELLOW, 2000);
    create3DText(-1686.19, -231.996, -20.328,       "04-SandIslantGasstationRadio"           , CL_YELLOW, 2000);
    create3DText(-517.973, 871.842, -19.3224,       "05-UptownDressingShopRadio"             , CL_YELLOW, 2000);
    create3DText(338.483, 881.513, -21.3066,        "06-LittleItalyGasstation(East)Radio"    , CL_YELLOW, 2000);
    create3DText(429.584, 302.659, -20.1786,        "07-Chinatown. Gas station. Radio"       , CL_YELLOW, 2000);
    create3DText(541.734, 2.07937, -18.2491,        "08-OsterbayGasstationRadio"             , CL_YELLOW, 2000);
    create3DText(-41.8942, 389.116, -13.9963,       "09-EastSideClothingShopRadio"           , CL_YELLOW, 2000);
    create3DText(105.723, 180.87, -20.0394,         "010-EastSideGasstaionRadio"             , CL_YELLOW, 2000);
    create3DText(-5.61307, 560.5, -19.4068,         "011-LittleItalyClothingShopRadio"       , CL_YELLOW, 2000);
    create3DText(-149.686, 604.01, -20.1886,        "012-LittleitalyGasstaion2Radio"         , CL_YELLOW, 2000);
    create3DText(240.014, 709.288, -24.0321,        "013-LittleitalyStellasDinerRadio"       , CL_YELLOW, 2000);
    create3DText(631.654, 897.374, -12.0138,        "014-LittleitalyBrialinBarRadio"         , CL_YELLOW, 2000);
    create3DText(-53.6405, 742.169, -21.9009,       "015-LittleitalyFreddysBarRadio"         , CL_YELLOW, 2000);
    create3DText(-8.8025, 741.246, -22.0582,        "016-LittleitalyGunshopNearFBRadio"      , CL_YELLOW, 2000); // near Freddy's Bar
    create3DText(-168.989, 522.981, -16.0193,       "017-LittleitalyGiuseppesShopRadio"      , CL_YELLOW, 2000);
    create3DText(-771.725, -377.324, -20.4072,      "018-SouthPortIlliasBarRadio"            , CL_YELLOW, 2000);
    create3DText(-321.456, -590.863, -20.1043,      "019-SouthPortGunshopRadio"              , CL_YELLOW, 2000);
    create3DText(-377.02, -448.385, -17.2661,       "020-SouthPortDiptonApparelRadio"        , CL_YELLOW, 2000);
    create3DText(-251.738, -70.3595, -11.458,       "021-MidtownUangelsD&RClosingRadio"      , CL_YELLOW, 2000);
    create3DText(24.2735, -78.9135, -15.5926,       "022-MidtownTheMalteseFalconRadio"       , CL_YELLOW, 2000);
    create3DText(-631.257, -41.4123, 0.922398,      "023-WestSideFuelStationRadio"           , CL_YELLOW, 2000);
    create3DText(-639.262, 349.289, 1.34485,        "024-WestSideMonaLisaRadio"              , CL_YELLOW, 2000);
    create3DText(-1558.92, -166.169, -19.6113,      "025-niggabarradio"                      , CL_YELLOW, 2000);
    create3DText(415.377, -290.927, -20.1622,       "026-OysterBayClothesRadio"              , CL_YELLOW, 2000);
    create3DText( -566.002, 312.354, 0.168081,      "027-WestSideGunshopRadio"               , CL_YELLOW, 2000);
    create3DText(-1588.4, 177.376, -12.4393,        "028-SandIslantDinerRadio"               , CL_YELLOW, 2000);
    create3DText( -627.297, 291.996, -0.267101,     "029-WSDIptonApparelRadio"               , CL_YELLOW, 2000);
    create3DText( -561.204, 428.302, 1.02075,       "030-West Side. Stella's Diner. Radio"   , CL_YELLOW, 2000);
    create3DText(-710.199, 1756.32, -15.0063,       "031-DiptonGasstaionRadio"               , CL_YELLOW, 2000);
    create3DText( 275.36, -452.657, -20.1636,       "032-OysterBayGunshopRadio"              , CL_YELLOW, 2000);
    create3DText( 277.922, -120.387, -12.2741,      "033-OysterBayGunshopRadio2"             , CL_YELLOW, 2000);
    create3DText( 344.479, 41.7052, -24.1478,       "034-OysterBayDiptonApparelRadio"        , CL_YELLOW, 2000);
    create3DText( 66.3907, 137.906, -14.4583,       "035-ESgunRadioCenter"                   , CL_YELLOW, 2000);
    create3DText( 271.602, 775.99, -21.2439,        "036-LIDiptoApparelRadioCenter"          , CL_YELLOW, 2000);
    create3DText( 402.929, 605.669, -24.9746,       "037-LIWestgunRadioCenter"               , CL_YELLOW, 2000);
    create3DText( -286.356, 1625.76, -23.0758,      "038-RiverSideGunRadioCenter"            , CL_YELLOW, 2000);
    create3DText( -1306.47, 1612.38, 1.22659,       "039-HarryRadioCenter"                   , CL_YELLOW, 2000);
    create3DText( -1181.47, 1704.52, 11.0941,       "040-KingstonGunRadioCenter"             , CL_YELLOW, 2000);
    create3DText( -1425.68, 1296.22, -13.7195,      "041-KingstonDiptonApparelRadioCEnter"   , CL_YELLOW, 2000);
    create3DText( -1582.61, 1603.15, -5.22507,      "042-KingstonEmpireDinerRadio"           , CL_YELLOW, 2000);
    create3DText( -1419.72, 961.505, -12.7543,      "043-GreenfieldEmpireDinerRadio"         , CL_YELLOW, 2000);
    create3DText( -1384.29, 470.847, -22.1321,      "044-LoneStarRadioCenter"                , CL_YELLOW, 2000);
    create3DText( -1377.66, 386.016, -23.7368,      "045-HunterDiptonApparelRadio"           , CL_YELLOW, 2000);
    create3DText( -1533.55, 3.86801, -17.8468,      "046-SIDiptonApparelRadio"               , CL_YELLOW, 2000);
    create3DText( -1396.45, -30.9751, -17.8468,     "047-SIgunRadioCenter"                   , CL_YELLOW, 2000);
    create3DText( -644.641, 1296.51, 3.94464,       "048-HighbrookCenterRadio"               , CL_YELLOW, 2000);
    create3DText( 142.147, -430.395, -19.429,       "049-OysterDinerRadioCenter"             , CL_YELLOW, 2000);

*/

// координаты радио приёмников:
/*

        create3DText( -1303.63, 1608.74, 1.22659,       "122-HarryRadio",                        CL_YELLOW, 2000);
        create3DText( 68.7955, 141.182, -14.4583,       "117-ESgunRadio",                        CL_YELLOW, 2000);
        create3DText(-645.075, 1293.6, 3.94464,         "1-HighbrookDinerRadio",                 CL_YELLOW, 2000);
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


})
