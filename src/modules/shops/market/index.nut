include("modules/shops/market/goods.nut");


const BUSINESS_BUY_DISTANCE      = 1.0;
const BUSINESS_VIEW_DISTANCE     = 5.0;
const BUSINESS_INTERACT_DISTANCE = 1.0;

local shops = [
    {
        "name": "Gun Shop (Southport)",
        "type": 3,
        "x": -323.175,
        "y": -589.111,
        "z": -20.1043,
        "alias": "gunshop"
    },
    {
        "name": "DIPTON APPAREL (Southport)",
        "type": 4,
        "x": -376.9,
        "y": -449.118,
        "z": -17.2661,
        "alias": "clothes_southport"
    },
    {
        "name": "Mona Lisa",
        "type": 2,
        "x": -639.048,
        "y": 350.089,
        "z": 1.34485,
        "alias": "monalisa"
    },
    {
        "name": "Gun Shop (Westside)",
        "type": 3,
        "x": -567.679,
        "y": 310.776,
        "z": 0.16808,
        "alias": "gunshop"
    },
    {
        "name": "DIPTON APPAREL (Westside)",
        "type": 4,
        "x": -627.173,
        "y": 291.272,
        "z": -0.26709,
        "alias": "clothes_westside"
    },
    {
        "name": "The Maltese Falcon (Midtown)",
        "type": 2,
        "x": 23.2583,
        "y": -74.7117,
        "z": -15.5834,
        "alias": "maltesefalcon"
    },
    {
        "name": "Gun Shop (East Side)",
        "type": 3,
        "x": 68.0516,
        "y": 139.686,
        "z": -14.4583,
        "alias": "gunshop"
    },
    {
        "name": "DIPTON APPAREL (East Side)",
        "type": 4,
        "x": -41.8942,
        "y": 389.17,
        "z": -13.9963,
        "alias": "clothes_eastside"
    },
    {
        "name": "DIPTON APPAREL (Little Italy)",
        "type": 4,
        "x": 271.814,
        "y": 774.975,
        "z": -21.2439,
        "alias": "clothes_littleitaly2"
    },
    {
        "name": "Gun Shop (Little Italy)",
        "type": 3,
        "x": -10.54,
        "y": 739.62,
        "z": -22.0582,
        "alias": "gunshop"
    },
    {
        "name": "DIPTON APPAREL (Uptown)",
        "type": 4,
        "x": -517.748,
        "y": 871.836,
        "z": -19.3224,
        "alias": "clothes_uptown"
    },
    {
        "name": "Gun Shop Army Navy (Kingston)",
        "type": 3,
        "x": -1306.45,
        "y": 1610.6,
        "z": 1.22659,
        "alias": "gunshop"
    },
    {
        "name": "Empire Diner (Kingston)",
        "type": 1,
        "x": -1582.23,
        "y": 1603.77,
        "z": -5.22507,
        "alias": "empirediner_kingston"
    },
    {
        "name": "Hill of Tara (Kingston)",
        "type": 2,
        "x": -1148.88,
        "y": 1589.56,
        "z": 6.25566,
        "alias": "hilloftara"
    },
    {
        "name": "Gun Shop (Kingston)",
        "type": 3,
        "x": -1182.98,
        "y": 1706.26,
        "z": 11.0941,
        "alias": "gunshop"
    },
    {
        "name": "DIPTON APPAREL (Kingston)",
        "type": 4,
        "x": -1295.73,
        "y": 1706.04,
        "z": 10.5592,
        "alias": "clothes_kingston"
    },
    {
        "name": "Gun Shop (RiverSide)",
        "type": 3,
        "x": -287.881,
        "y": 1627.6,
        "z": -23.0758,
        "alias": "gunshop"
    },
    {
        "name": "Empire Diner (Highbrook)",
        "type": 1,
        "x": -645.659,
        "y": 1296.7,
        "z": 3.94464,
        "alias": "empirediner_highbrook"
    },
    {
        "name": "Empire Diner (Oyster Bay)",
        "type": 1,
        "x": 142.779,
        "y": -429.708,
        "z": -19.429,
        "alias": "empirediner_oysterbay"
    },
    {
        "name": "Gun Shop (Oyster Bay Hill)",
        "type": 3,
        "x": 279.78,
        "y": -118.633,
        "z": -12.2741,
        "alias": "gunshop"
    },
    {
        "name": "DIPTON APPAREL (Oyster Bay)",
        "type": 4,
        "x": 412.535,
        "y": -291.014,
        "z": -20.1622,
        "alias": "clothes_oysterbay2"
    },
    {
        "name": "DIPTON APPAREL (Oyster Bay)",
        "type": 4,
        "x": 344.562,
        "y": 40.8297,
        "z": -24.1478,
        "alias": "clothes_oysterbay1"
    },
    {
        "name": "Gun Shop (Oyster Bay)",
        "type": 3,
        "x": 273.826,
        "y": -454.25,
        "z": -20.1636,
        "alias": "gunshop"
    },
    {
        "name": "Steaks & Chops (Sand Island)",
        "type": 1,
        "x": -1558.61,
        "y": -165.144,
        "z": -19.6113,
        "alias": "steaksnchops"
    },
    {
        "name": "DIPTON APPAREL (Sand Island)",
        "type": 4,
        "x": -1533.2,
        "y": 2.98646,
        "z": -17.8468,
        "alias": "clothes_sandisland"
    },
    {
        "name": "Gun Shop (Sand Island)",
        "type": 3,
        "x": -1394.95,
        "y": -32.7772,
        "z": -17.8468,
        "alias": "gunshop"
    },
    {
        "name": "DIPTON APPAREL (Hunters Point)",
        "type": 4,
        "x": -1376.94,
        "y": 386.225,
        "z": -23.7368,
        "alias": "clothes_hunterspoint"
    },
    {
        "name": "Bar Lone Star (Hunters Point)",
        "type": 2,
        "x": -1384.91,
        "y": 470.167,
        "z": -22.1321,
        "alias": "lonestar"
    },
    {
        "name": "Empire Diner (Greenfield)",
        "type": 1,
        "x": -1420.38,
        "y": 961.451,
        "z": -12.7543,
        "alias": "empirediner_greenfield"
    },
    {
        "name": "Illia's Bar",
        "type": 1,
        "x": -771.337,
        "y": -377.348,
        "z": -20.4072,
        "alias": "stellasdiner"
    },
    {
        "name": "Stella's Diner",
        "type": 1,
        "x": 240.014,
        "y": 708.524,
        "z": -24.0321,
        "alias": "stellasdiner"
    },
    {
        "name": "DragStrip",
        "type": 2,
        "x": 627.616,
        "y": 897.013,
        "z": -12.0138,
        "alias": "dragstrip"
    },
    {
        "name": "Freddy's Bar",
        "type": 2,
        "x": -51.0486,
        "y": 737.972,
        "z": -21.9009,
        "alias": "freddysbar"
    },
    {
        "name": "Empire Diner (Hunters Point)",
        "type": 1,
        "x": -1588.62,
        "y": 177.631,
        "z": -12.4393,
        "alias": "empirediner_hunterspoint"
    },
    {
        "name": "Stella's Diner",
        "type": 1,
        "x": -561.204,
        "y": 429.07,
        "z": 1.02075,
        "alias": "stellasdiner"
    },
    {
        "name": "DIPTON APPAREL (Greenfield)",
        "type": 4,
        "x": -1424.83,
        "y": 1296.62,
        "z": -13.7195,
        "alias": "clothes_greenfield"
    },
    {
        "name": "VANGEL'S",
        "type": 4,
        "x": -252.387,
        "y": -80.4043,
        "z": -11.458,
        "alias": "clothes_vangels"
    },
    {
        "name": "DIPTON APPAREL (Little Italy)",
        "type": 4,
        "x": -5.64809,
        "y": 560.374,
        "z": -19.4068,
        "alias": "clothes_littleitaly1"
    },
    {
        "name": "DIPTON APPAREL (Chinatown)",
        "type": 4,
        "x": 429.87,
        "y": 302.866,
        "z": -20.1786,
        "alias": "clothes_chinatown"
    },
    {
        "name": "Gun Shop (Little Italy East)",
        "type": 3,
        "x": 404.601,
        "y": 603.754,
        "z": -24.9746,
        "alias": "gunshop"
    }
]

