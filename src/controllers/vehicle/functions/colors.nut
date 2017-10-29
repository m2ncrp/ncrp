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
    { paints = ["20|20", "23|04", "28|02", "28|10", "28|12", "28|22", "28|03", "03|23", "02|20", "20|02", "10|02", "03|10", "22|40", "01|40"], title = "Shubert_PickUp"          },
    { paints = ["02|04", "18|20", "16|16", "18|18", "23|23", "02|28", "12|12", "31|28", "02|03", "22|28", "03|36", "00|00", "00|00", "00|00"], title = "Smith_V8"                },
    { paints = ["23|22", "20|20", "16|16", "04|17", "22|22", "20|18", "03|02", "12|12", "12|02", "36|03", "10|10", "00|00", "00|00", "00|00"], title = "Ulver_NewYorker"         },
    { paints = ["12|02", "20|18", "09|09", "18|18", "03|03", "12|12", "40|22", "22|22", "28|28", "18|01", "03|36", "00|00", "00|00", "00|00"], title = "Walter_Coupe"            },
    { paints = ["00|02", "00|08", "00|12", "00|16", "00|22", "00|31", "00|23", "00|10", "00|28", "00|39", "00|00", "00|00", "00|00", "00|00"], title = "Jefferson_provincial"    },
    { paints = ["01|02", "04|12", "02|01", "31|31", "10|28", "23|23", "23|28", "28|28", "03|12", "01|22", "12|04", "02|20", "22|01", "17|03"], title = "Shubert_38"              },
    { paints = ["40|40", "10|10", "23|08", "01|22", "22|23", "18|01", "16|16", "03|03", "31|05", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Shubert_Panel"           },
    { paints = ["16|18", "02|22", "02|12", "20|20", "02|02", "28|28", "04|23", "10|10", "39|39", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Lassiter_69"             },
    { paints = ["18|02", "23|17", "10|04", "22|22", "13|16", "16|16", "21|23", "20|14", "24|24", "04|02", "00|00", "00|00", "00|00", "00|00"], title = "Potomac_Indian"          },
    { paints = ["00|09", "00|02", "00|17", "00|12", "00|02", "00|39", "00|26", "00|22", "00|28", "00|18", "00|00", "00|00", "00|00", "00|00"], title = "Berkley_Kingfisher_pha"  },
    { paints = ["00|04", "00|12", "00|16", "00|20", "00|22", "00|23", "00|40", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Smith_Wagon_pha"         },
    { paints = ["28|22", "28|14", "28|11", "28|40", "28|30", "28|10", "28|38", "28|02", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Hot_Rod_1"               },
    { paints = ["24|03", "21|33", "33|10", "28|28", "08|08", "21|21", "10|08", "40|21", "12|05", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Hot_Rod_2"               },
    { paints = ["00|10", "00|02", "00|12", "00|14", "00|16", "00|22", "00|24", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Smith_Mainline_pha"      },
    { paints = ["00|08", "00|02", "00|26", "00|09", "00|16", "00|22", "00|10", "00|39", "00|24", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Shubert_Frigate_pha"     },
    { paints = ["02|19", "02|33", "35|33", "22|23", "18|15", "01|18", "01|22", "01|09", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Smith_200_pha"           },
    { paints = ["12|12", "20|20", "02|02", "02|14", "24|24", "02|33", "06|35", "01|10", "13|16", "21|01", "14|01", "27|01", "28|28", "40|40"], title = "Quicksilver_Windsor_pha" },
    { paints = ["00|03", "00|12", "00|28", "00|16", "00|31", "00|23", "00|24", "00|39", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Lassiter_75_pha"         },
    { paints = ["02|12", "02|29", "16|16", "02|30", "23|17", "24|22", "04|04", "09|09", "02|05", "01|22", "39|39", "00|00", "00|00", "00|00"], title = "Ascot_BaileyS200_pha"    },
    { paints = ["21|23", "16|13", "02|18", "01|17", "22|01", "14|01", "02|03", "01|12", "28|11", "30|33", "01|08", "01|35", "00|00", "00|00"], title = "Houston_Wasp_pha"        },
    { paints = ["01|09", "04|12", "40|01", "25|01", "33|30", "17|01", "01|21", "37|24", "20|04", "23|22", "19|01", "12|01", "28|09", "33|01"], title = "Shubert_Beverly"         },
    { paints = ["00|04", "00|17", "00|12", "00|22", "00|16", "00|28", "00|10", "00|31", "00|40", "00|38", "00|39", "00|00", "00|00", "00|00"], title = "Walker_Rocket"           },
    { paints = ["00|23", "00|04", "00|16", "00|17", "00|22", "00|02", "00|10", "00|08", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Jefferson_Futura_pha"    },
    { paints = ["02|14", "02|21", "27|38", "09|09", "27|25", "02|33", "30|04", "01|03", "28|24", "04|17", "04|35", "01|41", "00|00", "00|00"], title = "Smith_Stingray_pha"      },
    { paints = ["00|24", "00|17", "00|18", "00|14", "00|10", "00|07", "00|04", "00|02", "00|38", "00|22", "00|00", "00|00", "00|00", "00|00"], title = "ISW_508"                 },
    { paints = ["17|20", "12|17", "22|24", "04|02", "02|12", "01|21", "08|08", "36|04", "28|11", "09|09", "28|28", "00|00", "00|00", "00|00"], title = "Delizia_Grandeamerica"   },
    { paints = ["23|23", "19|19", "16|14", "02|03", "22|22", "14|14", "04|04", "28|12", "12|10", "28|19", "00|00", "00|00", "00|00", "00|00"], title = "Jeep_civil"              },
    { paints = ["00|04", "00|39", "00|29", "00|01", "00|02", "00|17", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Shubert_Hearse"          },
    { paints = ["28|29", "12|06", "28|11", "40|33", "24|22", "28|36", "28|20", "16|18", "28|05", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Smith_Truck"             },
    { paints = ["08|08", "24|21", "11|07", "40|28", "33|07", "09|02", "10|28", "07|40", "28|13", "25|27", "00|00", "00|00", "00|00", "00|00"], title = "Hot_Rod_3"               },
    { paints = ["10|10", "28|11", "28|03", "16|14", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Smith_coupe"             },
    { paints = ["20|20", "23|04", "28|02", "28|10", "28|12", "28|22", "28|33", "33|24", "02|20", "20|02", "10|02", "33|10", "21|40", "01|40"], title = "Shubert_34"              },
    { paints = ["40|40", "09|01", "14|01", "01|22", "36|07", "18|01", "11|33", "16|33", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Milk_Truck"              },
    { paints = ["01|28", "28|39", "38|12", "28|17", "02|10", "06|01", "09|28", "01|02", "12|39", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Trautenberg_Grande"      },
    { paints = ["00|24", "00|06", "00|10", "00|04", "00|12", "00|23", "00|17", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Shubert_Pharaon"         },
    { paints = ["03|10", "28|10", "28|12", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Shubert_Truck_CC"        },
    { paints = ["03|11", "17|23", "04|32", "05|19", "22|40", "03|17", "33|06", "03|40", "24|40", "01|22", "00|00", "00|00", "00|00", "00|00"], title = "Shubert_Truck_CT"        },
    { paints = ["03|11", "17|23", "04|32", "22|40", "24|40", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Shubert_Truck_CT_cigar"  },
    { paints = ["03|20", "17|16", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Shubert_Truck_SG"        },
    { paints = ["03|08", "28|11", "40|40", "40|39", "23|22", "22|14", "01|21", "17|17", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Shubert_Truck_SP"        },
    { paints = ["00|17", "00|39", "00|28", "00|22", "00|14", "00|11", "00|40", "00|30", "00|10", "00|38", "00|02", "00|04", "00|17", "00|12"], title = "Roller"                  },
    { paints = ["00|22", "00|14", "00|11", "00|40", "00|30", "00|10", "00|28", "00|38", "00|02", "00|04", "00|17", "00|12", "00|16", "00|39"], title = "Elysium"                 },
    { paints = ["17|40", "03|11", "40|40", "03|39", "23|22", "03|40", "03|32", "04|36", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Shubert_Truck_QD"        },
    { paints = ["04|23", "04|12", "22|40", "20|20", "12|12", "23|23", "10|23", "10|01", "10|10", "07|07", "00|00", "00|00", "00|00", "00|00"], title = "Hank_B"                  },
    { paints = ["01|15", "01|19", "26|12", "02|23", "02|84", "05|04", "07|10", "28|02", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Chaffeque"               },
    { paints = ["00|40", "00|08", "00|07", "00|39", "00|35", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Waybar"                  },
    { paints = ["23|08", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00", "00|00"], title = "Shubert_Panel_m14"       },
];

local registry = {};

event("onScriptInit", function() {
    foreach (idx, obj in gamepaints) {
        local modelid = getVehicleModelIdFromName(obj.title);

        if (modelid == -1) continue;
        registry[modelid] <- [];

        foreach (id, value in obj.paints) {
            if (value == "00|00") continue;

            local temp = value;

            local colors = split(temp,"|");

            local color1 = colors[0].tointeger();
            local color2 = colors[1].tointeger();

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

function getVehicleColorsArray(vehicleid) {
    local modelid = getVehicleModel(vehicleid);
    local colors = [];
    if (modelid in registry) {
        foreach (idx, color in registry[modelid]) {
            colors.push([color.a.r, color.a.g, color.a.b, color.b.r, color.b.g, color.b.b]);
            if(color.a.r != color.b.r || color.a.g != color.b.g || color.a.b != color.b.b) {
                colors.push([color.b.r, color.b.g, color.b.b, color.a.r, color.a.g, color.a.b]);
            }
        }
    }
    return colors;
}


function getVehicleColorsArrayByModel(modelid) {
    local colors = [];
    if (modelid in registry) {
        foreach (idx, color in registry[modelid]) {
            colors.push([color.a.r, color.a.g, color.a.b, color.b.r, color.b.g, color.b.b]);
            if(color.a.r != color.b.r || color.a.g != color.b.g || color.a.b != color.b.b) {
                colors.push([color.b.r, color.b.g, color.b.b, color.a.r, color.a.g, color.a.b]);
            }
        }
    }
    return colors;
}
