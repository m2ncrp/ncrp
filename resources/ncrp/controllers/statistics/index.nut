const STATISICS_ENABLED = true;

function statisticsPushObject(object, type, additional = "") {
    // create object
    local point = StatisticPoint();

    // set values
    point.x = object.x;
    point.y = object.y;
    point.z = object.z;
    point.type = type;
    point.created = getDateTime();
    point.additional = additional;

    // save it to db
    point.save();
}

function statisticsPushPlayers() {
    local amount = 0;

    playerList.each(function(playerid) {
        local additional = isPlayerInVehicle(playerid) ? "invehicle" : "onfoot";
        statisticsPushObject( getPlayerPositionObj(playerid), "player",  additional);
        amount++;
    });

    return amount;
}

function statisticsPushVehicles() {
    local amount = 0;

    foreach (vehicleid in getCustomPlayerVehicles()) {
        local additional = isVehicleEmpty(vehicleid) ? "empty" : "driven";
        statisticsPushObject( getVehiclePositionObj(vehicleid), "vehicle", additional );
        amount++;
    }

    return amount;
}

addEventHandlerEx("onServerAutosave", function() {
    if (!STATISICS_ENABLED) {
        return;
    }

    local amount = 0;
    amount += statisticsPushPlayers();
    amount += statisticsPushVehicles();
    // log("[stats] collected info #" + amount + " records");
});
