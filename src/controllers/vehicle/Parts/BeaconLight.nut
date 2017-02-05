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

    /**
     * Return true if beacon light visually broken on server side.
     * @return {Boolean}
     */
    function isBroken() {
        return false;
    }
}
