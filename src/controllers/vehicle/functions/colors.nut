local gamecolors = [
    rgb( 000 , 000 , 000 ),  // blackskc
    rgb( 154 , 154 , 154 ),    //White
    rgb( 143 , 137 , 124 ),    //Beige
    rgb( 112 , 104 , 89 ), //Beige
    rgb( 79  , 72  , 65 ), //Brown
    rgb( 120 , 111 , 68 ), //Yellow
    rgb( 157 , 143 , 110 ),    //Beige
    rgb( 145 , 114 , 33 ), //Yellow
    rgb( 121 , 113 , 31 ), //Yellow
    rgb( 98  , 26  , 21 ), //Red
    rgb( 66  , 0   , 0 ),  //Red
    rgb( 97  , 46  , 10 ), //Orange
    rgb( 29  , 4   , 0 ),  //Brown
    rgb( 70  , 128 , 95 ), //Green
    rgb( 27  , 76  , 65 ), //Green
    rgb( 57  , 84  , 37 ), //Green
    rgb( 15  , 32  , 24 ), //Green
    rgb( 80  , 80  , 80 ), //Gray
    rgb( 83  , 104 , 80 ), //Green
    rgb( 73  , 75  , 33 ), //Green
    rgb( 1   , 17  , 13 ), //Green
    rgb( 47  , 95  , 106 ),    //Blue
    rgb( 71  , 91  , 91 ), //Blue
    rgb( 20  , 33  , 39 ), //Blue
    rgb( 4   , 15  , 20 ), //Blue
    rgb( 132 , 90  , 103 ),    //Pink
    rgb( 90  , 28  , 38 ), //Red
    rgb( 97  , 35  , 58 ), //Violet
    rgb( 4   , 4   , 4 ),  //Black
    rgb( 102 , 70  , 18 ), //Orange
    rgb( 74  , 43  , 8 ),  //Orange
    rgb( 57  , 49  , 29 ), //Brown
    rgb( 35  , 22  , 8 ),  //Brown
    rgb( 132 , 112 , 78 ), //Orange
    rgb( 125 , 0   , 0 ),  //Red
    rgb( 74  , 43  , 34 ), //Red
    rgb( 51  , 22  , 8 ),  //Red
    rgb( 78  , 132 , 129 ),    //Blue
    rgb( 17  , 1   , 14 ), //Violet
    rgb( 2   , 5   , 19 ), //Blue
    rgb( 18  , 44  , 69 ), //Blue
];

