include("controllers/business/fuelStations/translations.nut");
include("controllers/business/fuelStations/translations-cyr.nut");

local TITLE_DRAW_DISTANCE = 10.0;
local FUEL_RADIUS = 2.0;
local FUEL_UNLOAD_RADIUS = 25.0;

const FUEL_STATION_LIMIT = 500.0;

local FUELUP_SPEED = 2.5; // gallons in second
local FUEL_UNLOAD_SPEED = 20; // gallons in second

local FUELSTATION_PREFIX = "FuelStation-";
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

local fuelStations = {};
// кеш заправки на персонажа, т.к. на двух одновременно он быть не может.
local fuelStationCache = {};

function getFuelStationsCoords() {
    return coords;
}

function loadFuelStation(station) {
    fuelStations[station.name] <- station;
}

function getFuelStations() {
    return fuelStations;
}

function getFuelStationEntity(name) {
    return fuelStations[name];
}

function getFuelStationCoords(station) {
    return station.name in coords ? coords[station.name] : null;
}

function getFuelStationCoordsByName(name) {
    return name in coords ? coords[name] : null;
}

function isPlayerNearFuelStation(playerid) {
    local res = false;
    foreach (key, station in coords) {
        if (isPlayerInValidPoint3D(playerid, station.shop[0], station.shop[1], station.shop[2], 1.0)) {
            res = getFuelStationEntity(key);
            break;
        }
    }

    return res;
}

function getFuelStationState(station) {
    return station.state;
}

function removeTruckFromUnloadingQueue(vehid) {
    local index = trucksOnQueue.find(vehid);
    if(index != null) trucksOnQueue.remove(index);
}

addEventHandlerEx("onServerStarted", function() {
    logStr("[biz] loading fuel stations and canister shops...");

    foreach (name, station in coords) {
        createPlace(format("%s%s", FUELSTATION_PREFIX, name), station.zone[0], station.zone[1], station.zone[2], station.zone[3]);
    }
});

event("onServerPlayerStarted", function(playerid) {
    foreach (name, station in coords) {
        createPrivate3DText ( playerid, station.public[0], station.public[1], station.public[2]+0.35, [[ "FUELSTATION", name.toupper()], "%s | %s"], CL_CHESTNUT, TITLE_DRAW_DISTANCE);
    }
});

event("onPlayerAreaEnter", function(playerid, name) {
    if (name.find(FUELSTATION_PREFIX) == null) {
        return;
    }

    local station = getFuelStationEntity(name.slice(FUELSTATION_PREFIX.len()));
    fuelStationCreatePrivateInteractions(playerid, station);
});

event("onPlayerAreaLeave", function(playerid, name) {
    if (name.find(FUELSTATION_PREFIX) == null) {
        return;
    }

    local station = getFuelStationEntity(name.slice(FUELSTATION_PREFIX.len()));
    fuelStationRemovePrivateInteractions(playerid, station);
});

