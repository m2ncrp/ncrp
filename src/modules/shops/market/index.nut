include("modules/shops/market/goods.nut");

const MAX_HEALTH = 800.0;

function selectShopAssortment(bizAlias) {
    local name = bizAlias;

    if( bizAlias.find("empirediner") != null) {
        name = "empirediner";
    }

    // if( bizAlias.find("gunshop") != null) {
    //     name = "gunshop";
    // }

    //if( bizAlias.find("clothes") != null) {
    //    name = "clothes";
    //}

    return JSONEncoder.encode(getMarketGoods(name));

}

translation("en", {
    "shops.restaurant.toofar"               : "[INFO] You're too far."
    "shops.restaurant.money.notenough"      : "Not enough money to buy that."
    "shops.needLTC"                         : "Show your LTC (in hands)"
    "shops.restaurant.buy.success"          : "You've successfuly bought %s for $%.2f."
});

event("native:shop:purchase", function(playerid, data) {

    local data = JSONParser.parse(data);
    local goods = getMarketGoods(data.type);
    local item = goods.items[data.itemIndex];
    local price = item.price;

    if (data.type == "gunshop") {
        if ( !players[playerid].hands.exists(0) || !players[playerid].hands.get(0) instanceof Item.LTC) {
            return msg(playerid, "shops.needLTC", CL_THUNDERBIRD);
        }
    }

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

    local volume = itemObject.calculateVolume();

    if (!players[playerid].inventory.isFreeVolume(volume)) {
        return msg(playerid, "inventory.volume.notenough", CL_WARNING);
    }

    subMoneyToPlayer(playerid, price);
    addWorldMoney(price);

    msg(playerid, "shops.restaurant.buy.success", [ plocalize(playerid, item.itemName), price ], CL_SUCCESS);

    if(itemObject.handsOnly) {
        players[playerid].hands.push(itemObject) || itemObject.save();
        players[playerid].hands.sync();
    } else {
        players[playerid].inventory.push(itemObject) || itemObject.save();
        players[playerid].inventory.sync();
    }

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
    if(bizAlias == "") return;

    local type = split(bizAlias, "_")[0];

    if(type == "gunshop") {

        if(hour < 10 || hour >= 20) {
                 msg(playerid, "interiors.gunshop.closed", CL_THUNDERBIRD);
          return msg(playerid, "interiors.gunshop.workinghours", CL_THUNDERBIRD);
        }

        msg(playerid, "en|shops.gunshop.weapon.canbuy"      );
        msg(playerid, "ru|shops.gunshop.weapon.warning"     );

        msg(playerid, "en|shops.gunshop.weapon.Revolver"    );
        msg(playerid, "en|shops.gunshop.weapon.MauserC96"   );
        msg(playerid, "en|shops.gunshop.weapon.Colt"        );
        msg(playerid, "en|shops.gunshop.weapon.ColtSpec"    );
        msg(playerid, "en|shops.gunshop.weapon.Magnum"      );
        msg(playerid, "en|shops.gunshop.weapon.Remington870");
        msg(playerid, "en|shops.gunshop.weapon.M3GreaseGun" );
        msg(playerid, "en|shops.gunshop.weapon.MP40"        );
        msg(playerid, "en|shops.gunshop.weapon.Thompson1928");
        msg(playerid, "en|shops.gunshop.weapon.M1A1Thompson");
        msg(playerid, "en|shops.gunshop.weapon.Beretta38A"  );
        msg(playerid, "en|shops.gunshop.weapon.M1Garand"    );
        msg(playerid, "en|shops.gunshop.weapon.Kar98k"      );
        msg(playerid, "ru|shops.gunshop.weapon.buy"         );
        return;
    }

    // logStr(bizAlias);
    players[playerid].trigger("showShopGUI", selectShopAssortment(bizAlias), getPlayerLocale(playerid));
    players[playerid].inventory.show(playerid);
});

