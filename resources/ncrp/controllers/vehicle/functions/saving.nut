/**
 * Set if vehicle can be automatically saved
 * @param  {Integer} vehicleid
 * @param  {Boolean} value
 * @return {Boolean}
 */
function setVehicleSaving(vehicleid, value) {
    if (vehicleid in __vehicles) {
        return __vehicles[vehicleid].saving = value;
    }
}

/**
 * Get if vehicle is automatically saved
 * @param  {Integer} vehicleid
 * @return {Boolean}
 */
function getVehicleSaving(vehicleid) {
    return (vehicleid in __vehicles && __vehicles[vehicleid].saving);
}

/**
 * Tries to save all vehicles
 */
function saveAllVehicles() {
    foreach (vehicleid, vehicle in __vehicles) {
        if (vehicle.saving) {
            trySaveVehicle(vehicleid);
        }
    }
}

/**
 * Try to save vehicle
 * make sure that vehicle is saveble via setVehicleSaving(vehicleid, true)
 *
 * @param  {integer} vehicleid
 * @return {bool} result
 */
function trySaveVehicle(vehicleid) {
    if (!(vehicleid in __vehicles)) {
        return dbg("[vehicle] trySaveVehicle: __vehicles no vehicleid #" + vehicleid);
    }

    local vehicle = __vehicles[vehicleid];

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
    vehicle.entity.fwheel    = vehicle.wheels.front;
    vehicle.entity.rwheel    = vehicle.wheels.rear;

    vehicle.entity.save();
    return true;
}
