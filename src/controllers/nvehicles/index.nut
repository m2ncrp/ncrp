include("controllers/nvehicles/functions.nut");
include("controllers/nvehicles/commands.nut");

include("controllers/nvehicles/classes/Vehicle_hack.nut");
include("controllers/nvehicles/classes/vehicle-metainfo.nut");
include("controllers/nvehicles/classes/Vehicle.nut");
include("controllers/nvehicles/classes/VehicleComponent.nut");
include("controllers/nvehicles/classes/VehicleContainer.nut");
include("controllers/nvehicles/classes/VehicleComponentContainer.nut");

include("controllers/nvehicles/classes/components/Hull.nut");
include("controllers/nvehicles/classes/components/FuelTank.nut");
include("controllers/nvehicles/classes/components/Engine.nut");
include("controllers/nvehicles/classes/components/KeyLock.nut");
include("controllers/nvehicles/classes/components/Gabarites.nut");
include("controllers/nvehicles/classes/components/Lights.nut");
include("controllers/nvehicles/classes/components/WheelPair.nut");
include("controllers/nvehicles/classes/components/Trunk.nut");
include("controllers/nvehicles/classes/components/GloveCompartment.nut");
include("controllers/nvehicles/classes/components/Plate.nut");

vehicles <- VehicleContainer();
vehicles_native <- {};

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
        log("------------------> started correct!");
        vehicles.map(function(vehicle) { vehicle.correct(); })
        log("------------------> finished correct!");
    });
});


event("native:onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    if (!(vehicleid in vehicles_native)) return; // NVEHICLES: this is only for our new vehicles

    local vehicle = vehicles_native[vehicleid];
    vehicle.onEnter(players[playerid], seat);
    vehicle.save();

    return 1;
});


event("native:onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (!(vehicleid in vehicles_native)) return; // NVEHICLES: this is only for our new vehicles

    local vehicle = vehicles_native[vehicleid];
    vehicle.onExit(players[playerid], seat);
    vehicle.save();

    return 1;
});

event(["onServerStopping", "onServerAutosave"], function() {
    vehicles.map(function(vehicle) { vehicle.save() });
});

event("onServerMinuteChange", function() {
    vehicles.map(function(vehicle) {
        vehicle.onMinute();
    })
});
