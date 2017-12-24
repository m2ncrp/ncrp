include("controllers/nvehicles/classes/Vehicle_hack.nut");

include("controllers/nvehicles/commands.nut");
include("controllers/nvehicles/functions/passengers.nut");

include("controllers/nvehicles/classes/Vehicle.nut");
include("controllers/nvehicles/classes/VehicleComponent.nut");
include("controllers/nvehicles/Parts/Hull.nut");
include("controllers/nvehicles/Parts/FuelTank.nut");
include("controllers/nvehicles/Parts/Engine.nut");
include("controllers/nvehicles/Parts/Gabarites.nut");
include("controllers/nvehicles/Parts/Lights.nut");
include("controllers/nvehicles/Parts/WheelPair.nut");
include("controllers/nvehicles/Parts/Trunk.nut");
include("controllers/nvehicles/Parts/Plate.nut");
include("controllers/nvehicles/patterns/VehicleContainer.nut");
include("controllers/nvehicles/patterns/VehicleComponentContainer.nut");

vehicles <- VehicleContainer();
vehicles_native <- {};
// __vehicles <- vehicles;

function getPlayerVehicleid(playerid) {
    if (!isPlayerInVehicle(playerid)) {
        local vehicle = vehicles.nearestVehicle(playerid);  // get vehicle obj from DB
        if (vehicle == null) return -1;                     // if there's no such return 1
        return vehicle.vehicleid;                           // return id on server side after it's been spawned (starts with 0)
    }

    local vehicleid = getPlayerVehicle(playerid);           // get vehicle id from server
    return vehicles_native[vehicleid].id;                   // get vehicle obj on MEM from DB (starts with 1)
}


// /**
//  * Return Entity.id from tbl_vehicles by vehicleid
//  * @return {array}
//  */
// function getVehicleEntityId (vehicleid) {
//     return vehicleid in __vehicles && __vehicles[vehicleid].entity ? __vehicles[vehicleid].entity.id : -1;
// }


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

    // if vehicle is NVehicle Object or not
    if (!(vehicleid in vehicles_native)) return;

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

    // if vehicle is NVehicle Object or not
    if (!(vehicleid in vehicles_native)) return;

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
