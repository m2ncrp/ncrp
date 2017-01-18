enum ITEM_TYPE {
    NONE,
    FOOD,
    DRUNK,
    CLOTHES,
    OTHER,
    WEAPON,
    AMMO,
};

//{id, weight, type, stackable,img }

local items = [
    { id = 0,   weight = 0.0,   type = ITEM_TYPE.NONE,    stackable = false, maxstack = 0, expiration = 0, img = "none.jpg"},
    { id = 1,   weight = 0.0,   type = ITEM_TYPE.OTHER,   stackable = false, maxstack = 0, expiration = 0, img = "money.jpg"},
/* ---------------------------------------------------------------WEAPONS/AMMO--------------------------------------------------------------------------------------- */
    { id = 2,   weight = 0.5,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "12Revolver.jpg"},
    { id = 3,   weight = 1.2,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "MauserC96.jpg"},
    { id = 4,   weight = 1.1,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "ColtM1911A1.jpg"},
    { id = 5,   weight = 1.5,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "ColtM1911Spec.jpg"},
    { id = 6,   weight = 0.9,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "19Revolver.jpg"},
    { id = 7,   weight = 0.6,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "MK2.jpg"},
    { id = 8,   weight = 3.6,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Remington870.jpg"},
    { id = 9,   weight = 3.5,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "M3GreaseGun.jpg"},
    { id = 10,  weight = 4.7,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "MP40.jpg"},
    { id = 11,  weight = 4.9,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Thompson1928.jpg"},
    { id = 12,  weight = 4.8,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "M1A1Thompson.jpg"},
    { id = 13,  weight = 3.3,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Beretta38A.jpg"},
    { id = 14,  weight = 11.5,  type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "MG42.jpg"},
    { id = 15,  weight = 4.3,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "M1Garand.jpg"},
    { id = 16,  weight = 0.007, type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "38Special.jpg"},
    { id = 17,  weight = 3.9,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Kar98k.jpg"},
    { id = 18,  weight = 0.012, type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "45ACP.jpg"},
    { id = 19,  weight = 0.01,  type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "357magnum.jpg"},
    { id = 20,  weight = 0.017, type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "12mm.jpg"},
    { id = 21,  weight = 1.0,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Molotov.jpg"},
    { id = 22,  weight = 0.0,   type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "9x19mm.jpg"},
    { id = 23,  weight = 0.012, type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "7,92x57mm.jpg"},
    { id = 24,  weight = 0.01,  type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "7,62x63mm.jpg"},
/* ---------------------------------------------------------------FOOD/DRUNK--------------------------------------------------------------------------------------- */
    /*{ id = 25,  weight = 0.01,  type = ITEM_TYPE.FOOD,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
    { id = 26,  weight = 0.01,  type = ITEM_TYPE.FOOD,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
    { id = 27,  weight = 0.01,  type = ITEM_TYPE.DRUNK,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
    { id = 28,  weight = 0.01,  type = ITEM_TYPE.FOOD,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
    { id = 29,  weight = 0.01,  type = ITEM_TYPE.FOOD,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
    { id = 30,  weight = 0.01,  type = ITEM_TYPE.DRUNK,    stackable = true,  maxstack = 0, expiration = 0, img = ""},*/
];



function getIdxFromID(id){
    foreach (idx, value in items) {
            if(value.id == fid.tointeger()){
                return value.id;
            }
        }
}

function getItemImageById (itemid) {
    local idx = getIdxFromID(itemid);
    return items[itemid].img;
}

function getItemWeigtById (itemid) {
    local idx = getIdxFromID(itemid);
    return items[itemid].weight;
}

function getItemTypeById (itemid) {
    local idx = getIdxFromID(itemid);
    return items[itemid].type;
}

function isItemStackable (itemid) {
    local idx = getIdxFromID(itemid);
    return items[itemid].stackable;
}



/*
local itemsDescription = [

];
 */

local weaponsProp = [
    { id = 2,  capacity = 6},
    { id = 3,  capacity = 10},
    { id = 4,  capacity = 7},
    { id = 5,  capacity = 23},
    { id = 6,  capacity = 6},
    { id = 7,  capacity = 1},
    { id = 8,  capacity = 8},
    { id = 9,  capacity = 30},
    { id = 10, capacity = 32},
    { id = 11, capacity = 50},
    { id = 12, capacity = 30},
    { id = 13, capacity = 30},
    { id = 14, capacity = 100},
    { id = 15, capacity = 8},
    { id = 17, capacity = 5},
    { id = 21, capacity = 1},
];

local ammoProp = [
];