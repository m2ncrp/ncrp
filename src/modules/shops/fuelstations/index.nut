translation("en", {

});

local MAX_FUEL_LEVEL = 70.0;
local GALLON_COST = 0.2; // 20 cents
local TITLE_DRAW_DISTANCE = 40.0;
local FUEL_RADIUS = 3.0;

local CANISTER_COST = 14.0;
local CANISTER_BUY_RADIUS = 5.0;

local FUELUP_SPEED = 2.5; // litres in second
local fueltank_loading = {};

local fuel_stations = [
    [-1676.81,   -231.85, -20.1853, "SANDISLAND"   ],
    [-1595.19,   942.496, -5.06366, "GREENFIELD"   ],
    [-710.17,    1765.73, -14.902,  "DIPTON"       ],
    [338.56,     872.179, -21.1526, "LITTLEITALY"  ],
    [-149.94,    613.368, -20.0459, "LITTLEITALY"  ],
    [115.146,    181.259, -19.8966, "EASTSIDE"     ],
    [551.154,    2.33366, -18.1063, "OYSTERBAY"    ],
    [-630.299,   -51.715, 1.06515,  "WESTSIDE"     ]
];

local canister_shops = [
    [ 337.074,  882.845,    -21.3066],
    [ 540.608,  0.800032,   -18.2491],
    [ -631.844, -41.1716,   0.922398],
    [ 104.56,   179.68,     -20.0394],
    [ -148.361, 602.842,    -20.1886],
    [ -708.623, 1755.18,    -15.0062],
    [ -1687.41, -233.401,   -20.328],
    [ -1584.6,  944.037,    -5.2064]
];

addEventHandlerEx("onServerStarted", function() {
    log("[shops] loading fuel stations and canister shops...");
});


event("onServerPlayerStarted", function(playerid) {

    foreach (station in fuel_stations) {
        createPrivate3DText ( playerid, station[0], station[1], station[2]+0.35, [[ "FUELSTATION", station[3]], "%s | %s"], CL_CHESTNUT, TITLE_DRAW_DISTANCE );
        createPrivate3DText ( playerid, station[0], station[1], station[2]-0.15, plocalize(playerid, "3dtext.job.press.E"), CL_WHITE.applyAlpha(150), FUEL_RADIUS );
    }

    foreach (canister in canister_shops) {
        createPrivate3DText ( playerid, canister[0], canister[1], canister[2]+0.35, plocalize(playerid, "CANISTER"), CL_RIPELEMON, CANISTER_BUY_RADIUS );
        createPrivate3DText ( playerid, canister[0], canister[1], canister[2]+0.20, [[ "3dtext.job.press.E", "PRICE"], "%s | %s: $"+CANISTER_COST ], CL_WHITE.applyAlpha(150), 1.0 );
    }

});


function isNearFuelStation(playerid) {
    foreach (station in fuel_stations) {
        if ( isInRadius(playerid, station[0], station[1], station[2], FUEL_RADIUS) ) {
            return true;
        }
    }
    return false;
}

acmd( ["fuel"], "low", function( playerid ) {
    local vehicleid = getPlayerVehicle(playerid);
    return setVehicleFuel(vehicleid, 10.0);
});


acmd( ["fuel"], "test", function( playerid ) {
    local vehicleid = getPlayerVehicle(playerid);
    local volume = getVehicleFuel(vehicleid) + 1.0;
    msg( playerid, "shops.fuelstations.fueltank.check", [volume] );
    return setVehicleFuel(vehicleid, volume);
});

