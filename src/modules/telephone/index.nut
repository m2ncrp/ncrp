include("modules/telephone/commands.nut");
include("modules/telephone/translations.nut");
include("modules/telephone/nodes.nut");

// TODO: может стоит переехать на классы
// include("modules/telephone/classes/Telephone.nut");

// type
const PHONE_TYPE_BOOTH = 0;
const PHONE_TYPE_BUSSINESS = 1;

TELEPHONE_TEXT_COLOR <- CL_WAXFLOWER;
local phone_nearest_blip = {};
local PHONE_CALL_PRICE = 0.50;

local numbers = {
    "0192": "car rental",
    "1111": "empire custom"
    // "0000", searhing car services
    // "1863", // Tires and Rims
    // "6214", // Richard Beck
};

local phoneObjs = {
    "0100": {"coords": [ -1021.87, 1643.44, 10.6318, -137.29, -0.00478374, -0.00297636 ], "name": "telephone0"  , "type": 0},
    "0101": {"coords": [ -562.55, 1522.12, -16.1834, -175.155, -0.000424851, -0.000149504       ], "name": "telephone1"  , "type": 0},
    "0102": {"coords": [ -310.62, 1694.98, -22.3772, -97.3623, -2.4078105, -0.00276796       ], "name": "telephone2"  , "type": 0},
    "0103": {"coords": [ -747.386, 1762.67, -15.0237, -97.3623, -2.4078105, -0.00276796 ], "name": "telephone3"  , "type": 0},
    "0104": {"coords": [ -747.386, 1762.67, -15.0237, -97.3623, -2.4078105, -0.00276796 ], "name": "telephone4"  , "type": 0},
    "0105": {"coords": [ -724.814, 1647.21, -14.9223, 177.088, -0.00136449, -0.00249676 ], "name": "telephone5"  , "type": 0},
    "0106": {"coords": [ -1199.97, 1675.74, 11.3331, -92.5463, -8.1721605, -0.000404868    ], "name": "telephone6"  , "type": 0},
    "0107": {"coords": [ -1436.24, 1675.97, 6.14957, -90.2346, -0.000102045, -0.000393846  ], "name": "telephone7"  , "type": 0},
    "0108": {"coords": [ -1520.39, 1592.49, -6.04865, -1.66217, -0.000100734, -0.000524284 ], "name": "telephone8"  , "type": 0},
    "0109": {"coords": [ -1038.65, 1368.63, -13.5484, 83.7251, -0.000281846, -8.0673405  ], "name": "telephone9"  , "type": 0},
    "0110": {"coords": [ -1037.11, 1368.54, -13.5485, -84.4394, -0.000697667, 0.000710821  ], "name": "telephone10" , "type": 0},
    "0111": {"coords": [ -1033.19, 1398.75, -13.5598, -89.6952, 0.00533877, -0.00711058 ], "name": "telephone11" , "type": 0},
    "0112": {"coords": [ -903.212, 1412.57, -11.3637, -177.313, -0.00217857, -0.0102878 ], "name": "telephone12" , "type": 0},
    "0113": {"coords": [ -1170.61, 1578.43, 5.84176, 171.046, -0.00291664, -0.00400316  ], "name": "telephone13" , "type": 0},
    "0114": {"coords": [ -1297.37, 1491.53, -6.07109, -86.3202, -0.000673492, -0.000199707 ], "name": "telephone14" , "type": 0},
    "0115": {"coords": [ -1297.38, 1492.68, -6.07106, -86.3202, -0.000673492, -0.000199707 ], "name": "telephone15" , "type": 0},
    "0116": {"coords": [ -1229.36, 1457.89, -4.88869, -8.62989, -0.000498972, 0.000281317 ], "name": "telephone16" , "type": 0},
    "0117": {"coords": [ -1228.24, 1457.91, -4.85487, -8.62989, -0.000498972, 0.000281317 ], "name": "telephone17" , "type": 0},
    "0118": {"coords": [ -1046.37, 1429.04, -4.31555, 176.632, -0.000221447, 0.000209638  ], "name": "telephone18" , "type": 0},
    "0119": {"coords": [ -1047.67, 1429.08, -4.31619, 176.632, -0.000221447, 0.000209638 ], "name": "telephone19" , "type": 0},
    "0120": {"coords": [ -952.974, 1486.2, -4.74201, 176.807, -3.7956505, -0.000202667 ], "name": "telephone20" , "type": 0},
    "0121": {"coords": [ -1654.81, 1142.99, -7.10698, 73.6452, -0.000160914, -4.9362805  ], "name": "telephone21" , "type": 0},
    "0122": {"coords": [ -1471.25, 1124.4, -11.7355, -5.70769, 0.00428384, -0.00404837  ], "name": "telephone22" , "type": 0},
    "0123": {"coords": [ -1187.01, 1276.5, -13.5483, 178.989, -6.6917306, -6.9934205  ], "name": "telephone23" , "type": 0},
    "0124": {"coords": [ -1187.17, 1274.98, -13.5486, -4.86224, -4.3975605, -0.000371553], "name": "telephone24" , "type": 0},
    "0125": {"coords": [ -1579.16, 940.331, -5.19275, -0.796922, -0.000853109, -0.000214953 ], "name": "telephone25" , "type": 0},
    "0126": {"coords": [ -1416.07, 935.489, -13.6496, 172.237, -0.00493577, -0.00345781 ], "name": "telephone26" , "type": 0},
    "0127": {"coords": [ -1342.92, 1017.59, -17.6024, 86.1758, -0.000218818, -9.0352805 ], "name": "telephone27" , "type": 0},
    "0128": {"coords": [ -1338.82, 915.978, -18.4359, -90.2148, -0.00302303, -0.00109575 ], "name": "telephone28" , "type": 0},
    "0129": {"coords": [ -1344.9, 796.402, -14.6408, 31.2495, -0.000101102, -0.000674572 ], "name": "telephone29" , "type": 0},
    "0130": {"coords": [ -1562.11, 527.842, -20.1475, -95.5123, -0.00289898, -0.00111628 ], "name": "telephone30" , "type": 0},
    "0131": {"coords": [ -1712.53, 688.178, -10.2715, -105.786, -0.00025038, -0.00111927 ], "name": "telephone31" , "type": 0},
    "0132": {"coords": [ -1639.62, 382.546, -19.5393, 83.7854, -0.000188592, -0.000872123 ], "name": "telephone32" , "type": 0},
    "0133": {"coords": [ -1559.64, 170.444, -13.267, -94.9647, -6.4557805, -0.000481018  ], "name": "telephone33" , "type": 0},
    "0134": {"coords": [ -1401.46, 218.949, -24.7309, -6.15038, -0.000215896, -0.0011474 ], "name": "telephone34" , "type": 0},
    "0135": {"coords": [ -1649.35, 65.5171, -9.22408, 80.9723, -0.000414989, -0.0016934    ], "name": "telephone35" , "type": 0},
    "0136": {"coords": [ -1777.23, -78.1633, -7.52363, 79.4424, -0.000322205, -0.0012092 ], "name": "telephone36" , "type": 0},
    "0137": {"coords": [ -1421.33, -191.078, -20.3049, 176.565, -2.92705, -0.000211357 ], "name": "telephone37" , "type": 0},
    "0138": {"coords": [ 139.128, 1226.7, 62.8898, 94.5107, -0.00538098, 0.0098791   ], "name": "telephone38" , "type": 0},
    "0139": {"coords": [ -508.654, 910.64, -19.0553, -5.59972, -0.000212386, -0.00088729 ], "name": "telephone39" , "type": 0},
    "0140": {"coords": [ -646.287, 923.909, -18.8974, -178.365, -3.9636406, -3.22105  ], "name": "telephone40" , "type": 0},
    "0141": {"coords": [ -736.35, 832.901, -18.8974, 179.527, -0.000119128, -5.6053305 ], "name": "telephone41" , "type": 0},
    "0142": {"coords": [ -736.572, 831.589, -18.8975, 0.388122, 6.8329509, 6.8329509 ], "name": "telephone42" , "type": 0},
    "0143": {"coords": [ -622.085, 815.314, -18.8976, -86.5227, -0.00013981, -3.611255 ], "name": "telephone43" , "type": 0},
    "0144": {"coords": [ -733.692, 691.436, -17.3997, 90.9048, -3.7133705, -0.000268763 ], "name": "telephone44" , "type": 0},
    "0145": {"coords": [ -377.203, 794.414, -20.1251, 5.33465, -0.0035573, -0.00120587  ], "name": "telephone45" , "type": 0},
    "0146": {"coords": [ -375.991, 794.554, -20.125, 5.33465, -0.0035573, -0.00120587  ], "name": "telephone46" , "type": 0},
    "0147": {"coords": [ -405.63, 913.687, -19.9787, -4.06176, -0.000124172, -0.000454748  ], "name": "telephone47" , "type": 0},
    "0148": {"coords": [ -156.401, 770.975, -20.7329, 173.917, -2.0094805, -0.000196411  ], "name": "telephone48" , "type": 0},
    "0149": {"coords": [ -8.69882, 625.297, -19.9222, 173.917, -2.0094805, -0.000196411 ], "name": "telephone49" , "type": 0},
    "0150": {"coords": [ -31.152, 658.461, -20.1295, -98.1743, -0.00198242, -7.8152805 ], "name": "telephone50" , "type": 0},
    "0151": {"coords": [ -123.712, 553.374, -20.2039, -91.1093, -0.00485083, -0.00407885 ], "name": "telephone51" , "type": 0},
    "0152": {"coords": [ 35.4811, 563.433, -19.3028, 83.3673, -0.000200406, -0.000644639  ], "name": "telephone52" , "type": 0},
    "0153": {"coords": [ 63.689, 417.287, -13.9427, -87.7104, -1.6546605, -5.3691807  ], "name": "telephone53" , "type": 0},
    "0154": {"coords": [ -6.96027, 381.783, -13.965, 90.7155, -5.3467906, -2.970405 ], "name": "telephone54" , "type": 0},
    "0155": {"coords": [ 112.508, 847.132, -19.9111, -6.84492, -0.000203872, -0.000883382   ], "name": "telephone55" , "type": 0},
    "0156": {"coords": [ 257.676, 825.918, -20.0009, 135.379, -0.000156072, -4.6969805     ], "name": "telephone56" , "type": 0},
    "0157": {"coords": [ 612.164, 845.662, -12.6474, -176.924, -0.000484676, -0.000187349  ], "name": "telephone57" , "type": 0},
    "0158": {"coords": [ 385.573, 680.05, -24.8659, -176.924, -0.000484676, -0.000187349   ], "name": "telephone58" , "type": 0},
    "0159": {"coords": [ 285.898, 612.984, -24.5618, 96.599, -0.00359091, -0.000274649  ], "name": "telephone59" , "type": 0},
    "0160": {"coords": [ 249.988, 494.066, -20.0461, 84.0427, -0.000151281, -0.00060156  ], "name": "telephone60" , "type": 0},
    "0161": {"coords": [ 436.873, 391.079, -20.1926, 3.92567, -0.00423433, -0.00192049  ], "name": "telephone61" , "type": 0},
    "0162": {"coords": [ 332.366, 232.089, -21.5327, 3.90697, -0.000388841, -0.000108725  ], "name": "telephone62" , "type": 0},
    "0163": {"coords": [ 331.261, 232.113, -21.5326, 3.90697, -0.000388841, -0.000108725  ], "name": "telephone63" , "type": 0},
    "0164": {"coords": [ 383.84, -111.634, -6.62287, -100.353, -8.6110705, -0.000539176 ], "name": "telephone64" , "type": 0},
    "0165": {"coords": [ 618.06, 32.8517, -18.267, 3.18194, -0.000304644, -0.0041655  ], "name": "telephone65" , "type": 0},
    "0166": {"coords": [ 747.689, 8.09371, -19.4605, 176.333, -0.00251729, -0.0115145  ], "name": "telephone66" , "type": 0},
    "0167": {"coords": [ 501.048, -265.239, -20.1588, -95.6591, -0.000217806, -0.000754509], "name": "telephone67" , "type": 0},
    "0168": {"coords": [ 282.865, -388.384, -20.1361, 95.5987, -1.6827405, -0.000130739 ], "name": "telephone68" , "type": 0},
    "0169": {"coords": [ 49.5431, -456.113, -20.1363, -87.1747, -0.0028458, -0.00645735 ], "name": "telephone69" , "type": 0},
    "0170": {"coords": [ -147.182, -596.278, -20.1251, 9.62458, -0.00446399, -0.00206396  ], "name": "telephone70" , "type": 0},
    "0171": {"coords": [ -315.638, -406.486, -14.393, 83.4711, -0.000158786, -0.000888381 ], "name": "telephone71" , "type": 0},
    "0172": {"coords": [ -315.533, -407.517, -14.4267, 97.5907, -0.000623669, -9.706405 ], "name": "telephone72" , "type": 0},
    "0173": {"coords": [ -427.766, -307.104, -11.724, -175.405, -7.2995605, -2.1900405  ], "name": "telephone73" , "type": 0},
    "0174": {"coords": [ 70.6958, -275.596, -20.1476, 5.42948, -3.5889305, -4.8834606  ], "name": "telephone74" , "type": 0},
    "0175": {"coords": [ -68.0227, -199.809, -14.3818, -80.0885, -0.00407661, -0.00093181 ], "name": "telephone75" , "type": 0},
    "0176": {"coords": [ -208.872, -45.5734, -12.0168, 86.3713, -0.00253405, -0.000965307], "name": "telephone76" , "type": 0},
    "0177": {"coords": [ 29.1381, 34.0004, -12.5575, 2.15495, -6.1603305, -1.4365905  ], "name": "telephone77" , "type": 0},
    "0178": {"coords": [ 68.3486, 237.466, -15.992, 173.974, -0.000313746, -0.00129492   ], "name": "telephone78" , "type": 0},
    "0179": {"coords": [ 67.2659, 237.417, -15.992, -179.965, -3.4059105, -0.000209161  ], "name": "telephone79" , "type": 0},
    "0180": {"coords": [ -78.6257, 233.259, -14.4044, 3.00029, -0.00475142 ], "name": "telephone80" , "type": 0},
    "0181": {"coords": [ -578.752, -481.255, -20.1363, -83.0985, -2.701405, -0.000178885 ], "name": "telephone81" , "type": 0},
    "0182": {"coords": [ -191.115, 165.362, -10.5756, 5.10323, -7.3959806, -5.7294805   ], "name": "telephone82" , "type": 0},
    "0183": {"coords": [ -584.818, 89.3622, -0.215257, 5.10323, -7.3959806, -5.7294805 ], "name": "telephone83" , "type": 0},
    "0184": {"coords": [ -655.453, 236.847, 1.04329, 87.3153, -6.0867806, -3.7040705   ], "name": "telephone84" , "type": 0},
    "0185": {"coords": [ -515.393, 449.461, 0.971962, -99.7138, -0.000350587, -0.000942466 ], "name": "telephone85" , "type": 0},
    "0186": {"coords": [ -653.539, 555.477, 1.04818, 3.03228, -0.00011432, -3.8686705  ], "name": "telephone86" , "type": 0},
    "0187": {"coords": [ -373.23, 487.743, 1.05807, -96.0297, -0.00021525, -0.000788177  ], "name": "telephone87" , "type": 0},
    "0188": {"coords": [ -373.226, 488.868, 1.05805, -81.1682, -0.00527207, -0.0025182   ], "name": "telephone88" , "type": 0},
    "0189": {"coords": [ -353.69, 592.678, 1.05805, -81.4417, -0.00484542, -0.00187503 ], "name": "telephone89" , "type": 0},
    "0190": {"coords": [ -469.619, 571.17, 1.04645, 4.36937, -5.0280206, -0.000128817  ], "name": "telephone90" , "type": 0},
    "0191": {"coords": [ -470.609, 571.31, 1.04651, 4.36937, -5.0280206, -0.000128817   ], "name": "telephone91" , "type": 0},
    "0193": {"coords": [ -408.327, 631.747, -12.366, -171.142, -0.00490582, -0.00423323 ], "name": "telephone92" , "type": 0},
    "0194": {"coords": [ -264.446, 678.975, -19.9447, 81.3248, -0.000286643, -0.000887627 ], "name": "telephone93" , "type": 0},
    "0400": {"coords": [ -352.354, -726.13, -15.4204, 73.9055, 0.00375327, -0.00724118 ], "name": "telephone94" , "type": 1},
    "0401": {"coords": [ 81.3131, 892.227, -13.3205, -107.731, 0.00634916, -0.00314047  ], "name": "telephone95" , "type": 1},
    "0402": {"coords": [ 626.347, 898.406, -11.7137, -38.2921, -0.00485503, -0.00479075  ], "name": "telephone96" , "type": 1},
    "0403": {"coords": [ -49.1983, 740.698, -21.9009, -93.2169, -5.32005, -0.000280421  ], "name": "telephone97" , "type": 1},
    "0404": {"coords": [ 19.2112, -74.6966, -15.595, 2.45636, -0.00451422, 0.00426057 ], "name": "telephone98" , "type": 1},
    "0405": {"coords": [ -254.035, -82.0485, -11.458, 79.7319, 0.00132973, 0.00118945 ], "name": "telephone99" , "type": 1},
    "0406": {"coords": [ -637.16, 348.219, 1.34485, -103.618, 0.000437143, 0.00763782   ], "name": "telephone100", "type": 1},
    "0407": {"coords": [ -1386.89, 470.825, -22.1321, 83.7185, -0.00183493, 0.0013126 ], "name": "telephone101", "type": 1},
    "0408": {"coords": [ -1559.75, -163.44, -19.6113, -178.075, -0.0063798, 0.000205364], "name": "telephone102", "type": 1},
    "0409": {"coords": [ -1146.46, 1591.17, 6.25566, -14.0116, -0.00409997, 0.00225157   ], "name": "telephone103", "type": 1},
    "0410": {"coords": [ -1301.75, 996.284, -17.3339, -14.0116, -0.00409997, 0.00225157 ], "name": "telephone104", "type": 1},
    "0411": {"coords": [ -651.048, 942.162, -7.93587, -99.2543, -0.00176639, -0.00120326 ], "name": "telephone105", "type": 1},
    "0412": {"coords": [ 374.248, -290.936, -15.5849, 174.082, -0.000505374, -0.000841301 ], "name": "telephone106", "type": 1},
    "0413": {"coords": [ -161.972, -588.33, -16.1199, -25.6465, 0.00154526, -0.00127798 ], "name": "telephone107", "type": 1},
    "0414": {"coords": [ 140.705, -427.998, -19.429, 165.959, -0.000389573, -0.00380836   ], "name": "telephone108", "type": 1},
    "0415": {"coords": [ -1590.33, 175.591, -12.4393, 79.173, 0.000844772, -0.00443575  ], "name": "telephone109", "type": 1},
    "0416": {"coords": [ -1584.26, 1605.49, -5.22507, 173.351, -0.00223529, 0.00130518  ], "name": "telephone110", "type": 1},
    "0417": {"coords": [ -645.33, 1293.94, 3.94464, 44.1121, -0.00310592, -0.00136321   ], "name": "telephone111", "type": 1},
    "0418": {"coords": [ -1422.12, 959.445, -12.7543, 83.6782, -0.00252772, -0.00090226 ], "name": "telephone112", "type": 1},
    "0419": {"coords": [ -562.84, 427.163, 1.02075, 143.54, -0.000810023, 0.00330452  ], "name": "telephone113", "type": 1},
    "0420": {"coords": [ 241.65, 710.361, -24.0321, -35.404, -0.00500102, -0.000859338    ], "name": "telephone114", "type": 1},
    "0421": {"coords": [ -773.044, -375.432, -20.4072, -139.671, 0.0015423, 0.00116826], "name": "telephone115", "type": 1},
    "0422": {"coords": [ -375.396, -449.846, -17.2661, -92.9832, -4.3735805, -0.000155459 ], "name": "telephone116", "type": 1},
    "0423": {"coords": [ -1294.27, 1705.11, 10.5592, -85.5316, -0.00200118, -0.00170338     ], "name": "telephone117", "type": 1},
    "0424": {"coords": [ -1423.97, 1298.05, -13.7194, -176.364, -0.000279942, -0.00408395   ], "name": "telephone118", "type": 1},
    "0425": {"coords": [ -625.72, 290.539, -0.267078, -92.669, -0.000449852, -0.000847793   ], "name": "telephone119", "type": 1},
    "0426": {"coords": [ -517.044, 873.339, -19.3223, -179.468, -0.000734806, -0.000101315   ], "name": "telephone120", "type": 1},
    "0427": {"coords": [ 430.723, 304.336, -20.1786, -175.948, -0.000111615, -0.000378541    ], "name": "telephone121", "type": 1},
    "0428": {"coords": [ -40.4175, 388.421, -13.9963, -95.336, -0.000228632, -0.000505461  ], "name": "telephone122", "type": 1},
    "0429": {"coords": [ 346.038, 39.9402, -24.1478, -84.7777, -0.00254404, -0.00242217   ], "name": "telephone123", "type": 1},
    "0430": {"coords": [ 414.008, -291.618, -20.1622, -99.5841, -0.0004598, -0.00139493  ], "name": "telephone124", "type": 1},
    "0431": {"coords": [ -4.11028, 559.525, -19.4067, -99.0386, -0.000673177, -0.0016384    ], "name": "telephone125", "type": 1},
    "0432": {"coords": [ 273.336, 774.424, -21.2439, -98.1703, -0.000778018, -0.00185254    ], "name": "telephone126", "type": 1},
    "0433": {"coords": [ -1376.16, 387.671, -23.7368, -179.563, -1.5034805, -5.4976405  ], "name": "telephone127", "type": 1},
    "0434": {"coords": [ -1531.69, 2.18275, -17.8468, -94.133, -0.00077657, -0.00162397  ], "name": "telephone128", "type": 1},
    "0435": {"coords": [ -1394.58, -34.1276, -17.8468, -4.38079, -0.00264083, 0.000201127  ], "name": "telephone129", "type": 1},
    "0436": {"coords": [ -1183.23, 1707.67, 11.0941, 175.956, -0.000903076, -0.00012567    ], "name": "telephone130", "type": 1},
    "0437": {"coords": [ -288.226, 1629.02, -23.0758, 167.172, -0.000735066, -0.00166823   ], "name": "telephone131", "type": 1},
    "0438": {"coords": [ 272.455, -454.55, -20.1636, 86.7596, -0.000304201, -0.000790352  ], "name": "telephone132", "type": 1},
    "0439": {"coords": [ 281.13, -118.42, -12.2741, -93.1049, -0.00137806, -0.000297773   ], "name": "telephone133", "type": 1},
    "0440": {"coords": [ -569.112, 310.325, 0.16808, 76.7262, -0.000658948, -0.00140114    ], "name": "telephone134", "type": 1},
    "0441": {"coords": [ -323.521, -587.756, -20.1043, 176.606, -0.000187083, -0.00324814 ], "name": "telephone135", "type": 1},
    "0442": {"coords": [ 69.4548, 139.945, -14.4583, -94.5282, -0.000337092, -2.8533705   ], "name": "telephone136", "type": 1},
    "0443": {"coords": [ -11.9297, 739.254, -22.0582, 88.1204, -3.3985406, -1.448205  ], "name": "telephone137", "type": 1},
    "0444": {"coords": [ 404.918, 602.374, -24.9746, -1.94366, 0.00252814, -0.00367209   ], "name": "telephone138", "type": 1},
    "0445": {"coords": [ -711.278, 1758.3, -14.9923, 6.64535, -0.000619965, -0.00170124  ], "name": "telephone139", "type": 1},
    "0446": {"coords": [ -1587.76, 941.364, -5.18969, -74.7749, 0.000854803, -0.00167265   ], "name": "telephone140", "type": 1},
    "0447": {"coords": [ -1684.18, -230.77, -20.3134, 97.8142, 0.000490091, 0.00385055 ], "name": "telephone141", "type": 1},
    "0448": {"coords": [ 339.769, 879.563, -21.2876, -168.179, 0.0037049, -0.00426408   ], "name": "telephone142", "type": 1},
    "0449": {"coords": [ -151.061, 605.983, -20.17, 12.5243, -3.1642605, -0.000277288  ], "name": "telephone143", "type": 1},
    "0450": {"coords": [ 543.736, 3.52588, -18.2273, 103.158, -9.3941605, -0.000554004    ], "name": "telephone144", "type": 1},
    "0451": {"coords": [ 107.751, 182.34, -20.0169, 107.077, -0.000439097, -0.000186336   ], "name": "telephone145", "type": 1},
    "0452": {"coords": [ -629.252, -44.3483, 0.942982, -163.888, -0.000373157, -0.000170487], "name": "telephone146", "type": 1},
    "0453": {"coords": [ -1304.76, 1608.74, 1.22659, 0.736924, -8.3402305, -0.0004075  ], "name": "telephone147", "type":  1},
};

