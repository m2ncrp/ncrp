class BeaconLight extends Horn {
    constructor (vehicleID) {
        base.constructor(vehicleID);
    }
    
    function getState() {
        return getVehicleBeaconLight( vehicleID );
    }

    function setState(to) {
        setVehicleBeaconLight( vehicleID, to );
    }
}
