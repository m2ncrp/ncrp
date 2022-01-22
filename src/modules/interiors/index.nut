include("modules/interiors/translations.nut");

local interiors = [
["onfoot",  "Enter", "type",  -51.6343, 747.523, -21.9009,   "KladovkaFreddyBarEnter"],
["onfoot",  "Exit",  "type",  -50.8003, 747.565, -21.9009,   "KladovkaFreddyBarExit"],
["onfoot",  "Enter", "type",  -48.4323, 728.248, -21.9672,    "FreddyBarEnter"],
["onfoot",  "Exit",  "type",  -48.8562, 728.771, -21.9009,   "FreddyBarExit"],
["onfoot",  "Enter", "type",   629.552, 894.31, -12.0137,     "DragStripEnter"],
["onfoot",  "Exit",  "type",   629.599, 895.129, -12.0138,     "DragStripExit"],
["onfoot",  "Enter", "type",   631.026, 899.66, -12.0138,     "DragStripBlackExit"],
["onfoot",  "Exit",  "type",   631.072, 900.367, -12.0137,   "DragStripBlackEnter"],
// ["onfoot",  "Enter", "type",   1226.26, 1273.46, 0.0755348,   "EmpireBayForgeEnter"],
// ["onfoot",  "Exit",  "type",   1225.56, 1273.45, 0.114826,    "EmpireBayForgeExit"],
["onfoot",  "Enter", "type",   267.905, 800.384, -19.6537,     "FamilyHouseEnter"],
["onfoot",  "Exit",  "type",   268.774, 800.345, -19.6114,    "FamilyHouseExit"],
["onfoot",  "Enter", "type",   275.058, 799.419, -15.4933,    "FamilyFlatEnter"],
["onfoot",  "Exit",  "type",    274.83, 798.749, -15.4962,    "FamilyFlatExit"],
["onfoot",  "Enter", "type",  -165.237, 518.876, -19.9438,   "JuseppeEnter"],
["onfoot",  "Exit",  "type",   -165.113, 519.746, -19.9191,   "JuseppeExit"],
["onfoot",  "Enter", "type",    -166.524, 520.981, -16.0193,   "JuseppeFlatEnter"],
["onfoot",  "Exit",  "type",   -167.196, 521.014, -16.0193,   "JuseppeFlatExit"],
["onfoot",  "Enter", "type",    -643.132, 357.536, 1.34967,    "MonaLisaEnter"],
["onfoot",  "Exit",  "type",   -642.294, 356.822, 1.3482,     "MonaLisaExit"],
["onfoot",  "Enter", "type",    -632.482, 345.732, 1.26516,    "MonaLisaEnterBlack"],
["onfoot",  "Exit",  "type",   -633.572, 345.882, 1.34485,    "MonaLisaExitBlack"],
["onfoot",  "Enter", "type",   -254.249, -88.6935, -11.458,   "VangelisEnter1"],
["onfoot",  "Exit",  "type",   -254.215, -88.0354, -11.458,   "VangelisExit1"],
["onfoot",  "Enter", "type",   -254.626, -52.4519, -11.458,   "VangelisEnter2"],
["onfoot",  "Exit",  "type",   -254.65, -53.2407, -11.458,    "VangelisExit2"],
["onfoot",  "Enter", "type",    -151.556, -91.7796, -12.041,   "MeriaEnter"],
["onfoot",  "Exit",  "type",   -151.476, -90.6505, -12.041,   "MeriaExit"],
["onfoot",  "Enter", "type",    -117.816, -67.6152, -12.041,   "MeriaEnterCenterLeft"],
["onfoot",  "Exit",  "type",   -118.937, -67.5348, -12.041,   "MeriaExitCenterLeft"],
["onfoot",  "Enter", "type",    -117.967, -58.2025, -12.041,   "MeriaEnterCenterRight"],
["onfoot",  "Exit",  "type",   -119.022, -58.1717, -12.041,   "MeriaExitCenterRight"],
["onfoot",  "Enter", "type",    29.2897, -66.3581, -16.1665,   "MalteseFalconEnter1"],
["onfoot",  "Exit",  "type",   28.1666, -66.1971, -16.193,     "MalteseFalconExit1"],
["onfoot",  "Enter", "type",    26.6326, -68.0389, -16.1945,   "MalteseFalconEnter2"],
["onfoot",  "Exit",  "type",   26.4773, -68.9185, -16.1942,    "MalteseFalconExit2"],
["onfoot",  "Enter", "type",    -165.001, -582.591, -20.1835,  "BruneEnter"],
["onfoot",  "Exit",  "type",   -165.032, -583.596, -20.1767,  "BrunoExit"],
["onfoot",  "Enter", "type",    -348.101, -731.57, -15.393,    "DerrekEnter"],
["onfoot",  "Exit",  "type",   -348.085, -730.38, -15.4208,   "DerrekExit"],
["onfoot",  "Enter", "type",    -83.3192, -886.394, -15.8433,  "PortDockEnter"],
["onfoot",  "Exit",  "type",   -81.4264, -882.224, -15.8433,  "PortDockExit"],
["onfoot",  "Enter", "type",    -1552.7, -169.291, -19.628,    "SandIslandBarEnter"],
["onfoot",  "Exit",  "type",   -1553.27, -168.626, -19.6113,  "SandIslandBarExit"],
["onfoot",  "Enter", "type",    -1379.57, 471.409, -22.2337,   "LoneStarEnter1"],
["onfoot",  "Exit",  "type",   -1380.33, 471.386, -22.1321,   "LoneStarExit1"],
["onfoot",  "Enter", "type",    -1381.72, 480.922, -23.182,    "LoneStarEnter2"],
["onfoot",  "Exit",  "type",   -1381.8, 480.092, -23.182,     "LoneStarExit2"],
["onfoot",  "Enter", "type",    -1392.45, 476.327, -22.3359,   "LoneStarBlackEnter"],
["onfoot",  "Exit",  "type",   -1391.45, 476.276, -22.1321,   "LoneStarBlackExit"],
["onfoot",  "Enter", "type",    -1306.52, 990.239, -17.3339,   "VillaVitoEnter"],
["onfoot",  "Exit",  "type",   -1305.48, 990.204, -17.3339,   "VillaVitoExit"],
["onfoot",  "Enter", "type",    -1305.61, 1006.22, -18.5781,   "VillaVitoGarageEnter"],
["onfoot",  "Exit",  "type",   -1304.24, 1006.04, -18.547,    "VillaVitoGarageExit"],
["onfoot",  "Enter", "type",    -1151.78, 1579.89, 6.27526,    "HillOfTaraEnter"],
["onfoot",  "Exit",  "type",   -1151.7, 1580.97, 6.25951,     "HillOfTaraExit"],
["onfoot",  "Enter", "type",    -1158.53, 1599.36, 6.28684,    "HillOfTaraBlackEnter"],
["onfoot",  "Exit",  "type",   -1157.58, 1599.38, 6.25566,    "HillOfTaraBlackExit"],
["onfoot",  "Enter", "type",    -85.217, 1736.77, -18.7144,    "BruskiEnter"],
["onfoot",  "Exit",  "type",   -84.276, 1736.76, -18.7167,    "BruskiExit"],
// ["onfoot",  "Enter", "type",    41.4893, 1783.96, -17.8668,    "ClementeEnter"],
// ["onfoot",  "Exit",  "type",   41.679, 1785.69, -17.8401,     "ClementeExit"],
["onfoot",  "Enter", "type",    -652.748, 940.193, -18.92,     "VitoHouseUptownGarage1Enter"],
["onfoot",  "Exit",  "type",   -652.693, 941.178, -19.011,     "VitoHouseUptownGarage1Exit"],
["onfoot",  "Enter", "type",    -645.395, 943.806, -19.0542,   "VitoHouseUptownGarage2Enter"],
["onfoot",  "Exit",  "type",   -646.394, 943.986, -19.011,     "VitoHouseUptownGarage2Exit"],
["onfoot",  "Enter", "type",    -653.11, 932.425, -18.9157,    "VitoHouseUptownEnter"],
["onfoot",  "Exit",  "type",   -653.16, 933.43, -18.92,       "VitoHouseUptownExit"],
["onfoot",  "Enter", "type",    -650.424, 943.794, -7.96406,   "VitoHouseUptownFlatEnter"],
["onfoot",  "Exit",  "type",   -650.522, 942.783, -7.93587,   "VitoHouseUptownFlatExit"],
["onfoot",  "Enter", "type",    366.227, -288.143, -20.163,    "MartyHouseGarageEnter"],
["onfoot",  "Exit",  "type",   366.216, -289.142, -20.162,    "MartyHouseGarageExit"],
["onfoot",  "Enter", "type",    372.027, -288.232, -15.586,    "MartyHouseGarageEnter"],
["onfoot",  "Exit",  "type",   371.934, -288.904, -15.5867,   "MartyHouseGarageExit"],
["onfoot",  "Enter", "type",    66.338, 913.974, -19.8856,     "JoeGarageEnter"],
["onfoot",  "Exit",  "type",   64.9196, 914.101, -19.8428,    "JoeGarageExit"],
["onfoot",  "Enter", "type",    94.8602, 880.96, -19.6134,     "JoeEnter"],
["onfoot",  "Exit",  "type",   94.201, 880.958, -19.6149,     "JoeExit"],
["onfoot",  "Enter", "type",    74.8334, 898.395, -19.1079,    "JoeBlackEnter"],
["onfoot",  "Exit",  "type",   74.7301, 897.725, -19.1137,    "JoeBlackExit"],
["onfoot",  "Enter", "type",  82.2117, 889.32, -13.3036,      "JoeApartmentEnter"],
["onfoot",  "Exit",  "type",  82.3615, 890.083, -13.3207,      "JoeApartmentExit"],
//["onfoot",  "Enter""type",    -1292.64, 1608.74, 4.30491,      "GarryShopEnter"],
//["onfoot",  "Exit","type",    -1293.31, 1608.81, 4.33968,      "GarryShopExit"],

["onfoot",  "Enter", "type",  -1534.51,    -4.53208,    -17.8467,    "ClothesSandIslandEnter"],
["onfoot",  "Exit",  "type",  -1534.45,    -3.90291,    -17.8467,    "ClothesSandIslandExit"],
["onfoot",  "Enter", "type",  -1369.41,    384.827,    -23.7208,     "ClothesHunterPointsEnter"],
["onfoot",  "Exit",  "type",  -1370.04,    384.993,    -23.7367,     "ClothesHunterPointsExit"],
["onfoot",  "Enter", "type",  -1417.31,    1295.23,    -13.7058,     "ClothesGreenfieldEnter"],
["onfoot",  "Exit",  "type",  -1417.94,    1295.31,    -13.7194,     "ClothesGreenfieldExit"],
["onfoot",  "Enter", "type",  -1297.13,    1698.45,    10.6932,      "ClothesKingstonEnter"],
["onfoot",  "Exit",  "type",  -1297.12,    1699.08,    10.5593,      "ClothesKingstonExit"],
["onfoot",  "Enter", "type",  -510.219,    870.53,    -19.2877,      "ClothesLItalyEnter"],
["onfoot",  "Exit",  "type",  -510.849,    870.564,    -19.3222,     "ClothesLItalyExit"],
["onfoot",  "Enter", "type",  270.449,    767.535,    -21.2438,      "ClothesLItalyEnter"],
["onfoot",  "Exit",  "type",  270.571,    768.213,    -21.2438,      "ClothesLItalyExit"],
["onfoot",  "Enter", "type",  -6.96273,    552.727,    -19.3915,     "ClothesLItalyEnter"],
["onfoot",  "Exit",  "type",  -6.92364,    553.356,    -19.4066,     "ClothesLItalyExit"],
["onfoot",  "Enter", "type",  -43.2028,    381.59,    -13.9932,      "ClothesEastSideEnter"],
["onfoot",  "Exit",  "type",  -43.1409,    382.231,    -13.9962,     "ClothesEastSideExit"],
["onfoot",  "Enter", "type",  437.402,    301.483,    -20.1634,      "ClothesChinatownEnter"],
["onfoot",  "Exit",  "type",  436.773,    301.632,    -20.1785,      "ClothesChinatownExit"],
["onfoot",  "Enter", "type",  343.188,    33.2364,    -24.1097,      "ClothesOysterBayEnter"],
["onfoot",  "Exit",  "type",  343.362,    33.9498,    -24.1477,      "ClothesOysterBayExit"],
["onfoot",  "Enter", "type",  411.193,    -298.532,    -20.1621,     "ClothesOysterBayEnter1"],
["onfoot",  "Exit",  "type",  411.243,    -297.823,    -20.1621,     "ClothesOysterBayExit1"],
["onfoot",  "Enter", "type",  -378.276,    -456.616,    -17.2628,    "ClothesSouthportEnter"],
["onfoot",  "Exit",  "type",  -378.154,    -455.987,    -17.266,     "ClothesSouthportExit"],
["onfoot",  "Enter", "type",  -628.528,     283.775,   -0.248354,    "ClothesWestSideEnter"],
["onfoot",  "Exit",  "type",  -628.414,     284.404,   -0.266979,    "ClothesWestSideExit"],

["onfoot",  "Enter", "gunshop",  -1395.04,    -26.8958,    -17.8468,    "GunsSandIslandEnter"],
["onfoot",  "Exit",  "gunshop",  -1395.12,    -27.5951,    -17.8468,    "GunsSandIslandExit"],
["onfoot",  "Enter", "gunshop",  -1182.75,    1700.38,    11.1807,      "GunsKingstonEnter"],
["onfoot",  "Exit",  "gunshop",  -1182.76,    1701.08,    11.0941,      "GunsKingstonExit"],
["onfoot",  "Enter", "gunshop",  -287.732,    1621.72,    -23.0972,     "GunsRiversideEnter"],
["onfoot",  "Exit",  "gunshop",  -287.684,    1622.42,    -23.0758,     "GunsRiversideExit"],
["onfoot",  "Enter", "gunshop",  -4.65858,    739.756,    -22.0199,     "GunsLITEnter"],
["onfoot",  "Exit",  "gunshop",  -5.35776,    739.824,    -22.0582,     "GunsLITExit"],
["onfoot",  "Enter", "gunshop",  404.41,    609.636,    -24.8944,       "GunsLITEnter"],
["onfoot",  "Exit",  "gunshop",  404.382,    608.937,    -24.9746,      "GunsLITExit"],
["onfoot",  "Enter", "gunshop",  62.1702,    139.499,    -14.414,       "GunsEastSideEnter"],
["onfoot",  "Exit",  "gunshop",  62.8693,    139.298,    -14.4583,      "GunsEastSideExit"],
["onfoot",  "Enter", "gunshop",  273.899,    -118.845,    -12.1976,     "GunsOysterBayEnter"],
["onfoot",  "Exit",  "gunshop",  274.598,    -118.978,    -12.2741,     "GunsOysterBayExit"],
["onfoot",  "Enter", "gunshop",  279.707,    -454.109,    -20.1616,     "GunsOysterBayEnter1"],
["onfoot",  "Exit",  "gunshop",  279.008,    -453.974,    -20.1636,     "GunsOysterBayExit1"],
["onfoot",  "Enter", "gunshop",  -323.075,    -594.988,    -20.1043,    "GunsSouthportEnter"],
["onfoot",  "Exit",  "gunshop",  -322.983,    -594.288,    -20.1043,    "GunsSouthportExit"],
["onfoot",  "Enter", "gunshop",  -592.749,    506.872,    1.02469,      "GunsUptownEnter"],
["onfoot",  "Exit",  "gunshop",  -592.818,    506.173,    1.02277,      "GunsUptownExit"],
["onfoot",  "Enter", "gunshop",  -561.842,    310.936,    0.186189,     "GunsWestSideEnter"],
["onfoot",  "Exit",  "gunshop",  -562.557,    310.902,    0.171005,     "GunsWestSideExit"],

["onfoot",  "Enter", "type",  -1587.41,    168.875,    -12.4756,     "EmpirDinerSandIslandEnter1"],
["onfoot",  "Exit",  "type",  -1587.37,    169.59,    -12.4393,      "EmpirDinerSandIslandExit1"],
["onfoot",  "Enter", "type",  -1584.61,    171.164,    -12.4761,     "EmpirDinerSandIslandEnter2"],
["onfoot",  "Exit",  "type",  -1585.34,    171.235,    -12.4393,     "EmpirDinerSandIslandExit2"],
["onfoot",  "Enter", "type",  -1587.29,    185.235,    -12.4762,     "EmpirDinerSandIslandEnter3"],
["onfoot",  "Exit",  "type",  -1587.39,    184.507,    -12.4393,     "EmpirDinerSandIslandExit3"],

["onfoot",  "Enter", "type",  -1419.12,    952.777,    -12.7921,     "EmpirDinerGreenfieldEnter1"],
["onfoot",  "Exit",  "type",  -1419.07,    953.456,    -12.7543,     "EmpirDinerGreenfieldExit1"],
["onfoot",  "Enter", "type",  -1416.33,    955.037,    -12.7921,     "EmpirDinerGreenfieldEnter2"],
["onfoot",  "Exit",  "type",  -1417.04,    955.156,    -12.7543,     "EmpirDinerGreenfieldExit2"],
["onfoot",  "Enter", "type",  -1419.09,    969.088,     -12.792,     "EmpirDinerGreenfieldEnter3"],
["onfoot",  "Exit",  "type",  -1419.21,    968.348,    -12.7543,     "EmpirDinerGreenfieldExit3"],

["onfoot",  "Enter", "type",  -1590.94,    1602.59,    -5.26265,     "EmpireDinerKingstonEnter1"],
["onfoot",  "Exit",  "type",  -1590.26,    1602.47,    -5.22507,     "EmpireDinerKingstonExit1"],
["onfoot",  "Enter", "type",  -1588.65,    1599.75,    -5.26265,     "EmpireDinerKingstonEnter2"],
["onfoot",  "Exit",  "type",  -1588.6,    1600.43,    -5.22507,      "EmpireDinerKingstonExit2"],
["onfoot",  "Enter", "type",  -1574.63,    1602.49,    -5.26265,     "EmpireDinerKingstonEnter3"],
["onfoot",  "Exit",  "type",  -1575.31,    1602.52,    -5.22507,     "EmpireDinerKingstonExit3"],
["onfoot",  "Enter", "type",  -638.571,    1291.29,    3.90839,      "EmpireDinerHighbrookEnter1"],
["onfoot",  "Exit",  "type",  -639.014,    1291.81,    3.94464,      "EmpireDinerHighbrookExit1"],
["onfoot",  "Enter", "type",  -638.125,    1294.84,    3.90784,      "EmpireDinerHighbrookEnter2"],
["onfoot",  "Exit",  "type",  -638.717,    1294.47,    3.94464,      "EmpireDinerHighbrookExit2"],
["onfoot",  "Enter", "type",  -650.002,    1302.93,    3.90791,      "EmpireDinerHighbrookEnter3"],
["onfoot",  "Exit",  "type",  -649.582,    1302.39,    3.94464,      "EmpireDinerHighbrookExit3"],
["onfoot",  "Enter", "type",  134.02,    -430.89,    -19.4652,       "EmpireDinerOysterBayEnter1"],
["onfoot",  "Exit",  "type",  134.699,    -431.047,    -19.429,      "EmpireDinerOysterBayExit1"],
["onfoot",  "Enter", "type",  136.242,    -433.722,    -19.4657,     "EmpireDinerOysterBayEnter2"],
["onfoot",  "Exit",  "type",  136.335,    -433.043,    -19.429,      "EmpireDinerOysterBayExit2"],
["onfoot",  "Enter", "type",  150.331,    -431.037,    -19.4657,     "EmpireDinerOysterBayEnter3"],
["onfoot",  "Exit",  "type",  149.652,    -430.939,    -19.429,      "EmpireDinerOysterBayExit3"],


// ["onfoot",  "Enter", "type",  310.27,      432.974,    -22.8998,     "ChinaTownEnter", 310.0, 432.0, -25.0],
// ["onfoot",  "Exit",  "type",  312.828,     426.763,    -25.7714,     "ChinaTownExit", 312.828, 426.763, -25.7714],

["onfoot",  "Enter", "type",  305.434,     400.538,    -25.7734,     "ChinaTownLiftEnter"],
["onfoot",  "Exit",  "type",  307.673,     397.318,    -29.5913,     "ChinaTownLiftExit"],

["onfoot",  "Enter", "type",  306.285,     397.738,    -26.5533,      "ChinaTownLiftEnterHelp"],
["onfoot",  "Exit",  "type",  307.673,     397.318,    -29.5913,      "ChinaTownLiftExitHelp"],

["onfoot",  "Enter", "type",    325.836, 412.82, -25.7734,     "ChinaTownLiftShaftRest"],
["onfoot",  "Exit",  "type",  326.838, 409.072, -19.4734,      "ChinaTownLiftShaftRest"],

// ["onfoot",  "Enter", "type",  326.867,     412.519,    -25.7734,      "ChinaTownLift2EnterHelp"],
// ["onfoot",  "Exit",  "type",  326.784,     411.757,     -26.467,      "ChinaTownLift2ExitHelp"],

["onfoot",  "Enter", "type",   318.324, 415.469, -25.7766,     "ChinaTownPodvalDoor"],
["onfoot",  "Exit",  "type",   319.013, 415.438, -25.7734      "ChinaTownPodvalDoor"],


["onfoot",  "Enter", "type",  -1302.92, 1613.28, 1.22659, "HarryVitrinaExit"],
["onfoot",  "Exit",  "type",  -1304.76, 1613.28, 1.22659, "HarryVitrinaEnter"],

["onfoot",  "Enter", "type",  545.215,   0.606471, -18.26,      "Gas Station Oyster Bay door1"           ],
["onfoot",  "Exit",  "type",  544.477,   0.636801, -18.2491,    "Gas Station Oyster Bay door1"           ],
["onfoot",  "Enter", "type",  540.2,     5.07567,  -18.26,      "Gas Station Oyster Bay door2"           ],
["onfoot",  "Exit",  "type",  540.2,     4.34056,  -18.2491,    "Gas Station Oyster Bay door2"           ],
["onfoot",  "Enter", "type",  538.638,   5.0681,   -18.26,      "Gas Station Oyster Bay door3"           ],
["onfoot",  "Exit",  "type",  538.619,   4.37051,  -18.2491,    "Gas Station Oyster Bay door3"           ],
["onfoot",  "Enter", "type",  109.224,   179.406,  -20.0307,    "Gas Station East Side door1"            ],
["onfoot",  "Exit",  "type",  108.335,   179.478,  -20.0394,    "Gas Station East Side door1"            ],
["onfoot",  "Enter", "type",  104.205,   183.962,  -20.0307,    "Gas Station East Side door2"            ],
["onfoot",  "Exit",  "type",  104.159,   183.112,  -20.0394,    "Gas Station East Side door2"            ],
["onfoot",  "Enter", "type",  102.624,   183.889,  -20.0307,    "Gas Station East Side door3"            ],
["onfoot",  "Exit",  "type",  102.511,   183.191,  -20.0394,    "Gas Station East Side door3"            ],
["onfoot",  "Enter", "type",  -632.135, -45.7719,  0.898507,    "Gas Station West Side door1"            ],
["onfoot",  "Exit",  "type",  -632.149, -45.0437,  0.922397,    "Gas Station West Side door1"            ],
["onfoot",  "Enter", "type",  -627.675, -40.787,   0.898235,    "Gas Station West Side door2"            ],
["onfoot",  "Exit",  "type",  -628.506, -40.6717,  0.922397,    "Gas Station West Side door2"            ],
["onfoot",  "Enter", "type",  -627.682, -39.2351,  0.898214,    "Gas Station West Side door3"            ],
["onfoot",  "Exit",  "type",  -628.449, -39.1388,  0.922397,    "Gas Station West Side door3"            ],
["onfoot",  "Enter", "type",  -148.154,  607.446,  -20.1877,    "Gas Station Little Italy Center door1"  ],
["onfoot",  "Exit",  "type",  -148.238,  606.676,  -20.1886,    "Gas Station Little Italy Center door1"  ],
["onfoot",  "Enter", "type",  -152.643,  602.442,  -20.221,     "Gas Station Little Italy Center door2"  ],
["onfoot",  "Exit",  "type",  -151.939,  602.444,  -20.1886,    "Gas Station Little Italy Center door2"  ],
["onfoot",  "Enter", "type",  -152.629,  600.89,   -20.2261,    "Gas Station Little Italy Center door3"  ],
["onfoot",  "Exit",  "type",  -151.932,  600.885,  -20.1886,    "Gas Station Little Italy Center door3"  ],
["onfoot",  "Enter", "type",  336.850,   878.114,  -21.3149,    "Gas Station Little Italy West door1"    ],
["onfoot",  "Exit",  "type",  336.850,   878.831,  -21.3066,    "Gas Station Little Italy West door1"    ],
["onfoot",  "Enter", "type",  341.349,   883.100,  -21.3149,    "Gas Station Little Italy West door2"    ],
["onfoot",  "Exit",  "type",  340.648,   883.100,  -21.3066,    "Gas Station Little Italy West door2"    ],
["onfoot",  "Enter", "type",  341.342,   884.660,  -21.3149,    "Gas Station Little Italy West door3"    ],
["onfoot",  "Exit",  "type",  340.644,   884.660,  -21.3066,    "Gas Station Little Italy West door3"    ],
["onfoot",  "Enter", "type",  -708.404,  1759.91,  -15.0082,    "Gas Station Dipton door1"               ],
["onfoot",  "Exit",  "type",  -708.454,  1759.08,  -15.0062,    "Gas Station Dipton door1"               ],
["onfoot",  "Enter", "type",  -712.898,  1754.76,  -15.002,     "Gas Station Dipton door2"               ],
["onfoot",  "Exit",  "type",  -712.2,    1754.77,  -15.0062,    "Gas Station Dipton door2"               ],
["onfoot",  "Enter", "type",  -712.908,  1753.2,   -15.0015,    "Gas Station Dipton door3"               ],
["onfoot",  "Exit",  "type",  -712.191,  1753.2,   -15.0062,    "Gas Station Dipton door3"               ],
["onfoot",  "Enter", "type",  -1589.33,  944.220,  -5.22379,    "Gas Station Greenfield door1"           ],
["onfoot",  "Exit",  "type",  -1588.4,   944.220,  -5.2064,     "Gas Station Greenfield door1"           ],
["onfoot",  "Enter", "type",  -1584.24,  939.762,  -5.22327,    "Gas Station Greenfield door2"           ],
["onfoot",  "Exit",  "type",  -1584.24,  940.459,  -5.2064,     "Gas Station Greenfield door2"           ],
["onfoot",  "Enter", "type",  -1582.60,  939.678,  -5.22265,    "Gas Station Greenfield door3"           ],
["onfoot",  "Exit",  "type",  -1582.60,  940.466,  -5.2064,     "Gas Station Greenfield door3"           ],
["onfoot",  "Enter", "type",  -1682.75, -233.56,   -20.3412,    "Gas Station Sand Island door1"          ],
["onfoot",  "Exit",  "type",  -1683.45, -233.56,   -20.328,     "Gas Station Sand Island door1"          ],
["onfoot",  "Enter", "type",  -1687.77, -229.126,  -20.3346,    "Gas Station Sand Island door2"          ],
["onfoot",  "Exit",  "type",  -1687.77, -229.823,  -20.328,     "Gas Station Sand Island door2"          ],
["onfoot",  "Enter", "type",  -1689.35, -229.082,  -20.3342,    "Gas Station Sand Island door3"          ],
["onfoot",  "Exit",  "type",  -1689.35, -229.831,  -20.328,     "Gas Station Sand Island door3"          ],

["onfoot",  "Enter", "type",  693.296, -5946.62, 8.2942,  "Gas Station Downtown door1" ],
["onfoot",  "Exit",  "type",  692.862, -5946.07, 8.32851, "Gas Station Downtown door1" ],
["onfoot",  "Enter", "type",  693.399, -5939.88, 8.22501, "Gas Station Downtown door2"],
["onfoot",  "Exit",  "type",  692.734, -5940.32, 8.32851, "Gas Station Downtown door2"],
["onfoot",  "Enter", "type",  692.3, -5938.8, 8.24894,    "Gas Station Downtown door3"],
["onfoot",  "Exit",  "type",  691.689, -5939.16, 8.32851, "Gas Station Downtown door3"],

["onfoot",  "Enter", "type",  1328.27, -3829.36, 32.25,   "Gas Station Hotel Clark door1"],
["onfoot",  "Exit",  "type",  1328.89, -3829.71, 32.2895, "Gas Station Hotel Clark door1"],
["onfoot",  "Enter", "type",  1331.41, -3835.17, 32.25,   "Gas Station Hotel Clark door2"],
["onfoot",  "Exit",  "type",  1331.87, -3834.58, 32.2895, "Gas Station Hotel Clark door2"],
["onfoot",  "Enter", "type",  1332.93, -3835.82, 32.25 ,  "Gas Station Hotel Clark door3"],
["onfoot",  "Exit",  "type",  1333.34, -3835.09, 32.2895, "Gas Station Hotel Clark door3"],

["onfoot",  "Enter", "type", -590.002, -5889.8, -6.97514,  "Gas Station Central Island door1"],
["onfoot",  "Exit",  "type", -590.239, -5890.51, -6.93749, "Gas Station Central Island door1"],
["onfoot",  "Enter", "type", -594.567, -5894.77, -6.99561, "Gas Station Central Island door2"],
["onfoot",  "Exit",  "type", -593.87, -5894.81, -6.93749,  "Gas Station Central Island door2"],
["onfoot",  "Enter", "type", -594.696, -5896.35, -6.99083, "Gas Station Central Island door3"],
["onfoot",  "Exit",  "type", -593.83, -5896.4, -6.93749,   "Gas Station Central Island door3"],

["onfoot",  "Enter", "type", -994.697, -6040.38, -5.23837, "Gas Station Works Quarter door1"],
["onfoot",  "Exit",  "type", -994.794, -6041.09, -5.22449, "Gas Station Works Quarter door1"],
["onfoot",  "Enter", "type", -999.191, -6045.37, -5.27117, "Gas Station Works Quarter door2"],
["onfoot",  "Exit",  "type", -998.472, -6045.43, -5.22449, "Gas Station Works Quarter door2"],
["onfoot",  "Enter", "type", -999.291, -6046.96, -5.28076, "Gas Station Works Quarter door3"],
["onfoot",  "Exit",  "type", -998.473, -6047.01, -5.22449, "Gas Station Works Quarter door3"],


];

