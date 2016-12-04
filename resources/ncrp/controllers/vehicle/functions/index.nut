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

// saving original vehicle method
local old__createVehicle = createVehicle;
local old__setVehicleWheelTexture = setVehicleWheelTexture;

// creating storage for vehicles
__vehicles <- {};

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
            status = VEHICLE_OWNERSHIP_NONE,
            owner  = null
        },
        wheels = {
            front = -1,
            rear  = -1
        },
        state = true,
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

function setVehicleEntity(vehicleid, entity) {
    if (vehicleid in __vehicles) {
        return __vehicles[vehicleid].entity = entity;
    }
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
