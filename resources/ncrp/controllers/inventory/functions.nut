include("controllers/inventory/items.nut");

invItems <- {};


/**
 * WARNING:
 * Override all current player items with empty one
 * without saving any prevous ones
 * @param  {Integer} playerid
 */
function resetPlayerItems(playerid) {
    invItems[playerid] <- {};

    for(local i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        addPlayerItem(playerid, Item.None(i));
    }
}

/**
 * Main method for loading items
 * @param {Integer} playerid
 * @param {Item.Item} item
 */
function addPlayerItem(playerid, item) {
    if (!(item instanceof Item.Item)) {
        throw "onItemLoading: you've provided invalid item instance. Make sure it extends Item.Item";
    }

    if (!(playerid in invItems)) {
        invItems[playerid] <- {};
    }

    invItems[playerid][item.slot] <- item;
    syncPlayerItem(playerid, item);
}


event("native:onPlayerUseItem", function(playerid, itemSlot) {
    itemSlot = itemSlot.tointeger();

    // exit if invalid
    if (!(playerid in invItems) || !(itemSlot in invItems[playerid])) return;

    invItems[playerid][itemSlot].use(playerid);
});

event("native:onPlayerMoveItem", function(playerid, oldSlot, newSlot) {
    oldSlot = oldSlot.tointeger();
    newSlot = newSlot.tointeger();

    // exit if invalid
    if (!(playerid in invItems) || !(oldSlot in invItems[playerid]) || !(newSlot in invItems[playerid])) return;

    // player trying to move empty item, ignore
    if (invItems[playerid][oldSlot].classname == "Item.None") return;

    // player trying to stack up same items
    if (invItems[playerid][oldSlot].classname == invItems[playerid][newSlot].classname && invItems[playerid][newSlot].stackable) {
        local newAmount = invItems[playerid][oldSlot].amount + invItems[playerid][newSlot].amount;

        if (newAmount > invItems[playerid][newSlot].maxstack) {
            invItems[playerid][newSlot].amount = invItems[playerid][oldSlot].maxstack;
            invItems[playerid][oldSlot].amount = newAmount - invItems[playerid][newSlot].maxstack;
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

    local temp = invItems[playerid][newSlot];
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
    if (item instanceof Item.Clothes)    return "ITEM_TYPE.CLOTHES";
    return "ITEM_TYPE.NONE";
}

function syncPlayerItem(playerid, item) {
    dbg("trying to sync item with name", item.classname, "to player", getIdentity(playerid));
    return trigger(playerid, "onServerSyncItems", item.slot.tostring(), item.classname, item.amount.tostring(), getItemType(item), item.calculateWeight().tostring());
}

function findFreeSlot(playerid){
    for (local i = 0; i < MAX_INVENTORY_SLOTS; i++) {
        if (invItems[playerid][i].classname == "Item.None") {
            return i;
        }
    }
    return -1;
}

function getPlayerItems(playerid) {
    return invItems[playerid];
}

function getTotalWeight(playerid) {
    local weight = 0.0;
    for(local i = 0; i < MAX_INVENTORY_SLOTS; i++){
        weight += invItems[playerid][i].calculateWeight();
    }
    return weight;
}