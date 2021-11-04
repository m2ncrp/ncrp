local playerTimers = {
    "ped": null,
    "vehicle": null
}

local clientStreamings = {}


function playerDrawer() {
    local plaPos = getPlayerPosition(getLocalPlayer());
    foreach (idx, value in getPlayers()) {
        if (!("player_"+idx in clientStreamings)) {
            clientStreamings["player_"+idx] <- true;
        }
        local targetPos = getPlayerPosition(idx);
        if ((getDistanceBetweenPoints2D(targetPos[0], targetPos[1], plaPos[0], plaPos[1]) >= 400) && (clientStreamings["player_"+idx])) {
            executeLua(format("game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):Deactivate()", idx));
            log("hiding player " + idx)
            clientStreamings["player_"+idx] = false;
        } else if ((getDistanceBetweenPoints2D(targetPos[0], targetPos[1], plaPos[0], plaPos[1]) <= 400) && (!clientStreamings["player_"+idx])){
            executeLua(format("game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):Activate()", idx));
            log("showing player " + idx)
            clientStreamings["player_"+idx] = true;
        }
    }
};

function vehicleDrawer() {
    local plaPos = getPlayerPosition(getLocalPlayer());
    foreach (vehicleid, object in getVehicles()) {
        if (!("vehicle_"+vehicleid in clientStreamings)) {
            clientStreamings["vehicle_"+vehicleid] <- true;
        }
        local targetPos = getVehiclePosition(vehicleid);
        if ((getDistanceBetweenPoints2D(targetPos[0], targetPos[1], plaPos[0], plaPos[1]) >= 400) && (clientStreamings["vehicle_"+vehicleid])){
            executeLua(format("game.entitywrapper:GetEntityByName(\"m2online_vehicle_%d\"):Deactivate()", vehicleid));
            clientStreamings["vehicle_"+vehicleid] = false;
        } else if ((getDistanceBetweenPoints2D(targetPos[0], targetPos[1], plaPos[0], plaPos[1]) <= 400) && (!clientStreamings["vehicle_"+vehicleid])) {
            executeLua(format("game.entitywrapper:GetEntityByName(\"m2online_vehicle_%d\"):Activate()", vehicleid));
            clientStreamings["vehicle_"+vehicleid] = true;
        }
    }
};

function stopDrawer(type, timer) {
    playerTimers[type].Kill();
    playerTimers[type] = null;
    local list = type == "vehicle" ? getVehicles() : getPlayers();
    foreach (idx, object in list) {
        executeLua(format("game.entitywrapper:GetEntityByName(\"m2online_%s_%d\"):Activate()", type, idx));
    }
}

addEventHandler("togglePlayersDrawer", function (state) {
    if (state) {
        playerTimers["ped"] = timer(playerDrawer, 250, -1);
    } else {
        if (playerTimers["ped"] != null) {
            stopDrawer("ped", playerTimers["ped"]);
        }
    }
});

addEventHandler("toggleVehiclesDrawer", function (state) {
    if (state) {
        playerTimers["vehicle"] = timer(vehicleDrawer, 250, -1);
    } else {
        if (playerTimers["vehicle"] != null) {
            stopDrawer("vehicle", playerTimers["vehicle"]);
        }
    }
});
