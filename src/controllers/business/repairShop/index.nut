include("controllers/business/repairShop/translations.nut");
include("controllers/business/repairShop/translations-cyr.nut");

local TITLE_DRAW_DISTANCE = 10.0;
local FUEL_RADIUS = 2.0;
local FUEL_UNLOAD_RADIUS = 25.0;

const FUEL_STATION_LIMIT = 1000.0;

local JERRYCAN_COST = 14.0;
local JERRYCAN_BUY_RADIUS = 4.0;

local FUELUP_SPEED = 2.5; // gallons in second
local FUEL_UNLOAD_SPEED = 20; // gallons in second

local FUELSTATION_PREFIX = "RepairShop-";
local FUELSTATION_COLOR = CL_RIPELEMON;

local trucksOnQueue = [];

function formatLitres(value) {
    return format("%.2f %s", value, declOfNum(value, ["литр", "литра", "литров"]));
}

function formatGallons(value) {
    return format("%.2f %s", value, declOfNum(value, ["галлон", "галлона", "галлонов"]));
}

function formatGallonsInteger(value) {
    local int = round(value, 0);
    return format("%d %s", int, declOfNum(int, ["галлон", "галлона", "галлонов"]));
}

local coords = {
    LittleItalyEast = {
        //        x1       y1       x2       y2
        zone = [343.581, 867.025, 326.252, 894.221],
        shop = [337.074, 882.845, -21.3066],
        private = [338.46, 879.9, -21.3066],
        public = [338.56, 872.179, -21.1526],
        unload = [334.355, 888.863, -21.337, -90.0]
    },
    OysterBay = {
        //        x1       y1       x2       y2
        zone = [558.744, -10.2085, 528.876, 10.7221],
        shop = [540.608,  0.800032,   -18.2491],
        private = [543.457, 2.20028, -18.2491],
        public = [551.154, 2.33366, -18.1063],
        unload = [534.794, -7.68394, -18.2765, -90.0]
    },
    EastSide = {
        //        x1       y1       x2       y2
        zone = [ 119.714, 168.771, 93.9342, 191.275],
        shop = [104.56,   179.68,     -20.0394],
        private = [107.501, 181.021, -20.0394],
        public = [115.146, 181.259, -19.8966],
        unload = [100.756, 171.258, -20.0475, -90.0]
    },
    WestSide = {
        //        x1       y1       x2       y2
        zone = [-642.384, -61.7181, -623.472, -27.4613],
        shop = [-631.844, -41.1716,   0.922398],
        private = [-630.55, -44.1097, 0.922344],
        public = [-630.299, -51.715, 1.06515],
        unload = [-634.465, -34.3056, 0.87535, -90.0]
    },
    LittleItalyWest = {
        //        x1       y1       x2       y2
        zone = [-137.525, 622.545, -156.566, 589.827],
        shop = [-148.361, 602.842,    -20.1886],
        private = [-149.762, 605.793, -20.1887],
        public = [-149.94, 613.368, -20.0459],
        unload = [-146.274, 596.469, -20.2397, 90.0]
    },
    Dipton = {
        //        x1       y1       x2       y2
        zone = [-697.765, 1774.44, -717.798, 1742.44],
        shop = [-708.623, 1755.18,    -15.0062],
        private = [-710.023, 1758.18, -15.0063],
        public = [-710.17, 1765.73, -14.902],
        unload = [-706.763, 1748.45, -15.031, 90.0]
    },
    Greenfield = {
        //        x1       y1       x2       y2
        zone = [-1603.73, 954.813, -1572.45, 933.205],
        shop = [-1584.6,  944.037,    -5.2064],
        private = [-1587.52, 942.637, -5.20645],
        public = [-1595.19, 942.496, -5.06366],
        unload = [-1578.33, 947.078, -5.23681, 0.0]
    },
    SandIsland = {
        //        x1       y1       x2       y2
        zone = [-1666.35, -244.487, -1697.43, -222.688],
        shop = [-1687.41, -233.401,   -20.328],
        private = [-1684.44, -232.014, -20.3281],
        public = [-1676.81, -231.85, -20.1853],
        unload = [-1693.75, -236.703, -20.3643, 180.0]
    }
}

    // canister or load
    // [ -590.481, -5894.12, -6.93749], // LH-CentraIsland
    // [  1332.21, -3831.19, 32.2895], // LH-HotelClark
    // [ -995.144, -6044.87, -5.22449], // LH-WorksQuarter
    // [  690.747, -5943.18, 8.33174], // LH-Downtown

