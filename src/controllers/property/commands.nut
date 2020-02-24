acmd("", function(playerid) {

})

// Open property inventory
key("e", function (playerid) {

    local propertyId = getNearestPropertyIdByPrivateForPlayer(playerid);
    if(propertyId == false) return;

    local property = getPropertyEntity(propertyId);

    if(propertyId == null) return;

    // local opened = veh.data.parts.trunk.opened;

    // if(!opened) {
    //     return msg(playerid, "vehicle.parts.trunk.isClosed", CL_ERROR);
    // }

    if(!("inventory" in property) || property.inventory == null) {
        loadPropertyInventory(property);
    }

    //if(veh.inventory.isOpened(playerid)) {
    //    sendLocalizedMsgToAll(playerid, "vehicle.parts.trunk.endinspecting", [ getKnownCharacterNameWithId, getVehiclePlateText(vehicleid) ], NORMAL_RADIUS, CL_CHAT_ME);
    //} else {
    //    sendLocalizedMsgToAll(playerid, "vehicle.parts.trunk.inspecting", [ getKnownCharacterNameWithId, getVehiclePlateText(vehicleid) ], NORMAL_RADIUS, CL_CHAT_ME);
    //}

    property.inventory.toggle(playerid);

})