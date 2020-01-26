VEHICLE_RESPAWN_PLAYER_DISTANCE <- pow(20, 2);

event("onServerSecondChange", function() {

    if ((getSecond() % 10) != 0) {
        return;
    }

   resetVehiclesInstances();
});

event("onServerPlayerStarted", function(playerid) {
    resetVehiclesInstances();
});


function resetVehiclesInstances() {
    foreach (vehicleid, vehicle in __vehicles) {
        if (!vehicle) continue;
        if (!isVehicleEmpty(vehicleid)) continue;
        setVehiclePositionObj(vehicleid, getVehiclePositionObj(vehicleid));
        setVehicleRotationObj(vehicleid, getVehicleRotationObj(vehicleid));

        if(vehicle.entity) {
            if(vehicle.entity.fwheel > -1) setVehicleWheelTexture( vehicleid, 0, vehicle.entity.fwheel );
            if(vehicle.entity.rwheel > -1) setVehicleWheelTexture( vehicleid, 1, vehicle.entity.rwheel );
        }
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
    }
}

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
 * Set vehicle respawn position as object
 * @param  {int} vehicleid
 * @param  {bool} value
 * @return {bool}
 */
function setVehicleRespawnPositionObj(vehicleid, obj) {
    if (vehicleid in __vehicles) {
        return __vehicles[vehicleid].respawn.position = obj;
    }
}

/**
 * Set vehicle respawn position as object
 * @param  {int} vehicleid
 * @param  {bool} value
 * @return {bool}
 */
function setVehicleRespawnRotationObj(vehicleid, obj) {
    if (vehicleid in __vehicles) {
        return __vehicles[vehicleid].respawn.rotation = obj;
    }
}

/**
 * Iterate over __vehicles
 * check their timestamps
 * and removes ones which are standing too long
 */
function checkVehicleRespawns() {
    foreach (vehicleid, vehicle in __vehicles) {
        if (!vehicle) continue;
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

    if(!__vehicles[vehicleid]) return false;

    local respawnData = __vehicles[vehicleid].respawn;

    if (!forced) {

        if (!respawnData.enabled) {
            return false;
        }

        if ((getTimestamp() - respawnData.time) < VEHICLE_RESPAWN_TIME) {
            return false;
        }

        // if vehicle not empty - reset timestamp
        if (!isVehicleEmpty(vehicleid)) {
            respawnData.time = getTimestamp();
            return false;
        }
    }

    local veh = getVehicleEntity(vehicleid);

    if(veh == null) {
        // repair and refuel
        repairVehicle(vehicleid);
        setVehicleFuel(vehicleid, getDefaultVehicleFuel(vehicleid));
    }

    setIndicatorLightState(vehicleid, INDICATOR_LEFT, false);
    setIndicatorLightState(vehicleid, INDICATOR_RIGHT, false);
    setVehicleLightState( vehicleid, false );

    // NOTE(inlife): might be bugged (stopping vehicles)
    setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);

    if (!forced) {

        // maybe vehicle already near its default place
        if (isVehicleNearPoint(vehicleid, respawnData.position.x, respawnData.position.y, 3.0)) {
            return false;
        }

        foreach (playerid, value in players) {
            local ppos = getPlayerPosition(playerid);
            local vpos = getVehiclePosition(vehicleid);

            // dont respawn if player is near
            if ((pow(ppos[0] - vpos[0], 2) + pow(ppos[1] - vpos[1], 2)) < VEHICLE_RESPAWN_PLAYER_DISTANCE) {
                dbg("vehicle", "respawn", "not respawning because of close player distance", getVehiclePlateText(vehicleid), getAuthor(playerid));
                respawnData.time = getTimestamp();
                return false;
            }
        }
    }

    // reset respawn time
    respawnData.time = getTimestamp();

    // reset position/rotation
    setVehiclePosition(vehicleid, respawnData.position.x, respawnData.position.y, respawnData.position.z);
    setVehicleRotation(vehicleid, respawnData.rotation.x, respawnData.rotation.y, respawnData.rotation.z);

    // reset other parameters
    setVehicleEngineState(vehicleid, false);
    setVehicleDirtLevel(vehicleid, randomf(VEHICLE_MIN_DIRT, VEHICLE_MAX_DIRT));

    return true;
}
