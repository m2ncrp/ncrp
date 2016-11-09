include("controllers/vehicle/lights.nut");
include("controllers/vehicle/validators.nut");
include("controllers/vehicle/additional.nut");
include("controllers/vehicle/overrides.nut");

const VEHICLE_RESPAWN_TIME = 60 * 5; // 5 minutes

// saving original vehicle method
local old__createVehicle = createVehicle;

// creating storage for vehicles
local vehicles = {};

// overriding to custom one
createVehicle = function(modelid, x, y, z, rx, ry, rz) {
    local vehicle = old__createVehicle(
        modelid.tointeger(), x.tofloat(), y.tofloat(), z.tofloat(), rx.tofloat(), ry.tofloat(), rz.tofloat()
    );

    // apply default functions
    setVehicleRotation(vehicle, rx.tofloat(), ry.tofloat(), rz.tofloat());
    getVehicleOverride(vehicle, modelid.tointeger());

    // save vehicle entity
    vehicles[vehicle] <- {
        respawn = {
            enabled = true,
            position = { x = x.tofloat(), y = y.tofloat(), z = z.tofloat() },
            rotation = { x = rx.tofloat(), y = ry.tofloat(), z = rz.tofloat() },
            time = getTimestamp(),
        }
    };

    return vehicle;
};

/**
 * Set if vehicle can be automatically respawned
 * @param  {int} vehicleid
 * @param  {bool} value
 * @return {bool}
 */
function setVehicleRespawnEx(vehicleid, value) {
    if (vehicleid in vehicles) {
        return vehicles[vehicleid].respawn.enabled = value;
    }
}

/**
 * Iterate over vehicles
 * check their timestamps
 * and removes ones which are standing too long
 */
function checkVehicleRespawns() {
    foreach (vehicleid, vehicle in vehicles) {
        // maybe vehicle is moving - means its active
        if (isVehicleMoving(vehicleid)) {
            vehicle.respawn.time = getTimestamp();
        }

        // try to respawn it
        if ((getTimestamp() - vehicle.respawn.time) > VEHICLE_RESPAWN_TIME) {
            respawnVehicleById(vehicleid);
        }
    }
}

/**
 * Reset vehicle respawn timer
 * @param  {int} vehicleid
 * @return {bool}
 */
function resetVehicleRespawnTimer(vehicleid) {
    if (!vehicleid in vehicles) {
        return false;
    }

    // reset timer
    vehicles[vehicleid].respawn.time = getTimestamp();
    return true;
}

/**
 * Trigger vehicle respawn
 * (on position where it was created)
 *
 * @param  {int} vehicleid
 * @param  {bool} forced
 * @return {boolean}
 */
function respawnVehicleById(vehicleid, forced = false) {
    if (!vehicleid in vehicles) {
        return false;
    }

    local data = vehicles[vehicleid].respawn;

    if (!respawn.enabled && !forced) {
        return false;
    }

    // maybe vehicle already near its default place
    if (isVehicleNearPoint(vehicleid, data.position.x, data.position.y, 3.0)) {
        return false;
    }

    // reset respawn time
    respawn.time = getTimestamp();

    // reset position/rotation
    setVehiclePosition(vehicleid, data.position.x, data.position.y, data.position.z);
    setVehicleRotation(vehicleid, data.rotation.x, data.rotation.y, data.rotation.z);

    // reset other parameters
    repairVehicle(vehicleid);

    return true;
}

/**
 * Destroy all vehicles spawned on server
 */
function destroyAllVehicles() {
    foreach (vehicleid, vehicle in vehicles) {
        destroyVehicle(vehicleid);
        delete vehicles[vehicleid];
    }
}

/**
 * Block vehicle (it cannot be moved or driven)
 * @param int vehicleid
 * @return bool
 */
function blockVehicle(vehicleid) {
    return setVehicleFuel(vehicleid, 0.0);
}

/**
 * Unblock vehicle
 * @param {int} vehicleid
 * @param {float} fuel
 * @return {bool}
 */
function unblockVehicle(vehicleid, fuel = 50.0) {
    return setVehicleFuel(vehicleid, fuel);
}