function getPhoneObj(number) {
    return number in phoneObjs ? phoneObjs[number] : null;
}

function getPlayerPhoneObj(playerid) {
    foreach (key, value in phoneObjs) {
        if (isPlayerInValidPoint3D(playerid, value.coords[0], value.coords[1], value.coords[2], 0.4)) {
            return value;
            break;
        }
    }
}

function findNearestPhoneObj(playerid) {
    local pos = getPlayerPositionObj(playerid);
    local dis = 2000;
    local obj = null;
    foreach (key, value in telephones) {
        local distance = getDistanceBetweenPoints2D(pos.x, pos.y, value.coords[0], value.coords[1]);
        if (distance < dis && value.type == PHONE_TYPE_BOOTH) {
           dis = distance;
           obj = value;
        }
    }
    return obj;
}

function goToPhone(playerid, number) {
    local phObj = getPhoneObj(number);
    setPlayerPosition(playerid, phObj.coords[0], phObj.coords[1], phObj.coords[2]);
}

event("onServerStarted", function() {
    logStr("[jobs] loading telephone services job and telephone system...");
    foreach (key, phone in phoneObjs) {
        phone.number <- key;
        phone.isCalling <- false;
        phone.isRinging <- false;
    }
});

event("onPlayerConnect", function(playerid){
    phone_nearest_blip[playerid] <- {};
    phone_nearest_blip[playerid].blip3dtext <- null;
});

