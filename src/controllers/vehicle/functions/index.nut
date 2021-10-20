include("controllers/vehicle/functions/state.nut");
include("controllers/vehicle/functions/lights.nut");
include("controllers/vehicle/functions/validators.nut");
include("controllers/vehicle/functions/additional.nut");
include("controllers/vehicle/functions/overrides.nut");
include("controllers/vehicle/functions/passengers.nut");
include("controllers/vehicle/functions/respawning.nut");
include("controllers/vehicle/functions/ownership.nut");
include("controllers/vehicle/functions/saving.nut");
include("controllers/vehicle/functions/blocking.nut");
include("controllers/vehicle/functions/fuel.nut");
include("controllers/vehicle/functions/plates.nut");
include("controllers/vehicle/functions/colors.nut");
include("controllers/vehicle/functions/distance.nut");
include("controllers/vehicle/functions/models.nut");
include("controllers/vehicle/functions/dirt.nut");
include("controllers/vehicle/functions/engine.nut");
include("controllers/vehicle/functions/mileage.nut");
include("controllers/vehicle/functions/parts.nut");
include("controllers/vehicle/functions/speed.nut");
include("controllers/vehicle/functions/walkie-talkie.nut");
// include("controllers/vehicle/functions/radio.nut");

// saving original vehicle method
local old__createVehicle = createVehicle;
local old__setVehicleWheelTexture = setVehicleWheelTexture;
local old__destroyVehicle = destroyVehicle;

// creating storage for vehicles
__vehicles <- {};
__vehiclesR <- {};

// overriding to custom one
createVehicle = function(modelid, x, y, z, rx, ry, rz) {
    local vehicleid = old__createVehicle(
        modelid.tointeger(), x.tofloat(), y.tofloat(), z.tofloat(), rx.tofloat(), ry.tofloat(), rz.tofloat()
    );

    // save vehicle record
    __vehicles[vehicleid] <- {
        saving  = false,
        entity = null,
        respawn = {
            enabled = true,
            position = { x = x.tofloat(), y = y.tofloat(), z = z.tofloat() },
            rotation = { x = rx.tofloat(), y = ry.tofloat(), z = rz.tofloat() },
            time = getTimestamp(),
        },
        ownership = {
            status   = VEHICLE_OWNERSHIP_NONE,
            owner    = null,
            ownerid  = -1,
        },
        spawned = true,
        wheels = {
            front = -1,
            rear  = -1
        },
        dirt = 0.0,
        engineState = false,
        fuel = getDefaultVehicleFuel(vehicleid),
    };

    // apply default functions
    setVehicleRotation(vehicleid, rx.tofloat(), ry.tofloat(), rz.tofloat());
    setVehicleDirtLevel(vehicleid, randomf(VEHICLE_MIN_DIRT, VEHICLE_MAX_DIRT));
    setVehiclePlateText(vehicleid, getRandomVehiclePlate());
    setRandomVehicleColors(vehicleid);
    setVehicleEngineState(vehicleid, false);

    // apply overrides
    getVehicleOverride(vehicleid, modelid.tointeger());

    return vehicleid;
};

// overriding to custom one
setVehicleWheelTexture = function(vehicleid, wheel, textureid) {
    if (textureid != 255 && textureid != -1) {

        if (vehicleid in __vehicles) {
            // add info for saving
            if (wheel == 0) __vehicles[vehicleid].wheels.front = textureid;
            if (wheel == 1) __vehicles[vehicleid].wheels.rear  = textureid;
        }

        // call native
        return old__setVehicleWheelTexture(vehicleid, wheel, textureid);
    }
}

/**
 * Remove player vehicle from database
 * @param  {Integer} vehicleid
 * @return {Boolean}
 */
function removeVehicle(vehicleid) {
    if (vehicleid in __vehicles) {
        dbg("removing player vehicle from database", getVehiclePlateText(vehicleid));
        if (__vehicles[vehicleid].entity) {
            __vehicles[vehicleid].entity.remove();
            __vehicles[vehicleid] = null;
            //delete __vehicles[vehicleid];
        }

        destroyVehicle(vehicleid);

        return true;
    }
}

function despawnVehicle(vehicleid) {
    if (vehicleid in __vehicles) {
        __vehicles[vehicleid].spawned <- false;
        old__destroyVehicle(vehicleid);

        return true;
    }
}

