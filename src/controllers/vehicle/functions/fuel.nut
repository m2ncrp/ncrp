local nativeSetVehicleFuel = setVehicleFuel;

/**
 * Set vehicle fuel
 * if temp true, fuel will be set temporary
 * saving old amount of fuel in special storage
 *
 * @param {Integer}  vehicleid
 * @param {Float}  amount
 * @param {Boolean} temp [optional]
 * @return {Boolean}
 */
function setVehicleFuel(vehicleid, amount, temp = false) {
    if (vehicleid in __vehicles && !temp) {
        __vehicles[vehicleid].fuel = amount;
    }

    return nativeSetVehicleFuel(vehicleid, amount);
}

/**
 * Restore amount of fuel that was saved during
 * temporary saving f.e.: setVehicleFuel(.., ..., true)
 *
 * @param  {Integer} vehicleid
 * @return {Boolean}
 */
function restoreVehicleFuel(vehicleid) {
    if (vehicleid in __vehicles) {
        return nativeSetVehicleFuel(vehicleid, __vehicles[vehicleid].fuel);
    }

    return nativeSetVehicleFuel(vehicleid, getDefaultVehicleFuel(vehicleid));
}

/**
 * Get fuel level for vehicle by vehicleid EX
 * @param  {Integer} vehicleid
 * @return {Float} level
 */
function getVehicleFuelEx(vehicleid) {
    if (vehicleid in __vehicles) {
        return __vehicles[vehicleid].fuel * GALLONS_PER_LITRE;
    }

    return 0;
}

/**
 * Set fuel level for vehicle by vehicleid EX
 * @param  {Integer} vehicleid
 * @return {Float} level
 */
function setVehicleFuelEx(vehicleid, gallons) {
    setVehicleFuel(vehicleid, gallons * LITRES_PER_GALLON);
}

/**
 * Get fuel level for vehicle by vehicleid
 * @param  {Integer} vehicleid
 * @return {Float} level
 */
function getDefaultVehicleFuel(vehicleid) {
    return getDefaultVehicleModelFuel(getVehicleModel(vehicleid));
}

/**
 * Get default fuel level by model id
 * @param  {Integer} modelid
 * @return {Float}
 */
function getDefaultVehicleModelFuel(modelid) {
    return ((("model_" + modelid) in vehicleInfo) ? vehicleInfo["model_" + modelid].tank : VEHICLE_FUEL_DEFAULT) * GALLONS_PER_LITRE;
}

/**
 * Return vehicle fuel level
 * @param  {integer}    vehicleid
 * @return {float}      fuel need
 */
function getVehicleFuelNeed(vehicleid) {
    local modelid = getVehicleModel(vehicleid);
    return getDefaultVehicleModelFuel(modelid) - getVehicleFuelEx(vehicleid);
}

/**
 * Check if fuel is needed
 * @return {boolean} true/false
 */
function isVehicleFuelNeeded(vehicleid) {
    return (getVehicleFuelNeed(vehicleid) > 1.0 ? true : false);
}

/**
 * Switch engine on/off
 * @param  {Integer} vehicleid
 * @return {Boolean}
 */
function switchEngine(vehicleid) {
    if (vehicleid in __vehicles) {
        return setVehicleEngineState(vehicleid, (__vehicles[vehicleid].state = !__vehicles[vehicleid].state));
    }

    return false;
}


const VEHICLE_FUEL_STEP = 0.01;

event("onServerMinuteChange", function() {
    foreach (vehicleid, object in __vehicles) {
        if (isVehicleEmpty(vehicleid) || isVehicleBlocked(vehicleid)) continue;

        local speed = getVehicleSpeed(vehicleid);

        if (__vehicles[vehicleid].state && __vehicles[vehicleid].fuel >= 0) {
            __vehicles[vehicleid].fuel -= VEHICLE_FUEL_STEP * getDefaultVehicleFuel(vehicleid);
        }

        setVehicleFuel(vehicleid, __vehicles[vehicleid].fuel);
    }
});
