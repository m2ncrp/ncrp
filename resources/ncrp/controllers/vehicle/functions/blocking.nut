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
