translation("en", {

});

local MAX_FUEL_LEVEL = 70.0;
local GALLON_COST = 0.2; // 20 cents
local TITLE_DRAW_DISTANCE = 40.0;
local FUEL_RADIUS = 3.0;

local JERRYCAN_COST = 14.0;
local JERRYCAN_BUY_RADIUS = 5.0;

local FUELUP_SPEED = 2.5; // litres in second
local fueltank_loading = {};

function formatLitres(value) {
    return value+" "+declOfNum(value, ["литр", "литра", "литров"]);
}

function formatGallons(value) {
    return value+" "+declOfNum(value, ["галлон", "галлона", "галлонов"]);
}

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
    [ -1584.6,  944.037,    -5.2064],

    [ -590.481, -5894.12, -6.93749], // LH-CentraIsland
    [  1332.21, -3831.19, 32.2895], // LH-HotelClark
    [ -995.144, -6044.87, -5.22449], // LH-WorksQuarter
    [  690.747, -5943.18, 8.33174], // LH-Downtown

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
        createPrivate3DText ( playerid, canister[0], canister[1], canister[2]+0.35, plocalize(playerid, "CANISTER"), CL_RIPELEMON, JERRYCAN_BUY_RADIUS );
        createPrivate3DText ( playerid, canister[0], canister[1], canister[2]+0.20, [[ "3dtext.job.press.E", "PRICE"], "%s | %s: $"+JERRYCAN_COST ], CL_WHITE.applyAlpha(150), 1.0 );
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
    msg( playerid, "shops.fuelstations.fueltank.check", [volume, formatLitres(volume)] );
    return setVehicleFuel(vehicleid, volume);
});

alternativeTranslate({

    "en|shops.fuelstations.toofar"             : "You are too far from any fuel station!"
    "ru|shops.fuelstations.toofar"             : "Вы слишком далеко от заправки!"

    "en|shops.fuelstations.farfromvehicle"     : "You are too far from vehicle."
    "ru|shops.fuelstations.farfromvehicle"     : "Вы находитесь не у автомобиля."

    "en|shops.fuelstations.stopyourmoves"      : "[FUEL] Please, stop car to fuel up."
    "ru|shops.fuelstations.stopyourmoves"      : "[FUEL] Остановите автомобиль, чтобы заправиться."

    "en|shops.fuelstations.notdriver"          : "[FUEL] You are not driver."
    "ru|shops.fuelstations.notdriver"          : "[FUEL] Вы не водитель автомобиля."

    "en|shops.fuelstations.stopengine"         : "[FUEL] Please, stop the engine."
    "ru|shops.fuelstations.stopengine"         : "[FUEL] Заглушите двигатель."

    "en|shops.fuelstations.loading"            : "[FUEL] Loading. Please, wait..."
    "ru|shops.fuelstations.loading"            : "[FUEL] Идёт заправка. Ждите..."

    "en|shops.fuelstations.fueltank.check"     : "Fuel level: %.2f %s."
    "ru|shops.fuelstations.fueltank.check"     : "В баке: %.2f %s."

    "en|shops.fuelstations.fueltank.full"      : "[FUEL] Fuel tank is full!"
    "ru|shops.fuelstations.fueltank.full"      : "[FUEL] Бак полон!"

    "en|shops.fuelstations.fueltank.loading"   : "[FUEL] Fuel tank is loading!"
    "ru|shops.fuelstations.fueltank.loading"   : "[FUEL] Бак заправляется!"

    "en|shops.fuelstations.money.notenough"    : "[FUEL] Not enough money. Need $%.2f."
    "ru|shops.fuelstations.money.notenough"    : "[FUEL] Недостаточно денег. Для оплаты требуется $%.2f."

    "en|shops.fuelstations.fuel.payed"         : "[FUEL] You pay $%.2f for %.2f %s. Come to us again!"
    "ru|shops.fuelstations.fuel.payed"         : "[FUEL] Вы заплатили $%.2f за %.2f %s. Будем рады видеть Вас снова!"

    "en|shops.fuelstations.help.fuelup"        : "To fill up vehicle fuel tank"
    "ru|shops.fuelstations.help.fuelup"        : "Заправить автомобиль"


    "en|shops.canistershop.toofar"            : "[JERRYCAN] You are too far from place of purchase!"
    "ru|shops.canistershop.toofar"            : "[JERRYCAN] Вы слишком далеко от места покупки!"

    "en|shops.canistershop.jerrycan.full"     : "[JERRYCAN] Your fuel tank is full!"
    "ru|shops.canistershop.jerrycan.full"     : "[JERRYCAN] Бак полон!"

    "en|shops.canistershop.money.notenough"   : "[JERRYCAN] Not enough money to buy canister. Need $%.2f."
    "ru|shops.canistershop.money.notenough"   : "[JERRYCAN] Недостаточно денег. Цена канистры: $%.2f."

    "en|shops.canistershop.bought"            : "[JERRYCAN] You bought canister."
    "ru|shops.canistershop.bought"            : "[JERRYCAN] Вы купили канистру."

    "en|canister.use.empty"                   : "[JERRYCAN] Jerrycan is empty."
    "ru|canister.use.empty"                   : "[JERRYCAN] Канистра пуста."

    "en|canister.use.fueltankfull"            : "[JERRYCAN] Fuel tank is full."
    "ru|canister.use.fueltankfull"            : "[JERRYCAN] Бак полон."

    "en|canister.use.farfromvehicle"          : "[JERRYCAN] You are too far from vehicle."
    "ru|canister.use.farfromvehicle"          : "[JERRYCAN] Вы слишком далеко от автомобиля."

    "en|canister.use.spent"                   : "[JERRYCAN] %.2f %s spent. Left %.2f %s."
    "ru|canister.use.spent"                   : "[JERRYCAN] Вылито %.2f %s. Осталось %.2f %s."


    "en|canister.fuelup.needinhands"          : "[JERRYCAN] Take canister in hands."
    "ru|canister.fuelup.needinhands"          : "[JERRYCAN] Возьмите в руки канистру."

    "en|canister.fuelup.toofar"               : "[JERRYCAN] You are too far from any fuel station!"
    "ru|canister.fuelup.toofar"               : "[JERRYCAN] Залить топливо в канистру можно только на заправке!"

    "en|canister.fuelup.isfull"               : "[JERRYCAN] Jerrycan is full."
    "ru|canister.fuelup.isfull"               : "[JERRYCAN] Канистра полная."

    "en|canister.fuelup.money.notenough"      : "[FUEL] Not enough money. Need $%.2f."
    "ru|canister.fuelup.money.notenough"      : "[FUEL] Недостаточно денег. Для оплаты требуется $%.2f."

    "en|canister.fuelup.filled"               : "[JERRYCAN] %.2f %s poured for $%.2f. Jerrycan filled."
    "ru|canister.fuelup.filled"               : "[JERRYCAN] Залито %.2f %s на $%.2f. Канистра заполнена."

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

    if (!canMoneyBeSubstracted(playerid, JERRYCAN_COST)) {
        return msg(playerid, "shops.canistershop.money.notenough", [JERRYCAN_COST], CL_THUNDERBIRD);
    }

    if(!players[playerid].hands.isFreeSpace(1)) {
        return msg(playerid, "inventory.hands.busy", CL_THUNDERBIRD);
    }

    msg(playerid, "shops.canistershop.bought", CL_CHESTNUT2);
    local canister = Item.Jerrycan();
    players[playerid].hands.push( canister );
    canister.save();
    players[playerid].hands.sync();
    subMoneyToPlayer(playerid, JERRYCAN_COST);
});