alternativeTranslate({

    "en|shops.fuelstations.toofar"             : "You are too far from any fuel station!"
    "ru|shops.fuelstations.toofar"             : "Вы слишком далеко от заправки!"

    "en|shops.fuelstations.farfromvehicle"     : "You are too far from vehicle."
    "ru|shops.fuelstations.farfromvehicle"     : "Вы находитесь не у автомобиля."

    "en|shops.fuelstations.stopyourmoves"      : "[FUEL] Please, stop car to fuel up."
    "ru|shops.fuelstations.stopyourmoves"      : "[FUEL] Остановите автомобиль, чтобы заправиться."

    "en|shops.fuelstations.noaccess"           : "[FUEL] You can not fuel up this car."
    "ru|shops.fuelstations.noaccess"           : "[FUEL] Вы не можете заправить этот автомобиль."

    "en|shops.fuelstations.notdriver"          : "[FUEL] You are not driver."
    "ru|shops.fuelstations.notdriver"          : "[FUEL] Вы не водитель автомобиля."

    "en|shops.fuelstations.stopengine"         : "[FUEL] Please, stop the engine."
    "ru|shops.fuelstations.stopengine"         : "[FUEL] Заглушите двигатель."

    "en|shops.fuelstations.loading"            : "[FUEL] Loading. Please, wait..."
    "ru|shops.fuelstations.loading"            : "[FUEL] Идёт заправка. Ждите..."

    "en|shops.fuelstations.fueltank.check"     : "Fuel level: %.2f gallons."
    "ru|shops.fuelstations.fueltank.check"     : "В баке: %.2f галлонов."

    "en|shops.fuelstations.fueltank.full"      : "[FUEL] Fuel tank is full!"
    "ru|shops.fuelstations.fueltank.full"      : "[FUEL] Бак полон!"

    "en|shops.fuelstations.fueltank.loading"   : "[FUEL] Fuel tank is loading!"
    "ru|shops.fuelstations.fueltank.loading"   : "[FUEL] Бак заправляется!"

    "en|shops.fuelstations.money.notenough"    : "[FUEL] Not enough money. Need $%.2f."
    "ru|shops.fuelstations.money.notenough"    : "[FUEL] Недостаточно денег. Для оплаты требуется $%.2f."

    "en|shops.fuelstations.fuel.payed"         : "[FUEL] Payment amounted to $%.2f for %.2f gallons. Come to us again!"
    "ru|shops.fuelstations.fuel.payed"         : "[FUEL] Оплата составила $%.2f за %.2f галлонов. Будем рады видеть Вас снова!"

    "en|shops.fuelstations.help.fuelup"        : "To fill up vehicle fuel tank"
    "ru|shops.fuelstations.help.fuelup"        : "Заправить автомобиль"


    "en|shops.canistershop.toofar"            : "[CANISTER] You are too far from place of purchase!"
    "ru|shops.canistershop.toofar"            : "[CANISTER] Вы слишком далеко от места покупки!"

    "en|shops.canistershop.jerrycan.full"     : "[CANISTER] Your fuel tank is full!"
    "ru|shops.canistershop.jerrycan.full"     : "[CANISTER] Бак полон!"

    "en|shops.canistershop.money.notenough"   : "[CANISTER] Not enough money to buy canister. Need $%.2f."
    "ru|shops.canistershop.money.notenough"   : "[CANISTER] Недостаточно денег. Цена канистры: $%.2f."

    "en|shops.canistershop.bought"            : "[CANISTER] You bought canister."
    "ru|shops.canistershop.bought"            : "[CANISTER] Вы купили канистру."

    "en|canister.use.empty"                   : "[CANISTER] Canister is empty."
    "ru|canister.use.empty"                   : "[CANISTER] Канистра пуста."

    "en|canister.use.fueltankfull"            : "[CANISTER] Fuel tank is full."
    "ru|canister.use.fueltankfull"            : "[CANISTER] Бак полон."

    "en|canister.use.farfromvehicle"          : "[CANISTER] You are too far from vehicle."
    "ru|canister.use.farfromvehicle"          : "[CANISTER] Вы слишком далеко от автомобиля."

    "en|canister.use.spent"                   : "[CANISTER] %.2f gallons spent. Left litres: %.2f."
    "ru|canister.use.spent"                   : "[CANISTER] Вылито %.2f галлонов. Осталось галлонов: %.2f."


    "en|canister.fuelup.needinhands"          : "[CANISTER] Take canister in hands."
    "ru|canister.fuelup.needinhands"          : "[CANISTER] Возьмите в руки канистру."

    "en|canister.fuelup.toofar"               : "[CANISTER] You are too far from any fuel station!"
    "ru|canister.fuelup.toofar"               : "[CANISTER] Залить топливо в канистру можно только на заправке!"

    "en|canister.fuelup.isfull"               : "[CANISTER] Сanister is full."
    "ru|canister.fuelup.isfull"               : "[CANISTER] Канистра полная."

    "en|canister.fuelup.money.notenough"      : "[FUEL] Not enough money. Need $%.2f."
    "ru|canister.fuelup.money.notenough"      : "[FUEL] Недостаточно денег. Для оплаты требуется $%.2f."

    "en|canister.fuelup.filled"               : "[CANISTER] %.2f gallons poured for $%.2f. Сanister filled."
    "ru|canister.fuelup.filled"               : "[CANISTER] Залито %.2f галлонов на $%.2f. Канистра заполнена."

});

// Jerrycan buy
key("e", function(playerid) {
    local check = false;
    foreach (key, value in canister_shops) {
        if (isPlayerInValidPoint(playerid, value[0], value[1], 1.0 )) {
            check = true;
        }
    }
    if(!check) {
        return;
    }

    if (!canMoneyBeSubstracted(playerid, CANISTER_COST)) {
        return msg(playerid, "shops.canistershop.money.notenough", [CANISTER_COST], CL_THUNDERBIRD);
    }

    if(!players[playerid].hands.isFreeSpace(1)) {
        return msg(playerid, "inventory.hands.busy", CL_THUNDERBIRD);
    }

    msg(playerid, "shops.canistershop.bought", CL_CHESTNUT2);
    local canister = Item.Jerrycan();
    players[playerid].hands.push( canister );
    canister.save();
    players[playerid].hands.sync();
    subMoneyToPlayer(playerid, CANISTER_COST);
});