local repairShops = {};
// кеш заправки на персонажа, т.к. на двух одновременно он быть не может.
local repairShopCache = {};

function loadRepairShop(shop) {
    repairShops[shop.name] <- shop;
}

function getRepairShops() {
    return repairShops;
}

function getRepairShopEntity(name) {
    return repairShops[name];
}

function getRepairShopCoords(shop) {
    return shop.name in coords ? coords[shop.name] : null;
}

function getRepairShopCoordsByName(name) {
    return name in coords ? coords[name] : null;
}

function getRepairShopState(shop) {
    return shop.state;
}

addEventHandlerEx("onServerStarted", function() {
    logStr("[shops] loading fuel shops and canister shops...");

    foreach (name, shop in coords) {
        createPlace(format("%s%s", FUELSTATION_PREFIX, name), shop.zone[0], shop.zone[1], shop.zone[2], shop.zone[3]);
    }
});

event("onServerPlayerStarted", function(playerid) {

    foreach (name, shop in coords) {
        createPrivate3DText ( playerid, shop.public[0], shop.public[1], shop.public[2]+0.35, [[ "FUELSTATION", name.toupper()], "%s | %s"], CL_CHESTNUT, TITLE_DRAW_DISTANCE);

        createPrivate3DText ( playerid, shop.shop[0], shop.shop[1], shop.shop[2]+0.35, plocalize(playerid, "CANISTER"), CL_RIPELEMON, JERRYCAN_BUY_RADIUS);
        createPrivate3DText ( playerid, shop.shop[0], shop.shop[1], shop.shop[2]+0.20, [[ "3dtext.job.press.E", "PRICE"], "%s | %s: $"+JERRYCAN_COST ], CL_WHITE.applyAlpha(150), 1.0);
    }

});

event("onPlayerPlaceEnter", function(playerid, name) {
    if (name.find(FUELSTATION_PREFIX) == null) {
        return;
    }

    local shop = getRepairShopEntity(name.slice(FUELSTATION_PREFIX.len()));
    repairShopCreatePrivateInteractions(playerid, shop);
});

event("onPlayerPlaceExit", function(playerid, name) {
    if (name.find(FUELSTATION_PREFIX) == null) {
        return;
    }

    local shop = getRepairShopEntity(name.slice(FUELSTATION_PREFIX.len()));
    repairShopRemovePrivateInteractions(playerid, shop);
});

function repairShopCreatePrivateInteractions(playerid, shop) {
    local shopState = getRepairShopState(shop);

    local charid = getCharacterIdFromPlayerId(playerid);
    if(!(charid in repairShopCache)) {
        repairShopCache[charid] <- {};
    }

    repairShopCache[charid].name <- shop.name;

    local shopCoords = getRepairShopCoords(shop);

    // Внезависимости от состояния, если это владелец - показать приватный 3д текст
    if(charid == shop.ownerid) {
        repairShopCache[charid].owner <- createPrivate3DText(playerid, shopCoords.private[0], shopCoords.private[1], shopCoords.private[2]+0.35, plocalize(playerid, "property.3dtext.private"), CL_CHESTNUT, FUEL_RADIUS);
        repairShopCache[charid].ownerSubtitle <- createPrivate3DText(playerid, shopCoords.private[0], shopCoords.private[1], shopCoords.private[2]+0.20, plocalize(playerid, "property.3dtext.press.E"), CL_WHITE.applyAlpha(150), 1.0);
        privateKey(playerid, "e", "repairShopManage", repairShopManage);
    }

    local texts = {
        opened = {
            subTitle = plocalize(playerid, "business.3dtext.repairShop.press.E", [shop.data.fuel.price])
        },
        closed = {
            subTitle = plocalize(playerid, "property.3dtext.closed")
        },
        onsale = {
            subTitle = plocalize(playerid, "property.3dtext.onsale")
        }
    }

    // Добавим публичный текст
    repairShopCache[charid].subTitle <- createPrivate3DText(playerid, shopCoords.public[0], shopCoords.public[1], shopCoords.public[2], texts[shopState].subTitle, CL_WHITE.applyAlpha(150), FUEL_RADIUS);

    // Для бензовоза на разгрузку
    if(shopState == "opened") {
        if(isPlayerInVehicle(playerid) && shop.data.fuel.amountIn > 0) {
            local vehicleid = getPlayerVehicle(playerid);
            local veh = getVehicleEntity(vehicleid);
            if(!veh) return;
            local modelid = veh.model;
            if(modelid == 5 && getMaxGallonsReadyToBuy(shop, veh) >= 1) {
                repairShopCache[charid].unload <- createPrivate3DText(playerid, shopCoords.unload[0], shopCoords.unload[1], shopCoords.unload[2]+0.35, plocalize(playerid,"business.3dtext.repairShop.unload"), CL_RIPELEMON, FUEL_UNLOAD_RADIUS);
                repairShopCache[charid].unloadSubtitle <- createPrivate3DText(playerid, shopCoords.unload[0], shopCoords.unload[1], shopCoords.unload[2], plocalize(playerid, "property.3dtext.press.E"), CL_WHITE.applyAlpha(150), FUEL_RADIUS);
                privateKey(playerid, "e", "fuelTruckUnload", fuelTruckUnload);
            }
        }

        // Привяжем приватные бинды
        logStr("registering "+shop.name)
        privateKey(playerid, "e", "fuelJerrycanBuy", fuelJerrycanBuy);
        privateKey(playerid, "e", "fuelVehicleOrJerrycanUp", fuelVehicleOrJerrycanUp);
    }

    if(shopState == "onsale") {
        privateKey(playerid, "e", "repairShopOnSale", repairShopOnSale);
    }
}