function fuelStationCreatePrivateInteractions(playerid, station) {
    local stationState = getFuelStationState(station);

    local charid = getCharacterIdFromPlayerId(playerid);
    if(!(charid in fuelStationCache)) {
        fuelStationCache[charid] <- {};
    }

    fuelStationCache[charid].name <- station.name;

    local stationCoords = getFuelStationCoords(station);

    // Внезависимости от состояния, если это владелец - показать приватный 3д текст
    if(charid == station.ownerid) {
        fuelStationCache[charid].owner <- createPrivate3DText(playerid, stationCoords.private[0], stationCoords.private[1], stationCoords.private[2]+0.35, plocalize(playerid, "property.3dtext.private"), CL_CHESTNUT, FUEL_RADIUS);
        fuelStationCache[charid].ownerSubtitle <- createPrivate3DText(playerid, stationCoords.private[0], stationCoords.private[1], stationCoords.private[2]+0.20, plocalize(playerid, "property.3dtext.press.E"), CL_WHITE.applyAlpha(150), 1.0);
        privateKey(playerid, "e", "fuelStationManage", fuelStationManage);
    }

    local texts = {
        opened = {
            subTitle = plocalize(playerid, "business.3dtext.fuelStation.press.E", [station.data.fuel.price])
        },
        closed = {
            subTitle = plocalize(playerid, "property.3dtext.closed")
        },
        onsale = {
            subTitle = plocalize(playerid, "property.3dtext.onsale")
        }
    }

    // Добавим публичный текст
    fuelStationCache[charid].subTitle <- createPrivate3DText(playerid, stationCoords.public[0], stationCoords.public[1], stationCoords.public[2], texts[stationState].subTitle, CL_WHITE.applyAlpha(150), FUEL_RADIUS);

    // Для бензовоза на разгрузку
    if(stationState == "opened") {
        if(isPlayerInVehicle(playerid) && station.data.fuel.amountIn > 0) {
            local vehicleid = getPlayerVehicle(playerid);
            local veh = getVehicleEntity(vehicleid);
            if(!veh) return;
            local modelid = veh.model;
            if(modelid == 5 && getMaxGallonsReadyToBuy(station, veh) >= 1) {
                fuelStationCache[charid].unload <- createPrivate3DText(playerid, stationCoords.unload[0], stationCoords.unload[1], stationCoords.unload[2]+0.35, plocalize(playerid,"business.3dtext.fuelStation.unload"), CL_RIPELEMON, FUEL_UNLOAD_RADIUS);
                fuelStationCache[charid].unloadSubtitle <- createPrivate3DText(playerid, stationCoords.unload[0], stationCoords.unload[1], stationCoords.unload[2], plocalize(playerid, "property.3dtext.press.E"), CL_WHITE.applyAlpha(150), FUEL_RADIUS);
                privateKey(playerid, "e", "fuelTruckUnload", fuelTruckUnload);
            }
        }

        // Привяжем приватные бинды
        logStr("registering "+station.name)
        privateKey(playerid, "e", "fuelStationMiniMarket", fuelStationMiniMarket);
        privateKey(playerid, "e", "fuelVehicleOrJerrycanUp", fuelVehicleOrJerrycanUp);
    }

    if(stationState == "onsale") {
        privateKey(playerid, "e", "fuelStationOnSale", fuelStationOnSale);
    }
}

function fuelStationOnSale(playerid) {
    local charid = getCharacterIdFromPlayerId(playerid);
    local stationName = getFuelStationCache(charid).name;

    if(!stationName) return;

    local stationCoords = getFuelStationCoordsByName(stationName);

    if (!isInRadius(playerid, stationCoords.public[0], stationCoords.public[1], stationCoords.public[2], FUEL_RADIUS) ) {
        return;
    }

    local station = getFuelStationEntity(stationName);

    if(charid == station.ownerid) {
               msg(playerid, "Вы - владелец этой автозаправки.", CL_SUCCESS);
        /*return*/ msg(playerid, "Управление автозаправкой находится внутри помещения.", CL_GRAY);
    }

    local amount = (station.ownerid == -1) ? station.baseprice : getFuelStationSalePrice(station);

    msgh(playerid, "Покупка автозаправки", [
        "Вы можете приобрести эту автозаправку.",
        format("На балансе: $ %.2f", station.data.money),
        format("Неплаченный налог: $ %.2f", station.data.tax),
        format("Цена: $ %.2f", station.ownerid == -1 ? station.baseprice : station.saleprice),
        format("Итого: $ %.2f", amount),
        "Купить: /biz buy"
    ]);
}

cmd("biz", "buy", function(playerid) {
    //return msg(playerid, "Покупка бизнеса сейчас недоступна. Попробуйте позже.", CL_HELP);

    local charid = getCharacterIdFromPlayerId(playerid);
    local stationName = getFuelStationCache(charid).name;

    if(!stationName) {
               msg(playerid, "Не удалось определить приобретаемый бизнес.", CL_ERROR);
        return msg(playerid, "Возможно вы находитесь далеко от места покупки.", CL_GRAY);
    }

    local stationCoords = getFuelStationCoordsByName(stationName);

    if (!isInRadius(playerid, stationCoords.public[0], stationCoords.public[1], stationCoords.public[2], FUEL_RADIUS) ) {
        return;
    }

    local station = getFuelStationEntity(stationName);

    if(charid == station.ownerid) {
               msg(playerid, "Вы - владелец этой автозаправки.", CL_SUCCESS);
        return msg(playerid, "Управление автозаправкой находится внутри помещения.", CL_GRAY);
    }

    if(station.state != "onsale") {
        return msg(playerid, "Эта автозаправка не продаётся в данный момент.", CL_ERROR);
    }

    if(!isPlayerAdmin(playerid) && isPlayerFractionMember(playerid, "gov")) {
        return msg(playerid, "business.fuelStation.gov-declined", CL_ERROR);
    }

    local amount = (station.ownerid == -1) ? station.baseprice : getFuelStationSalePrice(station);

    if (!canMoneyBeSubstracted(playerid, amount)) {
        return msg(playerid, "business.fuelStation.money.notenough", [amount], CL_ERROR);
    }

    subPlayerMoney(playerid, amount);
    local sellerid = getPlayerIdFromCharacterId(station.ownerid);

    if(station.ownerid != -1) {
        if(sellerid != -1) {
            addPlayerDeposit(sellerid, amount);
            msg(sellerid, "business.fuelStation.sold", [station.name], CL_SUCCESS);
        } else {
            getOfflineCharacter(station.ownerid, function(char) {
                char.deposit += amount;
                char.save();
            })
        }
    } else {
        addTreasuryMoney(amount);
    }

    station.ownerid = charid;
    station.purchaseprice = station.saleprice;
    station.saleprice = 0;
    station.state = "closed";
    station.save();

    msg(playerid, "business.fuelStation.bought", CL_SUCCESS);
    msg(playerid, "Управление автозаправкой находится внутри помещения.", CL_GRAY);

    fuelStationReloadPrivateInteractionsForAllAtStation(station);

});

