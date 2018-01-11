include("modules/shops/market/goods.nut");

const MAX_HEALTH = 800.0;

function selectShopAssortment(bizAlias) {
    local name = bizAlias;

    if( bizAlias.find("empirediner") != null) {
        name = "empirediner";
    }

    if( bizAlias.find("gunshop") != null) {
        name = "gunshop";
    }

    //if( bizAlias.find("clothes") != null) {
    //    name = "clothes";
    //}

    return JSONEncoder.encode(getMarketGoods(name));

}


translation("en", {
    "shops.restaurant.toofar"               : "[INFO] You're too far."
    "shops.restaurant.money.notenough"      : "Not enough money to buy that."
    "shops.restaurant.buy.success"          : "You've successfuly bought %s for $%.2f."
});

event("native:shop:purchase", function(playerid, data) {

    local data = JSONParser.parse(data);
    local goods = getMarketGoods(data.type);
    local item = goods.items[data.itemIndex];
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

    if (item.itemName == "Item.Clothes") {
        itemObject.amount = item.amount;
    }

    local weight = itemObject.calculateWeight();

    if (!players[playerid].inventory.isFreeWeight(weight)) {
        return msg(playerid, "inventory.weight.notenough", CL_WARNING);
    }

    subMoneyToPlayer(playerid, price);
    addMoneyToTreasury(price);

    msg(playerid, "shops.restaurant.buy.success", [ plocalize(playerid, item.itemName), price ], CL_SUCCESS);

    players[playerid].inventory.push(itemObject) || itemObject.save();
    players[playerid].inventory.sync();

    dbg("[ MARKET ] "+getPlayerName(playerid)+" [ "+getAccountName(playerid)+" ] -> Bought "+localize(item.itemName)+" for "+ format("%.2f", price)+" dollars.");

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