function repairShopOnSale(playerid) {
    local charid = getCharacterIdFromPlayerId(playerid);
    local shopName = getRepairShopCache(charid).name;

    if(!shopName) return;

    local shopCoords = getRepairShopCoordsByName(shopName);

    if (!isInRadius(playerid, shopCoords.public[0], shopCoords.public[1], shopCoords.public[2], FUEL_RADIUS) ) {
        return;
    }

    local shop = getRepairShopEntity(shopName);

    if(charid == shop.ownerid) {
               msg(playerid, "Вы - владелец этой автозаправки.", CL_SUCCESS);
        /*return*/ msg(playerid, "Управление автозаправкой находится внутри помещения.", CL_GRAY);
    }

    local amount = (shop.ownerid == -1) ? shop.baseprice : getRepairShopSalePrice(shop);

    msgh(playerid, "Покупка автозаправки", [
        "Вы можете приобрести эту автозаправку.",
        format("На балансе: $ %.2f", shop.data.money),
        format("Неплаченный налог: $ %.2f", shop.data.tax),
        format("Цена: $ %.2f", shop.ownerid == -1 ? shop.baseprice : shop.saleprice),
        format("Итого: $ %.2f", amount),
        "Купить: /biz buy"
    ]);
}

cmd("biz", "buy", function(playerid) {
    //return msg(playerid, "Покупка бизнеса сейчас недоступна. Попробуйте позже.", CL_HELP);

    local charid = getCharacterIdFromPlayerId(playerid);
    local shopName = getRepairShopCache(charid).name;

    if(!shopName) {
               msg(playerid, "Не удалось определить приобретаемый бизнес.", CL_ERROR);
        return msg(playerid, "Возможно вы находитесь далеко от места покупки.", CL_GRAY);
    }

    local shopCoords = getRepairShopCoordsByName(shopName);

    if (!isInRadius(playerid, shopCoords.public[0], shopCoords.public[1], shopCoords.public[2], FUEL_RADIUS) ) {
        return;
    }

    local shop = getRepairShopEntity(shopName);

    if(charid == shop.ownerid) {
               msg(playerid, "Вы - владелец этой автозаправки.", CL_SUCCESS);
        return msg(playerid, "Управление автозаправкой находится внутри помещения.", CL_GRAY);
    }

    if(shop.state != "onsale") {
        return msg(playerid, "Эта автозаправка не продаётся в данный момент.", CL_ERROR);
    }

    if(!isPlayerAdmin(playerid) && isPlayerFractionMember(playerid, "gov")) {
        return msg(playerid, "business.repairShop.gov-declined", CL_ERROR);
    }

    local amount = (shop.ownerid == -1) ? shop.baseprice : getRepairShopSalePrice(shop);

    if (!canMoneyBeSubstracted(playerid, amount)) {
        return msg(playerid, "business.repairShop.money.notenough", [amount], CL_ERROR);
    }

    subPlayerMoney(playerid, amount);
    local sellerid = getPlayerIdFromCharacterId(shop.ownerid);

    if(shop.ownerid != -1) {
        if(sellerid != -1) {
            addPlayerDeposit(sellerid, amount);
            msg(sellerid, "business.repairShop.sold", [shop.name], CL_SUCCESS);
        } else {
            getOfflineCharacter(shop.ownerid, function(char) {
                char.deposit += amount;
                char.save();
            })
        }
    } else {
        addTreasuryMoney(amount);
    }

    shop.ownerid = charid;
    shop.purchaseprice = shop.saleprice;
    shop.saleprice = 0;
    shop.state = "closed";
    shop.save();

    msg(playerid, "business.repairShop.bought", CL_SUCCESS);
    msg(playerid, "Управление автозаправкой находится внутри помещения.", CL_GRAY);

    repairShopReloadPrivateInteractionsForAllAtStation(shop);

});