function getFuelStationSalePrice(station) {
    return station.saleprice + station.data.money - station.data.tax;
}

function getFuelStationSaleToCityPrice(station) {
    return station.baseprice * getSettingsValue("saleBizToCityCoef") - station.data.tax;
}

/* Удалим приватные 3D тексты для персонажа по конкретной заправке */
function fuelStationRemovePrivateInteractions(playerid, station) {
    // Удалим 3d тексты
    local charid = getCharacterIdFromPlayerId(playerid);
    if(!(charid in fuelStationCache)) {
        return;
    }

    foreach (key, hash in fuelStationCache[charid]) {
        if(key == "name") continue;
        remove3DText(hash)
    }

    // Удалим приватные бинды
    logStr("unregistering "+station.name)
    removePrivateKey(playerid, "e", "fuelStationMiniMarket");
    removePrivateKey(playerid, "e", "fuelVehicleOrJerrycanUp");
    removePrivateKey(playerid, "e", "fuelTruckUnload");
    removePrivateKey(playerid, "e", "fuelStationManage");
    removePrivateKey(playerid, "e", "fuelStationOnSale");

    delete fuelStationCache[charid];
}

function fuelStationReloadPrivateInteractions(playerid, station) {
    fuelStationRemovePrivateInteractions(playerid, station);
    fuelStationCreatePrivateInteractions(playerid, station);
}

function fuelStationReloadPrivateInteractionsForAllAtStation(station) {

    foreach (playerid, player in players) {
        local charid = getCharacterIdFromPlayerId(playerid);

        if(!(charid in fuelStationCache)) {
           continue;
        }

        if(fuelStationCache[charid].name == station.name) {
            fuelStationReloadPrivateInteractions(playerid, station)
        }

    }
}

