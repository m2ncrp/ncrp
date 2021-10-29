local coef = 8;
local goods = {

    "empirediner" : {
        title = "Empire Diner",
        type  = "empirediner",
        items = [
            { itemName = "Item.MasterBeer",         price = 0.53 * coef },
            { itemName = "Item.CoffeeCup",          price = 0.08 * coef },
            { itemName = "Item.Sandwich",           price = 0.17 * coef },
            { itemName = "Item.Burger",             price = 0.12 * coef },
            { itemName = "Item.Hotdog",             price = 0.17 * coef },
            { itemName = "Item.Donut",              price = 0.10 * coef },
            { itemName = "Item.Cola",               price = 0.04 * coef },
        ]
    },

    "maltesefalcon" : {
        title = "Maltese Falcon",
        type  = "maltesefalcon",
        items = [
            { itemName = "Item.OldEmpiricalBeer",   price = 0.54 * coef },
            { itemName = "Item.StoltzBeer",         price = 0.64 * coef },
            { itemName = "Item.MasterBeer",         price = 0.60 * coef },
            { itemName = "Item.Wine",               price = 0.80 * coef },
            { itemName = "Item.Whiskey",            price = 0.78 * coef },
            { itemName = "Item.Brandy",             price = 0.83 * coef },
            { itemName = "Item.CoffeeCup",          price = 0.20 * coef },
        ]
    },

    "stellasdiner" : {
        title = "Stella's Diner",
        type  = "stellasdiner",
        items = [
            { itemName = "Item.Cola",               price = 0.04 * coef },
            { itemName = "Item.Hotdog",             price = 0.18 * coef },
            { itemName = "Item.Sandwich",           price = 0.19 * coef },
            { itemName = "Item.CoffeeCup",          price = 0.18 * coef },
            { itemName = "Item.Gyros",              price = 0.23 * coef },
            { itemName = "Item.StoltzBeer",         price = 0.54 * coef },
        ]
    },


    "lonestar" : {
        title = "The Lone Star",
        type  = "lonestar",
        items = [
            { itemName = "Item.OldEmpiricalBeer",   price = 0.42 * coef },
            { itemName = "Item.CoffeeCup",          price = 0.08 * coef },
            { itemName = "Item.Brandy",             price = 0.73 * coef },
            { itemName = "Item.MasterBeer",         price = 0.47 * coef },
            { itemName = "Item.StoltzBeer",         price = 0.43 * coef },
            { itemName = "Item.Whiskey",            price = 0.68 * coef },
        ]
    },

    "dragstrip" : {
        title = "The Dragstrip",
        type  = "dragstrip",
        items = [
            { itemName = "Item.CoffeeCup",          price = 0.10 * coef },
            { itemName = "Item.OldEmpiricalBeer",   price = 0.50 * coef },
            { itemName = "Item.Wine",               price = 0.65 * coef },
            { itemName = "Item.Whiskey",            price = 0.80 * coef },
            { itemName = "Item.Brandy",             price = 0.85 * coef },
        ]
    },

    "steaksnchops" : {
        title = "Steaks & Chops",
        type  = "steaksnchops",
        items = [
            { itemName = "Item.MasterBeer",         price = 0.47 * coef },
            { itemName = "Item.CoffeeCup",          price = 0.06 * coef },
            { itemName = "Item.Sandwich",           price = 0.17 * coef },
            { itemName = "Item.Burger",             price = 0.13 * coef },
            { itemName = "Item.Hotdog",             price = 0.18 * coef },
            { itemName = "Item.Cola",               price = 0.04 * coef },
        ]
    },

    "freddysbar" : {
        title = "Freddy's Bar",
        type  = "freddysbar",
        items = [
            { itemName = "Item.OldEmpiricalBeer",   price = 0.53 * coef },
            { itemName = "Item.Whiskey",            price = 0.73 * coef },
            { itemName = "Item.Brandy",             price = 0.86 * coef },
            { itemName = "Item.StoltzBeer",         price = 0.65 * coef },
            { itemName = "Item.MasterBeer",         price = 0.57 * coef },
            { itemName = "Item.Wine",               price = 0.70 * coef },
            { itemName = "Item.CoffeeCup",          price = 0.12 * coef },
        ]
    },

    "hilloftara" : {
        title = "Hill of Tara",
        type  = "hilloftara",
        items = [
            { itemName = "Item.OldEmpiricalBeer",   price = 0.45 * coef },
            { itemName = "Item.CoffeeCup",          price = 0.08 * coef },
            { itemName = "Item.StoltzBeer",         price = 0.55 * coef },
            { itemName = "Item.MasterBeer",         price = 0.49 * coef },
            { itemName = "Item.Whiskey",            price = 0.75 * coef },
            { itemName = "Item.Wine",               price = 0.60 * coef },
            { itemName = "Item.Brandy",             price = 0.71 * coef },
        ]
    },

    "monalisa" : {
        title = "The Mona Lisa",
        type  = "monalisa",
        items = [
            { itemName = "Item.Brandy",             price = 0.78 * coef },
            { itemName = "Item.Whiskey",            price = 0.78 * coef },
            { itemName = "Item.Wine",               price = 0.70 * coef },
            { itemName = "Item.OldEmpiricalBeer",   price = 0.52 * coef },
            { itemName = "Item.CoffeeCup",          price = 0.18 * coef },
        ]
    },

    "kiosk" : {
        title = "News Stand",
        type  = "kiosk",
        items = [
            //{ itemName = "Item.Newspaper",          price = 0.05},
            { itemName = "Item.Dice",               price = 0.50 },
            { itemName = "Item.BigBreakRed",        price = 2.50 },
            { itemName = "Item.BigBreakBlue",       price = 1.65 },
            { itemName = "Item.BigBreakWhite",      price = 0.90 },
            { itemName = "Item.Cola",               price = 0.05 * coef },
            { itemName = "Item.MasterBeer",         price = 0.55 * coef },
            { itemName = "Item.StoltzBeer",         price = 0.58 * coef },
        ]
    },

    "fuelStation" : {
        title = "Мини-маркет при автозаправке",
        type  = "fuelStation",
        items = [
            { itemName = "Item.Jerrycan",           price = 14.0 },
            { itemName = "Item.RepairKit",          price = 3.0 },
        ]
    },




    // Ирландцы
    "clothes_kingston": {
        title = "Dipton Apparel",
        type = "clothes_kingston",
        items = [
            { itemName = "Item.Clothes", amount = 81, price = 150.0 },
            { itemName = "Item.Clothes", amount = 83, price = 180.0 },
            { itemName = "Item.Clothes", amount = 84, price = 175.0 },
            { itemName = "Item.Clothes", amount = 85, price = 200.0 },
        ]
    },

    "clothes_kingston_z": {
        title = "Dipton Apparel",
        type = "clothes_kingston_z",
        items = [
            { itemName = "Item.Clothes", amount = 87, price = 60.0 },
            { itemName = "Item.Clothes", amount = 88, price = 160.0 },
            { itemName = "Item.Clothes", amount = 162, price = 140.0 },
        ]
    },

    //3 Обычная одежда
    "clothes_uptown": {
        title = "Dipton Apparel",
        type = "clothes_uptown",
        items = [
            { itemName = "Item.Clothes", amount = 80, price = 210.0 },
            { itemName = "Item.Clothes", amount = 89, price = 230.0 },
            { itemName = "Item.Clothes", amount = 109, price = 190.0 },
            { itemName = "Item.Clothes", amount = 111, price = 160.0 },
        ]
    },

    "clothes_uptown_z": {
        title = "Dipton Apparel",
        type = "clothes_uptown_z",
        items = [
            { itemName = "Item.Clothes", amount = 117, price = 210.0 },
            { itemName = "Item.Clothes", amount = 120, price = 150.0 }, //woman
            { itemName = "Item.Clothes", amount = 121, price = 130.0 }, //woman
            { itemName = "Item.Clothes", amount = 122, price = 140.0 }, //woman
        ]
    },

    //5 Обычная одежда
    "clothes_littleitaly1": {
        title = "Dipton Apparel",
        type = "clothes_littleitaly1",
        items = [
            { itemName = "Item.Clothes", amount = 97,  price = 260.0 },
            { itemName = "Item.Clothes", amount = 99,  price = 270.0 },
            { itemName = "Item.Clothes", amount = 100, price = 260.0 },
            { itemName = "Item.Clothes", amount = 108, price = 270.0 },
        ]
    },

    "clothes_littleitaly1_z": {
        title = "Dipton Apparel",
        type = "clothes_littleitaly1_z",
        items = [
            { itemName = "Item.Clothes", amount = 91,  price = 275.0 },
            { itemName = "Item.Clothes", amount = 94,  price = 275.0 },
            { itemName = "Item.Clothes", amount = 106, price = 275.0 },
            { itemName = "Item.Clothes", amount = 107, price = 275.0 },
        ]
    },

    //6 Центр, лучше предыдущей
    "clothes_eastside": {
        title = "Dipton Apparel",
        type = "clothes_eastside",
        items = [
            { itemName = "Item.Clothes", amount = 147, price = 120.0 },
            { itemName = "Item.Clothes", amount = 148, price = 120.0 },
            { itemName = "Item.Clothes", amount = 149, price = 120.0 },
            { itemName = "Item.Clothes", amount = 135, price = 140.0 }, //woman
            { itemName = "Item.Clothes", amount = 138, price = 140.0 }, //woman
            { itemName = "Item.Clothes", amount = 118, price = 120.0 }, //woman
            { itemName = "Item.Clothes", amount = 119, price = 130.0 }, //woman

        ]
    },

    "clothes_eastside_z": {
        title = "Dipton Apparel",
        type = "clothes_eastside_z",
        items = [
            { itemName = "Item.Clothes", amount = 137, price = 150.0 }, //woman
            { itemName = "Item.Clothes", amount = 139, price = 150.0 }, //woman
        ]
    },

    //7 Азиаты
    "clothes_chinatown": {
        title = "Dipton Apparel",
        type = "clothes_chinatown",
        items = [
            { itemName = "Item.Clothes", amount = 48, price = 250.0 },
            { itemName = "Item.Clothes", amount = 49, price = 250.0 },
            { itemName = "Item.Clothes", amount = 50, price = 270.0 },
            { itemName = "Item.Clothes", amount = 51, price = 150.0 },
            { itemName = "Item.Clothes", amount = 52, price = 150.0 },
            { itemName = "Item.Clothes", amount = 53, price = 110.0 },
            { itemName = "Item.Clothes", amount = 56, price = 150.0 }, // woman
            { itemName = "Item.Clothes", amount = 57, price = 160.0 }, // woman

        ]
    },

    "clothes_chinatown_z": {
        title = "Dipton Apparel",
        type = "clothes_chinatown_z",
        items = [
            { itemName = "Item.Clothes", amount = 164, price = 140.0 },
            { itemName = "Item.Clothes", amount = 58,  price = 130.0 }, // woman
            { itemName = "Item.Clothes", amount = 59,  price = 130.0 }, // woman
        ]
    },

    //8 Азиаты
    "clothes_oysterbay1": {
        title = "Dipton Apparel",
        type = "clothes_oysterbay1",
        items = [
            { itemName = "Item.Clothes", amount = 48, price = 250.0 },
            { itemName = "Item.Clothes", amount = 49, price = 250.0 },
            { itemName = "Item.Clothes", amount = 50, price = 270.0 },
            { itemName = "Item.Clothes", amount = 51, price = 150.0 },
            { itemName = "Item.Clothes", amount = 52, price = 150.0 },
            { itemName = "Item.Clothes", amount = 53, price = 110.0 },
            { itemName = "Item.Clothes", amount = 56, price = 150.0 }, // woman
            { itemName = "Item.Clothes", amount = 57, price = 160.0 }, // woman

        ]
    },

    "clothes_oysterbay1_z": {
        title = "Dipton Apparel",
        type = "clothes_oysterbay1_z",
        items = [
            { itemName = "Item.Clothes", amount = 164, price = 140.0 },
            { itemName = "Item.Clothes", amount = 58,  price = 130.0 }, // woman
            { itemName = "Item.Clothes", amount = 59,  price = 130.0 }, // woman
        ]
    },

    //9 Бриолинщики
    "clothes_briolins": {
        title = "Dipton Apparel",
        type = "clothes_briolins",
        items = [
            { itemName = "Item.Clothes", amount = 123, price = 220.0 },
            { itemName = "Item.Clothes", amount = 124, price = 220.0 },
            { itemName = "Item.Clothes", amount = 125, price = 220.0 },
            { itemName = "Item.Clothes", amount = 126, price = 220.0 },
            { itemName = "Item.Clothes", amount = 127, price = 220.0 },

        ]
    },

    "clothes_briolins_z": {
        title = "Dipton Apparel",
        type = "clothes_briolins_z",
        items = [
            { itemName = "Item.Clothes", amount = 123, price = 220.0 },
            { itemName = "Item.Clothes", amount = 124, price = 220.0 },
            { itemName = "Item.Clothes", amount = 125, price = 220.0 },
            { itemName = "Item.Clothes", amount = 126, price = 220.0 },
            { itemName = "Item.Clothes", amount = 127, price = 220.0 },
        ]
    },

    //10 Венджел
    "clothes_vangels": {
        title = "Vangel's",
        type = "clothes_vangels",
        items = [
            { itemName = "Item.Clothes", amount = 73,  price = 450.0 },
            { itemName = "Item.Clothes", amount = 74,  price = 450.0 },
            { itemName = "Item.Clothes", amount = 96,  price = 500.0 },
            { itemName = "Item.Clothes", amount = 101, price = 450.0 },
            { itemName = "Item.Clothes", amount = 102, price = 450.0 },
            { itemName = "Item.Clothes", amount = 103, price = 450.0 },
            { itemName = "Item.Clothes", amount = 104, price = 450.0 },

        ]
    },

    "clothes_vangels_z": {
        title = "Vangel's",
        type = "clothes_vangels_z",
        items = [
            { itemName = "Item.Clothes", amount = 90, price = 220.0 },
            { itemName = "Item.Clothes", amount = 92, price = 220.0 },
            { itemName = "Item.Clothes", amount = 93, price = 220.0 },
            { itemName = "Item.Clothes", amount = 95, price = 220.0 },
            { itemName = "Item.Clothes", amount = 141, price = 220.0 }, // woman
            { itemName = "Item.Clothes", amount = 143, price = 220.0 }, // woman
        ]
    },

    //11 Рабочие
    "clothes_southport": {
        title = "Dipton Apparel",
        type = "clothes_southport",
        items = [
            { itemName = "Item.Clothes", amount = 77,  price = 40.0 }, // азиат
            { itemName = "Item.Clothes", amount = 78,  price = 40.0 }, // негр
            { itemName = "Item.Clothes", amount = 79,  price = 40.0 }, // азиат
            { itemName = "Item.Clothes", amount = 129, price = 30.0 }, // негр
            { itemName = "Item.Clothes", amount = 131, price = 30.0 }, // европеец
            { itemName = "Item.Clothes", amount = 134, price = 30.0 }, // европеец
        ]
    },

    "clothes_southport_z": {
        title = "Dipton Apparel",
        type = "clothes_southport_z",
        items = [
            { itemName = "Item.Clothes", amount = 77,  price = 40.0 }, // азиат
            { itemName = "Item.Clothes", amount = 78,  price = 40.0 }, // негр
            { itemName = "Item.Clothes", amount = 79,  price = 40.0 }, // азиат
            { itemName = "Item.Clothes", amount = 129, price = 30.0 }, // негр
            { itemName = "Item.Clothes", amount = 131, price = 30.0 }, // европеец
            { itemName = "Item.Clothes", amount = 134, price = 30.0 }, // европеец
        ]
    },

    //12 Обычная одежда
    "clothes_westside": {
        title = "Dipton Apparel",
        type = "clothes_westside",
        items = [
            { itemName = "Item.Clothes", amount = 80,  price = 210.0 },
            { itemName = "Item.Clothes", amount = 89,  price = 230.0 },
            { itemName = "Item.Clothes", amount = 109, price = 190.0 },
            { itemName = "Item.Clothes", amount = 111, price = 160.0 },
            { itemName = "Item.Clothes", amount = 140, price = 160.0 }, // woman
            { itemName = "Item.Clothes", amount = 142, price = 160.0 }, // woman
        ]
    },

    "clothes_westside_z": {
        title = "Dipton Apparel",
        type = "clothes_westside_z",
        items = [
            { itemName = "Item.Clothes", amount = 91,  price = 275.0 },
            { itemName = "Item.Clothes", amount = 94,  price = 275.0 },
            { itemName = "Item.Clothes", amount = 106, price = 275.0 },
            { itemName = "Item.Clothes", amount = 107, price = 275.0 },
        ]
    },

    //13 Чернокожие
    "clothes_negros": {
        title = "Dipton Apparel",
        type = "clothes_negros",
        items = [
            { itemName = "Item.Clothes", amount = 39, price = 150.0 },
            { itemName = "Item.Clothes", amount = 40, price = 150.0 },
            { itemName = "Item.Clothes", amount = 41, price = 150.0 },
            { itemName = "Item.Clothes", amount = 42, price = 130.0 },
            { itemName = "Item.Clothes", amount = 43, price = 130.0 },
            { itemName = "Item.Clothes", amount = 44, price = 110.0 },
            { itemName = "Item.Clothes", amount = 47, price = 130.0 }, // woman
        ]
    },

    "clothes_negros_z": {
        title = "Dipton Apparel",
        type = "clothes_negros_z",
        items = [
            { itemName = "Item.Clothes", amount = 45,  price = 160.0 },
            { itemName = "Item.Clothes", amount = 163, price = 140.0 },
            { itemName = "Item.Clothes", amount = 70,  price = 150.0 },
        ]
    },
}


