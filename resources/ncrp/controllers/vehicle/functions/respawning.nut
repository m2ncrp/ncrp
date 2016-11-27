/**
 * Set if vehicle can be automatically respawned
 * @param  {int} vehicleid
 * @param  {bool} value
 * @return {bool}
 */
function setVehicleRespawnEx(vehicleid, value) {
    if (vehicleid in __vehicles) {
        return __vehicles[vehicleid].respawn.enabled = value;
    }
}

/**
 * Iterate over __vehicles
 * check their timestamps
 * and removes ones which are standing too long
 */
function checkVehicleRespawns() {
    foreach (vehicleid, vehicle in __vehicles) {
        tryRespawnVehicleById(vehicleid);
    }
}

/**
 * Reset vehicle respawn timer
 * @param  {int} vehicleid
 * @return {bool}
 */
function resetVehicleRespawnTimer(vehicleid) {
    if (!vehicleid in __vehicles) {
        return false;
    }

    // reset timer
    __vehicles[vehicleid].respawn.time = getTimestamp();
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
function tryRespawnVehicleById(vehicleid, forced = false) {
    if (!(vehicleid in __vehicles)) {
        return false;
    }

    // bug ?
    if (!(vehicleid in getVehicles())) {
        delete __vehicles[vehicleid];
        return false;
    }

    local data = __vehicles[vehicleid].respawn;

    if (!data.enabled && !forced) {
        return false;
    }

    if ((getTimestamp() - data.time) < VEHICLE_RESPAWN_TIME) {
        return false;
    }

    // if vehicle not emtpty - reset timestamp
    if (!isVehicleEmpty(vehicleid)) {
        data.time = getTimestamp();
        return false;
    }

    // maybe vehicle already near its default place
    if (isVehicleNearPoint(vehicleid, data.position.x, data.position.y, 3.0)) {
        return false;
    }

    // maybe vehicle is moving - means its active
    if (isVehicleMoving(vehicleid)) {
        data.time = getTimestamp();
        return false;
    }

    // reset respawn time
    data.time = getTimestamp();

    // reset position/rotation
    setVehiclePosition(vehicleid, data.position.x, data.position.y, data.position.z);
    setVehicleRotation(vehicleid, data.rotation.x, data.rotation.y, data.rotation.z);

    // reset other parameters
    repairVehicle(vehicleid);
    setVehicleEngineState(vehicleid, false);
    setVehicleFuel(vehicleid, VEHICLE_FUEL_DEFAULT);
    setVehicleDirtLevel(vehicleid, randomf(VEHICLE_MIN_DIRT, VEHICLE_MAX_DIRT));

    return true;
}