// Jerrycan buy
function fuelJerrycanBuy(playerid) {
    local check = false;
    foreach (key, station in coords) {
        if (isPlayerInValidPoint3D(playerid, station.shop[0], station.shop[1], station.shop[2], 1.0 )) {
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
    subPlayerMoney(playerid, JERRYCAN_COST);
    addWorldMoney(JERRYCAN_COST);
}

function fuelVehicleUp(playerid) {
    // Проверка на расстояние выполняется в функции fuelVehicleOrJerrycanUp
    if(isPlayerVehicleMoving(playerid)) {
        return msg(playerid, "business.fuelStation.stopyourmoves", CL_ERROR);
    }

    local vehicleid = getPlayerVehicle(playerid);
    local veh = getVehicleEntity(vehicleid);
    local charid = getCharacterIdFromPlayerId(playerid);
    local stationName = getFuelStationCache(charid).name;


    if(!isPlayerHaveVehicleKey(playerid, vehicleid) && (isVehicleCarRent(vehicleid) && getPlayerWhoRentVehicle(vehicleid) != charid)) {
        return msg(playerid, "business.fuelStation.noaccess", CL_ERROR);
    }

    if(!isPlayerVehicleDriver(playerid)) {
        return msg(playerid, "business.fuelStation.notdriver", CL_ERROR);
    }

    if(isVehicleEngineStarted(vehicleid)) {
        return msg(playerid, "business.fuelStation.stopengine", CL_ERROR);
    }

    if (!isVehicleFuelNeeded(vehicleid)) {
        return msg(playerid, "business.fuelStation.fueltank.full", CL_ERROR);
    }

    if(getVehicleState(vehicleid) == "fuelup") {
        return msg(playerid, "business.fuelStation.fueltank.loading", CL_ERROR);
    }

    local station = getFuelStationEntity(stationName);

    if(station.data.fuel.amount == 0) {
        return msg(playerid, "business.fuelStation.zero-fuel", CL_ERROR);
    }

    local gallons = round(getVehicleFuelNeed(vehicleid), 2);

    if(station.data.fuel.amount < gallons) {
        gallons = station.data.fuel.amount;
    }

    local cost = round(station.data.fuel.price * gallons, 2);

    if(isVehicleCarRent(vehicleid)) {
        local veh = getVehicleEntity(vehicleid);

        if(station.data.fuel.price > veh.data.rent.fuelPrice) {
            return msg(playerid, "rentcar.very-expensive-fuel", [veh.data.rent.fuelPrice], CL_ERROR);
        }

        if(veh.data.rent.money < cost) {
            return msg(playerid, "rentcar.notenoughbill", CL_ERROR);
        }
        veh.data.rent.money -= cost;
        veh.save();
    } else {
        if (!canMoneyBeSubstracted(playerid, cost) ) {
            return msg(playerid, "business.fuelStation.money.notenough", [cost], CL_ERROR);
        }
        subPlayerMoney(playerid, cost);
    }

    local fuelupTime = (gallons / FUELUP_SPEED).tointeger();
    msg(playerid, "business.fuelStation.loading", CL_CHESTNUT2);
    freezePlayer( playerid, true);
    setVehicleState(vehicleid, "fuelup");
    setVehicleEngineState(vehicleid, false);
    trigger(playerid, "hudCreateTimer", fuelupTime, true, true);

    station.data.fuel.amount -= gallons;

    if("sold" in station.data.fuel == false) {
        station.data.fuel.sold <- 0;
    }
    station.data.fuel.sold += gallons;

    local tax = getGovernmentValue("taxSales") * 0.01;
    local income = round(cost * (1 - tax), 2);
    station.data.money += income;
    station.data.tax += (cost - income);
    station.save();

    local fuelLevel = getVehicleFuelEx(vehicleid);
    local newFuelLevel = fuelLevel + gallons;

    logger.logf(
        join(["[VEHICLE FUEL UP]", "%s [%d] (%s)", "%s - %s (model: %d, vehid: %d)", "%s", "coords: [%.5f, %.5f, %.5f]", "haveKey: %s", "%.2f + %.2f = %.2f gallons"], "\n> "),
            getPlayerName(playerid),
            playerid,
            getAccountName(playerid),
            getVehiclePlateText(vehicleid),
            getVehicleNameByModelId(getVehicleModel(vehicleid)),
            getVehicleModel(vehicleid),
            vehicleid,
            getNearestTeleportFromVehicle(vehicleid).name,
            getVehiclePositionObj(vehicleid).x,
            getVehiclePositionObj(vehicleid).y,
            getVehiclePositionObj(vehicleid).z,
            isVehicleOwned(vehicleid) ? (isPlayerHaveVehicleKey(playerid, vehicleid) ? "true" : "false") : "city_ncrp",
            fuelLevel,
            gallons,
            newFuelLevel
    );

    delayedFunction(fuelupTime * 1000, function () {
        if(isPlayerConnected(playerid)) {
            freezePlayer( playerid, false);
            delayedFunction(1000, function () { freezePlayer( playerid, false); });
            msg(playerid, "business.fuelStation.fuel.payed", [cost, formatGallons(gallons)], CL_CHESTNUT2);
        }
        setVehicleState(vehicleid, "free");
        setVehicleFuelEx(vehicleid, newFuelLevel);
    });



}


function fuelJerrycanUp(playerid) {
    // Проверка на расстояние выполняется в функции fuelVehicleOrJerrycanUp
    dbg("fuelJerrycanUp");

    local charid = getCharacterIdFromPlayerId(playerid);
    local stationName = getFuelStationCache(charid).name;

    if ( !players[playerid].hands.exists(0) || !players[playerid].hands.get(0) instanceof Item.Jerrycan) {
               msg(playerid, "canister.fuelup.needinhands", CL_ERROR);
               msg(playerid, "canister.fuelup.needinhands-help1", CL_GRAY);
        return msg(playerid, "canister.fuelup.needinhands-help2", CL_GRAY);
    }

    local jerrycanObj = players[playerid].hands.get(0);

    if(jerrycanObj.amount >= jerrycanObj.capacity) {
        return msg(playerid, "canister.fuelup.isfull", CL_ERROR);
    }

    local station = getFuelStationEntity(stationName);

    if(station.data.fuel.amount == 0) {
        return msg(playerid, "business.fuelStation.zero-fuel", CL_ERROR);
    }

    local gallons = round(jerrycanObj.capacity - jerrycanObj.amount, 2);

    if(station.data.fuel.amount < gallons) {
        gallons = station.data.fuel.amount;
    }

    local cost = round(station.data.fuel.price * gallons, 2);

    if(!canMoneyBeSubstracted(playerid, cost) ) {
        return msg(playerid, "canister.fuelup.money.notenough", [cost], CL_ERROR);
    }

    local fuelupTime = (gallons / FUELUP_SPEED).tointeger();

    msg(playerid, "business.fuelStation.loading", CL_CHESTNUT2);
    freezePlayer(playerid, true);
    trigger(playerid, "hudCreateTimer", fuelupTime, true, true);
    players[playerid].inventory.blocked = true;
    delayedFunction(fuelupTime * 1000, function () {
        subPlayerMoney(playerid, cost);
        jerrycanObj.amount += gallons;
        jerrycanObj.save();

        local tax = getGovernmentValue("taxSales") * 0.01;
        local income = round(cost * (1 - tax), 2);
        station.data.money += income;
        station.data.tax += (cost - income);
        station.data.fuel.amount -= gallons;

        if("sold" in station.data.fuel == false) {
            station.data.fuel.sold <- 0;
        }
        station.data.fuel.sold += gallons;

        station.save();

        players[playerid].inventory.blocked = false;
        msg(playerid, "canister.fuelup.filled", [formatGallons(gallons), cost], CL_CHESTNUT2);
        freezePlayer(playerid, false);

        players[playerid].hands.sync();
        delayedFunction(1000, function () { freezePlayer( playerid, false); });
    });
}

function fuelVehicleOrJerrycanUp(playerid) {
    if (!isNearFuelStation(playerid)) return;

    local charid = getCharacterIdFromPlayerId(playerid);
    local stationName = getFuelStationCache(charid).name;
    local station = getFuelStationEntity(stationName);
    local stationState = getFuelStationState(station);

    if(stationState != "opened") {
        return msg(playerid, "business.fuelStation.closed", CL_ERROR);
    }

    if (isPlayerInVehicle(playerid) ) {
        fuelVehicleUp(playerid);
    } else {
        fuelJerrycanUp(playerid);
    }
}

function isNearFuelStation(playerid) {
    foreach (station in coords) {
        if (isInRadius(playerid, station.public[0], station.public[1], station.public[2], FUEL_RADIUS)) {
            return true;
        }
    }
    return false;
}

// acmd( ["fuel"], "low", function( playerid ) {
//     local vehicleid = getPlayerVehicle(playerid);
//     return setVehicleFuel(vehicleid, 10.0);
// });

function getFuelStationCache(charid) {
    return charid in fuelStationCache ? fuelStationCache[charid] : null;
}

function getMaxGallonsReadyToBuy(station, veh) {
    local a = Math.min(Math.min(FUEL_STATION_LIMIT - station.data.fuel.amount, station.data.fuel.amountIn), veh.data.parts.cargo);
    if(station.data.fuel.priceIn == 0.0) {
        return a;
    }
    return Math.min(a, station.data.money / station.data.fuel.priceIn);
}

function fuelTruckUnload(playerid) {

    local charid = getCharacterIdFromPlayerId(playerid);
    local stationName = getFuelStationCache(charid).name;

    if(!stationName) return;

    local stationCoords = getFuelStationCoordsByName(stationName);

    if (!isInRadius(playerid, stationCoords.unload[0], stationCoords.unload[1], stationCoords.unload[2], FUEL_RADIUS) ) {
        return;
    }

    if (!isPlayerInVehicle(playerid) || getVehicleModel(getPlayerVehicle(playerid)) != 5) {
        return msg(playerid, "business.fuelStation.need-fuel-truck", CL_ERROR);
    }

    if(isPlayerVehicleMoving(playerid)) {
        return msg(playerid, "business.fuelStation.stopyourmoves", CL_ERROR);
    }

    local vehicleid = getPlayerVehicle(playerid);
    local veh = getVehicleEntity(vehicleid);

    if(!isPlayerVehicleDriver(playerid)) {
        return msg(playerid, "business.fuelStation.notdriver", CL_ERROR);
    }

    if(isVehicleEngineStarted(vehicleid)) {
        return msg(playerid, "business.fuelStation.stopengine", CL_ERROR);
    }

    if(trucksOnQueue.find(veh.id) != null) {
        return;
    }

    if(getVehicleState(vehicleid) == "unloading") {
        return msg(playerid, "vehicle.state.unloading", CL_ERROR);
    }

    local station = getFuelStationEntity(stationName);
    local stationState = getFuelStationState(station);

    if(stationState != "opened") {
        return msg(playerid, "business.fuelStation.closed", CL_ERROR);
    }

    local maxGallonsReadyToBuy = getMaxGallonsReadyToBuy(station, veh);

    if(veh.data.parts.cargo == 0) {
        return msg(playerid, "business.fuelStation.fueltruck.empty", CL_ERROR);
    }

    if(maxGallonsReadyToBuy < 1) {
        return msg(playerid, "business.fuelStation.not-ready-to-buy", CL_ERROR);
    }

    if(station.data.fuel.amount >= FUEL_STATION_LIMIT) {
        return msg(playerid, "business.fuelStation.full", CL_ERROR);
    }

    msg(playerid, "business.fuelStation.enter-value-of-gallons-1", CL_RIPELEMON);
    msg(playerid, "business.fuelStation.enter-value-of-gallons-2", [station.data.fuel.priceIn], CL_RIPELEMON);
    msg(playerid, "business.fuelStation.enter-value-of-gallons-hint", [1, maxGallonsReadyToBuy], CL_GRAY);

    local isEntered = false;

    // Поставить бензовоз в очередь получения действия от игрока
    trucksOnQueue.push(veh.id);

    delayedFunction(15000, function() {
        if (!isEntered) {
            msg(playerid, "business.fuelStation.unloading-canceled");
            removeTruckFromUnloadingQueue(veh.id);
        }
    });

    trigger(playerid, "hudCreateTimer", 15.0, true, true);

    requestUserInput(playerid, function(playerid, text) {
        trigger(playerid, "hudDestroyTimer");

        if (!text || !isNumeric(text)) {
            return msg(playerid, "business.fuelStation.invalid-enter", CL_ERROR);
        }

        isEntered = true;
        removeTruckFromUnloadingQueue(veh.id);

        if (!isInRadius(playerid, stationCoords.unload[0], stationCoords.unload[1], stationCoords.unload[2], FUEL_RADIUS) ) {
            return msg(playerid, "business.fuelStation.toofar", CL_ERROR);
        }

        local gallons = text.tointeger();

        if(gallons > veh.data.parts.cargo) {
            // галонов больше, чем есть в бензовозе
            return msg(playerid, "business.fuelStation.truck.no-enough-fuel", [formatGallons(gallons)], CL_ERROR);
        }

        local maxGallonsReadyToBuyNow = getMaxGallonsReadyToBuy(station, veh);

        if(maxGallonsReadyToBuyNow < 1) {
            return msg(playerid, "business.fuelStation.not-ready-to-buy", CL_ERROR);
        }

        if(gallons > maxGallonsReadyToBuyNow) {
            // галонов больше, чем заправка покупает или чем заправка может вместить
            return msg(playerid, "business.fuelStation.ready-to-buy", [formatGallons(maxGallonsReadyToBuyNow)], CL_ERROR);
        }

        local amount = round(station.data.fuel.priceIn * gallons, 2);

        // запомним персонажа
        local charid = getCharacterIdFromPlayerId(playerid);

        addPlayerMoney(playerid, amount);

        veh.data.parts.cargo -= gallons;
        veh.save();

        station.data.money -= amount;
        station.data.fuel.amountIn -= gallons;
        station.data.fuel.amount += gallons;
        station.save();

        blockDriving(playerid, vehicleid);
        setVehicleState(vehicleid, "unloading");
        setVehicleEngineState(vehicleid, false);

        local fuelUnloadSeconds = (gallons / FUEL_UNLOAD_SPEED).tointeger();
        msg(playerid, "vehicle.state.unloading", FUELSTATION_COLOR);
        msg(playerid, "business.fuelStation.earned", [amount, formatGallons(gallons)], FUELSTATION_COLOR);

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

include("controllers/business/fuelStations/manage.nut");
include("controllers/business/fuelStations/shop.nut");