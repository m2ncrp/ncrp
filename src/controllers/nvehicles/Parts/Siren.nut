class Siren extends SwitchableVehiclePart {
    constructor (vehicleID) {
        base.constructor(vehicleID, null, false);
    }
    
    function getState() {
        return getVehicleSirenState( vehicleID );
    }

    function setState(to) {
        setVehicleSirenState( vehicleID, to );
        base.setState( to );
    }

    /**
     * Return true if siren visually broken on server side. 
     * @return {Boolean}
     */
    function isBroken() {
        return false;
    }
}
