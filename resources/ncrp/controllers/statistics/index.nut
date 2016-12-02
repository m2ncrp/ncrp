const STATISICS_ENABLED = true;

function statisticsPushObject(object, type, additional = "") {
    // create object
    local entity = StatisticPoint();

    // set values
    entity.x = object.x;
    entity.y = object.y;
    entity.z = object.z;
    entity.type = type;
    entity.created = getDateTime();
    entity.additional = additional;

    // save it to db
    entity.save();
    entity.clean();
    return true;
}

function statisticsPushText(object, type, author, content, additional = "") {
    // create object
    local entity = StatisticText();

    // set values
    entity.type    = type;
    entity.author  = author;
    entity.content = content;
    entity.created = getDateTime();
    entity.additional = additional;

    entity.x = object.x;
    entity.y = object.y;
    entity.z = object.z;

    // save it to db
    entity.save();
    entity.clean();
    return true;
}

function statisticsPushMessage(playerid, message, type = "") {
    return statisticsPushText(getPlayerPositionObj(playerid), "message", getPlayerName(playerid), message, type);
}

function statisticsPushCommand(playerid, command) {
    return statisticsPushText(getPlayerPositionObj(playerid), "command", getPlayerName(playerid), command);
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