local icons = {
    "1": ICON_BURGER,
    "2": ICON_BAR,
    "3": ICON_WEAPON,
    "4": ICON_CLOTHES,
}

event("onServerPlayerStarted", function(playerid) {

    foreach (idx, shop in shops) {
        if(shop.type == 3) continue;
        createPrivate3DText ( playerid, shop.x, shop.y, shop.z+0.35, shop.name, CL_RIPELEMON, BUSINESS_VIEW_DISTANCE);
        createPrivate3DText ( playerid, shop.x, shop.y, shop.z+0.15, plocalize(playerid, "3dtext.job.press.E"), CL_WHITE.applyAlpha(150), 1.0);
        createPrivateBlip( playerid, shop.x, shop.y, icons[shop.type.tostring()], 100.0 );
    }

});

/**
 * Search for the first business near player
 *
 * @param  {Integer} playerid
 * @return {Integer} business id
 */
function getBusinessNearPlayer(playerid) {
    foreach (bizid, biz in shops) {
        if (getDistanceToPoint(playerid, biz.x, biz.y, biz.z) <= BUSINESS_INTERACT_DISTANCE) {
            return bizid;
        }
    }

    return null;
}

/**
 * Get business alias
 * @param  {Integer}
 * @return {Float}
 */
function getBusinessAlias(bizid) {
    if (!(bizid in shops)) {
        return false;
    }

    return shops[bizid].alias;
}

