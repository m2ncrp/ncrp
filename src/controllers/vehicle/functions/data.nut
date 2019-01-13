/**
 * Set vehicle data
 *
 * @param {Integer} vehicleid
 * @param {Mixed} data
 */
function setVehicleData(vehicleid, data) {

    if (!(vehicleid in __vehicles)) {
        return dbg("[vehicle] setVehicleData: __vehicles no vehicleid #" + vehicleid);
    }

    if (__vehicles[vehicleid].entity == null) {
        __vehicles[vehicleid].entity <- {}
        __vehicles[vehicleid].entity.data <- {}
    }

    __vehicles[vehicleid].entity.data = JSONParser.parse(data);

    return true;
}

/**
 * Get vehicle data
 *
 * @param  {integer} vehicleid
 * @return {mixed}
 */
function getVehicleData(vehicleid) {
    if (!(vehicleid in __vehicles)) {
        dbg("[vehicle] getVehicleData: __vehicles no vehicleid #" + vehicleid);
        return false;
    }

    local vehicle = __vehicles[vehicleid];

    return vehicle.entity.data;
}
