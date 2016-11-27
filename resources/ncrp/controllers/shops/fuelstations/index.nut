include("controllers/shops/fuelstations/commands.nut");

translation("en", {
    "shops.fuelstations.toofar"             : "You are too far from any fuel station!",
    "shops.fuelstations.farfromvehicle"     : "You are too far from vehicle.",
    "shops.fuelstations.fueltank.check"     : "Fuel level: %.2f gallons.",
    "shops.fuelstations.fueltank.full"      : "[FUEL] Your fuel tank is full!",
    "shops.fuelstations.money.notenough"    : "[FUEL] Not enough money. Need $%.2f, but you have only $%s",
    "shops.fuelstations.fuel.payed"         : "[FUEL] You pay $%.2f for %.2f gallons. Current balance $%s. Come to us again."
});

translation("ru", {
    "shops.fuelstations.toofar"             : "Вы слишком далеко от заправки!",
    "shops.fuelstations.farfromvehicle"     : "Вы находитесь не у автомобиля.",
    "shops.fuelstations.fueltank.check"     : "В баке: %.2f литров.",
    "shops.fuelstations.fueltank.full"      : "[FUEL] Бак полон!",
    "shops.fuelstations.money.notenough"    : "[FUEL] Денег недостаточно. Для оплаты требуется $%.2f, а у вас только $%s",
    "shops.fuelstations.fuel.payed"         : "[FUEL] Вы заплатили $%.2f за %.2f литров. Ваш баланс $%s. Будем рады видеть вас вновь."
});

const MAX_FUEL_LEVEL = 70.0;
const GALLON_COST = 0.1; // 10 cents

const TITLE_DRAW_DISTANCE = 40.0;
const FUEL_RADIUS = 4.0;

fuel_stations <- [
    [-1676.81,   -231.85, -20.1853, "SAND ISLAND"   ],
    [-1595.19,   942.496, -5.06366, "GREENFIELD"    ],
    [-710.17,    1765.73, -14.902,  "DIPTON"        ],
    [338.56,     872.179, -21.1526, "LITTLE ITALY"  ],
    [-149.94,    613.368, -20.0459, "LITTLE ITALY"  ],
    [115.146,    181.259, -19.8966, "EAST SIDE"     ],
    [551.154,    2.33366, -18.1063, "OYSTER BAY"    ],
    [-630.299,   -51.715, 1.06515,  "WEST SIDE"     ]
];

addEventHandlerEx("onServerStarted", function() {
    log("[shops] loading fuel stations...");
    foreach (station in fuel_stations) {
        create3DText ( station[0], station[1], station[2]+0.35, "=== "+station[3]+" FUEL STATION ===", CL_ROYALBLUE, TITLE_DRAW_DISTANCE );
        create3DText ( station[0], station[1], station[2]-0.15, "/fuel up", CL_WHITE.applyAlpha(150), FUEL_RADIUS );
    }
});

function isNearFuelStation(playerid) {
    foreach (station in fuel_stations) {
        if ( isInRadius(playerid, station[0], station[1], station[2], FUEL_RADIUS) ) {
            return true;
        }
    }
    msg(playerid, "shops.fuelstations.toofar", [], CL_THUNDERBIRD);
    return false;
}


/**
 * Return value player need to fuel up his vehicle
 * @param  {integer}    playerid
 * @return {float}      fuel used
 */
function getFuelNeed(playerid) {
    local vehicleid = getPlayerVehicle(playerid);
    local vehicle_model = getVehicleModel(vehicleid);
    return vehicle_tank[vehicle_model][1] - getVehicleFuel(vehicleid);
}

function isFuelNeeded(playerid) {
    local vehicleid = getPlayerVehicle(playerid);
    return getFuelNeed(playerid) > 1.0;
}


/**
 * Fuel up player vehicle
 * @param  {integer}    playerid
 * @return {void}
 */
function fuelup(playerid) {
    local vehicleid = getPlayerVehicle(playerid);
    local fuel = round( getFuelNeed(playerid), 2 );
    local cost = round(GALLON_COST*fuel, 2);
    
    if ( isNearFuelStation(playerid) ) {
        if ( !isFuelNeeded(playerid) ) {
            return msg(playerid, "shops.fuelstations.fueltank.full");
        }
        if ( !canMoneyBeSubstracted(playerid, cost) ) {
            return msg(playerid, "shops.fuelstations.money.notenough", [cost, getPlayerBalance(playerid)], CL_THUNDERBIRD);
        }
        setVehicleFuel(vehicleid, MAX_FUEL_LEVEL);
        subMoneyToPlayer(playerid, cost);
        return msg(playerid, "shops.fuelstations.fuel.payed", [cost, fuel, getPlayerBalance(playerid)]);
    }
}
