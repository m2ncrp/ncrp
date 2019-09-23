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



// Lock/unlock vehicle trunk
key("q", function (playerid) {

    local vehicleid = getNearestVehicleForPlayerForTrunk(playerid);
    if(vehicleid == false) return;

    local veh = getVehicleEntity(vehicleid);

    if(veh == null) return;

    local locked = veh.data.parts.trunk.locked;
    local opened = veh.data.parts.trunk.opened;


    local hasAccess = isPlayerHaveVehicleKey(playerid, vehicleid) || ( isOfficer(playerid) && isOfficerOnDuty(playerid) && isVehicleidPoliceVehicle(vehicleid) );

    if(!hasAccess) {
        msg(playerid, "vehicle.owner.warning", CL_ERROR);
        // нельзя делать return, поскольку надо предотвратить открытие залоченного багажника (мало ли игрок поменял кнопку).
    } else {
        // ключ есть
        if(locked) {
            locked = false;
            msg(playerid, "vehicle.parts.trunk.unlocked", CL_SUCCESS);
        } else {

            if(opened) {
                opened = false;

                if(veh.inventory == null) {
                    loadVehicleInventory(veh);
                }

                veh.inventory.hideForAll();
            }

            locked = true;
            msg(playerid, "vehicle.parts.trunk.locked", CL_ERROR);
        }

    }

    veh.data.parts.trunk.locked = locked;
    veh.data.parts.trunk.opened = opened;
    setVehiclePartOpen(vehicleid, 1, opened)
    delayedFunction(50, function () {
        setVehiclePartOpen(vehicleid, 1, opened)
    });

});

// Open/close vehicle trunk
key("e", function (playerid) {

    local vehicleid = getNearestVehicleForPlayerForTrunk(playerid);
    if(vehicleid == false) return;

    local veh = getVehicleEntity(vehicleid);

    if(veh == null) return;

    local locked = veh.data.parts.trunk.locked;
    local opened = veh.data.parts.trunk.opened;

    if(locked) {
        msg(playerid, "vehicle.parts.trunk.isLocked", CL_ERROR);
        // нельзя делать return, поскольку надо предотвратить открытие залоченного багажника
    } else {

        // запишем новое состояние
        opened = !opened;
        msg(playerid, "vehicle.parts.trunk."+ (opened ? "opened" : "closed"), opened ? CL_SUCCESS : CL_ERROR);
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

// Open vehicle inventory
key("z", function (playerid) {

    local vehicleid = getNearestVehicleForPlayerForTrunk(playerid);
    if(vehicleid == false) return;

    local veh = getVehicleEntity(vehicleid);

    if(veh == null) return;

    local opened = veh.data.parts.trunk.opened;

    if(!opened) {
        return msg(playerid, "vehicle.parts.trunk.isClosed", CL_ERROR);
    }

    if(veh.inventory == null) {
        loadVehicleInventory(veh);
    }

    if(veh.inventory.isOpened(playerid)) {
        sendMsgToAllInRadius(playerid, "vehicle.parts.trunk.endinspecting", [ getPlayerName(playerid), getVehiclePlateText(vehicleid) ], CL_CHAT_ME, NORMAL_RADIUS);
    } else {
        sendMsgToAllInRadius(playerid, "vehicle.parts.trunk.inspecting", [ getPlayerName(playerid), getVehiclePlateText(vehicleid) ], CL_CHAT_ME, NORMAL_RADIUS);
    }

    veh.inventory.toggle(playerid);

})

// Open vehicle interior
key("z", function (playerid) {
    if(!isPlayerInVehicleSeat(playerid, 0)) return;

    local vehicleid = getPlayerVehicle(playerid);
    if(vehicleid == false) return;

    if(!isPlayerHaveVehicleKey(playerid, vehicleid)) return;

    local veh = getVehicleEntity(vehicleid);
    if(veh == null) return;

    if(veh.interior == null) {
        loadVehicleInterior(veh);
    }

    veh.interior.toggle(playerid);

})

acmd(["setdefault"], function( playerid ) {
    if(!isPlayerInVehicle(playerid)) return msg(playerid, "Нужно быть в машине");
    local vehicleid = getPlayerVehicle(playerid);
    local veh = getVehicleEntity(vehicleid);
    if(veh == null) return;

    local vehPos = getVehiclePositionObj(vehicleid);
    local vehRot = getVehicleRotationObj(vehicleid);

    veh.data.defaultPos <- vehPos;
    veh.data.defaultRot <- vehRot;
    veh.save();
    msg(playerid, "Позиция и поворот по-умолчанию установлены");
});