/*
["vehicle", "enter",     -1309,23, 1006,19, -18,4034, 90,2244, 0,113699, -0,113254,         "VillaVitoGarageCAREnter"],
["vehicle", "exit",     -1299,48, 1006,07, -18,3797, 91,5782, 0,478648, 0,19822,           "VillaVitoGarageCARExit"],
["vehicle", "enter",     41,3696, 1781,04, -17,5494, 1,72538, -0,011548, 0,766892,          "ClementeTRUCKEnter"],
["vehicle", "exit",     41,7381, 1789,06, -17,5289, 179,675, 0,176731, -0,943787,          "ClementeTRUCKExit"],
["vehicle", "enter",     -642,498, 943,819, -18,857, -87,4446, 0,242543, -0,0992122,        "VitoHouseUptownCarEnter"],
["vehicle", "exit",     -650,09, 944,14, -18,8143, -88,1758, 0,203709, -0,14339,           "VitoHouseUptownCarExit"],
["vehicle", "enter",     366,252, -284,925, -19,9473, -178,724, -0,29729, -0,174022,        "MartyHouseGarageCAREnter"],
["vehicle", "exit",     366,372, -293,386, -19,9664, 0,029353, -4,439, 0,17332,            "MartyHouseGarageCARExit"],
["vehicle", "enter",     69,7592, 913,878, -19,7791, -89,3322, -1,31559, 0,454302,          "JoeGarageCarEnter"],
["vehicle", "exit",     61,3827, 913,346, -19,6444, 89,6546, -0,270483, 0,272119,          "JoeGarageCarExit"],
["onfoot",  "buy",     634,281, 893,82, -12,0137,     "DragStripBuy"],
["onfoot",  "buy",     -50,3259, 725,668, -21,95,     "FreddyBarBuy"],
["onfoot",  "buy",     -641,437, 359,847, 1,39693,    "MonaLisaBuy"],
["onfoot",  "buy",     34,4768, -69,5437, -17,135,    "MaltySokolBuy"]
*/

