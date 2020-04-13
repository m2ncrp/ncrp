acmd("weapons-off", function(playerid) {
    setSettingsValue("weaponsAvailable", false);
    msg(playerid, "Продажа оружия выключена")
})

acmd("weapons-on", function(playerid) {
    setSettingsValue("weaponsAvailable", true);
    msg(playerid, "Продажа оружия включена")
})

cmd("gun", "buy", function(playerid, weaponid) {

    local bid = getBusinessNearPlayer(playerid);

    if (!bid) return;
    //if (!(getBusinessType(bid) == 1) && !(getBusinessType(bid) == 2)) return;

    local bizAlias = getBusinessAlias(bid);
    if(bizAlias == "") return;

    local type = split(bizAlias, "_")[0];

    if(type != "gunshop") return;

    if(!getSettingsValue("weaponsAvailable")) {
        return msg(playerid, "Приобретение оружия приостановлено администрацией сервера", CL_ERROR);
    }

	if(players[playerid].xp < 300) {
        return msg(playerid, "Вы отыграли меньше 5 часов, поэтому вам недоступно приобретение оружия.", CL_ERROR);
	}

    if (!canMoneyBeSubstracted(playerid, 25.0)) {
        //triggerClientEvent(playerid, "hideCarShopGUI");
        return msg(playerid, "money.invoice.notenoughmoney", CL_ERROR);
    }

    weaponid = weaponid.tointeger();

    if([2, 4, 6, 8, 15, 17].find(weaponid) == null) {
        return msg(playerid, "shops.gunshop.weapon.not", CL_ERROR);
    }

    subMoneyToPlayer(playerid, 25.0);
    givePlayerWeapon(playerid, weaponid.tointeger(), 200);
    trigger("onPlayerBoughtWeapon", playerid, weaponid);
    msg(playerid, "shops.gunshop.weapon.bought", CL_SUCCESS);


});

alternativeTranslate({
    "en|shops.gunshop.weapon.canbuy"           : "You can buy any weapons from list ($25):"
    "ru|shops.gunshop.weapon.canbuy"           : "Вы можете купить любое оружие из списка ($25):"

    "en|shops.gunshop.weapon.warning"          : "Warning! Weapons are not saved between relogging and server restarts."
    "ru|shops.gunshop.weapon.warning"          : "Внимание! Оружие НЕ сохраняется между переподключениями к серверу и рестартами сервера. Деньги не возвращаются. Это экспериментальная возможность."

    "en|shops.gunshop.weapon.buy"              : "Type to buy: /gun buy id"
    "ru|shops.gunshop.weapon.buy"              : "Купить: /gun buy id"

    "en|shops.gunshop.weapon.not"              : "No weapons with this id"
    "ru|shops.gunshop.weapon.not"              : "В продаже нет оружия с таким id"

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