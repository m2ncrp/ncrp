enum ITEM_TYPE {
    NONE,
    FOOD,
    DRUNK,
    CLOTHES,
    OTHER,
};

local items = [
        { id = 0, title = "",       type = ITEM_TYPE.NONE,  stackable = false,  img = "none.png"},
        { id = 1, title = "Бургер", type = ITEM_TYPE.FOOD,  stackable = true,   img = "burger.png"},
        { id = 2, title = "Хотдог", type = ITEM_TYPE.FOOD,  stackable = true,   img = "hotdog.png"},
        { id = 3, title = "Виски",  type = ITEM_TYPE.DRUNK, stackable = true,   img = "whiskey.png"},
        { id = 4, title = "Вино",   type = ITEM_TYPE.DRUNK, stackable = true,   img = "wine.png"},
        { id = 5, title = "Деньги", type = ITEM_TYPE.OTHER, stackable = false,  img = "money.png"},
];

local invItems = {};

addEventHandler("onItemLoading", function(playerid, id, amount, slot){
    local item = {};
    item.id <- id.tointeger();
    item.amount <- amount.tointeger();
    invItems[playerid][slot.tointeger()].push( item );
    dbg(invItems[playerid][slot.tointeger()]);
});

acmd("slot", function(playerid, id) {
    dbg(invItems[playerid][id]);
});


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
    return items[id].img;
}

function getItemDescriptionById (id) {
    //todo
}

function getItemTypeById (id) {
    return items[id].type;
}

function isItemStackable (id) {
    return items[id].stackable;
}