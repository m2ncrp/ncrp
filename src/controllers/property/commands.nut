// Open property inventory
key("z", function (playerid) {

    local propertyId = getNearestPropertyIdByPrivateForPlayer(playerid);
    if(propertyId == false) return;

    local property = getPropertyEntity(propertyId);

    if(propertyId == null) return;

    // local opened = veh.data.parts.trunk.opened;

    // if(!opened) {
    //     return msg(playerid, "vehicle.parts.trunk.isClosed", CL_ERROR);
    // }

    if(property.inventory == null) {
        loadPropertyInventory(property);
    }

    //if(veh.inventory.isOpened(playerid)) {
    //    sendLocalizedMsgToAll(playerid, "vehicle.parts.trunk.endinspecting", [ getKnownCharacterNameWithId, getVehiclePlateText(vehicleid) ], NORMAL_RADIUS, CL_CHAT_ME);
    //} else {
    //    sendLocalizedMsgToAll(playerid, "vehicle.parts.trunk.inspecting", [ getKnownCharacterNameWithId, getVehiclePlateText(vehicleid) ], NORMAL_RADIUS, CL_CHAT_ME);
    //}

    if(property.inventory.isOpened(playerid)) {
        players[playerid].inventory.hide(playerid);
        property.inventory.hide(playerid);

        if(property.inventory) {
            foreach (idx, item in property.inventory) {
                item.parent = property.id;
                item.save();
            }
        }

    } else {
        property.inventory.toggle(playerid);
        players[playerid].inventory.toggle(playerid);
    }
})