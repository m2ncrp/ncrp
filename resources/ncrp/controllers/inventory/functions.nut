enum ITEM_TYPE {
    NONE,
    FOOD,
    DRUNK,
    CLOTHES,
    OTHER,
};

local items = [
    { id = 0, title = "ёбаное ничего",  type = ITEM_TYPE.NONE,  stackable = false,  img = "none.jpg"},
    { id = 1, title = "Бургер",         type = ITEM_TYPE.FOOD,  stackable = true,   img = "burger.jpg"},
    { id = 2, title = "Хотдог",         type = ITEM_TYPE.FOOD,  stackable = true,   img = "hotdog.jpg"},
    { id = 3, title = "Виски",          type = ITEM_TYPE.DRUNK, stackable = true,   img = "whiskey.jpg"},
    { id = 4, title = "Свифт кола",     type = ITEM_TYPE.DRUNK, stackable = true,   img = "swift-cola.jpg"},
    { id = 5, title = "Деньги",         type = ITEM_TYPE.OTHER, stackable = false,  img = "money.jpg"},
    { id = 6, title = "Квитанция",      type = ITEM_TYPE.OTHER, stackable = false,  img = "fine.jpg"},
];

local invItems = {};

addEventHandler("onItemLoading", function(playerid, id, amount, slot){
    local item = {};
    item.id <- id.tointeger();
    item.amount <- amount.tointeger();
    invItems[playerid][slot.tointeger()].push( item );
    trigger(playerid, "onServerSyncItems",slot,id);
});

function sendFullItemSync (playerid) {
    for(local i = 0; i < MAX_INVENTORY_SLOTS; i++){
        local item = getItemIdBySlot(i);
        trigger(playerid, "onServerSyncItems",i,item);
    }
}

function initPlayerItems(playerid){
    invItems[playerid] <- {};
    resetPlayerItems(playerid);
}

function  resetPlayerItems (playerid) {
    for(local i = 0; i < MAX_INVENTORY_SLOTS; i++) { // reset player items
        invItems[playerid][i] <- array(2, 0);
    }
}

function getItemIdBySlot (playerid, slot) {
    return invItems[playerid][slot].id;
}

function getItemAmountBySlot (playerid, slot) {
    return invItems[playerid][slot].amount;
}

function getItemImageById (id) {
    return items[id.tointeger()].img;
}
addEventHandler("getItemImageById", getItemImageById)

function getItemDescriptionById (id) {
    //todo
}

function getItemTypeById (id) {
    return items[id].type;
}

function isItemStackable (id) {
    return items[id].stackable;
}

addEventHandler("onPlayerUseItem", function(itemSlot) {

})

addEventHandler("onPlayerMoveItem", function(oldSlot, newSlot) {
    if(invItems[playerid][oldSlot].id > 0){
        if(invItems[playerid][newSlot].id == 0){
            invItems[playerid][newSlot].id = invItems[playerid][oldSlot].id;
            invItems[playerid][newSlot].amount = invItems[playerid][oldSlot].amount;
            invItems[playerid][oldSlot].id = 0;
            invItems[playerid][oldSlot].amount = 0;
            trigger(playerid, "updateSlot", newSlot, invItems[playerid][newSlot].id);
            trigger(playerid, "updateSlot", oldSlot, invItems[playerid][oldSlot].id);
        }
        else { // опа рокировочка проиошла кек
            invItems[playerid][newSlot].id = invItems[playerid][oldSlot].id;
            invItems[playerid][newSlot].amount = invItems[playerid][oldSlot].amount;
            invItems[playerid][oldSlot].id = invItems[playerid][newSlot].id;
            invItems[playerid][oldSlot].amount = invItems[playerid][newSlot].amount;
            trigger(playerid, "updateSlot", newSlot, invItems[playerid][newSlot].id);
            trigger(playerid, "updateSlot", oldSlot, invItems[playerid][oldSlot].id);
        }
    }
})

function givePlayerItem (playerid, item, amount) {
    local free = findFreeInvSlot(playerid);
    if(!free){
        return; //no free slots :(
    }
    invItems[playerid][free].id = item.tointeger();
    invItems[playerid][free].amount =  amount.tointeger();
}

function findFreeInvSlot(palyerid){
    local freeSlot = null;
    for(local i = 0; i < MAX_INVENTORY_SLOTS; i++){
        if(invItems[playerid][i].id == 0){
            freeSlot = i;
            break;
        }
    }
    return freeSlot;
}

function resetPlayerSlot(slot){
    invItems[playerid][slot].id = 0;
    invItems[playerid][slot].amount = 0;
}

acmd("slot", function(playerid, slot, id) {
    trigger(playerid, "updateSlot", slot, id);
});