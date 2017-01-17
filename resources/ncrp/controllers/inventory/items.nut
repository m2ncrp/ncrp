enum ITEM_TYPE {
    NONE,
    FOOD,
    DRUNK,
    CLOTHES,
    OTHER,
    WEAPON,
};

local items = [  //{ id = , weight = 0.0, type = ITEM_TYPE., stackable = ,   img = ""},
    { id = 0,   weight = 0.0, type = ITEM_TYPE.NONE,    stackable = false,  img = "none.jpg"},
    { id = 1,   weight = 0.0, type = ITEM_TYPE.OTHER,   stackable = true,   img = "money.jpg"},
    { id = 2,   weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 3,   weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 4,   weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 5,   weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 6,   weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 7,   weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 8,   weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 9,   weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 10,  weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 11,  weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 12,  weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 13,  weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 14,  weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 15,  weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 16,  weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
    { id = 17,  weight = 0.0, type = ITEM_TYPE.WEAPON,  stackable = false,  img = ""},
];




function getItemImageById (id) {
    return items[id].img;
}

function getItemWeigtById (id) {
    return items[id].weight;
}

function getItemTypeById (id) {
    return items[id].type;
}

function isItemStackable (id) {
    return items[id].stackable;
}


/*
local itemsDescription = [

];
 */