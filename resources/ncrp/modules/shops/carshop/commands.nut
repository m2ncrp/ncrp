/**
 * Car help
 * Usage: /car
 */
// cmd("car", function(playerid) {
//     if (isPlayerNearCarShop(playerid)) {
//         return msg(playerid, "shops.carshop.welcome", getPlayerName(playerid), CL_INFO);
//     }

//     return msg(playerid, "shops.carshop.gotothere", getPlayerName(playerid), CL_WARNING);
// });

/**
 * RANAMED FROM CAR LIST
 * List car models available in the shop
 * Usage: /car list
 */
cmd("car", function(playerid, page = null, a = null) {
    if (!isPlayerNearCarShop(playerid)) {
        return msg(playerid, "shops.carshop.gotothere", getPlayerName(playerid), CL_WARNING);
    }

    local carshopid = getPlayerCarShopIndex(playerid);

    msg(playerid, "shops.carshop.list.title", CL_INFO);

    foreach (idx, car in getCarPrices(carshopid)) {
        msg(playerid, "shops.carshop.list.entry", [car.modelid, car.title, car.price])
    }

    msg(playerid, "shops.carshop.list.title", CL_INFO);
});

/**
 * Attempt to by car model
 * Usage: /car buy
 */
cmd("car", "buy", function(playerid, modelid = null) {
    local modelid = toInteger(modelid);

    if (!isPlayerNearCarShop(playerid)) {
        return msg(playerid, "shops.carshop.gotothere", getPlayerName(playerid), CL_WARNING);
    }

    local carshopid = getPlayerCarShopIndex(playerid);

    if (!isThereFreeCarShopPoint(carshopid)) {
        return msg(playerid, "shops.carshop.nofreespace", CL_ERROR);
    }

    if (!modelid || !getCarShopModelById(modelid, carshopid)) {
        return msg(playerid, "shops.carshop.selectmodel");
    }

    local car = getCarShopModelById(modelid, carshopid);

    if (!canMoneyBeSubstracted(playerid, car.price)) {
        return msg(playerid, "shops.carshop.money.error", CL_ERROR);
    }

    // get free slot
    local point = getCarShopSlotById(carshopid);

    // take money
    subMoneyToPlayer(playerid, car.price);

    // spawn it
    local vehicleid = createVehicle(car.modelid,
        point.position.x, point.position.y, point.position.z,
        point.rotation.x, point.rotation.y, point.rotation.z
    );

    // mark slot as not available
    point.state = vehicleid;

    // set params
    setVehicleOwner(vehicleid, playerid);
    setVehicleSaving(vehicleid, true);
    setVehicleRespawnEx(vehicleid, false);
    setVehicleDirtLevel(vehicleid, 0.0);
    repairVehicle(vehicleid);

    return msg(playerid, "shops.carshop.success", CL_SUCCESS);
});

function carShopHelp (playerid, a = null, b = null) {
    local title = "shops.carshop.help.title";
    local commands = [
        { name = "/car list", desc = "shops.carshop.help.list" },
        { name = "/car buy MODELID",  desc = "shops.carshop.help.buy" },
    ];
    msg_help(playerid, title, commands);
}

// usage: /help car
cmd("help", "car", carShopHelp);
