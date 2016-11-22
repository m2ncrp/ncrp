include("controllers/vehicle/functions/lights.nut");
include("controllers/vehicle/functions/validators.nut");
include("controllers/vehicle/functions/additional.nut");
include("controllers/vehicle/functions/overrides.nut");
include("controllers/vehicle/functions/passengers.nut");

const VEHICLE_RESPAWN_TIME = 600; // 10 minutes
const VEHICLE_FUEL_DEFAULT = 40.0;
const VEHICLE_MIN_DIRT     = 0.25;
const VEHICLE_MAX_DIRT     = 0.75;
const VEHICLE_DEFAULT_OWNER = "";
const VEHICLE_OWNERSHIP_NONE = 0;
const VEHICLE_OWNERSHIP_SINGLE = 0;

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
    setVehicleDirtLevel(vehicle, randomf(VEHICLE_MIN_DIRT, VEHICLE_MAX_DIRT));

    // save vehicle entity
    vehicles[vehicle] <- {
        saving  = false,
        entity = null,
        respawn = {
            enabled = true,
            position = { x = x.tofloat(), y = y.tofloat(), z = z.tofloat() },
            rotation = { x = rx.tofloat(), y = ry.tofloat(), z = rz.tofloat() },
            time = getTimestamp(),
        },
        ownership = {
            status = VEHICLE_OWNERSHIP_NONE,
            owner  = null
        },
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

function setVehicleEntity(vehicleid, entity) {
    if (vehicleid in vehicles) {
        return vehicles[vehicleid].entity = entity;
    }
}

/**
 * Set if vehicle can be automatically saved
 * @param  {int} vehicleid
 * @param  {bool} value
 * @return {bool}
 */
function setVehicleSaving(vehicleid, value) {
    if (vehicleid in vehicles) {
        return vehicles[vehicleid].saving = value;
    }
}


/**
 * Iterate over vehicles
 * check their timestamps
 * and removes ones which are standing too long
 */
function checkVehicleRespawns() {
    foreach (vehicleid, vehicle in vehicles) {
        tryRespawnVehicleById(vehicleid);
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
function tryRespawnVehicleById(vehicleid, forced = false) {
    if (!(vehicleid in vehicles)) {
        return false;
    }

    // bug ?
    if (!(vehicleid in getVehicles())) {
        delete vehicles[vehicleid];
        return false;
    }

    local data = vehicles[vehicleid].respawn;

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

/**
 * Destroy all vehicles spawned on server
 */
function destroyAllVehicles() {
    foreach (vehicleid, vehicle in vehicles) {
        trySaveVehicle(vehicleid);
        destroyVehicle(vehicleid);
    }
}

/**
 * Block vehicle (it cannot be moved or driven)
 * @param int vehicleid
 * @return bool
 */
function blockVehicle(vehicleid) {
    setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
    setVehicleEngineState(vehicleid, false);
    return setVehicleFuel(vehicleid, 0.0);
}

/**
 * Unblock vehicle
 * @param {int} vehicleid
 * @param {float} fuel
 * @return {bool}
 */
function unblockVehicle(vehicleid, fuel = VEHICLE_FUEL_DEFAULT) {
    return setVehicleFuel(vehicleid, fuel);
}

/**
 * Set vehicle owner
 * can be passed as playername or playerid(connected)
 *
 * @param {integer} vehicleid
 * @param {mixed} playerNameOrId
 */
function setVehicleOwner(vehicleid, playerNameOrId) {
    // if its id - get name from it
    if (typeof playerNameOrId == "integer") {
        if (isPlayerConnected(playerNameOrId)) {
            playerNameOrId = getPlayerName(playerNameOrId);
        } else {
            return dbg("[vehicle] setVehicleOwner: trying to set for playerid that aint connected #" + playerNameOrId);
        }
    }

    if (!(vehicleid in vehicles)) {
        return dbg("[vehicle] setVehicleOwner: vehicles no vehicleid #" + vehicleid);
    }

    vehicles[vehicleid].ownership.status = VEHICLE_OWNERSHIP_SINGLE;
    vehicles[vehicleid].ownership.owner  = playerNameOrId;

    return true;
}

/**
 * Get vehicle owner name or null
 *
 * @param  {integer} vehicleid
 * @return {mixed}
 */
function getVehicleOwner(vehicleid) {
    if (!(vehicleid in vehicles)) {
        dbg("[vehicle] getVehicleOwner: vehicles no vehicleid #" + vehicleid);
        return VEHICLE_DEFAULT_OWNER;
    }

    local vehicle = vehicles[vehicleid];

    // if (vehicle.ownership.status != VEHICLE_OWNERSHIP_NONE) {
        return vehicle.ownership.owner;
    // }

    return VEHICLE_DEFAULT_OWNER;
}

/**
 * Check if current connected player is owner of ther car
 * @param  {integer}  playerid
 * @param  {integer}  vehicleid
 * @return {Boolean}
 */
function isPlayerVehicleOwner(playerid, vehicleid) {
    return (isPlayerConnected(playerid) && getVehicleOwner(vehicleid) == getPlayerName(playerid));
}

/**
 * Try to save vehicle
 * make sure that vehicle is saveble via setVehicleSaving(vehicleid, true)
 *
 * @param  {integer} vehicleid
 * @return {bool} result
 */
function trySaveVehicle(vehicleid) {
    if (!(vehicleid in vehicles)) {
        return dbg("[vehicle] trySaveVehicle: vehicles no vehicleid #" + vehicleid);
    }

    local vehicle = vehicles[vehicleid];

    if (!vehicle.saving) {
        return false;
    }


    if (!vehicle.entity) {
        vehicle.entity = Vehicle();
    }

    // save data
    local position = getVehiclePosition(vehicleid);
    local rotation = getVehicleRotation(vehicleid);

    vehicle.entity.x  = position[0];
    vehicle.entity.y  = position[1];
    vehicle.entity.z  = position[2];
    vehicle.entity.rx = rotation[0];
    vehicle.entity.ry = rotation[1];
    vehicle.entity.rz = rotation[2];

    local colors = getVehicleColour(vehicleid);

    vehicle.entity.cra = colors[0];
    vehicle.entity.cga = colors[1];
    vehicle.entity.cba = colors[2];
    vehicle.entity.crb = colors[3];
    vehicle.entity.cgb = colors[4];
    vehicle.entity.cbb = colors[5];

    vehicle.entity.model     = getVehicleModel(vehicleid);
    vehicle.entity.tunetable = getVehicleTuningTable(vehicleid);
    vehicle.entity.dirtlevel = getVehicleDirtLevel(vehicleid);
    vehicle.entity.fuellevel = getVehicleFuel(vehicleid);
    vehicle.entity.plate     = getVehiclePlateText(vehicleid);
    vehicle.entity.owner     = getVehicleOwner(vehicleid);

    vehicle.entity.save();
    return true;
}

/**
 * Retuern array of vehicleids which are saveble
 * @return {array}
 */
function getCustomPlayerVehicles() {
    local ids = [];

    foreach (vehicleid, vehicle in vehicles) {
        if (vehicle.saving) {
            ids.push(vehicleid);
        }
    }

    return ids;
}

/**
 * Tries to save all vehicles
 */
function saveAllVehicles() {
    foreach (vehicleid, vehicle in vehicles) {
        if (vehicle.saving) {
            trySaveVehicle(vehicleid);
        }
    }
}