function fuelVehicleUp(playerid) {
    if(isPlayerVehicleMoving(playerid)) {
        return msg( playerid, "shops.fuelstations.stopyourmoves", CL_THUNDERBIRD );
    }

    local vehicleid = getPlayerVehicle(playerid);

    if(!isPlayerHaveVehicleKey(playerid, vehicleid)) {
        return msg( playerid, "vehicle.owner.warning", CL_THUNDERBIRD );
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
    local fuelInGallons = round(fuel * GALLONS_PER_LITRE, 2);
    local cost = round(GALLON_COST * fuelInGallons, 2);

    if ( !isVehicleFuelNeeded(vehicleid) ) {
        return msg(playerid, "shops.fuelstations.fueltank.full", CL_THUNDERBIRD);
    }

    if ( !canMoneyBeSubstracted(playerid, cost) ) {
        return msg(playerid, "shops.fuelstations.money.notenough", [cost], CL_THUNDERBIRD);
    }

    local fuelup_time = (fuel / FUELUP_SPEED).tointeger();
    msg( playerid, "shops.fuelstations.loading", CL_CHESTNUT2 );
    freezePlayer( playerid, true);
    fueltank_loading[vehicleid] = true;
    setVehicleEngineState(vehicleid, false);
    trigger(playerid, "hudCreateTimer", fuelup_time, true, true);
    subMoneyToPlayer(playerid, cost);
    //addMoneyToTreasury(cost);
    delayedFunction(fuelup_time * 1000, function () {
        if(isPlayerConnected(playerid)) {
            freezePlayer( playerid, false);
            delayedFunction(1000, function () { freezePlayer( playerid, false); });
            msg(playerid, "shops.fuelstations.fuel.payed", [cost, fuelInGallons, formatGallons(fuelInGallons)], CL_CHESTNUT2);
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

    local jerrycanObj = players[playerid].hands.get(0);

    if ( jerrycanObj.amount == jerrycanObj.capacity ) {
        return msg(playerid, "canister.fuelup.isfull", CL_THUNDERBIRD);
    }

    local fuel = round(jerrycanObj.capacity - jerrycanObj.amount, 2);
    local fuelInGallons = round(fuel * GALLONS_PER_LITRE, 2);
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
        msg(playerid, "canister.fuelup.filled", [fuelInGallons, formatGallons(fuelInGallons), cost], CL_CHESTNUT2);
        jerrycanObj.amount = jerrycanObj.capacity;
        jerrycanObj.save();
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
