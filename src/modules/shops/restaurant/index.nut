const MAX_HEALTH = 800.0;

local coef = 7;
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
            { itemName = "Item.BigBreakRed",        price = 2.50 },
            { itemName = "Item.BigBreakBlue",       price = 1.65 },
            { itemName = "Item.BigBreakWhite",      price = 0.90 },
            { itemName = "Item.Cola",               price = 0.05 * coef },
            { itemName = "Item.MasterBeer",         price = 0.55 * coef },
            { itemName = "Item.StoltzBeer",         price = 0.58 * coef },
        ]
    },

/*
    "gunshop" : {
        title = "Fernando's Shop",
        type  = "gunshop",
        items = [
            { itemName = "Item.BigBreakRed",    price = 2.50 },
            { itemName = "Item.BigBreakBlue",   price = 1.65 },
            { itemName = "Item.BigBreakWhite",  price = 0.90 },
            { itemName = "Item.Whiskey", price = 7.25 },
        ]
    },
*/

}

function selectShopAssortment(bizAlias) {
    local name = bizAlias;

    if( bizAlias.find("empirediner") != null) {
        name = "empirediner";
    }

    if( bizAlias.find("gunshop") != null) {
        name = "gunshop";
    }

    if( bizAlias.find("clothes") != null) {
        name = "clothes";
    }

    return JSONEncoder.encode(goods[name]);

}


translation("en", {
    "shops.restaurant.toofar"               : "[INFO] You're too far."
    "shops.restaurant.money.notenough"      : "Not enough money to buy that."
    "shops.restaurant.buy.success"          : "You've successfuly bought %s for $%.2f."
});

event("native:shop:purchase", function(playerid, data) {
    local data = JSONParser.parse(data);

    local item = goods[data.type].items[data.itemIndex];
    local price = item.price;

    if (!canMoneyBeSubstracted(playerid, price)) {
        return msg(playerid, "shops.restaurant.money.notenough", CL_WARNING);
    }

    if (!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_WARNING);
    }

    // маленькая хитрость: отрезать «Item.» от значения поля item.itemName, оставив только имя предмета и вызвать, создав тем самым экземпляр класса
    // Пример: было "Item.Clothes", обрезаем до "Clothes", подставляем и вызываем
    local itemObject = Item[ item.itemName.slice(5) ]();

    local weight = itemObject.calculateWeight();

    if (!players[playerid].inventory.isFreeWeight(weight)) {
        return msg(playerid, "inventory.weight.notenough", CL_WARNING);
    }

    subMoneyToPlayer(playerid, price);
    addMoneyToTreasury(price);

    msg(playerid, "shops.restaurant.buy.success", [ plocalize(playerid, item.itemName), price ], CL_SUCCESS);

    players[playerid].inventory.push(itemObject) || itemObject.save();
    players[playerid].inventory.sync();

});


event("native:shop:close", function(playerid, name) {
    players[playerid].inventory.hide(playerid);
});

key("e", function(playerid) {
    local bid = getBusinessNearPlayer(playerid);

    if (!bid) return;
    //if (!(getBusinessType(bid) == 1) && !(getBusinessType(bid) == 2)) return;

    local bizAlias = getBusinessAlias(bid);
    // log(bizAlias);
    players[playerid].trigger("showShopGUI", selectShopAssortment(bizAlias), getPlayerLocale(playerid));
    players[playerid].inventory.show(playerid);
});
