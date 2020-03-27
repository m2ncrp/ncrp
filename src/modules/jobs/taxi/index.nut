include("modules/jobs/taxi/commands.nut");
include("modules/jobs/taxi/translations.nut");
include("modules/jobs/taxi/peds_coords.nut");

local DRIVERS = {}; // таблица водителей

local price = 0.0015; // тариф за 1 метр

const TAXI_JOB_SKIN = 171;
const TAXI_JOB_LEVEL = 2;

local TAXI_BLIP = [-710.638, 255.64, 0.365978];
local TAXI_COORDS = [-720.586, 248.261, 0.365978];
local TAXI_RADIUS = 2.0;

local TAXI_CHARACTERS_LIMIT = 1000000;


event("onServerStarted", function() {
    logStr("[jobs] loading taxi job...");
    local taxicars = [
        createVehicle(24, -127.650, 412.521, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 1
        createVehicle(24, -127.650, 408.872, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 2
        createVehicle(24, -127.650, 405.611, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 3
        createVehicle(24, -127.650, 402.069, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 4
        createVehicle(33, -127.650, 398.769, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 5
        createVehicle(33, -708.733, 248.0, 0.504346, -0.44367, -0.00094714, -0.230679 ), // Taxi1
        createVehicle(33, -714.508, 248.0, 0.504346, -0.44367, -0.00094714, -0.244627 ), // Taxi2
        createVehicle(24, -718.301, 261.576, 0.504056, 141.868, -0.025185, 0.340924 ), // Taxi3
        createVehicle(24, -712.0, 262.183, 0.504394, 141.868, -0.025185, 0.340924   ), // Taxi4
        createVehicle(33, -479.656, 702.3, 1.2, -179.983, -2.09183, 0.445576  ),     // taxi Uptown 1
        createVehicle(24, -483.363, 702.3, 1.2, -178.785, -2.16034, 0.16853   ),     // taxi Uptown 2

        createVehicle(24, -533.348, 1583.63, -16.4578, 0.272268, 0.379557, -0.261274 ),         // taxi_naprotiv_vokzala_1
        createVehicle(33, -547.207, 1600.14, -16.4299, -179.116, -0.221615, 0.447305 ),         // taxi_naprotiv_vokzala_2
                createVehicle(24, -551.133, 1583.27, -16.4543, 0.443711, 0.00174642, -0.451021 ),    // taxi_naprotiv_vokzala_3
                createVehicle(   24, -658.287, 236.719, 1.17881, -179.192, 0.255169, -0.234465 ),    // TaxiDEVELOPER
                createVehicle(33, -487.191, 702.3, 1.2, -178.078, -2.24803, 0.0579244 ),             // taxi Uptown 3
    ];

    registerPersonalJobBlip("taxidriver", TAXI_BLIP[0], TAXI_BLIP[1]);

    // вызываем такси каждые 15 секунд
    delayedFunction(15000, function() {
        callTaxiByPed();
    });

});


event("onPlayerConnect", function(playerid) {
    // Если игрок работает таксистом, получаем id персонажа, проверяем сущетсвует ли он в DRIVERS и если нет - добавляем.
    if(isTaxiDriver(playerid)) {
        local drid = getCharacterIdFromPlayerId(playerid);
        if ( !(drid in DRIVERS) ) {
            addTaxiDriver(drid);
        }
    }
});

// добавить водителя такси по charid
function addTaxiDriver(drid) {
    DRIVERS[drid] <- {
        status = "offair",
        vehicleid = null
    };
}