function getRepairShopSalePrice(shop) {
    return shop.saleprice + shop.data.money - shop.data.tax;
}

function getRepairShopSaleToCityPrice(shop) {
    return shop.baseprice * getSettingsValue("saleBizToCityCoef") - shop.data.tax;
}

/* Удалим приватные 3D тексты для персонажа по конкретной заправке */
function repairShopRemovePrivateInteractions(playerid, shop) {
    // Удалим 3d тексты
    local charid = getCharacterIdFromPlayerId(playerid);
    if(!(charid in repairShopCache)) {
        return;
    }

    foreach (key, hash in repairShopCache[charid]) {
        if(key == "name") continue;
        remove3DText(hash)
    }

    // Удалим приватные бинды
    logStr("unregistering "+shop.name)
    removePrivateKey(playerid, "e", "fuelJerrycanBuy");
    removePrivateKey(playerid, "e", "fuelVehicleOrJerrycanUp");
    removePrivateKey(playerid, "e", "fuelTruckUnload");
    removePrivateKey(playerid, "e", "repairShopManage");
    removePrivateKey(playerid, "e", "repairShopOnSale");

    delete repairShopCache[charid];
}

function repairShopReloadPrivateInteractions(playerid, shop) {
    repairShopRemovePrivateInteractions(playerid, shop);
    repairShopCreatePrivateInteractions(playerid, shop);
}

function repairShopReloadPrivateInteractionsForAllAtStation(shop) {

    foreach (playerid, player in players) {
        local charid = getCharacterIdFromPlayerId(playerid);

        if(!(charid in repairShopCache)) {
           continue;
        }

        if(repairShopCache[charid].name == shop.name) {
            repairShopReloadPrivateInteractions(playerid, shop)
        }

    }
}

// Jerrycan buy
function fuelJerrycanBuy(playerid) {
    local check = false;
    foreach (key, shop in coords) {
        if (isPlayerInValidPoint3D(playerid, shop.shop[0], shop.shop[1], shop.shop[2], 1.0 )) {
            check = true;
        }
    }
    if(!check) {
        return;
    }

    if (!canMoneyBeSubstracted(playerid, JERRYCAN_COST)) {
        return msg(playerid, "shops.canistershop.money.notenough", [JERRYCAN_COST], CL_ERROR);
    }

    if(!players[playerid].hands.isFreeSpace(1)) {
        return msg(playerid, "inventory.hands.busy", CL_ERROR);
    }

    msg(playerid, "shops.canistershop.bought", CL_CHESTNUT2);
    local canister = Item.Jerrycan();
    players[playerid].hands.push( canister);
    canister.save();
    players[playerid].hands.sync();
    subMoneyToPlayer(playerid, JERRYCAN_COST);
    addWorldMoney(JERRYCAN_COST);
}

