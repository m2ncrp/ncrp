include("modules/shops/fuelstations/commands.nut");
include("modules/shops/fuelstations/functions.nut");

include("modules/shops/fuelstations/fueldriver");

translation("en", {
    "shops.fuelstations.toofar"             : "You are too far from any fuel station!"
    "shops.fuelstations.farfromvehicle"     : "You are too far from vehicle."
    "shops.fuelstations.stopyourmoves"      : "Please, stop car to fuel up."
    "shops.fuelstations.fueltank.check"     : "Fuel level: %.2f gallons."
    "shops.fuelstations.fueltank.full"      : "[FUEL] Your fuel tank is full!"
    "shops.fuelstations.money.notenough"    : "[FUEL] Not enough money. Need $%.2f, but you have only $%s"
    "shops.fuelstations.fuel.payed"         : "[FUEL] You pay $%.2f for %.2f gallons. Current balance $%s. Come to us again!"

    "shops.fuelstations.help.fuelup"        : "To fill up vehicle fuel tank"
});

const MAX_FUEL_LEVEL = 70.0;
const GALLON_COST = 0.2; // 20 cents

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
