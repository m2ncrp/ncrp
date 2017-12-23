include("controllers/vehicle/commands.nut");
include("controllers/vehicle/functions/passengers.nut");

const VEHICLE_FUEL_DEFAULT      = 40.0;

include("controllers/vehicle/dep_functions/blocking.nut");
include("controllers/vehicle/dep_functions/models.nut");
include("controllers/vehicle/dep_functions/colors.nut");
include("controllers/vehicle/dep_functions/engine.nut");
include("controllers/vehicle/dep_functions/fuel.nut");
include("controllers/vehicle/dep_functions/ownership.nut");
include("controllers/vehicle/dep_functions/plates.nut");
include("controllers/vehicle/dep_functions/passengers.nut");
include("controllers/vehicle/dep_functions/validators.nut");

include("controllers/vehicle/classes/Vehicle.nut");
include("controllers/vehicle/classes/VehicleComponent.nut");
include("controllers/vehicle/Parts/Hull.nut");
include("controllers/vehicle/Parts/FuelTank.nut");
include("controllers/vehicle/Parts/Engine.nut");
include("controllers/vehicle/Parts/Gabarites.nut");
include("controllers/vehicle/Parts/Lights.nut");
include("controllers/vehicle/Parts/WheelPair.nut");
include("controllers/vehicle/Parts/Trunk.nut");
include("controllers/vehicle/Parts/Plate.nut");
include("controllers/vehicle/patterns/VehicleContainer.nut");
include("controllers/vehicle/patterns/VehicleComponentContainer.nut");

vehicles <- VehicleContainer();
vehicles_native <- {};
__vehicles <- vehicles;

function getPlayerVehicleid(playerid) {
    if (!isPlayerInVehicle(playerid)) {
        local vehicle = vehicles.nearestVehicle(playerid);  // get vehicle obj from DB
        if (vehicle == null) return -1;                     // if there's no such return 1
        return vehicle.vehicleid;                           // return id on server side after it's been spawned (starts with 0)
    }

    local vehicleid = getPlayerVehicle(playerid);           // get vehicle id from server
    return vehicles_native[vehicleid].id;                   // get vehicle obj on MEM from DB (starts with 1)
}


/**
 * Return Entity.id from tbl_vehicles by vehicleid
 * @return {array}
 */
function getVehicleEntityId (vehicleid) {
    return vehicleid in __vehicles && __vehicles[vehicleid].entity ? __vehicles[vehicleid].entity.id : -1;
}


event("onServerStarted", function() {
    Vehicle.findAll(function(err, results) {
        foreach (idx, vehicle in results) {
            // dbg("Displaying info about ", vehicle.id);

            // foreach (idx, component in vehicle.components) {
            //     dbg(" + Component:", component.id, "with data:", component.data);
            // }

            if (vehicle.state == Vehicle.State.Spawned) {
                vehicles.set(vehicle.id, vehicle);
                vehicle.spawn();
            }

            // dbg("----------------");
        }
    });
});


event("onServerPlayerStarted", function(playerid) {
    log("------------------> Started!");
    delayedFunction(10000, function () {
        log("------------------> Done!");

        foreach (vehicle in vehicles) {
            // if veh spawned
            if (vehicle.state == 1) {
                local vpos = getVehiclePosition( vehicle.vehicleid );

                // dont respawn if player is near
                foreach (component in vehicle.components) {
                    component.correct();
                }
            }
        }
    });
});




event("native:onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    // bug's prediction is here. Needs to separate player vehicles out of scripted one
    local vehicle = vehicles_native[vehicleid];

    log( getPlayerName(playerid) + " entered vehicle " + vehicle.vehicleid.tostring() + " (seat: " + seat.tostring() + ")." );
    // correct state of all the vehicle components
    vehicle.hack.OnEnter(seat);
    // add player as a vehicle passenger
    addVehiclePassenger(vehicle, playerid, seat);

    vehicle.save();

    return 1;
});


event("native:onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    local vehicle = vehicles_native[vehicleid];

    log(getPlayerName(playerid) + " #" + playerid + " JUST LEFT VEHICLE with ID=" + vehicle.vehicleid.tostring() + " (seat: " + seat.tostring() + ")." );
    // remove player as a vehicle passenger
    removeVehiclePassenger(vehicle, playerid, seat);
    // correct state of all the vehicle components
    vehicle.hack.OnExit(seat);
    vehicle.save();
    return 1;
});


event(["onServerStopping", "onServerAutosave"], function() {
    vehicles.map(function(vehicle) { vehicle.save() });
});

event("onServerMinuteChange", function() {
    foreach (vehicle in vehicles) {
        vehicle.correct(); // Sync all the visuals
    }
});


// vehicles[15].compoenents.find(VehicleComponent.Hull).getDirtLevel()
// vehicles[15].dirt

// Vehicle().setModel(15).setPosition(15, 25, 25).spawn();
// Vehicle().setModel(15).setPosition(15, 25, 25).spawn();
// Vehicle().setModel(15).setPosition(15, 25, 25).spawn();
// Vehicle().setModel(15).setPosition(15, 25, 25).spawn();






















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