function fuelVehicleUp(playerid) {
    if(isPlayerVehicleMoving(playerid)) {
        return msg( playerid, "shops.fuelstations.stopyourmoves", CL_THUNDERBIRD );
    }

    local vehicleid = getPlayerVehicle(playerid);
    local charid = getCharacterIdFromPlayerId(playerid);

    if(!isPlayerHaveVehicleKey(playerid, vehicleid) && (isVehicleCarRent(vehicleid) && getPlayerWhoRentVehicle(vehicleid) != charid)) {
        return msg( playerid, "shops.fuelstations.noaccess", CL_THUNDERBIRD );
    }

    if(!isPlayerVehicleDriver(playerid)) {
        return msg( playerid, "shops.fuelstations.notdriver", CL_THUNDERBIRD );
    }

    if(isVehicleEngineStarted(vehicleid)) {
        return msg( playerid, "shops.fuelstations.stopengine", CL_THUNDERBIRD );
    }

    if( ! (vehicleid in fueltank_loading) ) {
        fueltank_loading[vehicleid] <- false;
    }

    if(fueltank_loading[vehicleid] == true) {
        return msg( playerid, "shops.fuelstations.fueltank.loading", CL_THUNDERBIRD );
    }

    local fuel = round(getVehicleFuelNeed(vehicleid), 2);
    local cost = round(GALLON_COST * fuel, 2);

    if ( !isVehicleFuelNeeded(vehicleid) ) {
        return msg(playerid, "shops.fuelstations.fueltank.full", CL_THUNDERBIRD);
    }

    if(isVehicleCarRent(vehicleid)) {
        local veh = getVehicleEntity(vehicleid);
        if(veh.data.rent.money < cost) {
            return msg(playerid, "rentcar.notenoughbill", CL_THUNDERBIRD);
        }
        veh.data.rent.money -= cost;
    } else {
        if (!canMoneyBeSubstracted(playerid, cost) ) {
            return msg(playerid, "shops.fuelstations.money.notenough", [cost], CL_THUNDERBIRD);
        }
        subMoneyToPlayer(playerid, cost);
        // addMoneyToTreasury(cost);
    }

    local fuelup_time = (fuel / FUELUP_SPEED).tointeger();
    msg( playerid, "shops.fuelstations.loading", CL_CHESTNUT2 );
    freezePlayer( playerid, true);
    fueltank_loading[vehicleid] = true;
    setVehicleEngineState(vehicleid, false);
    trigger(playerid, "hudCreateTimer", fuelup_time, true, true);
    delayedFunction(fuelup_time * 1000, function () {
        if(isPlayerConnected(playerid)) {
            freezePlayer( playerid, false);
            delayedFunction(1000, function () { freezePlayer( playerid, false); });
            msg(playerid, "shops.fuelstations.fuel.payed", [cost, fuel], CL_CHESTNUT2);
        }
        fueltank_loading[vehicleid] = false;
        setVehicleFuel(vehicleid, getDefaultVehicleFuel(vehicleid));
    });
}


function fuelJerrycanUp( playerid ) {

    if ( !players[playerid].hands.exists(0) || !players[playerid].hands.get(0) instanceof Item.Jerrycan) {
        return msg(playerid, "canister.fuelup.needinhands", CL_THUNDERBIRD);
    }

    if ( !isNearFuelStation(playerid) ) {
        return msg(playerid, "canister.fuelup.toofar", [], CL_THUNDERBIRD);
    }

    if ( players[playerid].hands.get(0).amount == 20.0 ) {
        return msg(playerid, "canister.fuelup.isfull", CL_THUNDERBIRD);
    }

    local fuel = round(20.0 - players[playerid].hands.get(0).amount, 2);
    local cost = round(GALLON_COST * fuel, 2);

    if ( !canMoneyBeSubstracted(playerid, cost) ) {
        return msg(playerid, "canister.fuelup.money.notenough", [cost], CL_THUNDERBIRD);
    }

    local fuelup_time = (fuel / FUELUP_SPEED).tointeger();

    msg( playerid, "shops.fuelstations.loading", CL_CHESTNUT2 );
    freezePlayer( playerid, true);
    trigger(playerid, "hudCreateTimer", fuelup_time, true, true);
    players[playerid].inventory.blocked = true;
    delayedFunction(fuelup_time * 1000, function () {
        freezePlayer( playerid, false);
        players[playerid].inventory.blocked = false;
        delayedFunction(1000, function () { freezePlayer( playerid, false); });
        msg(playerid, "canister.fuelup.filled", [fuel, cost], CL_CHESTNUT2);
        players[playerid].hands.get(0).amount = 20.0;
        players[playerid].hands.get(0).save();
        players[playerid].hands.sync();
        subMoneyToPlayer(playerid, cost);
        addMoneyToTreasury(cost);
    });
}


key("e", function(playerid) {
    if ( !isNearFuelStation(playerid) ) return;

    if (isPlayerInVehicle(playerid) ) {
        fuelVehicleUp(playerid);
    } else {
        fuelJerrycanUp(playerid);
    }

});
