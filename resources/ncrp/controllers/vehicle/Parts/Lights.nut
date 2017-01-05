class Lights extends SwitchableVehiclePart {
    
    constructor (vehicleID) {
        base.constructor(vehicleID, null, false);
    }

    function getState() {
        // log( state.tostring() +"~"+ getVehicleLightState(vehicleID).tostring() );
        local native = getVehicleLightState(vehicleID);
        return native || state;
    }

    function setState(to) {
        setVehicleLightState( vehicleID, to);
        base.setState( to );
    }

    /**
     * Return true if lights visually broken on server side.
     * @return {Boolean}
     */
    function isBroken() {
        return false;
    }
}