local gamepaints = [
    { paints = ["2020", "2304", "2802", "2810", "2812", "2822", "2803", "0323", "0220", "2002", "1002", "0310", "2240", "0140"], title = "Shubert_PickUp" },
    { paints = ["0204", "1820", "1616", "1818", "2323", "0228", "1212", "3128", "0203", "2228", "0336", "0000", "0000", "0000"], title = "Smith_V8" },
    { paints = ["2322", "2020", "1616", "0417", "2222", "2018", "0302", "1212", "1202", "3603", "1010", "0000", "0000", "0000"], title = "Ulver_NewYorker" },
    { paints = ["1202", "2018", "0909", "1818", "0303", "1212", "4022", "2222", "2828", "1801", "0336", "0000", "0000", "0000"], title = "Walter_Coupe" },
    { paints = ["0002", "0008", "0012", "0016", "0022", "0031", "0023", "0010", "0028", "0039", "0000", "0000", "0000", "0000"], title = "Jefferson_provincial" },
    { paints = ["0102", "0412", "0201", "3131", "1028", "2323", "2328", "2828", "0312", "0122", "1204", "0220", "2201", "1703"], title = "Shubert_38" },
    { paints = ["4040", "1010", "2308", "0122", "2223", "1801", "1616", "0303", "3105", "0000", "0000", "0000", "0000", "0000"], title = "Shubert_Panel" },
    { paints = ["1618", "0222", "0212", "2020", "0202", "2828", "0423", "1010", "3939", "0000", "0000", "0000", "0000", "0000"], title = "Lassiter_69" },
    { paints = ["1802", "2317", "1004", "2222", "1316", "1616", "2123", "2014", "2424", "0402", "0000", "0000", "0000", "0000"], title = "Potomac_Indian" },
    { paints = ["0009", "0002", "0017", "0012", "0002", "0039", "0026", "0022", "0028", "0018", "0000", "0000", "0000", "0000"], title = "Berkley_Kingfisher_pha" },
    { paints = ["0004", "0012", "0016", "0020", "0022", "0023", "0040", "0000", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Smith_Wagon_pha" },
    { paints = ["2822", "2814", "2811", "2840", "2830", "2810", "2838", "2802", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Hot_Rod_1" },
    { paints = ["2403", "2133", "3310", "2828", "0808", "2121", "1008", "4021", "1205", "0000", "0000", "0000", "0000", "0000"], title = "Hot_Rod_2" },
    { paints = ["0010", "0002", "0012", "0014", "0016", "0022", "0024", "0000", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Smith_Mainline_pha" },
    { paints = ["0008", "0002", "0026", "0009", "0016", "0022", "0010", "0039", "0024", "0000", "0000", "0000", "0000", "0000"], title = "Shubert_Frigate_pha" },
    { paints = ["0219", "0233", "3533", "2223", "1815", "0118", "0122", "0109", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Smith_200_pha" },
    { paints = ["1212", "2020", "0202", "0214", "2424", "0233", "0635", "0110", "1316", "2101", "1401", "2701", "2828", "4040"], title = "Quicksilver_Windsor_pha" },
    { paints = ["0003", "0012", "0028", "0016", "0031", "0023", "0024", "0039", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Lassiter_75_pha" },
    { paints = ["0212", "0229", "1616", "0230", "2317", "2422", "0404", "0909", "0205", "0122", "3939", "0000", "0000", "0000"], title = "Ascot_BaileyS200_pha" },
    { paints = ["2123", "1613", "0218", "0117", "2201", "1401", "0203", "0112", "2811", "3033", "0108", "0135", "0000", "0000"], title = "Houston_Wasp_pha" },
    { paints = ["0109", "0412", "4001", "2501", "3330", "1701", "0121", "3724", "2004", "2322", "1901", "1201", "2809", "3301"], title = "Shubert_Beverly" },
    { paints = ["0004", "0017", "0012", "0022", "0016", "0028", "0010", "0031", "0040", "0038", "0039", "0000", "0000", "0000"], title = "Walker_Rocket" },
    { paints = ["0023", "0004", "0016", "0017", "0022", "0002", "0010", "0008", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Jefferson_Futura_pha" },
    { paints = ["0214", "0221", "2738", "0909", "2725", "0233", "3004", "0103", "2824", "0417", "0435", "0141", "0000", "0000"], title = "Smith_Stingray_pha" },
    { paints = ["0024", "0017", "0018", "0014", "0010", "0007", "0004", "0002", "0038", "0022", "0000", "0000", "0000", "0000"], title = "ISW_508" },
    { paints = ["1720", "1217", "2224", "0402", "0212", "0121", "0808", "3604", "2811", "0909", "2828", "0000", "0000", "0000"], title = "Delizia_Grandeamerica" },
    { paints = ["2323", "1919", "1614", "0203", "2222", "1414", "0404", "2812", "1210", "2819", "0000", "0000", "0000", "0000"], title = "Jeep_civil" },
    { paints = ["0004", "0039", "0029", "0001", "0002", "0017", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Shubert_Hearse" },
    { paints = ["2829", "1206", "2811", "4033", "2422", "2836", "2820", "1618", "2805", "0000", "0000", "0000", "0000", "0000"], title = "Smith_Truck" },
    { paints = ["0808", "2421", "1107", "4028", "3307", "0902", "1028", "0740", "2813", "2527", "0000", "0000", "0000", "0000"], title = "Hot_Rod_3" },
    { paints = ["1010", "2811", "2803", "1614", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Smith_coupe" },
    { paints = ["2020", "2304", "2802", "2810", "2812", "2822", "2833", "3324", "0220", "2002", "1002", "3310", "2140", "0140"], title = "Shubert_34" },
    { paints = ["4040", "0901", "1401", "0122", "3607", "1801", "1133", "1633", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Milk_Truck" },
    { paints = ["0128", "2839", "3812", "2817", "0210", "0601", "0928", "0102", "1239", "0000", "0000", "0000", "0000", "0000"], title = "Trautenberg_Grande" },
    { paints = ["0024", "0006", "0010", "0004", "0012", "0023", "0017", "0000", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Shubert_Pharaon" },
    { paints = ["0310", "2810", "2812", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Shubert_Truck_CC" },
    { paints = ["0311", "1723", "0432", "0519", "2240", "0317", "3306", "0340", "2440", "0122", "0000", "0000", "0000", "0000"], title = "Shubert_Truck_CT" },
    { paints = ["0311", "1723", "0432", "2240", "2440", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Shubert_Truck_CT_cigar" },
    { paints = ["0320", "1716", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Shubert_Truck_SG" },
    { paints = ["0308", "2811", "4040", "4039", "2322", "2214", "0121", "1717", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Shubert_Truck_SP" },
    { paints = ["0017", "0039", "0028", "0022", "0014", "0011", "0040", "0030", "0010", "0038", "0002", "0004", "0017", "0012"], title = "Roller" },
    { paints = ["0022", "0014", "0011", "0040", "0030", "0010", "0028", "0038", "0002", "0004", "0017", "0012", "0016", "0039"], title = "Elysium" },
    { paints = ["1740", "0311", "4040", "0339", "2322", "0340", "0332", "0436", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Shubert_Truck_QD" },
    { paints = ["0423", "0412", "2240", "2020", "1212", "2323", "1023", "1001", "1010", "0707", "0000", "0000", "0000", "0000"], title = "Hank_B" },
    { paints = ["0115", "0119", "2612", "0223", "0284", "0504", "0710", "2802", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Chaffeque" },
    { paints = ["0040", "0008", "0007", "0039", "0035", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Waybar" },
    { paints = ["2308", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000", "0000"], title = "Shubert_Panel_m14" },
];

local registry = {};

event("onScriptInit", function() {
    foreach (idx, obj in gamepaints) {
        local modelid = getVehicleModelIdFromName(obj.title);

        if (modelid == -1) continue;
        registry[modelid] <- [];

        foreach (id, value in obj.paints) {
            if (value == "0000") continue;

            local temp = value;

            local color1 = (temp[0].tochar() + "" + temp[1].tochar()).tointeger();
            local color2 = (temp[2].tochar() + "" + temp[3].tochar()).tointeger();

            if (color1 == 0) color1 = color2;

            if (color1 in gamecolors && color2 in gamecolors) {
                registry[modelid].push({ a = gamecolors[color1], b = gamecolors[color2] });
            }
        }
    }
});

// aliases
setVehicleColor <- setVehicleColour;
getVehicleColor <- getVehicleColour;

/**
 * Set vehicle color via color object
 * CL_**** or via rgb table
 *
 * @param {Integer} vehiceid
 * @param {Color} colorA
 * @param {Color} colorB
 * @return {Boolean} result
 */
function setVehicleColorEx(vehiceid, colorA, colorB) {
    return setVehicleColor(vehiceid, colorA.r, colorA.g, colorA.b, colorB.r, colorB.g, colorB.b);
}

/**
 * Get vehicle color into color object
 * CL_**** or via rgb table
 *
 * @param  {Integer} vehiceid
 * @return {Array}
 */
function getVehicleColourEx(vehiceid) {
    local colors = getVehicleColour(vehiceid);
    return [
        rgb(colors[0], colors[1], colors[2]),
        rgb(colors[3], colors[4], colors[5]),
    ];
}

// /**
//  * Set random colors for the vehice
//  *
//  * @param {Integer} vehicleid
//  * @return {Boolean} result
//  */
function setRandomVehicleColors(vehicleid) {
    // local size = random(0, 2);
    // local colorA = defaults[random(0, defaults.len() - 1)];
    // local colorB = colorA;
    // if (size == 0) {
    //     colorB = defaults[random(0, defaults.len() - 1)];
    // }
    // return setVehicleColorEx(vehicleid, colorA, colorB);

    local modelid = getVehicleModel(vehicleid);

    if (modelid in registry) {
        local color = registry[modelid][random(0, registry[modelid].len() - 1)];
        return setVehicleColorEx(vehicleid, color.b, color.a);
    }

    return false;
}

acmd("vcr", function(playerid) {
    if (!isPlayerInVehicle(playerid)) return;
    setRandomVehicleColors(getPlayerVehicle(playerid));
})

function resetUnownedVehicles() {
    foreach (idx, value in __vehicles) {
        if (getVehicleOwner(idx) == "__cityNCRP") {
            setRandomVehicleColors(idx);
            if (value.entity) value.entity.save();
        }
    }
}
