/*
    removePlayerWeapon(playerid, weaponid);
    givePlayerWeapon(playerid, weaponid, bulletCount);
    getPlayerWeapon(playerid);
    getPlayerWeaponBullet(playerid);
*/

local weapons = {
    "0":  {
        "name": "Nothing",
        "bullet": 0,
        "maxBullet": 0,
    },
    "1":  {
        "name": "Hands",
        "bullet": 0,
        "maxBullet": 0,
    },
    "2":  {
        "name": "Revolver .38",
        "bullet": 6,
        "maxBullet": 36,
    },
    "3":  {
        "name": "Mauser C96",
        "bullet": 10,
        "maxBullet": 50,
    },
    "4":  {
        "name": "Colt M1911A1",
        "bullet": 7,
        "maxBullet": 49,
    },
    "5":  {
        "name": "Colt M1911 Special",
        "bullet": 23,
        "maxBullet": 69,
    },
    "6":  {
        "name": "Magnum",
        "bullet": 6,
        "maxBullet": 36,
    },
    "8":  {
        "name": "Remington 870",
        "bullet": 8,
        "maxBullet": 48,
    },
    "9":  {
        "name": "MP Grease Gun",
        "bullet": 30,
        "maxBullet": 90,
    },
    "10":  {
        "name": "MP-40",
        "bullet": 32,
        "maxBullet": 96,
    },
    "11":  {
        "name": "Thompson 1928",
        "bullet": 50,
        "maxBullet": 150,
    },
    "12":  {
        "name": "M1A1 Thompson",
        "bullet": 30,
        "maxBullet": 90,
    },
    "13":  {
        "name": "Beretta 38A",
        "bullet": 30,
        "maxBullet": 90,
    },
    "15":  {
        "name": "M1 Garand",
        "bullet": 8,
        "maxBullet": 32,
    },
    "17":  {
        "name": "Kar 98k",
        "bullet": 5,
        "maxBullet": 30,
    }
}

event("onPlayerWeaponShoot", function(playerid) {
    local weaponid = getPlayerWeapon(playerid);
    local weaponText = weapons[weaponid.tostring()].name;
    local bullets = getPlayerWeaponBullet(playerid);
    msg(playerid, format("Пиу: %s | %d -> %d", weaponText, bullets, bullets - 1))
})

event("onPlayerWeaponReload", function(playerid) {
    local weaponid = getPlayerWeapon(playerid);
    local weaponText = weapons[weaponid.tostring()].name;
    local bullets = getPlayerWeaponBullet(playerid);
    msg(playerid, format("Перезарядка: %s | %d", weaponText, bullets), CL_ERROR)
})

event("native:onPlayerChangeWeapon", function(playerid, weaponId, prevWeaponId) {
    if(weaponId == 0 || prevWeaponId == 0) return;
    local message = "";
    if(weaponId == 1) {
        message = format("убрал %s", weapons[prevWeaponId.tostring()].name);
    } else if(prevWeaponId == 1) {
        message = format("достал %s", weapons[weaponId.tostring()].name);
    } else {
        message = format("сменил %s на %s", weapons[prevWeaponId.tostring()].name, weapons[weaponId.tostring()].name)
    }

    sendLocalizedMsgToAll(playerid, "chat.player.me", [getKnownCharacterNameWithId, message], NORMAL_RADIUS, CL_CHAT_ME);
})

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

    subPlayerMoney(playerid, 25.0);
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

/*
itemID <- {};

itemID[  0 ] <- Item.None;
itemID[  1 ] <- Item.Clothes;

itemID[  2 ] <- Item.Revolver12;
itemID[  3 ] <- Item.MauserC96;
itemID[  4 ] <- Item.ColtM1911A1;
itemID[  5 ] <- Item.ColtM1911Spec;
itemID[  6 ] <- Item.Revolver19;
itemID[  7 ] <- Item.MK2;
itemID[  8 ] <- Item.Remington870;
itemID[  9 ] <- Item.M3GreaseGun;
itemID[ 10 ] <- Item.MP40;
itemID[ 11 ] <- Item.Thompson1928;
itemID[ 12 ] <- Item.M1A1Thompson;
itemID[ 13 ] <- Item.Beretta38A;
itemID[ 14 ] <- Item.MG42;
itemID[ 15 ] <- Item.M1Garand;

itemID[ 16 ] <- Item.Ammo38Special;
itemID[ 17 ] <- Item.Kar98k;
itemID[ 18 ] <- Item.Ammo45ACP;
itemID[ 19 ] <- Item.Ammo357magnum;
itemID[ 20 ] <- Item.Ammo12mm;
itemID[ 21 ] <- Item.Molotov;
itemID[ 22 ] <- Item.Ammo9x19mm;
itemID[ 23 ] <- Item.Ammo792x57mm;
itemID[ 24 ] <- Item.Ammo762x63mm;

tommy <- null;
acmd("addtommy", function(playerid) {
    local slot = findFreeSlot(playerid);

    if (slot == -1){
        return msg(playerid, "ERROR: no free slots", CL_ERROR);// no free slots
    }

    tommy = Item.Thompson1928();
    tommy.state  = ITEM_STATE.PLAYER_INV;
    tommy.amount = 6;
    tommy.parent = players[playerid].id;
    tommy.slot   = findFreeSlot(playerid);
    tommy.save();

    // dbg(tommy.classname);

    addPlayerItem(playerid, tommy);
});

acmd("giveitem",function(playerid, itemid = 0, amount = 0) {
    local slot = findFreeSlot(playerid);
    if(slot == -1){
        return msg(playerid, "ERROR: no free slots");// no free slots
    }

    local itemclass = itemID[itemid.tointeger()];
    local item = itemclass();
    item.state = ITEM_STATE.PLAYER_INV;
    item.amount = amount.tointeger();
    item.parent = players[playerid].id;
    item.slot  = slot;
    item.save();

    addPlayerItem(playerid, item);
});


*/


