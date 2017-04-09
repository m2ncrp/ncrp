const EAT_COST = 0.35;
const DRINK_COST = 0.15;
const MAX_HEALTH = 800.0;

translation("en", {
    "shops.restaurant.toofar"               : "[INFO] You're too far."
    "shops.restaurant.money.notenough"      : "Not enough money to buy that."
    "shops.restaurant.diner.eat.success"    : "You've spend $%.2f on diner."
    "shops.restaurant.bar.drink.success"    : "You've spend $%.2f for beer."
    // "shops.restaurant.diner.eat.success"    : "You've eaten some food (free)."
    // "shops.restaurant.bar.drink.success"    : "You've drunk some beer (free)."
});

/**
 * Some actions on call eat function call
 * @param  {[type]} playerid [description]
 * @return {[type]}          [description]
 */
function onEating(playerid) {
    subMoneyToPlayer(playerid, EAT_COST);
    addMoneyToTreasury(EAT_COST);
    msg(playerid, "shops.restaurant.diner.eat.success", [EAT_COST], CL_SUCCESS);
    // return setPlayerHealth(playerid, MAX_HEALTH);
    addPlayerHunger(playerid, randomf(30.0, 40.0));
}

/**
 * Some actions on call drink function call
 * @param  {[type]} playerid [description]
 * @return {[type]}          [description]
 */
function onDrinking(playerid) {
    subMoneyToPlayer(playerid, DRINK_COST);
    addMoneyToTreasury(DRINK_COST);
    msg(playerid, "shops.restaurant.bar.drink.success", [DRINK_COST], CL_SUCCESS);
    // setPlayerHealth(playerid, MAX_HEALTH);
    addPlayerThirst(playerid, randomf(30.0, 40.0));
}

// cmd("eat", function(playerid) {
//     local bid = getBusinessNearPlayer(playerid);

//     if ( getBusinessType(bid) == 1 ) {
//         if (canMoneyBeSubstracted(playerid, EAT_COST)) {
//             return onEating(playerid);
//         }
//         return msg(playerid, "shops.restaurant.money.notenough"); // !
//     } else {
//         return msg(playerid, "shops.restaurant.toofar");
//     }
// });

// cmd("drink", function(playerid) {
//     local bid = getBusinessNearPlayer(playerid);

//     if ( getBusinessType(bid) == 2 ) {
//         if (canMoneyBeSubstracted(playerid, DRINK_COST)) {
//             return onDrinking(playerid);
//         }
//         return msg(playerid, "shops.restaurant.money.notenough"); // !
//     } else {
//         return msg(playerid, "shops.restaurant.toofar");
//     }
// });

local empirediner_prices = [ 0.50, 0.10, 0.25, 0.50 ];
local empirediner_items  = [ Item.Burger, Item.Hotdog, Item.Sandwich, Item.Cola ];

event("native:shop:purchase", function(playerid, data) {
    local data = JSONParser.parse(data);
    if (data.type != "empirediner") return;

    local all_prices = clone(empirediner_prices); all_prices.reverse();
    local cur_prices = data.items.map(function(amount) {
        return all_prices.pop() * amount;
    })

    local price = cur_prices.reduce(@(total, price) fabs(total) + fabs(price));
    local count = data.items.reduce(@(a,b) abs(a) + abs(b));

    if (count > players[playerid].inventory.freelen()) {
        return msg(playerid, "shops.restaurant.space.notenough", CL_WARNING);
    }

    if (!canMoneyBeSubstracted(playerid, price)) {
        return msg(playerid, "shops.restaurant.money.notenough", CL_WARNING);
    }

    subMoneyToPlayer(playerid, price);
    addMoneyToTreasury(price);

    foreach (j, amount in data.items) {
        for (local i = 0; i < amount; i++) {
            local item = empirediner_items[j]();
            players[playerid].inventory.push(item);
            item.save();
        }
    }

    players[playerid].inventory.sync();

    // local all_items = clone(empirediner_items).reverse();

    // data.items.map(function(amount) {
    //     local item = all_items.pop();
    //     range(abs(amount)).map(function(i) {
    //         players[playerid].inventory.push(item());
    //     });
    // });
});

event("native:shop:close", function(playerid, name) {
    players[playerid].inventory.hide();
});

key("e", function(playerid) {
    local bid = getBusinessNearPlayer(playerid);

    if (!bid) return;

    players[playerid].trigger("showShopGUI");
    players[playerid].inventory.show();
});
