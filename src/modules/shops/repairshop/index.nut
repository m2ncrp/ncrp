include("modules/shops/repairshop/commands.nut");

translation("en", {
    "shops.repairshop.toofar"             : "You are too far from any reapir shop!"
    "shops.repairshop.money.notenough"    : "[REPAIR SHOP] Not enough money. Need $%.2f, but you have only $%s."
    "shops.repairshop.repair.payed"       : "[REPAIR SHOP] You pay $%.2f for repair car. Current balance $%s. Come to us again!"
    "shops.repairshop.repaint.payed"      : "[REPAIR SHOP] You pay $%.2f for repaint car. Current balance $%s. Come to us again!"
    "shops.repairshop.needwait"           : "[REPAIR SHOP] Please, wait while your car is on repair..."
    "shops.repairshop.ownership.wrong"    : "Sorry mate, but it's not your car. I won't repaint that."

    "shops.repairshop.help.title"         : "List of available commands for REPAIR SHOP:"
    "shops.repairshop.help.repair"        : "Repair car"
});

const SHOP_REPAIR_COST = 4.99;
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

paint_shops <- [
[ -1127.71, 1391.04, -13.5724   ], // hardware-kingston
[ -1227.33, 1552.58, 4.9256     ], // hardware-kingston-uo
[ -1577.31, 1676.58, -0.165643  ], // hardware-kingston-dealer
[ -403.811, 1666.22, -23.3185   ], // hardware-dipton
[ -149.426, 726.255, -20.5496   ], // hardware-italy
[ 1.42512, 625.981, -20.1637    ], // hardware-italy-2
[ -222.122, 668.816, -20.1623   ], // hardware-italy-3
[ 33.0751, 412.291, -16.6849    ], // hardware-east-side-big
[ -149.058, 336.459, -13.3921   ], // locksmith-east-side-big
[ 500.476, -285.232, -20.1639   ], // hardware-oyster
[ 277.548, 33.2104, -23.3492    ], // hardware-oyster-2
[ -183.09, -595.772, -20.1636   ], // hardware-southport
[ -413.696, -586.736, -20.111   ], // hardware-southport-2
[ -523.188, -574.907, -20.1684  ], // hardware-southport-3
[ -724.994, -492.171, -22.7499  ], // hardware-southport-4
[ -1496.2, -214.56, -20.1636    ], // hardware-sand
[ -1391.38, -187.803, -20.1528  ], // hardware-sand-2
[ -1749.63, 139.438, -5.14041   ], // hardware-sand-3
[ -1368.81, 402.271, -23.7304   ], // hardware-hunters
[ 61.5946, 99.3949, -13.4522    ], // locksmith-east-side-2
[ 410.477, 682.052, -24.8827    ], // hardware-italy-4
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
        createPrivateBlip( playerid,  shop[0], shop[1], ICON_REPAIR, 100.0 );
    }

    foreach (shop in paint_shops) {

        createPrivateBlip( playerid,  shop[0], shop[1], ICON_LOCK, 100.0 );
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
            return msg(playerid, "shops.repairshop.money.notenough", [SHOP_REPAIR_COST, getPlayerBalance(playerid)], CL_THUNDERBIRD);
        }
        msg(playerid, "shops.repairshop.needwait");
        screenFadeinFadeoutEx(playerid, 250, 3000, null, function() {
            local vehicleid = getPlayerVehicle(playerid);
            repairVehicle( vehicleid );
            subMoneyToPlayer(playerid, SHOP_REPAIR_COST);
            addWorldMoney(SHOP_REPAIR_COST);
            return msg(playerid, "shops.repairshop.repair.payed", [SHOP_REPAIR_COST, getPlayerBalance(playerid)]);
        });
    }
}
