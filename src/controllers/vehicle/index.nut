// include("controllers/vehicle/commands.nut");

// include("controllers/vehicle/models/CustomVehicle.nut");
// include("controllers/vehicle/patterns/VehicleContainer.nut");

// include("controllers/vehicle/models/VehicleComponent.nut");
// include("controllers/vehicle/parts/Engine.nut");

// include("controllers/vehicle/classes/NativeVehicle.nut");
// include("controllers/vehicle/classes/LockableVehicle.nut");
// include("controllers/vehicle/classes/OwnableVehicle.nut");
// include("controllers/vehicle/classes/SeatableVehicle.nut");
// include("controllers/vehicle/classes/RespawnableVehicle.nut");
// include("controllers/vehicle/classes/SaveableVehicle.nut");
// include("controllers/vehicle/classes/Vehicle.nut");


// const VEHICLE_RESPAWN_TIME      = 300; // 5 (real) minutes
// const VEHICLE_FUEL_DEFAULT      = 40.0;
// const VEHICLE_MIN_DIRT          = 0.25;
// const VEHICLE_MAX_DIRT          = 0.75;
// const VEHICLE_DEFAULT_OWNER     = "";
// const VEHICLE_OWNERSHIP_NONE    = 0;
// const VEHICLE_OWNERSHIP_SINGLE  = 1;
// const VEHICLE_OWNER_CITY        = "__cityNCRP";

// translate("en", {
//     "vehicle.sell.amount"       : "You need to set the amount you wish to sell your car for."
//     "vehicle.sell.2passangers"  : "You need potential buyer to sit in the vehicle with you."
//     "vehicle.sell.ask"          : "%s offers you to buy his vehicle for $%.2f."
//     "vehicle.sell.log"          : "You offered %s to buy your vehicle for $%.2f."
//     "vehicle.sell.success"      : "You've successfuly sold this car."
//     "vehicle.buy.success"       : "You've successfuly bought this car."
//     "vehicle.sell.failure"      : "%s refused to buy this car."
//     "vehicle.buy.failure"       : "You refused to buy this car."
//     "vehicle.sell.notowner"     : "You can't sell car tht doesn't belong to you."
// });


// event("onScriptInit", function() {

// });

// // binding events
// event("onServerStarted", function() {
//     log("[vehicles] starting...");
//     local counter = 0;

//     // load all vehicles from db
//     Vehicle.findAll(function(err, results) {
//         foreach (idx, vehicle in results) {
//             // Use data from vehicle-metainfo.nut file to get seats in given model
//             // local seats = getSeatsNumber(vehicle.model);
//             local seats = 2;
//             local veh = Vehicle( vehicle, seats );

//             veh.setRespawnEx(false);
//             veh.setSaveable(true);

//             __vehicles.add(veh.vid, veh);
//             counter++;
//         }

//         log("[vehicles] loaded " + counter + " vehicles from database. Totally " + __vehicles.len() + " vehicles on server.");
//     });
// });

// // respawn cars and update passangers
// event("onServerMinuteChange", function() {
//     __vehicles.each(function(vehicleid, vehicle) {
//         vehicle.updatePassengers();
//         vehicle.tryRespawn();
//     }, true);
// });

// // force resetting vehicle position to death point
// event("onPlayerDeath", function(playerid) {

// });

// event("onPlayerSpawned", function(playerid) {

// });


include("controllers/vehicle/classes/Vehicle.nut");
include("controllers/vehicle/classes/VehicleComponent.nut");
include("controllers/vehicle/Parts/Hull.nut");
include("controllers/vehicle/patterns/VehicleContainer.nut");
include("controllers/vehicle/patterns/VehicleComponentContainer.nut");

vehicles <- VehicleContainer();
__vehicles <- vehicles;

// event("onServerStarted", function() {
//     local v = Vehicle();

//     v.components.add("hull", VehicleComponent.Hull({ id = "hull", color1 = fromRGB(255, 250, 150), color2 = fromRGB(255, 250, 150), model = 28 }));
//     // v.components.add("engine", VehicleComponent({ id = "engine", started = true }));
//     // v.components.add("fueltank", VehicleComponent({ id = "fueltank", amount = 14.24 }));

//     // v.save();
//     // v.spawn();
//     // v.despawn();
//     // v.spawn();
// })


event("onServerStarted", function() {
    // dbg(JSONParser.parse("[{\"id\":\"hood\",\"opened\":false},{\"id\":\"engine\",\"started\":true},{\"id\":\"fueltank\",\"amount\":14.24}]"));
    Vehicle.findAll(function(err, results) {
        foreach (idx, vehicle in results) {
            vehicles.push(vehicle);
            dbg("Displaying info about ", vehicle.id);

            // if (vehicle.components.len()) {
            //     dbg(vehicle.components[0]);
            // }

            foreach (idx, component in vehicle.components) {
                dbg(" + Component:", component.id, "with data:", component.data);
            }

            dbg("----------------");
        }
    });
})


// vehicles[15].compoenents.find(VehicleComponent.Hull).getDirtLevel()
// vehicles[15].dirt

// Vehicle().setModel(15).setPosition(15, 25, 25).spawn();
// Vehicle().setModel(15).setPosition(15, 25, 25).spawn();
// Vehicle().setModel(15).setPosition(15, 25, 25).spawn();
// Vehicle().setModel(15).setPosition(15, 25, 25).spawn();
