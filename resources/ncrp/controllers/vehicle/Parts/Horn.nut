class Horn extends SwitchableVehiclePart {
    
    constructor (vehicleID) {
        base.constructor(vehicleID, null, false);
    }

    function getState() {
        return getVehicleHornState( vehicleID ); // || state;
    }

    function setState(to) {
        setVehicleHornState( vehicleID, to );
        base.setState( to );
    }
}