event("onServerStarted", function() {
    logStr("[interiors] loading interiors enteries...");

    createPlace("ChinaTownPodvalExit", 308.871, 425.365, 306.927, 426.858);
});

event("onServerPlayerStarted", function( playerid ){
    //creating public 3dtext
    foreach (value in interiors) {
        createPrivate3DText ( playerid, value[3], value[4], value[5]+0.35, [[value[1], "3dtext.job.press.E"], "%s | %s"], CL_WHITE, 0.5 );
    }
});

event("onPlayerAreaEnter", function(playerid, name) {
    if(name != "ChinaTownPodvalExit") return;

    removePlayerWeaponChina ( playerid );
});

key(["e"], function(playerid) {
    if (isPlayerInVehicle(playerid)) {
        return;
    }

    local check = false;
    local i = -1;
    foreach (key, value in interiors) {
        if (isPlayerInValidPoint3D(playerid, value[3], value[4], value[5], 0.5 )) {
            check = true;
            i = key;
            break;
        }
    }
    if (!check) {
       return;
    }

    if (interiors[i][1] == "Enter") {

        if (interiors[i][2] == "gunshop") {
          local hour = getHour();
          if(hour < 10 || hour >= 20) {
                   msg(playerid, "interiors.gunshop.closed", CL_THUNDERBIRD);
            return msg(playerid, "interiors.gunshop.workinghours", CL_THUNDERBIRD);
          }
        }

        dbg("[ INTERIOR ] "+getPlayerName(playerid)+" [ "+getAccountName(playerid)+" ] -> Enter >| "+interiors[i][6]+".");
        if (interiors[i].len() <= 7) {
            i += 1;
            setPlayerPosition(playerid, interiors[i][3], interiors[i][4], interiors[i][5]);
        } else {
            freezePlayer( playerid, true );
            screenFadeinFadeoutEx(playerid, 250, 1000, function() {
                setPlayerPosition(playerid, interiors[i][7], interiors[i][8], interiors[i][9]);
                    delayedFunction(1000, function () {
                        i += 1;
                        setPlayerPosition(playerid, interiors[i][3], interiors[i][4], interiors[i][5]);
                        delayedFunction(1500, function () {
                            freezePlayer( playerid, false );
                        })
                    });
            });
        }

    } else  {

        dbg("[ INTERIOR ] "+getPlayerName(playerid)+" [ "+getAccountName(playerid)+" ] -> Exit |> "+interiors[i][6]+".");

        if (interiors[i].len() <= 7) {
            i -= 1;
            setPlayerPosition(playerid, interiors[i][3], interiors[i][4], interiors[i][5]);
        } else {
            freezePlayer( playerid, true );
            screenFadeinFadeoutEx(playerid, 250, 1000, function() {
                setPlayerPosition(playerid, interiors[i][7], interiors[i][8], interiors[i][9]);
                    delayedFunction(1000, function () {
                        i -= 1;
                        setPlayerPosition(playerid, interiors[i][3], interiors[i][4], interiors[i][5]);
                        delayedFunction(1500, function () {
                            freezePlayer( playerid, false );
                        })
                    });
            });
        }

        removePlayerWeaponChina ( playerid );

    }

}, KEY_UP);


function removePlayerWeaponChina ( playerid ) {
    local weaponlist = [3, 5, 7, 9, 10, 11, 12, 13, 14, 18, 19, 20, 21];
    weaponlist.apply(function(id) {
        removePlayerWeapon( playerid, id );
    })
}
