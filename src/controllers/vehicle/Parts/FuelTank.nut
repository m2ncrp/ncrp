class FuelTank extends BaseVehiclePart {
    volume = null;
    model = null;

    constructor (vehicleID, model) {
        base.constructor(vehicleID, null);
        this.model = getVehicleModel(vehicleID);
        this.volume = getFuelVolume();

        local current = volume * 0.667; // 2/3 of full tank
        setVehicleFuel(vehicleID, current);
    }

    function getFuelVolume() {
        return vehicle_info[model][1];
    }

    function getFuel() {
        return getVehicleFuel(vehicleID);
    }

    function setFuel( to ) {
        setVehicleFuel(vehicleID, to);
    }

    function setFuelToMax() {
        setFuel(volume);
    }

    function setFuelToMin() {
        setFuel(0.0);
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
            return old__setVehicleFuel(vehicleid, __vehicles[vehicleid].fuel);
        }

        return old__setVehicleFuel(vehicleid, getDefaultVehicleFuel(vehicleid));
    }

    /**
     * Get fuel level for vehicle by vehicleid
     * @param  {Integer} vehicleid
     * @return {Float} level
     */
    function getDefaultVehicleFuel(vehicleid) {
        return getDefaultVehicleModelFuel(getVehicleModel(vehicleid));
    }
}



// const VEHICLE_FUEL_STEP = 0.02;

// event("onServerMinuteChange", function() {
//     foreach (vehicleid, object in __vehicles) {
//         if (isVehicleEmpty(vehicleid) || isVehicleBlocked(vehicleid)) continue;

//         local speed = getVehicleSpeed(vehicleid);

//         if (__vehicles[vehicleid].state && __vehicles[vehicleid].fuel >= 0) {
//             __vehicles[vehicleid].fuel -= VEHICLE_FUEL_STEP * getDefaultVehicleFuel(vehicleid);
//         }

//         setVehicleFuel(vehicleid, __vehicles[vehicleid].fuel);
//     }
// });



// local nativeSetVehicleFuel = setVehicleFuel;

// /**
//  * Set vehicle fuel
//  * if temp true, fuel will be set temporary
//  * saving old amount of fuel in special storage
//  *
//  * @param {Integer}  vehicleid
//  * @param {Float}  amount
//  * @param {Boolean} temp [optional]
//  * @return {Boolean}
//  */
// function setVehicleFuel(vehicleid, amount, temp = false) {
//     if (vehicleid in __vehicles && !temp) {
//         __vehicles[vehicleid].fuel = amount;
//     }

//     return nativeSetVehicleFuel(vehicleid, amount);
// }

// /**
//  * Restore amount of fuel that was saved during
//  * temporary saving f.e.: setVehicleFuel(.., ..., true)
//  *
//  * @param  {Integer} vehicleid
//  * @return {Boolean}
//  */
// function restoreVehicleFuel(vehicleid) {
//     if (vehicleid in __vehicles) {
//         return nativeSetVehicleFuel(vehicleid, __vehicles[vehicleid].fuel);
//     }

//     return nativeSetVehicleFuel(vehicleid, getDefaultVehicleFuel(vehicleid));
// }

// /**
//  * Get fuel level for vehicle by vehicleid
//  * @param  {Integer} vehicleid
//  * @return {Float} level
//  */
// function getDefaultVehicleFuel(vehicleid) {
//     return getDefaultVehicleModelFuel(getVehicleModel(vehicleid));
// }

// /**
//  * Get default fuel level by model id
//  * @param  {Integer} modelid
//  * @return {Float}
//  */
// function getDefaultVehicleModelFuel(modelid) {
//     return (("model_" + modelid) in vehicleFuelTankData) ? vehicleFuelTankData["model_" + modelid] : VEHICLE_FUEL_DEFAULT;
// }
