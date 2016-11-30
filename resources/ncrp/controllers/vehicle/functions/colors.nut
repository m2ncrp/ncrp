local defaults = [
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

/**
 * Set random colors for the vehice
 *
 * @param {Integer} vehicleid
 * @return {Boolean} result
 */
function setRandomVehicleColors(vehicleid) {
    local size = random(0, 2);
    local colorA = defaults[random(0, defaults.len() - 1)];
    local colorB = colorA;
    if (size == 0) {
        colorB = defaults[random(0, defaults.len() - 1)];
    }
    return setVehicleColorEx(vehicleid, colorA, colorB);
}
