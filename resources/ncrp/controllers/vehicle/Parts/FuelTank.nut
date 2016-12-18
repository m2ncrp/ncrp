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