function selectShopAssortment(bizAlias) {
    local name = bizAlias;

    if( bizAlias.find("empirediner") != null) {
        name = "empirediner";
    }

    if( bizAlias.find("gunshop") != null) {
        name = "gunshop";
    }

    // if( bizAlias.find("clothes") != null) {
    //     name = "clothes";
    // }

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

    if(item.itemName == "Item.Clothes") {
        itemObject.amount = item.amount;
    }

    local volume = itemObject.calculateVolume();

    if(itemObject.handsOnly) {
        if(!players[playerid].hands.isFreeSpace(1)) {
            return msg(playerid, "inventory.hands.busy", CL_WARNING);
        }
    } else if(!players[playerid].inventory.isFreeVolume(volume)) {
        return msg(playerid, "inventory.volume.notenough", CL_WARNING);
    }

    subPlayerMoney(playerid, price);
    addWorldMoney(price);

    if(data.type == "kiosk") {
      local kiosk = getKioskEntity(data.shop);
        if(!("purchases" in kiosk.data)) {
            kiosk.data.purchases <- 0;
            kiosk.data.income <- 0.0;
        }
      kiosk.data.purchases += 1;
      kiosk.data.income += price;
      kiosk.save();
    }

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

    if(!bid) return;
    //if (!(getBusinessType(bid) == 1) && !(getBusinessType(bid) == 2)) return;

    local bizAlias = getBusinessAlias(bid);
    if(bizAlias == "") return;
    if(bizAlias == "gunshop") return;

    local type = split(bizAlias, "_")[0];

    if(type == "gunshop") {

        if(!getSettingsValue("weaponsAvailable")) {
            return msg(playerid, "Приобретение оружия приостановлено администрацией сервера", CL_ERROR);
        }

        if(players[playerid].xp < 300) {
            return msg(playerid, "Вы отыграли меньше 5 часов, поэтому вам недоступно приобретение оружия.", CL_ERROR);
        }

        local hour = getHour();

        if(hour < 10 || hour >= 20) {
                 msg(playerid, "interiors.gunshop.closed", CL_THUNDERBIRD);
          return msg(playerid, "interiors.gunshop.workinghours", CL_THUNDERBIRD);
        }

        msg(playerid, "shops.gunshop.weapon.canbuy", CL_SUCCESS);
        msg(playerid, "shops.gunshop.weapon.warning", CL_ERROR);

        msg(playerid, "shops.gunshop.weapon.Revolver"    );
        msg(playerid, "shops.gunshop.weapon.Colt"        );
        msg(playerid, "shops.gunshop.weapon.Magnum"      );
        msg(playerid, "shops.gunshop.weapon.Remington870");
        msg(playerid, "shops.gunshop.weapon.M1Garand"    );
        msg(playerid, "shops.gunshop.weapon.Kar98k"      );
        msg(playerid, "shops.gunshop.weapon.buy"         );
        return;
    }

    // logStr(bizAlias);
    players[playerid].trigger("showShopGUI", selectShopAssortment(bizAlias), getPlayerLocale(playerid), "any");
    players[playerid].inventory.show(playerid);
});