cmd("gun", "buy", function(playerid, weaponid) {

    local bid = getBusinessNearPlayer(playerid);

    if (!bid) return;
    //if (!(getBusinessType(bid) == 1) && !(getBusinessType(bid) == 2)) return;

    local bizAlias = getBusinessAlias(bid);
    if(bizAlias == "") return;

    local type = split(bizAlias, "_")[0];

    if(type != "gunshop") return;

    if (!canMoneyBeSubstracted(playerid, 15.0)) {
        //triggerClientEvent(playerid, "hideCarShopGUI");
        return msg(playerid, "money.invoice.notenoughmoney", CL_ERROR);
    }

    weaponid = weaponid.tointeger();

    if([2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 15, 17].find(weaponid) == null) {
        return msg(playerid, "shops.gunshop.weapon.not", CL_ERROR);
    }

    subMoneyToPlayer(playerid, 15.0);
    givePlayerWeapon(playerid, weaponid.tointeger(), 200);

    msg(playerid, "shops.gunshop.weapon.bought", CL_SUCCESS);


});

alternativeTranslate({
    "en|shops.gunshop.weapon.canbuy"           : "You can buy any weapons from list:"
    "ru|shops.gunshop.weapon.canbuy"           : "Вы можете купить любое оружие из списка:"

    "en|shops.gunshop.weapon.warning"          : "Warning! Weapons are not saved between relogging and server restarts."
    "ru|shops.gunshop.weapon.warning"          : "Внимание! Оружие не сохраняется между переподключения и рестартами сервера."

    "en|shops.gunshop.weapon.buy"              : "Type to buy: /gun buy id"
    "ru|shops.gunshop.weapon.buy"              : "Купить: /gun buy id"

    "en|shops.gunshop.weapon.not"              : "No weapons with this id"
    "ru|shops.gunshop.weapon.not"              : "Нет оружия с таким id"

    "en|shops.gunshop.weapon.bought"           : "You bought weapon"
    "ru|shops.gunshop.weapon.bought"           : "Вы купили оружие"

    "en|shops.gunshop.weapon.Revolver"         : "2. Revolver .38"
    "en|shops.gunshop.weapon.MauserC96"        : "3. Mauser C96"
    "en|shops.gunshop.weapon.Colt"             : "4. Colt M1911A1"
    "en|shops.gunshop.weapon.ColtSpec"         : "5. Colt M1911 Special"
    "en|shops.gunshop.weapon.Magnum"           : "6. Magnum"
    "en|shops.gunshop.weapon.Remington870"     : "8. Remington 870"
    "en|shops.gunshop.weapon.M3GreaseGun"      : "9. MP Grease Gun"
    "en|shops.gunshop.weapon.MP40"             : "10. MP-40"
    "en|shops.gunshop.weapon.Thompson1928"     : "11. Thompson 1928"
    "en|shops.gunshop.weapon.M1A1Thompson"     : "12. M1A1 Thompson"
    "en|shops.gunshop.weapon.Beretta38A"       : "13. Beretta 38A"
    "en|shops.gunshop.weapon.M1Garand"         : "15. M1 Garand"
    "en|shops.gunshop.weapon.Kar98k"           : "17. Kar 98k"

    "ru|shops.gunshop.weapon.Revolver"         : "2. Revolver .38"
    "ru|shops.gunshop.weapon.MauserC96"        : "3. Mauser C96"
    "ru|shops.gunshop.weapon.Colt"             : "4. Colt M1911"
    "ru|shops.gunshop.weapon.ColtSpec"         : "5. Colt M1911 Special"
    "ru|shops.gunshop.weapon.Magnum"           : "6. Magnum"
    "ru|shops.gunshop.weapon.Remington870"     : "8. Remington 870"
    "ru|shops.gunshop.weapon.M3GreaseGun"      : "9. MP Grease Gun"
    "ru|shops.gunshop.weapon.MP40"             : "10. MP-40"
    "ru|shops.gunshop.weapon.Thompson1928"     : "11. Thompson 1928"
    "ru|shops.gunshop.weapon.M1A1Thompson"     : "12. M1A1 Thompson"
    "ru|shops.gunshop.weapon.Beretta38A"       : "13. Beretta 38A"
    "ru|shops.gunshop.weapon.M1Garand"         : "15. M1 Garand"
    "ru|shops.gunshop.weapon.Kar98k"           : "17. Kar 98k"
});