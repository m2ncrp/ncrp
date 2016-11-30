/**
 * Car help
 * Usage: /car
 */
cmd("car", function(playerid) {
    if (isPlayerNearCarShop(playerid)) {
        return msg(playerid, "shops.carshop.welcome", getPlayerName(playerid), CL_INFO);
    }

    return msg(playerid, "shops.carshop.gotothere", getPlayerName(playerid), CL_WARNING);
});

/**
 * List car models available in the shop
 * Usage: /car list
 */
cmd("car", "list", function(playerid, page = 1) {
    if (!isPlayerNearCarShop(playerid)) {
        return msg(playerid, "shops.carshop.gotothere", getPlayerName(playerid), CL_WARNING);
    }

    msg(playerid, "shops.carshop.list.title", CL_INFO);

    foreach (idx, car in getCarPrices()) {
        msg(playerid, "shops.carshop.list.entry", [car.modelid, car.title, car.price])
    }
});

/**
 * Attempt to by car model
 * Usage: /car buy
 */
cmd("car", "buy", function(playerid, modelid = null) {
    if (!isPlayerNearCarShop(playerid)) {
        return msg(playerid, "shops.carshop.gotothere", getPlayerName(playerid), CL_WARNING);
    }

    if (!isThereFreeCarShopPoint()) {
        return msg(playerid, "shops.carshop.nofreespace", CL_ERROR);
    }

    if (!modelid || !getCarShopModelById(modelid)) {
        return msg(playerid, "shops.carshop.selectmodel");
    }

    local car = getCarShopModelById(modelid);

    if (!canMoneyBeSubstracted(playerid, car.price)) {
        return msg(playerid, "shops.carshop.money.error", CL_ERROR);
    }

    // get free slot
    local point = getCarShopSlotById();

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

    return msg(playerid, "shops.carshop.success", CL_SUCCESS);
});

function carShopHelp (playerid, a = null, b = null) {
    local title = "shops.carshop.help.title";
    local commands = [
        { name = "/car list", desc = "shops.carshop.help.list" },
        { name = "/car buy modelid",  desc = "shops.carshop.help.buy" },
    ];
    msg_help(playerid, title, commands);
}

// usage: /help car
cmd("help", "car", carShopHelp);
cmd("car",  "car", carShopHelp);
