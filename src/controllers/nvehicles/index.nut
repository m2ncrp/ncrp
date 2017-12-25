/**
 * NEW NVEHICLE METHODS
 * should be used ONLY for native events ONLY INSIDE this module
 * for scripting use the OOP aproach
 */

    /**
     * Check if player is in the new vehicle
     * @param  {Character|Integer}  playerOrId
     * @return {Boolean}
     */
    function isPlayerInNVehicle(playerOrId) {
        if (playerOrId instanceof Character) {
            playerOrId = playerOrId.playerid;
        }

        if (!original__isPlayerInVehicle(playerOrId)) {
            return false;
        }

        local vehicleid = original__getPlayerVehicle(playerOrId);
        if (!(vehicleid in vehicles_native)) return false;

        return true;
    }

    /**
     * Return Vehicle player is currently in
     * @param  {Character|Integer} player/playerid
     * @return {Vehicle}
     */
    function getPlayerNVehicle(playerOrId) {
        if (playerOrId instanceof Character) {
            playerOrId = playerOrId.playerid;
        }

        if (!isPlayerInNVehicle(playerOrId)) {
            return null;
        }

        return vehicles_native[original__getPlayerVehicle(playerOrId)];
    }

    /**
     * Return closest vehicle to player, or the one he is sitting in
     * @param  {Character|Integer} playerOrId
     * @return {Vehicle}
     */
    function getPlayerNearestNVehicle(playerOrId) {
        if (playerOrId instanceof Character) {
            playerOrId = playerOrId.playerid;
        }

        if (isPlayerInNVehicle(playerOrId)) {
            return getPlayerNVehicle(playerOrId);
        }

        return vehicles.nearestVehicle(playerid);
    }

/**
 * ENDOF NEW NVEHICLE METHODS
 */

include("controllers/nvehicles/classes/Vehicle_hack.nut");

include("controllers/nvehicles/commands.nut");

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
