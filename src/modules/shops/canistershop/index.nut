local CANISTER_COST = 0.2; // 20 cents
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

addEventHandlerEx("onServerStarted", function() {
    log("[shops] loading canister shops..");
    foreach (canister in canister_shops) {
        create3DText ( canister[0], canister[1], canister[2]+0.35, "CANISTER", CL_RIPELEMON, CANISTER_BUY_RADIUS );
        create3DText ( canister[0], canister[1], canister[2]+0.20, "Buy: /canister", CL_WHITE.applyAlpha(150), 1.0 );
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
        return msg(playerid, "Canister too far", [], CL_THUNDERBIRD);
    }

    if (!canMoneyBeSubstracted(playerid, CANISTER_COST)) {
        return msg(playerid, "notenough money %.2f %.2f", [CANISTER_COST, getPlayerBalance(playerid)], CL_THUNDERBIRD);
    }

    if(players[playerid].inventory.freelen() <= 0) {
        return msg(playerid, "shops.restaurant.space.notenough", CL_WARNING);
    }

    local canister = Item.Jerrycan();
    players[playerid].inventory.push( canister );
    canister.save();
    subMoneyToPlayer(playerid, CANISTER_COST);
    msg(playerid, "You bought canister", CL_SUCCESS);

});
