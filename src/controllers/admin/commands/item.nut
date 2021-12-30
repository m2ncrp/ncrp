mcmd(["admin.item"], "item", function( playerid, itemName = 0 ) {

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
    players[playerid].inventory.sync();
    item.save();

    if(players[playerid].inventory.isOpened(playerid)) {
        trigger(playerid, "onServerShowCursorTrigger");
    }

    return msg( playerid, format("Item %s received", itemName), CL_SUCCESS );
});