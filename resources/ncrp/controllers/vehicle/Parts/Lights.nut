class Lights extends SwitchableVehiclePart {
    
    constructor (vehicleID) {
        base.constructor(vehicleID, null, false);
    }

    function getState() {
        return getVehicleLightState(vehicleID);
    }

    function setState(to) {
        setVehicleLightState( vehicleID, to);
        base.setState( to );
    }
}