event("onServerPlayerStarted", function( playerid ){
    foreach (key, phObj in phoneObjs) {
        createPrivate3DText(playerid, phObj.coords[0], phObj.coords[1], phObj.coords[2]+0.35, plocalize(playerid, "TELEPHONE", [key]), CL_RIPELEMON, 2.0);
        createPrivate3DText(playerid, phObj.coords[0], phObj.coords[1], phObj.coords[2]+0.20, plocalize(playerid, "3dtext.job.press.Q"), CL_WHITE.applyAlpha(150), 0.4);
    }
});


function showBlipNearestPhoneForPlayer(playerid) {
    if (phone_nearest_blip[playerid].blip3dtext) {
        return msg(playerid, "telephone.findalready");
    }

    local phObj = findNearestPhoneObj(playerid);
    local phonehash = createPrivateBlip(playerid, phObj.coords[0], phObj.coords[1], ICON_RED, 1000.0);
    phone_nearest_blip[playerid].blip3dtext = true;
    msg(playerid, "telephone.findphone");
    delayedFunction(20000, function() {
        removeBlip(phonehash);
        phone_nearest_blip[playerid].blip3dtext = null;
    });
}

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


function animatePhonePickUp(playerid) {
    local phoneObj = getPlayerPhoneObj(playerid);
    local type = phoneObj.type == PHONE_TYPE_BUSSINESS;
    local animation1 = type ? "Phone.PickUp": "PhoneBooth.PickUp";
    local animation2 = type ? "Phone.Static" : "PhoneBooth.Static";
    local model = type ? 118 : 1;
    animateGlobal(playerid, {"animation": animation1, "unblock": false, "model": model}, 2000);
    local coords = phoneObj.coords;
    setPlayerPosition(playerid, coords[0], coords[1], coords[2]);
    setPlayerRotation(playerid, coords[5], coords[4], coords[3]);
    delayedFunction(2000, function() {
        animateGlobal(playerid, {"animation": animation2, "endless": true, "block": false, "model": model});
    });
}

