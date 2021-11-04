local playerTimers = {
    "pedTimer": null,
    "vehicleTimer": null
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
        } else if ((getDistanceBetweenPoints2D(targetPos[0], targetPos[1], plaPos[0], plaPos[1]) <= 10) && (!clientStreamings["player_"+idx])){
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
        } else if ((getDistanceBetweenPoints2D(targetPos[0], targetPos[1], plaPos[0], plaPos[1]) <= 10) && (!clientStreamings["vehicle_"+vehicleid])) {
            executeLua(format("game.entitywrapper:GetEntityByName(\"m2online_vehicle_%d\"):Activate()", vehicleid));
            clientStreamings["vehicle_"+vehicleid] = true;
        }
    }
};

function stopDrawer(type, timer) {
    local list = null;
    timer.Kill();
    playerTimers[type+"Timer"] = null;
    if (type == "vehicle"){
        list = getVehicles();
    } else {
        list = getPlayers();
    }
    foreach (idx, object in list) {
        executeLua(format("game.entitywrapper:GetEntityByName(\"m2online_%s_%d\"):Activate()", type, idx));
    }
}

addEventHandler("togglePlayersDrawer", function (state) {
    if (state) {
        playerTimers["pedTimer"] = timer(playerDrawer, 250, -1);
    } else {
        if (playerTimers["pedTimer"] != null) {
            stopDrawer("ped", playerTimers["pedTimer"]);
        }
    }
});

addEventHandler("toggleVehiclesDrawer", function (state) {
    if (state) {
        playerTimers["vehicleTimer"] = timer(vehicleDrawer, 250, -1);
    } else {
        if (playerTimers["vehicleTimer"] != null) {
            stopDrawer("vehicle", playerTimers["vehicleTimer"]);
        }
    }
});
