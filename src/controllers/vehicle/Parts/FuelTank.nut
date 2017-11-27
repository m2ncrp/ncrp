class VehicleCompoent.FuelTank extends VehicleComponent {
    volume = null;
    model = null;

    constructor (data) {
        dbg("called fuel tank creation");
        base.constructor(data);

        if (this.data == null) {
            this.data = {
                volume = vehicle_info[this.parent.vehicleid][1];
                current = volume * 0.667; // 2/3 of full tank
            }
        }
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
