local CANISTER_COST = 14.0;
local CANISTER_BUY_RADIUS = 5.0;

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

alternativeTranslate({

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
"ru|canister.use.spent"                   : "[CANISTER] Вылито %.2f литров. Осталось литров: %.2f."


"en|canister.fuelup.needinhands"          : "[CANISTER] Take canister in hands."
"ru|canister.fuelup.needinhands"          : "[CANISTER] Возьмите в руки канистру."

"en|canister.fuelup.toofar"               : "[CANISTER] You are too far from any fuel station!"
"ru|canister.fuelup.toofar"               : "[CANISTER] Залить топливо в канистру можно только на заправке!"

"en|canister.fuelup.isfull"               : "[CANISTER] Сanister is full."
"ru|canister.fuelup.isfull"               : "[CANISTER] Канистра полная."

"en|canister.fuelup.money.notenough"      : "[FUEL] Not enough money. Need $%.2f."
"ru|canister.fuelup.money.notenough"      : "[FUEL] Недостаточно денег. Для оплаты требуется $%.2f."

"en|canister.fuelup.filled"               : "[CANISTER] %.2f gallons poured for $%.2f. Сanister filled."
"ru|canister.fuelup.filled"               : "[CANISTER] Залито %.2f литров на $%.2f. Канистра заполнена."

});

addEventHandlerEx("onServerStarted", function() {
    log("[shops] loading canister shops..");
    foreach (canister in canister_shops) {
        create3DText ( canister[0], canister[1], canister[2]+0.35, "CANISTER", CL_RIPELEMON, CANISTER_BUY_RADIUS );
        create3DText ( canister[0], canister[1], canister[2]+0.20, "Price: $"+CANISTER_COST+" | Buy: /canister", CL_WHITE.applyAlpha(150), 1.0 );
    }
});


cmd("canister", function( playerid ) {
    local check = false;
    foreach (key, value in canister_shops) {
        if (isPlayerInValidPoint(playerid, value[0], value[1], 1.0 )) {
            check = true;
        }
    }
    if(!check) {
        return msg(playerid, "shops.canistershop.toofar", [], CL_THUNDERBIRD);
    }

    if (!canMoneyBeSubstracted(playerid, CANISTER_COST)) {
        return msg(playerid, "shops.canistershop.money.notenough", [CANISTER_COST], CL_THUNDERBIRD);
    }

    if(players[playerid].hands.freelen() <= 0) {
        return msg(playerid, "inventory.hands.busy", CL_THUNDERBIRD);
    }

    msg(playerid, "shops.canistershop.bought", CL_SUCCESS);
    local canister = Item.Jerrycan();
    players[playerid].hands.push( canister );
    canister.save();
    players[playerid].hands.sync();
    subMoneyToPlayer(playerid, CANISTER_COST);
});

cmd( ["canister"], "up", function( playerid ) {

    if(isPlayerInVehicle(playerid)) {
        return msg(playerid, "canister.leavethecar", CL_THUNDERBIRD);
    }

    if ( !(players[playerid].hands.isFree()) || !(players[playerid].hands.get(0) instanceof Item.Jerrycan) ){
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
    dbg(cost);

    if ( !canMoneyBeSubstracted(playerid, cost) ) {
        return msg(playerid, "canister.fuelup.money.notenough", [cost], CL_THUNDERBIRD);
    }

    msg(playerid, "canister.fuelup.filled", [fuel, cost], CL_SUCCESS);
    players[playerid].hands.get(0).amount = 20.0;
    players[playerid].hands.get(0).save();
    players[playerid].hands.sync();
    subMoneyToPlayer(playerid, cost);
    addMoneyToTreasury(cost);
});
