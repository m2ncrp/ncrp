class Siren extends Horn {
    constructor (vehicleID) {
        base.constructor(vehicleID);
    }
    
    function getState() {
        return getVehicleSirenState( vehicleID );
    }

    function setState(to) {
        setVehicleSirenState( vehicleID, to );
    }
}