function animatePhonePut(playerid) {
    clearAnimPlace(playerid);
    local phoneObj = getPlayerPhoneObj(playerid);
    local type = phoneObj.type == PHONE_TYPE_BUSSINESS;
    local animation = type ? "Phone.Put": "PhoneBooth.Put";
    local model = type ? 118 : 1;
    animateGlobal(playerid, {"animation": animation, "model": model}, 1)
    delayedFunction(50, function() {
        if(!isPlayerConnected(playerid)) return;
        animateGlobal(playerid, {"animation": animation, "model": model}, 1000)
    });
}


function callByPhone(playerid, number = null) {
    local number = str_replace("555-", "", number);
    local phoneObj = getPlayerPhoneObj(playerid);

    if (phoneObj == false) {
        return;
    }

    if (phoneObj.type == PHONE_TYPE_BOOTH) {
        if(!canMoneyBeSubstracted(playerid, PHONE_CALL_PRICE)) {
            trigger("onPlayerPhonePut", playerid);
            return msg(playerid, "telephone.notenoughmoney");
        }
        subPlayerMoney(playerid, PHONE_CALL_PRICE);
        addWorldMoney(PHONE_CALL_PRICE);
    }

    if (phoneObj.number == number) {
        msg(playerid, "telephone.callyourself", CL_WARNING);
        trigger("onPlayerPhonePut", playerid);
        return;
    }

    // TODO
    if(number == "taxi" || number == "police" || number == "dispatch" || number == "towtruck" ) {
        return trigger("onPlayerPhoneCallNPC", playerid, number, plocalize(playerid, phoneObj.name));
    }

    if(!isNumeric(number) || number.len() != 4) {
        msg(playerid, "telephone.incorrect");
        return trigger("onPlayerPhonePut", playerid);
    }

    msg(playerid, "telephone.youcalling", ["555-"+number]);

    local isNumberExist = getPhoneObj(number);
    local eventName = number in numbers ? "onPlayerPhoneCallNPC" : isNumberExist ? "onPlayerPhoneCall" : null;

    if (!eventName) {
        msg(playerid, "telephone.notregister");
        trigger("onPlayerPhonePut", playerid);
        return;
    }

    trigger(eventName, playerid, number, phoneObj);
}

