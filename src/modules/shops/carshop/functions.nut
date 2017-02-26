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
        { modelid = 22, price = 2100, title = "Potomac Indian"          },
        { modelid = 23, price = 2350, title = "Quicksilver Windsor"     },
        { modelid = 44, price = 1950, title = "Smith Mainline"          },
        { modelid = 48, price = 1380, title = "Smith Wagon"             },
        { modelid = 50, price = 1650, title = "Culver Empire"           },
        { modelid = 53, price = 870 , title = "Walter Coupe"            },
        { modelid = 47, price = 610,  title = "Smith V8"                },
        { modelid = 43, price = 470 , title = "Smith Coupe"             },
        { modelid = 25, price = 750 , title = "Shubert 38"              },
        { modelid = 31, price = 730 , title = "Shubert 38 Panel Truck"  },
    ],
    [   // bad guy
        { modelid = 10, price = 9400, title = "ISW 508"                 },
        //{ modelid = 18, price = 7670, title = "Lassiter Series 75 Hollywood" },
        { modelid = 9 , price = 2840, title = "Houston Wasp"            },
        { modelid = 1 , price = 5680, title = "Berkley Kingfisher"      },
        { modelid = 0 , price = 6995, title = "Ascot Bailey S200"       },
        { modelid = 15, price = 3500, title = "Lassiter Series 69"      },
        { modelid = 29, price = 5070, title = "Shubert Frigate"         },
        { modelid = 14, price = 4800, title = "Jefferson Provincial"    },
        { modelid = 45, price = 4200, title = "Smith Thunderbolt"       },
        { modelid = 28, price = 2530, title = "Shubert Beverly"         },
        { modelid = 41, price = 3140, title = "Smith Custom 200"        },
        { modelid = 52, price = 4550, title = "Walker Rocket"           },
    ]
];

/**
 * Automatically changing the range of cars both stores.
 * Writing to carPrices[0] for Diamond Motors and carPrices[1] for Bad Guy
 */

function generateRandomCarPrices() {
    local carPrices = [[],[]];

    local carPricesDiamond = clone(carPricesAll[0]);
    for (local i = 0; i < 8; i++) {
        local rand = random(0, carPricesDiamond.len() - 1);
        carPrices[0].push(carPricesDiamond[rand]);
        carPricesDiamond.remove(rand);
    }
    carPricesDiamond.clear();

    local carPricesBadGuy = clone(carPricesAll[1]);
    for (local i = 0; i < 8; i++) {
        local rand = random(0, carPricesBadGuy.len() - 1);
        carPrices[1].push(carPricesBadGuy[rand]);
        carPricesBadGuy.remove(rand);
    }
    carPricesBadGuy.clear();

    foreach (idx, subprices in carPrices) {
        foreach (idx_, object in subprices) {
            object.price = randomf(object.price - CARSHOP_PRICE_DIFF * 0.5, object.price + CARSHOP_PRICE_DIFF * 2.0);
        }
    }

    return carPrices;
}

local carPrices = generateRandomCarPrices();


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

    if (getDistanceToPoint(playerid, BADGUY_CARSHOP_X , BADGUY_CARSHOP_Y , BADGUY_CARSHOP_Z ) <= CARSHOP_DISTANCE) {
        return 1;
    }

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
