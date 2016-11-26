/**
 * Regiser coordinates for vehicles (4 doors at diamond motors)
 * @type {Array}
 */
local vehiclePositions = [
    { state = CARSHOP_STATE_FREE, position = vector3(-205.466, 835.142, -20.9735), rotation = vector3(159.300, 0.346464, 2.31108) },
    { state = CARSHOP_STATE_FREE, position = vector3(-209.199, 833.547, -21.0283), rotation = vector3(160.662, 0.470803, 2.37895) },
    { state = CARSHOP_STATE_FREE, position = vector3(-213.164, 832.172, -20.9392), rotation = vector3(160.965, 0.350293, 2.35895) },
    { state = CARSHOP_STATE_FREE, position = vector3(-217.133, 830.954, -20.9312), rotation = vector3(159.368, 0.344307, 2.36111) },
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

local carShopPlace = vector3(-204.324, 826.917, -20.8854);
local carShopBlock = [vector3(-221.32, 834.918, -21.2491), vector3(-199.757, 828.45, -20.8919)];
local carShopDisplay = {
    text = null,
    help = null
};

/**
 * Array with current market car prices
 * @type {Array}
 */
local carPrices = [
    { modelid = 1 , price = 5000, title = "Berkley Kingfisher"  },  // berkley_kingfisher_pha
    { modelid = 9 , price = 2740, title = "Houston Wasp"        },  // houston_wasp_pha
    { modelid = 22, price = 2100, title = "Potomac Indian"      },  // potomac_indian
    { modelid = 23, price = 2350, title = "Quicksilver Windsor" },  // quicksilver_windsor_pha
    { modelid = 25, price = 730 , title = "Shubert 38"          },  // shubert_38
    { modelid = 43, price = 450 , title = "Smith Coupe"         },  // smith_coupe
    { modelid = 48, price = 1500, title = "Smith Wagon"         },  // smith_wagon_pha
    { modelid = 53, price = 770 , title = "Walter Coupe"        },  // walter_coupe
];

/**
 * Check if player is near the sop
 * @param  {[type]}  playerid [description]
 * @return {Boolean}          [description]
 */
function isPlayerNearCarShop(playerid) {
    return getDistanceToPoint(playerid, carShopPlace.x, carShopPlace.y, carShopPlace.z) <= CARSHOP_DISTANCE;
}

/**
 * Return car prices array
 * @return {Array}
 */
function getCarPrices() {
    return carPrices;
}

/**
 * Check if there is free car shop point
 * @return {Boolean} [description]
 */
function isThereFreeCarShopPoint() {
    return (getFreeCarShopPoint() != null);
}

/**
 * Get free car shop point
 * @return {} [description]
 */
function getFreeCarShopPoint() {
    foreach (idx, value in vehiclePositions) {
        if (value.state == CARSHOP_STATE_FREE) {
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
function getCarShopModelById(modelid) {
    foreach(idx, car in carPrices) {
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
    // foreach (idx, value in getAll) {
    //     // Code
    // }
}

function carShopCreatePlace() {
    carShopDisplay.text = create3DText(carShopPlace.x, carShopPlace.y, carShopPlace.z, "== Car Shop ==", CL_WHITE);
    carShopDisplay.help = create3DText(carShopPlace.x, carShopPlace.y, carShopPlace.z, "/car", CL_WHITE.applyAlpha(150));
    return true;
}