destroyVehicle <- despawnVehicle;

/*
    removeVehicle - перманентное удаление авто
    destroyVehicle / despawnVehicle - удаление 3d модели из игрового мира (десвпавн)
    spawnVehicle - воссоздание авто (спавн)
*/

/**
 * Spawn vehicle [working bad]
 * @param  {Integer} vehicleid
 * @return {Boolean}
 */
function spawnVehicle(vehicleid) {
    if (vehicleid in __vehicles) {
        local veh = getVehicleEntity(vehicleid);

        local vehhh = createVehicle(veh.model, veh.x, veh.y, veh.z, veh.rx, veh.ry, veh.rz);
        dbg(vehhh);
        return true;
    }

    return false;
}


function setVehicleEntity(vehicleid, entity) {
    __vehiclesR[entity.id] <- entity;

    if (vehicleid in __vehicles) {
        return __vehicles[vehicleid].entity = entity;
    }
}

function loadVehicleInventory(entity) {

    local data = {
        sizeX  = getVehicleTrunkDefaultSizeX(entity.model),
        sizeY  = getVehicleTrunkDefaultSizeY(entity.model),
        limit  = getVehicleTrunkDefaultVolumeLimit(entity.model),
    }

    entity.inventory = VehicleInventoryItemContainer(entity, data);

    ORM.Query("select * from tbl_items where parent = :id and state = :states")
        .setParameter("id", entity.id)
        .setParameter("states", Item.State.VEHICLE_INV, true)
        .getResult(function(err, items) {
            foreach (idx, item in items) {
                entity.inventory.set(item.slot, item);
            }
        });
}

function loadVehicleInterior(entity) {

    local data = {
        sizeX  = 3,
        sizeY  = 1,
        limit  = 50,
    }

    entity.interior = VehicleInteriorItemContainer(entity, data);

    ORM.Query("select * from tbl_items where parent = :id and state = :states")
        .setParameter("id", entity.id)
        .setParameter("states", Item.State.VEHICLE_INTERIOR, true)
        .getResult(function(err, items) {
            foreach (idx, item in items) {
                entity.interior.set(item.slot, item);
            }
        });
}

/**
 * Destroy all vehicles spawned on server
 */
function destroyAllVehicles() {
    foreach (vehicleid, vehicle in __vehicles) {
        trySaveVehicle(vehicleid);
        destroyVehicle(vehicleid);
    }
}

/**
 * Return array of vehicleids which are saveble
 * @return {array}
 */
function getCustomPlayerVehicles() {
    local ids = [];

    foreach (vehicleid, vehicle in __vehicles) {
        if (vehicle.saving) {
            ids.push(vehicleid);
        }
    }

    return ids;
}

/**
 * @deprecated
 * @return {[type]} [description]
 */
function getAllServerVehicles() {
    return __vehicles;
}


/**
 * Return Entity.id from tbl_vehicles by vehicleid
 * @return {array}
 */
function getVehicleEntity(vehicleid) {
    return vehicleid in __vehicles && __vehicles[vehicleid].entity ? __vehicles[vehicleid].entity : null;
}


/**
 * Return Entity.id from tbl_vehicles by vehicleid
 * @return {array}
 */
function getVehicleEntityId (vehicleid) {
    return vehicleid in __vehicles && __vehicles[vehicleid].entity ? __vehicles[vehicleid].entity.id : -1;
}

/**
 * Return vehicleid by EntityId
 * or false if vehicle was not found
 * @param {Integer} EntityId
 * @return {Integer} vehicleid
 */
function getVehicleIdFromEntityId(entityid) {
    foreach(vehicleid, value in __vehicles) {
        if(!value) continue;
        if(value.entity != null && value.entity.id == entityid) {
            return vehicleid;
        }
    }
    return false;
}

/**
 * Unblock vehicle driving
 * @param {int} vehicleid
 * @param {float} fuel
 * @return {bool}
 */
function unblockDriving(vehicleid) {
    unblockVehicle(vehicleid);
    addPrivateVehicleLightsKeys(vehicleid);
}

/**
 * Block vehicle driving
 * @param int vehicleid
 * @return bool
 */
function blockDriving(playerid, vehicleid) {
    blockVehicle(vehicleid);
    removePrivateVehicleLightsKeys(playerid);
}