function fuelVehicleUp(playerid) {
    // Проверка на расстояние выполняется в функции fuelVehicleOrJerrycanUp
    if(isPlayerVehicleMoving(playerid)) {
        return msg(playerid, "business.repairShop.stopyourmoves", CL_ERROR);
    }

    local vehicleid = getPlayerVehicle(playerid);
    local veh = getVehicleEntity(vehicleid);
    local charid = getCharacterIdFromPlayerId(playerid);
    local shopName = getRepairShopCache(charid).name;


    if(!isPlayerHaveVehicleKey(playerid, vehicleid) && (isVehicleCarRent(vehicleid) && getPlayerWhoRentVehicle(vehicleid) != charid)) {
        return msg(playerid, "business.repairShop.noaccess", CL_ERROR);
    }

    if(!isPlayerVehicleDriver(playerid)) {
        return msg(playerid, "business.repairShop.notdriver", CL_ERROR);
    }

    if(isVehicleEngineStarted(vehicleid)) {
        return msg(playerid, "business.repairShop.stopengine", CL_ERROR);
    }

    if (!isVehicleFuelNeeded(vehicleid)) {
        return msg(playerid, "business.repairShop.fueltank.full", CL_ERROR);
    }

    if(getVehicleState(vehicleid) == "fuelup") {
        return msg(playerid, "business.repairShop.fueltank.loading", CL_ERROR);
    }

    local shop = getRepairShopEntity(shopName);

    if(shop.data.fuel.amount == 0) {
        return msg(playerid, "business.repairShop.zero-fuel", CL_ERROR);
    }

    local gallons = round(getVehicleFuelNeed(vehicleid), 2);

    if(shop.data.fuel.amount < gallons) {
        gallons = shop.data.fuel.amount;
    }

    local cost = round(shop.data.fuel.price * gallons, 2);

    if(isVehicleCarRent(vehicleid)) {
        local veh = getVehicleEntity(vehicleid);

        if(shop.data.fuel.price > veh.data.rent.fuelPrice) {
            return msg(playerid, "rentcar.very-expensive-fuel", [veh.data.rent.fuelPrice], CL_ERROR);
        }

        if(veh.data.rent.money < cost) {
            return msg(playerid, "rentcar.notenoughbill", CL_ERROR);
        }
        veh.data.rent.money -= cost;
        veh.save();
    } else {
        if (!canMoneyBeSubstracted(playerid, cost) ) {
            return msg(playerid, "business.repairShop.money.notenough", [cost], CL_ERROR);
        }
        subPlayerMoney(playerid, cost);
    }

    local fuelupTime = (gallons / FUELUP_SPEED).tointeger();
    msg(playerid, "business.repairShop.loading", CL_CHESTNUT2);
    freezePlayer( playerid, true);
    setVehicleState(vehicleid, "fuelup");
    setVehicleEngineState(vehicleid, false);
    trigger(playerid, "hudCreateTimer", fuelupTime, true, true);

    shop.data.fuel.amount -= gallons;

    if("sold" in shop.data.fuel == false) {
        shop.data.fuel.sold <- 0;
    }
    shop.data.fuel.sold += gallons;

    local tax = getGovernmentValue("taxSales") * 0.01;
    local income = round(cost * (1 - tax), 2);
    shop.data.money += income;
    shop.data.tax += (cost - income);
    shop.save();

    delayedFunction(fuelupTime * 1000, function () {
        if(isPlayerConnected(playerid)) {
            freezePlayer( playerid, false);
            delayedFunction(1000, function () { freezePlayer( playerid, false); });
            msg(playerid, "business.repairShop.fuel.payed", [cost, formatGallons(gallons)], CL_CHESTNUT2);
        }
        setVehicleState(vehicleid, "free");
        setVehicleFuelEx(vehicleid, getVehicleFuelEx(vehicleid) + gallons);
    });
}


