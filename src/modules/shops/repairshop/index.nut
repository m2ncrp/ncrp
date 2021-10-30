include("modules/shops/repairshop/commands.nut");

translation("en", {
    "shops.repairshop.toofar"             : "You are too far from any reapir shop!"
    "shops.repairshop.money.notenough"    : "[REPAIR SHOP] Not enough money. Need $%.2f."
    "shops.repairshop.repair.payed"       : "[REPAIR SHOP] You pay $%.2f for repair car. Come to us again!"
    "shops.repairshop.needwait"           : "[REPAIR SHOP] Please, wait while your car is on repair..."
    "shops.repairshop.ownership.wrong"    : "Sorry mate, but it's not your car. I won't repaint that."
});

const SHOP_REPAIR_COST = 5.99;
const SHOP_REPAINT_COST = 84.00;

const SHOP_REPAIR_3DTEXT_DRAW_DISTANCE = 35.0;
const SHOP_REPAIR_RADIUS = 4.0;

repair_shops <- [
    [ 283.703,    296.812,    -21.3215, "CHINATOWN"         ],
    [ 427.703,    780.306,    -21.0342, "LITTLEITALY"      ],
    [ -120.695,   530.662,    -20.0303, "LITTLEITALY"      ],
    [ -68.9644,   204.738,    -14.2976, "EASTSIDE"         ],
    [ 49.2922,   -405.444,    -19.9571, "SOUTHPORT"         ],
    [ 719.814,   -447.579,    -19.9535, "SOUTHMILLVILLE"   ],
    [ 554.52,     -122.35,    -20.0935, "SOUTHMILLVILLE"   ],
    [ -282.625,   699.927,    -19.7625, "UPTOWN"            ],
    [ -686.074,   188.778,     1.20266, "WESTSIDE"         ],
    [ -1439.38,   1381.07,     -13.362, "GREENFIELD"        ],
    [ -377.372,   1735.65,    -22.8186, "DIPTON"            ],
    [ -1583.72,   68.9308,    -13.0742, "SANDISLAND"       ],
    [  832.358,  -4857.47,     18.1211, "AIRPORT"          ],
];

addEventHandlerEx("onServerStarted", function() {
    logStr("[shops] loading repair shops...");
    //foreach (shop in repair_shops) {
    //    create3DText ( shop[0], shop[1], shop[2]+0.35, "=== "+shop[3]+" REPAIR SHOP ===", CL_ROYALBLUE, SHOP_REPAIR_3DTEXT_DRAW_DISTANCE );
    //    create3DText ( shop[0], shop[1], shop[2]+0.20, "Press E | Price: $"+SHOP_REPAIR_COST, CL_WHITE.applyAlpha(150), SHOP_REPAIR_RADIUS );
    //    // create3DText ( shop[0], shop[1], shop[2], format("(price: $%.2f) Use: /repaint r g b", SHOP_REPAINT_COST), CL_WHITE.applyAlpha(150), SHOP_REPAIR_RADIUS );
    //}
});

event("onServerPlayerStarted", function(playerid) {
    foreach (shop in repair_shops) {
        createPrivate3DText ( playerid, shop[0], shop[1], shop[2]+0.35, [[ "REPAIRSHOP", shop[3]], "%s | %s"], CL_ROYALBLUE, SHOP_REPAIR_3DTEXT_DRAW_DISTANCE );
        createPrivate3DText ( playerid, shop[0], shop[1], shop[2]+0.20, [[ "3dtext.job.press.E", "PRICE"], "%s | %s: $"+SHOP_REPAIR_COST ], CL_WHITE.applyAlpha(150), SHOP_REPAIR_RADIUS );
    }
});

function isNearRepairShop(playerid) {
    foreach (key, value in repair_shops) {
        if (isPlayerVehicleInValidPoint(playerid, value[0], value[1], SHOP_REPAIR_RADIUS )) {
            return true;
        }
    }
    return false;
}


/**
 * Repair player car
 * @param  {integer}    playerid
 * @return {void}
 */
function repairShopRepairCar (playerid) {

    if ( isNearRepairShop(playerid) ) {
        if ( !canMoneyBeSubstracted(playerid, SHOP_REPAIR_COST) ) {
            return msg(playerid, "shops.repairshop.money.notenough", [SHOP_REPAIR_COST], CL_THUNDERBIRD);
        }
        msg(playerid, "shops.repairshop.needwait");
        screenFadeinFadeoutEx(playerid, 250, 3000, null, function() {
            local vehicleid = getPlayerVehicle(playerid);
            repairVehicle( vehicleid );
            subPlayerMoney(playerid, SHOP_REPAIR_COST);
            addWorldMoney(SHOP_REPAIR_COST);
            return msg(playerid, "shops.repairshop.repair.payed", [SHOP_REPAIR_COST]);
        });
    }
}


/*
        if( isPlayerInVehicle( playerid ) )
        {
            local vehicleid = getPlayerVehicle( playerid );
            setVehicleTuningTable( vehicleid, 3 );
        }
 */