event("PhoneCallGUI", callByPhone);

event("onPlayerPhoneCall", function(playerid, number, phoneObj) {
    local targetPhoneObj = getPhoneObj(number);
    local charId = getCharacterIdFromPlayerId(playerid);

    if (targetPhoneObj.isRinging || targetPhoneObj.isCalling) {
        trigger("onPlayerPhonePut", playerid);
        return msg(playerid, "telephone.lineinuse", CL_WARNING);
    }

    targetPhoneObj.isRinging = true;

    addPhoneNode(charId, phoneObj.number, number);

    local coords = targetPhoneObj.coords;
    createPlace(format("phone_%s", number), coords[0] + 10, coords[1] + 10, coords[0] - 10, coords[1] - 10);

    delayedFunction(15000, function() {
        if (targetPhoneObj.isRinging) {
            stopRinging(targetPhoneObj);
            trigger("onPlayerPhonePut", playerid);
            msg(playerid, "telephone.noanswer", CL_WARNING);
        }
    });
});

event("onPlayerPhonePickUp", function(playerid, phoneObj) {
    animatePhonePickUp(playerid);
    phoneObj.isCalling = true;

    local node = findPhoneNodeBy({"to": phoneObj.number});

    // Есть входящий звонок, отвечаем
    if(node) {
        local charId = getCharacterIdFromPlayerId(playerid);
        msg(playerid, "telephone.callstart", CL_SUCCESS);
        msg(getPlayerIdFromCharacterId(node.subscribers[0]), "telephone.callstart", CL_SUCCESS);
        phoneNodeAddSubscriber(node.hash, charId);
        stopRinging(phoneObj);
        return;
    }

    // Показать окно
    delayedFunction(2500, function() {
        showPhoneGUI(playerid);
    });
});

