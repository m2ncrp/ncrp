include("controllers/inventory/items.nut");


local invItems = {};

function  resetPlayerItems (playerid) {
    invItems[playerid] <- {};
    trigger(playerid,"resetClientInvItem");
    for(local i = 0; i < MAX_INVENTORY_SLOTS; i++) { // reset player items
        invItems[playerid][i] <- {id = 0, amount = 0};
    }
}

function getItemIdBySlot (playerid, slot) {
    return invItems[playerid][slot].id;
}

function getItemAmountBySlot (playerid, slot) {
    return invItems[playerid][slot].amount;
}


addEventHandler("onItemLoading", function(playerid, id, amount, slot){
    invItems[playerid][slot.tointeger()] <- {id = id.tointeger(), amount = amount.tointeger()};
    trigger(playerid, "onServerSyncItems",slot,id,amount);
});


addEventHandler("onPlayerUseItem", function(playerid, itemSlot) {

})

addEventHandler("onPlayerMoveItem", function(playerid,oldSlot, newSlot) {
    oldSlot = oldSlot.tointeger();
    newSlot = newSlot.tointeger();
    local oldId = invItems[playerid][oldSlot].id;
    local newId = invItems[playerid][newSlot].id;
    if(invItems[playerid][oldSlot].id > 0){
        if(invItems[playerid][newSlot].id == 0){
            invItems[playerid][newSlot].id = invItems[playerid][oldSlot].id;
            invItems[playerid][newSlot].amount = invItems[playerid][oldSlot].amount;
            invItems[playerid][oldSlot].id = 0;
            invItems[playerid][oldSlot].amount = 0;
            trigger(playerid, "updateSlot", newSlot.tostring(), invItems[playerid][newSlot].id.tostring(), invItems[playerid][newSlot].amount.tostring());
            trigger(playerid, "updateSlot", oldSlot.tostring(), invItems[playerid][oldSlot].id.tostring(), invItems[playerid][oldSlot].amount.tostring());
            return;
        }
        if(invItems[playerid][newSlot].id > 0){

            if(oldId == newId && (isItemStackable(oldId) && isItemStackable(newId))){
                return stackItem(playerid, oldSlot, newSlot);
            }

            return castlingItem(playerid, oldSlot, newSlot);
        }
    }
})

function resetPlayerSlot(slot){
    invItems[playerid][slot].id = 0;
    invItems[playerid][slot].amount = 0;
}

acmd("giveitem",function(playerid, itemid = 0, amount = 0) {
    local slot = findFreeSlot(playerid);
    if(slot == -1){
        return msg(playerid, "ERROR: no free slots");// no free slots
    }
    invItems[playerid][slot] <- {id = itemid.tointeger(), amount = amount.tointeger()};
    trigger(playerid, "updateSlot", slot.tostring(), invItems[playerid][slot].id.tostring(), invItems[playerid][slot].amount.tostring());
});




function findFreeSlot(playerid){
    local freeSlot = -1;
    for(local i = 0; i < MAX_INVENTORY_SLOTS; i++){
        if(invItems[playerid][i].id == 0){
            freeSlot = i;
            break;
        }
    }
    return freeSlot;
}

function stackItem(playerid, oldSlot, newSlot) {
    local oldId = invItems[playerid][oldSlot].id;
    local oldAmount = invItems[playerid][oldSlot].amount;

    local newId = invItems[playerid][newSlot].id;
    local newAmount = invItems[playerid][oldSlot].amount;

    if(oldId == newId && (isItemStackable(oldId) && isItemStackable(newId))){
        invItems[playerid][oldSlot].id = 0;
        invItems[playerid][oldSlot].amount = 0;
        trigger(playerid, "updateSlot", oldSlot.tostring(), invItems[playerid][oldSlot].id.tostring(), invItems[playerid][oldSlot].amount.tostring());

        invItems[playerid][newSlot].amount += oldAmount;
        trigger(playerid, "updateSlot", newSlot.tostring(), invItems[playerid][newSlot].id.tostring(), invItems[playerid][newSlot].amount.tostring());
        dbg("TRU TO STACK ITEMS:" invItems[playerid][newSlot].amount);
        return;
    }
    return;
}

function castlingItem (playerid, oldSlot, newSlot) {
    local oldId = invItems[playerid][oldSlot].id;
    local oldAmount = invItems[playerid][oldSlot].amount;

    local newId = invItems[playerid][newSlot].id;
    local newAmount = invItems[playerid][oldSlot].amount;

    invItems[playerid][oldSlot].id = newId;
    invItems[playerid][oldSlot].amount = newAmount;
    trigger(playerid, "updateSlot", oldSlot.tostring(), invItems[playerid][oldSlot].id.tostring(), invItems[playerid][oldSlot].amount.tostring());

    invItems[playerid][newSlot].id = oldId;
    invItems[playerid][newSlot].amount = oldAmount;
    trigger(playerid, "updateSlot", newSlot.tostring(), invItems[playerid][newSlot].id.tostring(),invItems[playerid][newSlot].amount.tostring());

    return;
}