function fuelJerrycanUp(playerid) {
    // Проверка на расстояние выполняется в функции fuelVehicleOrJerrycanUp
    dbg("fuelJerrycanUp");

    local charid = getCharacterIdFromPlayerId(playerid);
    local shopName = getRepairShopCache(charid).name;

    if ( !players[playerid].hands.exists(0) || !players[playerid].hands.get(0) instanceof Item.Jerrycan) {
               msg(playerid, "canister.fuelup.needinhands", CL_ERROR);
               msg(playerid, "canister.fuelup.needinhands-help1", CL_GRAY);
        return msg(playerid, "canister.fuelup.needinhands-help2", CL_GRAY);
    }

    local jerrycanObj = players[playerid].hands.get(0);

    if(jerrycanObj.amount >= jerrycanObj.capacity) {
        return msg(playerid, "canister.fuelup.isfull", CL_ERROR);
    }

    local shop = getRepairShopEntity(shopName);

    if(shop.data.fuel.amount == 0) {
        return msg(playerid, "business.repairShop.zero-fuel", CL_ERROR);
    }

    local gallons = round(jerrycanObj.capacity - jerrycanObj.amount, 2);

    if(shop.data.fuel.amount < gallons) {
        gallons = shop.data.fuel.amount;
    }

    local cost = round(shop.data.fuel.price * gallons, 2);

    if(!canMoneyBeSubstracted(playerid, cost) ) {
        return msg(playerid, "canister.fuelup.money.notenough", [cost], CL_ERROR);
    }

    local fuelupTime = (gallons / FUELUP_SPEED).tointeger();

    msg(playerid, "business.repairShop.loading", CL_CHESTNUT2);
    freezePlayer(playerid, true);
    trigger(playerid, "hudCreateTimer", fuelupTime, true, true);
    players[playerid].inventory.blocked = true;
    delayedFunction(fuelupTime * 1000, function () {
        subPlayerMoney(playerid, cost);
        jerrycanObj.amount += gallons;
        jerrycanObj.save();

        local tax = getGovernmentValue("taxSales") * 0.01;
        local income = round(cost * (1 - tax), 2);
        shop.data.money += income;
        shop.data.tax += (cost - income);
        shop.data.fuel.amount -= gallons;

        if("sold" in shop.data.fuel == false) {
            shop.data.fuel.sold <- 0;
        }
        shop.data.fuel.sold += gallons;

        shop.save();

        players[playerid].inventory.blocked = false;
        msg(playerid, "canister.fuelup.filled", [formatGallons(gallons), cost], CL_CHESTNUT2);
        freezePlayer(playerid, false);

        players[playerid].hands.sync();
        delayedFunction(1000, function () { freezePlayer( playerid, false); });
    });
}

function fuelVehicleOrJerrycanUp(playerid) {
    if (!isNearRepairShop(playerid)) return;

    local charid = getCharacterIdFromPlayerId(playerid);
    local shopName = getRepairShopCache(charid).name;
    local shop = getRepairShopEntity(shopName);
    local shopState = getRepairShopState(shop);

    if(shopState != "opened") {
        return msg(playerid, "business.repairShop.closed", CL_ERROR);
    }

    if (isPlayerInVehicle(playerid) ) {
        fuelVehicleUp(playerid);
    } else {
        fuelJerrycanUp(playerid);
    }
}

function isNearRepairShop(playerid) {
    foreach (shop in coords) {
        if (isInRadius(playerid, shop.public[0], shop.public[1], shop.public[2], FUEL_RADIUS)) {
            return true;
        }
    }
    return false;
}

acmd( ["fuel"], "low", function( playerid ) {
    local vehicleid = getPlayerVehicle(playerid);
    return setVehicleFuel(vehicleid, 10.0);
});

function getRepairShopCache(charid) {
    return charid in repairShopCache ? repairShopCache[charid] : null;
}

function getMaxGallonsReadyToBuy(shop, veh) {
    local a = Math.min(Math.min(FUEL_STATION_LIMIT - shop.data.fuel.amount, shop.data.fuel.amountIn), veh.data.parts.cargo);
    if(shop.data.fuel.priceIn == 0.0) {
        return a;
    }
    return Math.min(a, shop.data.money / shop.data.fuel.priceIn);
}

