acmd("item", function( playerid, itemName = 0 ) {

    if (itemName == 0) {
        return msg(playerid, "/item VehicleKey | /item Burger");
    }

    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    }

    local item = Item[itemName]();

    if (!players[playerid].inventory.isFreeVolume(item)) {
        return msg(playerid, "inventory.volume.notenough", CL_THUNDERBIRD);
    }

    players[playerid].inventory.push(item);
    item.save();
    players[playerid].inventory.sync();

    return msg( playerid, format("Item %s received", itemName), CL_SUCCESS );
});