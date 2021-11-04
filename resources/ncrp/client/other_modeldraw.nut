local playerTimers = {
	"pedTimer": null,
	"vehicleTimer": null
}


function playerDrawer() {
	local plaPos = getPlayerPosition(getLocalPlayer());
	foreach (idx, value in getPlayers()) {
		local targetPos = getPlayerPosition(idx);
		if (getDistanceBetweenPoints2D(targetPos[0], targetPos[1], plaPos[0], plaPos[1]) >= 400) {
		    executeLua(format("game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):Deactivate()", idx));
		} else {
		    executeLua(format("game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):Activate()", idx));
		}
	}
};

function vehicleDrawer() {
	local plaPos = getPlayerPosition(getLocalPlayer());
  	foreach (vehicleid, object in getVehicles()) {
		local targetPos = getVehiclePosition(vehicleid);
		if (getDistanceBetweenPoints2D(targetPos[0], targetPos[1], plaPos[0], plaPos[1]) >= 400) {
			executeLua(format("game.entitywrapper:GetEntityByName(\"m2online_vehicle_%d\"):Deactivate()", vehicleid));
		} else {
			executeLua(format("game.entitywrapper:GetEntityByName(\"m2online_vehicle_%d\"):Activate()", vehicleid));
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
