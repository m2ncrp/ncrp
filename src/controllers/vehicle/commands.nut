/**
 * KEYBINDS
 */

function addPrivateVehicleLightsKeys (vehicleid) {
    local playerid = getVehicleDriver(vehicleid);
    if(playerid == null) return;
    privateKey(playerid, "q", "vehicleEngineSwitch", function(playerid) { switchEngine(vehicleid) });
    privateKey(playerid, "r", "switchLights", function(playerid) { switchLights(vehicleid) });
    privateKey(playerid, "z", "switchLeftLight", function(playerid) { switchLeftLight(vehicleid) });
    privateKey(playerid, "c", "switchRightLight", function(playerid) { switchRightLight(vehicleid) });
    privateKey(playerid, "x", "switchBothLight", function(playerid) { switchBothLight(vehicleid) });
}

function removePrivateVehicleLightsKeys (playerid) {
    removePrivateKey(playerid, "q", "vehicleEngineSwitch")
    removePrivateKey(playerid, "r", "switchLights");
    removePrivateKey(playerid, "z", "switchLeftLight");
    removePrivateKey(playerid, "c", "switchRightLight");
    removePrivateKey(playerid, "x", "switchBothLight");
}


cmd("vehinv", function (playerid, vehicleid) {
    vehicleid = vehicleid.tointeger();
    local veh = getVehicleEntity(vehicleid);

    if(veh.inventory == null) {
        loadVehicleInventory(veh);
    }

    veh.inventory.toggle(playerid);
});

key("q", function (playerid) {
    if (isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getNearestVehicleForPlayer(playerid, 5.0);
    if(vehicleid == -1) {
        return;
    }

    local pos = getVehicleTrunkPosition(vehicleid);

    if(!isInRadius(playerid, pos.x, pos.y, pos.z, 0.75)) {
        log("not in Radius")
        return;
    }

    local veh = getVehicleEntity(vehicleid);

    local locked = veh.data.parts.trunk.locked;
    local opened = veh.data.parts.trunk.opened;

    if(!isPlayerHaveVehicleKey(playerid, vehicleid)) {
        msg(playerid, "Need key to manage trunk");
    } else {
        // ключ есть
        if(locked) {
            locked = false;
            msg(playerid, "Trunk has been unlocked", CL_SUCCESS);
        } else {

            if(opened) {
                opened = false;

                if(veh.inventory == null) {
                    loadVehicleInventory(veh);
                }

                veh.inventory.hideForAll();
            }

            locked = true;
            msg(playerid, "Trunk has been locked", CL_ERROR);
        }

    }

    veh.data.parts.trunk.locked = locked;
    veh.data.parts.trunk.opened = opened;
    setVehiclePartOpen(vehicleid, 1, opened)
    delayedFunction(50, function () {
        setVehiclePartOpen(vehicleid, 1, opened)
    });

});

key("e", function (playerid) {
    if(isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getNearestVehicleForPlayer(playerid, 5.0);
    if(vehicleid == -1) {
        return;
    }

    local pos = getVehicleTrunkPosition(vehicleid);
    //createPrivate3DText ( playerid, pos.x, pos.y, pos.z, plocalize(playerid, "V"), CL_ROYALBLUE, 50.0);

    if(!isInRadius(playerid, pos.x, pos.y, pos.z, 0.75)) {
        log("not in Radius")
        return;
    }

    local veh = getVehicleEntity(vehicleid);

    local locked = veh.data.parts.trunk.locked;
    local opened = veh.data.parts.trunk.opened;

    if(locked) {
        msg(playerid, "Trunk is locked", CL_ERROR);
    } else {

        // запишем новое состояние
        opened = !opened;
        msg(playerid, "Trunk has been "+ (opened ? "open" : "close"), opened ? CL_SUCCESS : CL_ERROR);
        if(veh.inventory == null) {
            loadVehicleInventory(veh);
        }

        if(opened == false) {
            veh.inventory.hideForAll();
        }
    }

    veh.data.parts.trunk.opened = opened;
    setVehiclePartOpen(vehicleid, 1, opened)
    delayedFunction(50, function () {
        setVehiclePartOpen(vehicleid, 1, opened)
    });

})

key("z", function (playerid) {
    if(isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getNearestVehicleForPlayer(playerid, 5.0);
    if(vehicleid == -1) {
        return;
    }

    local pos = getVehicleTrunkPosition(vehicleid);
    //createPrivate3DText ( playerid, pos.x, pos.y, pos.z, plocalize(playerid, "V"), CL_ROYALBLUE, 50.0);

    if(!isInRadius(playerid, pos.x, pos.y, pos.z, 0.75)) {
        log("not in Radius")
        return;
    }

    local veh = getVehicleEntity(vehicleid);

    local opened = veh.data.parts.trunk.opened;

    if(!opened) {
        msg(playerid, "Trunk is closed", CL_ERROR);
    } else {

        if(veh.inventory == null) {
            loadVehicleInventory(veh);
        }

        veh.inventory.toggle(playerid);
    }

})

cmd("vee2", function (playerid, distance) {
    local vehicleid = getPlayerVehicle(playerid);
    distance = distance.tofloat()
    for (local i = 0; i < 72; i++) {
        vee(playerid, distance);

        local rot = getVehicleRotation(vehicleid);
        setVehicleRotation(vehicleid, rot[0]-5.0, rot[1], rot[2]);
    }
});

