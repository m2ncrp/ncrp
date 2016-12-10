class BeaconLight extends SwitchableVehiclePart {
    constructor (vehicleID) {
        base.constructor(vehicleID, null, false);
    }
    
    function getState() {
        return getVehicleBeaconLight( vehicleID ); // || state;
    }

    function setState(to) {
        setVehicleBeaconLight( vehicleID, to );
        base.setState( to );
    }
}
