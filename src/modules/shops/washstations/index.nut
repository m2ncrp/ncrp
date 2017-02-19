include("modules/shops/washstations/commands.nut");

translation("en", {
    "shops.washstations.toofar"             : "You are too far from any wash station!"
    "shops.washstations.money.notenough"    : "[WASH STATION] Not enough money. Need $%.2f, but you have only $%s."
    "shops.washstations.wash.payed"         : "[WASH STATION] You pay $%.2f for washing a car. Current balance $%s. Come to us again!"
    "shops.washstations.needwait"           : "[WASH STATION] Please, wait while your car is washing."

    "shops.washstations.help.title"         : "List of available commands for WASH STATIONS:"
    "shops.washstations.help.wash"          : "Wash car"
});

if (isSummer()) {
    SHOP_WASH_COST <- 0.03;
} else {
    SHOP_WASH_COST <- 0.05;
}

const SHOP_WASH_3DTEXT_DRAW_DISTANCE = 35.0;
const SHOP_WASH_RADIUS = 4.0;

wash_stations <- [
    [ -650.72, -51.2855,   1.11898,  "WEST SIDE"     ],
    [ -129.748, 612.73,   -19.9173,  "LITTLE ITALY"  ],
    [ 318.459, 873.165,   -21.0677,  "LITTLE ITALY"  ],
    [ 549.954, -17.8149,  -18.0524,  "OYSTER BAY"    ],
    [ -1677.71, -252.047, -20.1124,  "SAND ISLAND"   ],
    [ -1594.26, 962.701,  -4.96899,  "GREENFIELD"    ],
    [ -689.994, 1764.51,  -14.7776,  "DIPTON"        ],
    [  114.305, 160.961,  -19.7987,  "EAST SIDE"     ]
];


addEventHandlerEx("onServerStarted", function() {
    log("[shops] loading wash stations...");
    foreach (shop in wash_stations) {
        create3DText ( shop[0], shop[1], shop[2]+0.35, "=== "+shop[3]+" WASH STATION ===", CL_SNUFF, SHOP_WASH_3DTEXT_DRAW_DISTANCE );
        create3DText ( shop[0], shop[1], shop[2]+0.20, format("(price: $%.2f) Use: /wash", SHOP_WASH_COST), CL_WHITE.applyAlpha(150), SHOP_WASH_RADIUS );
    }
});

function isNearWashStations(playerid) {
    foreach (key, value in wash_stations) {
        if (isPlayerVehicleInValidPoint(playerid, value[0], value[1], SHOP_WASH_RADIUS )) {
            return true;
        }
    }
    msg(playerid, "shops.washstations.toofar", [], CL_THUNDERBIRD);
    return false;
}


/**
 * Wash player car
 * @param  {integer}    playerid
 * @return {void}
 */
function washStationsWashCar (playerid) {

    if ( isNearWashStations(playerid) ) {
        if ( !canMoneyBeSubstracted(playerid, SHOP_WASH_COST) ) {
            return msg(playerid, "shops.washstations.money.notenough", [SHOP_WASH_COST, getPlayerBalance(playerid)], CL_THUNDERBIRD);
        }
        msg(playerid, "shops.washstations.needwait");
        screenFadeinFadeoutEx(playerid, 250, 3000, null, function() {
            local vehicleid = getPlayerVehicle(playerid);
            setVehicleDirtLevel (vehicleid, 0.0);
            subMoneyToPlayer(playerid, SHOP_WASH_COST);
            addMoneyToTreasury(SHOP_WASH_COST);
            return msg(playerid, "shops.washstations.wash.payed", [SHOP_WASH_COST, getPlayerBalance(playerid)]);
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
