class FuelTank {
    volume = null;
    vehicleID = null;
    model = null;

    constructor (vehicleID, model) {
        this.vehicleID = vehicleID;
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
}
