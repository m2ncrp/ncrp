/**
 * Regiser coordinates for vehicles (4 doors at diamond motors)
 * @type {Array}
 */
local vehiclePositions = [
    [   // diamond motors
        { state = CARSHOP_STATE_FREE, position = Vector3(-205.466, 835.142, -20.9735), rotation = Vector3(159.300, 0.346464, 2.31108) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-209.199, 833.547, -21.0283), rotation = Vector3(160.662, 0.470803, 2.37895) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-213.164, 832.172, -20.9392), rotation = Vector3(160.965, 0.350293, 2.35895) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-217.133, 830.954, -20.9312), rotation = Vector3(159.368, 0.344307, 2.36111) },

        { state = CARSHOP_STATE_FREE, position = Vector3(-220.716, 827.691, -20.8228), rotation = Vector3(120.179, -0.570173, 3.1387) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-221.450, 822.812, -20.7874), rotation = Vector3(92.0500, 3.58971,  1.63252) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-221.450, 818.652, -20.6618), rotation = Vector3(92.0500, 3.72205, 0.869233) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-221.450, 814.535, -20.6319), rotation = Vector3(92.0500, 3.80713, 0.798234) },
    ],
    [   // bad guy
        { state = CARSHOP_STATE_FREE, position = Vector3(-626.011, 949.629, -18.7708), rotation = Vector3(-89.2381, 1.3864, -0.456439) },
        { state = CARSHOP_STATE_FREE, position = Vector3(-625.906, 954.701, -18.7714), rotation = Vector3(-89.3728, 1.50941, -0.26591) },
    ]
];

/**
 * Array with current market car prices
 * @type {Array}
 */
local carPricesAll = [
    [   // diamond motors
        { modelid = 0  , price = 7690 , rent = 0.74, title = "Ascot Bailey S200"            },
        { modelid = 1  , price = 6325 , rent = 0.61, title = "Berkley Kingfisher"           },
        { modelid = 9  , price = 2810 , rent = 0.32, title = "Houston Wasp"                 },
        { modelid = 10 , price = 10070, rent = 0.98, title = "ISW 508"                      },
        { modelid = 12 , price = 2400 , rent = 0.24, title = "Walter Utility"               },
        { modelid = 13 , price = 26500, rent = 2.65, title = "Jefferson Futura"             },
        { modelid = 14 , price = 5050 , rent = 0.51, title = "Jefferson Provincial"         },
        { modelid = 15 , price = 3600 , rent = 0.36, title = "Lassiter Series 69"           },
        { modelid = 18 , price = 7870 , rent = 0.79, title = "Lassiter Series 75 Hollywood" },
        { modelid = 22 , price = 2200 , rent = 0.22, title = "Potomac Indian"               },
        { modelid = 23 , price = 1800 , rent = 0.18, title = "Quicksilver Windsor"          },
        { modelid = 25 , price = 650  , rent = 0.07, title = "Shubert 38"                   },
        { modelid = 28 , price = 2600 , rent = 0.26, title = "Shubert Beverly"              },
        { modelid = 29 , price = 4575 , rent = 0.46, title = "Shubert Frigate"              },
        { modelid = 31 , price = 730  , rent = 0.07, title = "Shubert 38 Panel Truck"       },
        { modelid = 41 , price = 2800 , rent = 0.28, title = "Smith Custom 200"             },
        { modelid = 43 , price = 470  , rent = 0.05, title = "Smith Coupe"                  },
        { modelid = 44 , price = 1650 , rent = 0.17, title = "Smith Mainline"               },
        { modelid = 45 , price = 4800 , rent = 0.48, title = "Smith Thunderbolt"            },
        { modelid = 47 , price = 570  , rent = 0.06, title = "Smith V8"                     },
        { modelid = 48 , price = 1580 , rent = 0.16, title = "Smith Deluxe Station Wagon"   },
        { modelid = 50 , price = 2050 , rent = 0.21, title = "Culver Empire"                },
        { modelid = 52 , price = 4950 , rent = 0.5 , title = "Walker Rocket"                },
        { modelid = 53 , price = 490  , rent = 0.05, title = "Walter Coupe"                 },

    ],
    [
        // bad guy
    ]
];

local carOnSale = [ 0, 1, 9, 10, 12, 13, 14, 15, 18, 22, 23, 25, 28, 29, 41, 43, 44, 45, 47, 48, 50, 52, 53 ];
local currentcarcolor = {};

// /**
//  * Regiser coordinates for players (4 doors at diamond motors)
//  * @type {Array}
//  */
// local humanPositions = [
//     // Vector3(-206.081, 836.666, -21.2459),
//     // Vector3(-209.93,  835.554, -21.2409),
//     // Vector3(-213.939, 833.966, -21.2204),
//     // Vector3(-217.467, 831.943, -21.1803),
// ];

// local carShopBlock = [Vector3(-221.32, 834.918, -21.2491), Vector3(-199.757, 828.45, -20.8919)];

/**
 * Get id of car shop were player is staying at
 * @param  {Inerger} playerid
 * @return {Integer}
 */
