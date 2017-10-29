/**
 * Get engine state for vehicle by vehicleid EX
 * @param  {Integer} vehicleid
 * @return {Boolean} state OR 0 if vehicle not found
 */
function getVehicleEngineStateEx (vehicleid) {
    if (vehicleid in __vehicles) {
        return __vehicles[vehicleid].state;
    }

    return 0;
}
