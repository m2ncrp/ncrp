enum ITEM_TYPE {
    NONE,
    FOOD,
    DRUNK,
    CLOTHES,
    OTHER,
};

local items = [
        { id = 0, type = ITEM_TYPE.NONE},
        { id = 1, type = ITEM_TYPE.FOOD},
        { id = 2, type = ITEM_TYPE.FOOD},
        { id = 3, type = ITEM_TYPE.DRUNK},
        { id = 4, type = ITEM_TYPE.DRUNK},
        { id = 5, type = ITEM_TYPE.OTHER},
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
    local image = "test.png"
    return image;
}

function getItemDescriptionById (id) {
    local description = "лул";
    return description;
}

function getItemTypeById (id) {
    local type = "kek"
    return type;
}

function isItemStackable (id) {
    // Code
}