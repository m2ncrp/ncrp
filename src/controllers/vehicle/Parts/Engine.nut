class Engine extends SwitchableVehiclePart {

    constructor (vehicleID) {
        base.constructor(vehicleID, null, false);
    }

    function getState() {
        local native = getVehicleEngineState( vehicleID );
        return native || state;
    }

    function setState(to) {
        setVehicleEngineState( vehicleID, to );
        base.setState( to );
    }

    /**
     * Return true if engine broken on server side.
     * @return {Boolean}
     */
    function isBroken() {
        return false;
    }
}
