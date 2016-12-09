class Horn extends VehiclePart {
    vehicleID = null;
    
    constructor (vehicleID) {
        this.vehicleID = vehicleID;
    }

    function getState() {
        return getVehicleHornState( vehicleID );
    }

    function setState(to) {
        setVehicleHornState( vehicleID, to );
    }
}