function fuelTruckUnload(playerid) {

    local charid = getCharacterIdFromPlayerId(playerid);
    local shopName = getRepairShopCache(charid).name;

    if(!shopName) return;

    local shopCoords = getRepairShopCoordsByName(shopName);

    if (!isInRadius(playerid, shopCoords.unload[0], shopCoords.unload[1], shopCoords.unload[2], FUEL_RADIUS) ) {
        return;
    }

    if (!isPlayerInVehicle(playerid) || getVehicleModel(getPlayerVehicle(playerid)) != 5) {
        return msg(playerid, "business.repairShop.need-fuel-truck", CL_ERROR);
    }

    if(isPlayerVehicleMoving(playerid)) {
        return msg(playerid, "business.repairShop.stopyourmoves", CL_ERROR);
    }

    local vehicleid = getPlayerVehicle(playerid);
    local veh = getVehicleEntity(vehicleid);

    if(!isPlayerVehicleDriver(playerid)) {
        return msg(playerid, "business.repairShop.notdriver", CL_ERROR);
    }

    if(isVehicleEngineStarted(vehicleid)) {
        return msg(playerid, "business.repairShop.stopengine", CL_ERROR);
    }

    if(trucksOnQueue.find(veh.id) != null) {
        return;
    }

    if(getVehicleState(vehicleid) == "unloading") {
        return msg(playerid, "vehicle.state.unloading", CL_ERROR);
    }

    local shop = getRepairShopEntity(shopName);
    local shopState = getRepairShopState(shop);

    if(shopState != "opened") {
        return msg(playerid, "business.repairShop.closed", CL_ERROR);
    }

    local maxGallonsReadyToBuy = getMaxGallonsReadyToBuy(shop, veh);

    if(veh.data.parts.cargo == 0) {
        return msg(playerid, "business.repairShop.fueltruck.empty", CL_ERROR);
    }

    if(maxGallonsReadyToBuy < 1) {
        return msg(playerid, "business.repairShop.not-ready-to-buy", CL_ERROR);
    }

    if(shop.data.fuel.amount == FUEL_STATION_LIMIT) {
        return msg(playerid, "business.repairShop.full", CL_ERROR);
    }

    msg(playerid, "business.repairShop.enter-value-of-gallons-1", CL_RIPELEMON);
    msg(playerid, "business.repairShop.enter-value-of-gallons-2", [shop.data.fuel.priceIn], CL_RIPELEMON);
    msg(playerid, "business.repairShop.enter-value-of-gallons-hint", [1, maxGallonsReadyToBuy], CL_GRAY);

    local isEntered = false;

    // Поставить бензовоз в очередь получения действия от игрока
    trucksOnQueue.push(veh.id);

    delayedFunction(15000, function() {
        if (!isEntered) {
            msg(playerid, "business.repairShop.unloading-canceled");
            removeTruckFromUnloadingQueue(veh.id);
        }
    });

    trigger(playerid, "hudCreateTimer", 15.0, true, true);

    requestUserInput(playerid, function(playerid, text) {
        trigger(playerid, "hudDestroyTimer");

        if (!text || !isNumeric(text)) {
            return msg(playerid, "business.repairShop.invalid-enter", CL_ERROR);
        }

        isEntered = true;
        removeTruckFromUnloadingQueue(veh.id);

        if (!isInRadius(playerid, shopCoords.unload[0], shopCoords.unload[1], shopCoords.unload[2], FUEL_RADIUS) ) {
            return msg(playerid, "business.repairShop.toofar", CL_ERROR);
        }

        local gallons = text.tointeger();

        if(gallons > veh.data.parts.cargo) {
            // галонов больше, чем есть в бензовозе
            return msg(playerid, "business.repairShop.truck.no-enough-fuel", [formatGallons(gallons)], CL_ERROR);
        }

        local maxGallonsReadyToBuyNow = getMaxGallonsReadyToBuy(shop, veh);

        if(maxGallonsReadyToBuyNow < 1) {
            return msg(playerid, "business.repairShop.not-ready-to-buy", CL_ERROR);
        }

        if(gallons > maxGallonsReadyToBuyNow) {
            // галонов больше, чем заправка покупает или чем заправка может вместить
            return msg(playerid, "business.repairShop.ready-to-buy", [formatGallons(maxGallonsReadyToBuyNow)], CL_ERROR);
        }

        local amount = round(shop.data.fuel.priceIn * gallons, 2);

        // запомним персонажа
        local charid = getCharacterIdFromPlayerId(playerid);

        addPlayerMoney(playerid, amount);

        veh.data.parts.cargo -= gallons;
        veh.save();

        shop.data.money -= amount;
        shop.data.fuel.amountIn -= gallons;
        shop.data.fuel.amount += gallons;
        shop.save();

        blockDriving(playerid, vehicleid);
        setVehicleState(vehicleid, "unloading");
        setVehicleEngineState(vehicleid, false);

        local fuelUnloadSeconds = (gallons / FUEL_UNLOAD_SPEED).tointeger();
        msg(playerid, "vehicle.state.unloading", FUELSTATION_COLOR);
        msg(playerid, "business.repairShop.earned", [amount, formatGallons(gallons)], FUELSTATION_COLOR);

        trigger(playerid, "hudCreateTimer", fuelUnloadSeconds, true, true);
        delayedFunction(fuelUnloadSeconds * 1000, function () {
            // получим водителя, и разблочим бензовоз если водитель есть и персонаж совпадает с тем, кто иницировал загрузку
            local driverid = getVehicleDriver(vehicleid);
            if(driverid != null) {
                local currentCharid = getCharacterIdFromPlayerId(driverid);
                if(charid == currentCharid) {
                    unblockDriving(vehicleid);
                }
                msg(driverid, "vehicle.state.unloaded", FUELSTATION_COLOR);
            }
            setVehicleState(vehicleid, "free");
        });

    }, 15);
}