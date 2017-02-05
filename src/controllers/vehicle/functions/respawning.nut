VEHICLE_RESPAWN_PLAYER_DISTANCE <- pow(20, 2);

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

    if (!forced) {

        if (!data.enabled) {
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
    }

    // repair and refuel
    repairVehicle(vehicleid);
    setVehicleFuel(vehicleid, getDefaultVehicleFuel(vehicleid));
    setIndicatorLightState(vehicleid, INDICATOR_LEFT, false);
    setIndicatorLightState(vehicleid, INDICATOR_RIGHT, false);
    setVehicleLightState( vehicleid, false );

    // NOTE(inlife): might be bugged (stopping vehicles)
    setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);

    if (!forced) {

        // maybe vehicle already near its default place
        if (isVehicleNearPoint(vehicleid, data.position.x, data.position.y, 3.0)) {
            return false;
        }

        foreach (playerid, value in players) {
            local ppos = getPlayerPosition(playerid);
            local vpos = getVehiclePosition(vehicleid);

            // dont respawn if player is near
            if ((pow(ppos[0] - vpos[0], 2) + pow(ppos[1] - vpos[1], 2)) < VEHICLE_RESPAWN_PLAYER_DISTANCE) {
                dbg("vehicle", "respawn", "not respawning because of close player distance", getVehiclePlateText(vehicleid), getAuthor(playerid));
                data.time = getTimestamp();
                return false;
            }
        }
    }

    // reset respawn time
    data.time = getTimestamp();

    // reset position/rotation
    setVehiclePosition(vehicleid, data.position.x, data.position.y, data.position.z);
    setVehicleRotation(vehicleid, data.rotation.x, data.rotation.y, data.rotation.z);

    // reset other parameters
    setVehicleEngineState(vehicleid, false);
    setVehicleDirtLevel(vehicleid, randomf(VEHICLE_MIN_DIRT, VEHICLE_MAX_DIRT));

    return true;
}
