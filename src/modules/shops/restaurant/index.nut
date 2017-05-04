const MAX_HEALTH = 800.0;

local empirediner_prices = [ 2.67, 1.75, 0.62, 1.24 ];
local empirediner_items  = [ Item.Burger, Item.Hotdog, Item.Sandwich, Item.Cola ];

translation("en", {
    "shops.restaurant.toofar"               : "[INFO] You're too far."
    "shops.restaurant.money.notenough"      : "Not enough money to buy that."
    "shops.restaurant.buy.success"          : "You've successfuly bought items(s) for $%.2f."
});

event("native:shop:purchase", function(playerid, data) {
    local data = JSONParser.parse(data);
    if (data.type != "empirediner") return;
    if (!data.items.len()) return;

    local all_prices = clone(empirediner_prices); all_prices.reverse();
    local cur_prices = data.items.map(function(amount) {
        return all_prices.pop() * amount;
    })

    local price = cur_prices.reduce(@(total, price) fabs(total) + fabs(price));
    local count = data.items.reduce(@(a,b) abs(a) + abs(b));

    if (!canMoneyBeSubstracted(playerid, price)) {
        return msg(playerid, "shops.restaurant.money.notenough", CL_WARNING);
    }

    local items = [];

    foreach (j, amount in data.items) {
        for (local i = 0; i < amount; i++) {
            items.push(empirediner_items[j]());
        }
    }

    local weight = items.map(@(a) a.calculateWeight()).reduce(@(a, b) a + b);

    if (!players[playerid].inventory.isFreeSpace(count)) {
        return msg(playerid, "inventory.space.notenough", CL_WARNING);
    }

    if (!players[playerid].inventory.isFreeWeight(weight)) {
        return msg(playerid, "inventory.weight.notenough", CL_WARNING);
    }

    subMoneyToPlayer(playerid, price);
    addMoneyToTreasury(price);

    msg(playerid, "shops.restaurant.buy.success", [price], CL_SUCCESS);

    items.map(@(item) (players[playerid].inventory.push(item) || item.save()));
    players[playerid].inventory.sync();
});

event("native:shop:close", function(playerid, name) {
    players[playerid].inventory.hide(playerid);
});

key("e", function(playerid) {
    local bid = getBusinessNearPlayer(playerid);

    if (!bid) return;
    if (!(getBusinessType(bid) == 1) && !(getBusinessType(bid) == 2)) return;

    players[playerid].trigger("showShopGUI");
    players[playerid].inventory.show(playerid);
});
