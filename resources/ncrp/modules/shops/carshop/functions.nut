/**
 * Regiser coordinates for vehicles (4 doors at diamond motors)
 * @type {Array}
 */
local vehiclePositions = [
    [   // diamond motors
        { state = CARSHOP_STATE_FREE, position = vector3(-205.466, 835.142, -20.9735), rotation = vector3(159.300, 0.346464, 2.31108) },
        { state = CARSHOP_STATE_FREE, position = vector3(-209.199, 833.547, -21.0283), rotation = vector3(160.662, 0.470803, 2.37895) },
        { state = CARSHOP_STATE_FREE, position = vector3(-213.164, 832.172, -20.9392), rotation = vector3(160.965, 0.350293, 2.35895) },
        { state = CARSHOP_STATE_FREE, position = vector3(-217.133, 830.954, -20.9312), rotation = vector3(159.368, 0.344307, 2.36111) },
    ],
    [   // bad guy
        { state = CARSHOP_STATE_FREE, position = vector3(-626.011, 949.629, -18.7708), rotation = vector3(-89.2381, 1.3864, -0.456439) },
        { state = CARSHOP_STATE_FREE, position = vector3(-625.906, 954.701, -18.7714), rotation = vector3(-89.3728, 1.50941, -0.26591) },
    ]
];

/**
 * Array with current market car prices
 * @type {Array}
 */
local carPrices = [
    [   // diamond motors
        { modelid = 1 , price = 5000, title = "Berkley Kingfisher"  },  // berkley_kingfisher_pha
        { modelid = 9 , price = 2740, title = "Houston Wasp"        },  // houston_wasp_pha
        { modelid = 22, price = 2100, title = "Potomac Indian"      },  // potomac_indian
        { modelid = 23, price = 2350, title = "Quicksilver Windsor" },  // quicksilver_windsor_pha
        { modelid = 50, price = 1475, title = "Culver Empire"       },
        { modelid = 48, price = 1500, title = "Smith Wagon"         },  // smith_wagon_pha
        { modelid = 43, price = 450 , title = "Smith Coupe"         },  // smith_coupe
        { modelid = 53, price = 770 , title = "Walter Coupe"        },  // walter_coupe
        { modelid = 25, price = 730 , title = "Shubert 38"          },  // shubert_38
    ],
    [   // bad guy
        { modelid = 10, price = 9000, title = "ISW 508"             },
        { modelid = 0 , price = 4995, title = "Ascot Bailey S200"   },
        { modelid = 18, price = 5170, title = "Lassiter Series 75 Hollywood" },
        { modelid = 15, price = 3500, title = "Lassiter Series 69"  },
        { modelid = 14, price = 3200, title = "Jefferson Provincial"},
        { modelid = 45, price = 2700, title = "Smith Thunderbolt"   },
        { modelid = 41, price = 2140, title = "Smith Custom 200"    },
        { modelid = 28, price = 2300, title = "Shubert Beverly"     },
        { modelid = 52, price = 2450, title = "Walker Rocket"       },
    ]
];

// /**
//  * Regiser coordinates for players (4 doors at diamond motors)
//  * @type {Array}
//  */
// local humanPositions = [
//     // vector3(-206.081, 836.666, -21.2459),
//     // vector3(-209.93,  835.554, -21.2409),
//     // vector3(-213.939, 833.966, -21.2204),
//     // vector3(-217.467, 831.943, -21.1803),
// ];

// local carShopBlock = [vector3(-221.32, 834.918, -21.2491), vector3(-199.757, 828.45, -20.8919)];

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