event("onPlayerPhonePut", function(playerid) {
    local phoneObj = getPlayerPhoneObj(playerid);

    phoneObj.isCalling = false;

    animatePhonePut(playerid);

    local node = findPhoneNodeBy({"from": phoneObj.number});
    if(!node) return;

    local targetPhoneObj = getPhoneObj(node.to);
    if(targetPhoneObj && targetPhoneObj.isRinging) stopRinging(targetPhoneObj);

    deletePhoneNode(node.hash)
});


function stopRinging(phoneObj) {
    phoneObj.isRinging = false;
    local coords = phoneObj.coords;
    foreach (idx, value in players) {
        if (isInArea(format("phone_%s", phoneObj.number), value.x, value.y)){
            if (phoneObj.type == PHONE_TYPE_BUSSINESS){
                triggerClientEvent(idx, "ringPhoneStatic", false, coords[0], coords[1], coords[2]);
            } else {
                triggerClientEvent(idx, "ringPhone", false);
            }
        }
    }
    removeArea(format("phone_%s", phoneObj.number));
}

event("onPlayerAreaEnter", function(playerid, name) {
    local data = split(name, "_");
    if (data[0] == "phone") {
        local phoneObj = getPhoneObj(data[1]);
        if(phoneObj.isRinging) {
            if (phoneObj.type == PHONE_TYPE_BUSSINESS){
                local coords = phoneObj.coords;
                triggerClientEvent(playerid, "ringPhoneStatic", true, coords[0], coords[1], coords[2]);
            } else {
                triggerClientEvent(playerid, "ringPhone", true);
            }
        }
    }
});