function getPlayerCarShopIndex(playerid) {
    if (getDistanceToPoint(playerid, DIAMOND_CARSHOP_X, DIAMOND_CARSHOP_Y, DIAMOND_CARSHOP_Z) <= CARSHOP_DISTANCE) {
        return 0;
    }
/*
    if (getDistanceToPoint(playerid, BADGUY_CARSHOP_X , BADGUY_CARSHOP_Y , BADGUY_CARSHOP_Z ) <= CARSHOP_DISTANCE) {
        return 1;
    }
*/
    return null;
}

/**
 * Check if player is near the car shop
 * @param  {Integer}  playerid
 * @return {Boolean}
 */
function isPlayerNearCarShop(playerid) {
    return (getPlayerCarShopIndex(playerid) != null)
}

/**
 * Return car prices array
 * @return {Array}
 */
function getCarPrices(carShopIndex = 0) {
    return carPrices[carShopIndex];
}

/**
 * Check if there is free car shop point
 * @return {Boolean} [description]
 */
function isThereFreeCarShopPoint(carShopIndex) {
    return (getCarShopSlotById(carShopIndex) != null);
}

/**
 * Get free car shop point
 * @return {} [description]
 */
function getCarShopSlotById(carShopIndex, id = CARSHOP_STATE_FREE) {
    foreach (idx, value in vehiclePositions[carShopIndex]) {
        if (value.state == id) {
            return value;
        }
    }

    return null;
}

/**
 * Get car shop model by number id
 * @param  {Integer} modelid
 * @return {Table}
 */
function getCarShopModelById(modelid, carShopIndex = 0) {
    foreach(idx, car in carPrices[carShopIndex]) {
        if (car.modelid == modelid.tointeger()) {
            return car;
        }
    }

    return null;
}

/**
 * Get car info by modelid
 * @param  {Integer} modelid
 * @return {Table}
 */
function getCarInfoModelById(modelid) {
    foreach(idx, car in carPricesAll[0]) {
        if (car.modelid == modelid.tointeger()) {
            return car;
        }
    }

    return null;
}

/**
 * Check for free space near car shop
 * @return {Boolean}
 */
function carShopCheckFreeSpace() {
    // TODO: add in "car teleportation update"
    // foreach (idx, value in getAll) {
    //     // Code
    // }
}

/**
 * Try to free slot point that is might be takend by vehicle
 * @param {Integer} playerid
 * @param {Integer} vehicleid
 */
function carShopFreeCarSlot(playerid, vehicleid) {
    if (!isPlayerVehicleOwner(playerid, vehicleid)) return;

    // try to get slot by vehicle
    local slot = getCarShopSlotById(0, vehicleid);

    if (!slot) {
        slot = getCarShopSlotById(1, vehicleid);
    }

    // if slot exists - remove current car from the slot
    if (slot) {
        slot.state = CARSHOP_STATE_FREE;
    }
}




function carShopChangeColor(playerid) {

    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getPlayerVehicle(playerid);
    local plate = getVehiclePlateText(vehicleid);
    if(plate != " SALE ") {
        return;
    }

    local carpaints = getVehicleColorsArray( vehicleid );

    local num = currentcarcolor[vehicleid] + 1;
    if(num >= carpaints.len()) num = 0;

    local cr = carpaints[num];
    currentcarcolor[vehicleid] = num;

    setVehicleColour(vehicleid, cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
}



/**
 * Automatically changing the range of cars both stores.
 * Writing to carPrices[0] for Diamond Motors and carPrices[1] for Bad Guy
 */

function generateRandomCarPrices() {
    local carPrices = [[],[]];
    local shopDiamondSpaces = vehiclePositions[0];
    local countFreeSpaces = shopDiamondSpaces.len();

    local carPricesDiamond = clone(carPricesAll[0]);
    for (local i = 0; i < countFreeSpaces; i++) {
        local rand = random(0, carPricesDiamond.len() - 1);
        // dbg(carPricesDiamond[rand].modelid);
        if( carOnSale.find(carPricesDiamond[rand].modelid) == null ) { i--; /* dbg("nicht"); */ continue; }

        local vehicleid = createVehicle(carPricesDiamond[rand].modelid,
            shopDiamondSpaces[i].position.x, shopDiamondSpaces[i].position.y, shopDiamondSpaces[i].position.z,
            shopDiamondSpaces[i].rotation.x, shopDiamondSpaces[i].rotation.y, shopDiamondSpaces[i].rotation.z
        );
        currentcarcolor[vehicleid] <- 0;
        setVehiclePlateText(vehicleid, " SALE ");
        setVehicleDirtLevel(vehicleid, 0.0);
        delayedFunction(1000, function() { setRandomVehicleColors(vehicleid); });
        repairVehicle(vehicleid);

        carPrices[0].push(carPricesDiamond[rand]);
        carPricesDiamond.remove(rand);
    }
    carPricesDiamond.clear();


    foreach (idx, subprices in carPrices) {
        foreach (idx_, object in subprices) {
            object.price = randomf(object.price - CARSHOP_PRICE_DIFF * 0.5, object.price + CARSHOP_PRICE_DIFF * 2.0);
        }
    }

    return carPrices;
}

local carPrices = generateRandomCarPrices();
