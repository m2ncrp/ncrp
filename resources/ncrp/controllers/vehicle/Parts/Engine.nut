class Engine extends SwitchableVehiclePart {

    constructor (vehicleID) {
        base.constructor(vehicleID, null, false);
    }

    function getState() {
        return getVehicleEngineState( vehicleID );
    }

    function setState(to) {
        setVehicleEngineState( vehicleID, to );
        base.setState( to );
    }
}