local gunshopTemplatesItems = [

        [
            { itemName = "Item.Revolver",       price = 62.99 + (random(-5, 5)).tofloat() },
            { itemName = "Item.Ammo38Special",  price = 2.49 + (random(-5, 5).tofloat() / 10) },
            { itemName = "Item.Magnum",         price = 149.99 + (random(-20, 20)).tofloat() },
            { itemName = "Item.Ammo357Magnum",  price = 4.25 + (random(-8, 8).tofloat() / 10) },
            { itemName = "Item.Remington870",   price = 399.99 + (random(-50, 50)).tofloat() },
            { itemName = "Item.Ammo12",         price = 9.99 + (random(-12, 12).tofloat() / 4) },
        ],
        [
            { itemName = "Item.Revolver",       price = 62.99 + (random(-5, 5)).tofloat() },
            { itemName = "Item.Ammo38Special",  price = 2.49 + (random(-5, 5).tofloat() / 10) },
            { itemName = "Item.Colt",           price = 122.99 + (random(-10, 10)).tofloat() },
            { itemName = "Item.Ammo45ACP",      price = 4.99 + (random(-10, 10).tofloat() / 5) },
            { itemName = "Item.M1Garand",       price = 249.99 + (random(-35, 35)).tofloat() },
            { itemName = "Item.Ammo762x63mm",   price = 2.49 + (random(-5, 5).tofloat() / 10) },
            { itemName = "Item.Remington870",   price = 399.99 + (random(-50, 50)).tofloat() },
            { itemName = "Item.Ammo12",         price = 9.99 + (random(-12, 12).tofloat() / 4) },
        ],
        [
            { itemName = "Item.Colt",           price = 122.99 + (random(-10, 10)).tofloat() },
            { itemName = "Item.Ammo45ACP",      price = 4.99 + (random(-10, 10).tofloat() / 5) },
            { itemName = "Item.Magnum",         price = 149.99 + (random(-20, 20)).tofloat() },
            { itemName = "Item.Ammo357Magnum",  price = 4.25 + (random(-8, 8).tofloat() / 10) },
            { itemName = "Item.M1Garand",       price = 249.99 + (random(-35, 35)).tofloat() },
            { itemName = "Item.Ammo762x63mm",   price = 2.49 + (random(-5, 5).tofloat() / 10) },
        ],
        [
            { itemName = "Item.Revolver",       price = 62.99 + (random(-5, 5)).tofloat() },
            { itemName = "Item.Ammo38Special",  price = 2.49 + (random(-5, 5).tofloat() / 10) },
            { itemName = "Item.Colt",           price = 122.99 + (random(-10, 10)).tofloat() },
            { itemName = "Item.Ammo45ACP",      price = 4.99 + (random(-10, 10).tofloat() / 5) },
            { itemName = "Item.Magnum",         price = 149.99 + (random(-20, 20)).tofloat() },
            { itemName = "Item.Ammo357Magnum",  price = 4.25 + (random(-8, 8).tofloat() / 10) },
        ],
        [
            { itemName = "Item.Revolver",       price = 62.99 + (random(-5, 5)).tofloat() },
            { itemName = "Item.Ammo38Special",  price = 2.49 + (random(-5, 5).tofloat() / 10) },
            { itemName = "Item.M1Garand",       price = 249.99 + (random(-35, 35)).tofloat() },
            { itemName = "Item.Ammo762x63mm",   price = 2.49 + (random(-5, 5).tofloat() / 10) },
            { itemName = "Item.Remington870",   price = 399.99 + (random(-50, 50)).tofloat() },
            { itemName = "Item.Ammo12",         price = 9.99 + (random(-12, 12).tofloat() / 4) },
        ]
]

local gunshopTemplatesItemsAvailable = [0, 1, 2, 3, 4];

function addGunShopRandom() {

    for (local i = 1; i <= 5; i++) {
        local index = random(0, gunshopTemplatesItemsAvailable.len() - 1);
        local id = i;
        goods["gunshop_"+id] <- {
                title = "Gun Shop",
                type  = "gunshop_"+id,
                items = gunshopTemplatesItems[gunshopTemplatesItemsAvailable[index]]
        }
        gunshopTemplatesItemsAvailable.remove(index);
    }
}

addGunShopRandom();


function getMarketGoods(name) {

    switch(name) {
        case "clothes_littleitaly2":
        case "clothes_oysterbay2":
            name = "clothes_briolins";
        break;
        case "clothes_greenfield":
            name = "clothes_kingston";
        break;
        case "clothes_hunterspoint":
        case "clothes_sandisland":
            name = "clothes_negros";
        break;
    }

    if (isSummer() == false && name.find("clothes") != null) {
        if(name.find("_z") == null) {
            name = name+"_z";
        }
    }

    return goods[name];
}