//{id, volume, type, stackable,img }

// local items = [
//     { id = 0,   volume = 0.0,   type = ITEM_TYPE.NONE,    stackable = false, maxstack = 0, expiration = 0, img = "none.jpg"},
//     { id = 1,   volume = 0.0,   type = ITEM_TYPE.OTHER,   stackable = false, maxstack = 0, expiration = 0, img = "money.jpg"},
// /* ---------------------------------------------------------------WEAPONS/AMMO--------------------------------------------------------------------------------------- */
//     { id = 2,   volume = 0.5,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "12Revolver.jpg"},
//     { id = 3,   volume = 1.2,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "MauserC96.jpg"},
//     { id = 4,   volume = 1.1,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "ColtM1911A1.jpg"},
//     { id = 5,   volume = 1.5,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "ColtM1911Spec.jpg"},
//     { id = 6,   volume = 0.9,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "19Revolver.jpg"},
//     { id = 7,   volume = 0.6,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "MK2.jpg"},
//     { id = 8,   volume = 3.6,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Remington870.jpg"},
//     { id = 9,   volume = 3.5,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "M3GreaseGun.jpg"},
//     { id = 10,  volume = 4.7,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "MP40.jpg"},
//     { id = 11,  volume = 4.9,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Thompson1928.jpg"},
//     { id = 12,  volume = 4.8,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "M1A1Thompson.jpg"},
//     { id = 13,  volume = 3.3,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Beretta38A.jpg"},
//     { id = 14,  volume = 11.5,  type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "MG42.jpg"},
//     { id = 15,  volume = 4.3,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "M1Garand.jpg"},
//     { id = 16,  volume = 0.007, type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "38Special.jpg"},
//     { id = 17,  volume = 3.9,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Kar98k.jpg"},
//     { id = 18,  volume = 0.012, type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "45ACP.jpg"},
//     { id = 19,  volume = 0.01,  type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "357magnum.jpg"},
//     { id = 20,  volume = 0.017, type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "12mm.jpg"},
//     { id = 21,  volume = 1.0,   type = ITEM_TYPE.WEAPON,  stackable = false, maxstack = 0, expiration = 0, img = "Molotov.jpg"},
//     { id = 22,  volume = 0.0,   type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "9x19mm.jpg"},
//     { id = 23,  volume = 0.012, type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "7,92x57mm.jpg"},
//     { id = 24,  volume = 0.01,  type = ITEM_TYPE.AMMO,    stackable = true,  maxstack = 0, expiration = 0, img = "7,62x63mm.jpg"},
// /* ---------------------------------------------------------------FOOD/DRUNK--------------------------------------------------------------------------------------- */
//     /*{ id = 25,  volume = 0.01,  type = ITEM_TYPE.FOOD,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
//     { id = 26,  volume = 0.01,  type = ITEM_TYPE.FOOD,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
//     { id = 27,  volume = 0.01,  type = ITEM_TYPE.DRUNK,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
//     { id = 28,  volume = 0.01,  type = ITEM_TYPE.FOOD,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
//     { id = 29,  volume = 0.01,  type = ITEM_TYPE.FOOD,    stackable = true,  maxstack = 0, expiration = 0, img = ""},
//     { id = 30,  volume = 0.01,  type = ITEM_TYPE.DRUNK,    stackable = true,  maxstack = 0, expiration = 0, img = ""},*/
// ];



// function getIdxFromID(id){
//     foreach (idx, value in items) {
//             if(value.id == id.tointeger()){
//                 return value.id;
//             }
//         }
// }

// function getItemImageById (itemid) {
//     local idx = getIdxFromID(itemid);
//     return items[itemid].img;
// }

// function getItemVolumeById (itemid) {
//     local idx = getIdxFromID(itemid);
//     return items[itemid].volume;
// }

// function getItemTypeById (itemid) {
//     local idx = getIdxFromID(itemid);
//     return items[itemid].type;
// }

// function isItemStackable (itemid) {
//     local idx = getIdxFromID(itemid);
//     return items[itemid].stackable;
// }



// /*
// local itemsDescription = [

// ];
//  */

// local weaponsProp = [
//     { id = 2,  capacity = },
//     { id = 3,  capacity = },
//     { id = 4,  capacity = },
//     { id = 5,  capacity = },
//     { id = 6,  capacity = },
//     { id = 7,  capacity = },
//     { id = 8,  capacity = },
//     { id = 9,  capacity = },
//     { id = 10, capacity = },
//     { id = 11, capacity = },
//     { id = 12, capacity = },
//     { id = 13, capacity = },
//     { id = 14, capacity = },
//     { id = 15, capacity = },
//     { id = 17, capacity = },
//     { id = 21, capacity = },
// ];

// local ammoProp = [
// ];
