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
    { id = 0,   weight = 0.0,   type = ITEM_TYPE.NONE,    stackable = false,  img = "none.jpg"},
    { id = 1,   weight = 0.0,   type = ITEM_TYPE.OTHER,   stackable = true,   img = "money.jpg"},
    { id = 2,   weight = 0.5,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Model 12 Revolver.jpg"},
    { id = 3,   weight = 1.2,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Mauser C96.jpg"},
    { id = 4,   weight = 1.1,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Colt M1911A1.jpg"},
    { id = 5,   weight = 1.5,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Colt M1911 Special.jpg"},
    { id = 6,   weight = 0.9,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Model 19 Revolver.jpg"},
    { id = 7,   weight = 0.6,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "MK2 Frag Grenade.jpg"},
    { id = 8,   weight = 3.6,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Remington Model 870 Field gun.jpg"},
    { id = 9,   weight = 3.5,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "M3 Grease Gun.jpg"},
    { id = 10,  weight = 4.7,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "MP40.jpg"},
    { id = 11,  weight = 4.9,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Thompson 1928.jpg"},
    { id = 12,  weight = 4.8,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "M1A1 Thompson.jpg"},
    { id = 13,  weight = 3.3,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Beretta Model 38A.jpg"},
    { id = 14,  weight = 11.5,  type = ITEM_TYPE.WEAPON,  stackable = false,  img = "MG42.jpg"},
    { id = 15,  weight = 4.3,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "M1 Garand.jpg"},
    { id = 16,  weight = 0.0,   type = ITEM_TYPE.AMMO,    stackable = true,  img = ""},
    { id = 17,  weight = 3.9,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Kar98k.jpg"},
    { id = 18,  weight = 0.0,   type = ITEM_TYPE.AMMO,    stackable = true,  img = ""},
    { id = 19,  weight = 0.0,   type = ITEM_TYPE.AMMO,    stackable = true,  img = ""},
    { id = 20,  weight = 0.0,   type = ITEM_TYPE.AMMO,    stackable = true,  img = ""},
    { id = 21,  weight = 1.0,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Molotov Cocktail.jpg"},

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