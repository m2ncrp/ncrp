include("controllers/inventory/items.nut");

local invItems = {};

/**
 * WARNING:
 * Override all current player items with empty one
 * without saving any prevous ones
 * @param  {Integer} playerid
 */
function resetPlayerItems(playerid) {
    invItems[playerid] <- {};

    for(local i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        trigger("onItemLoading", playerid, Item.None(i));
    }
}

/**
 * Main event for loading items
 * @param {Integer} playerid
 * @param {Item.Item} item
 */
event("onItemLoading", function(playerid, item) {
    if (!(item instanceof Item.Item)) {
        throw "onItemLoading: you've provided invalid item instance. Make sure it extends Item.Item";
    }

    if (!(playerid in invItems)) {
        invItems[playerid] <- {};
    }

    invItems[playerid][item.slot] <- item;
    syncPlayerItem(playerid, item);
});


event("native:onPlayerUseItem", function(playerid, itemSlot) {

});

event("native:onPlayerMoveItem", function(playerid, oldSlot, newSlot) {
    oldSlot = oldSlot.tointeger();
    newSlot = newSlot.tointeger();

    // player trying to move empty item, ignore
    if (invItems[playerid][oldSlot].classname == "Item.None") return;

    // player trying to stack up same items
    if (invItems[playerid][oldSlot].classname == invItems[playerid][newSlot].classname && invItems[playerid][newSlot].stackable) {
        local newAmount = invItems[playerid][oldSlot].amount + invItems[playerid][oldSlot].amount;

        if (newAmount > invItems[playerid][newSlot].maxstack) {
            invItems[playerid][oldSlot] = newAmount - invItems[playerid][newSlot].maxstack;
            invItems[playerid][newSlot] = invItems[playerid][oldSlot].maxstack;
        } else {
            invItems[playerid][oldSlot] = Item.None(oldSlot);
            invItems[playerid][newSlot].amount = newAmount;
        }

        syncPlayerItem(playerid, invItems[playerid][newSlot]);
        syncPlayerItem(playerid, invItems[playerid][oldSlot]);

        trigger("onPlayerStackItem", playerid, invItems[playerid][newSlot]);
        // TODO(inlife): maybe add on player remove item for oldSlot?
        return;
    }

    local temp = invItems[playerid][oldSlot];
    invItems[playerid][newSlot] = invItems[playerid][oldSlot];
    invItems[playerid][oldSlot] = temp;

    invItems[playerid][newSlot].slot = newSlot;
    invItems[playerid][oldSlot].slot = oldSlot;

    syncPlayerItem(playerid, invItems[playerid][newSlot]);
    syncPlayerItem(playerid, invItems[playerid][oldSlot]);

    if (invItems[playerid][oldSlot].classname != "Item.None") trigger("onPlayerMoveItem", playerid, invItems[playerid][oldSlot]);
    if (invItems[playerid][newSlot].classname != "Item.None") trigger("onPlayerMoveItem", playerid, invItems[playerid][newSlot]);

    return true;
});

function getItemType(item) {
    if (item instanceof Item.Ammo)      return "ITEM_TYPE.AMMO";
    if (item instanceof Item.Weapon)    return "ITEM_TYPE.WEAPON";

    return "ITEM_TYPE.NONE";
}

function syncPlayerItem(playerid, item) {
    return trigger(playerid, "onServerSyncItems", item.slot.tostring(), item.classname, item.amount.tostring(), getItemType(item));
}

// acmd("giveitem",function(playerid, itemid = 0, amount = 0) {
//     local slot = findFreeSlot(playerid);
//     if(slot == -1){
//         return msg(playerid, "ERROR: no free slots");// no free slots
//     }
//     invItems[playerid][slot] <- {id = itemid.tointeger(), amount = amount.tointeger()};
//     trigger(playerid, "updateSlot", slot.tostring(), invItems[playerid][slot].classname.tostring(), invItems[playerid][slot].amount.tostring());
// });


function findFreeSlot(playerid){
    local freeSlot = -1;
    for(local i = 0; i < MAX_INVENTORY_SLOTS; i++){
        if(invItems[playerid][i].classname == 0){
            freeSlot = i;
            break;
        }
    }
    return freeSlot;
}