event("onPlayerAreaLeave", function(playerid, name) {
    local data = split(name, "_");
    if (data[0] == "phone") {
        local phoneObj = getPhoneObj(data[1]);
        if(phoneObj.isRinging) {
            if (phoneObj.type == PHONE_TYPE_BUSSINESS){
                local coords = phoneObj.coords;
                triggerClientEvent(playerid, "ringPhoneStatic", false, coords[0], coords[1], coords[2]);
            } else {
                triggerClientEvent(playerid, "ringPhone", false);
            }
        }
    }
});

event("onPlayerDisconnect", function(playerid, reason) {
    stopCall(playerid);
});

event("onPlayerDeath", function(playerid) {
    stopCall(playerid);
});



function stopCall(playerid) {
    local charId = getCharacterIdFromPlayerId(playerid);

    trigger("onPlayerPhonePut", playerid);

    local node = findPhoneNodeBy({"subscribers": charId});

    if(!node) return;

    msg(playerid, "telephone.callend", CL_WARNING);

    local companionCharId = getPhoneNodeCompanion(node, charId);
    if(companionCharId) {
        local companionPlayerId = getPlayerIdFromCharacterId(companionCharId);
        if(companionPlayerId == -1 || !isPlayerConnected(companionPlayerId)) return;
        msg(companionPlayerId, "telephone.callend", CL_WARNING);
        trigger("onPlayerPhonePut", companionPlayerId);
    }
}

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

    local ets1 = createVehicle(31, -1066.02, 1483.81, -3.79657, -90.8055, -1.36482, -0.105954);   // telephoneCAR1
    local ets2 = createVehicle(31, -1076.38, 1483.81, -3.51025, -89.5915, -1.332, -0.0857111);   // telephoneCAR2
    setVehicleColor(ets1, 102, 70, 18, 63, 36, 7);
    setVehicleColor(ets2, 102, 70, 18, 63, 36, 7);
    setVehiclePlateText(ets1, "ETS-01");
    setVehiclePlateText(ets2, "ETS-02");
*/
