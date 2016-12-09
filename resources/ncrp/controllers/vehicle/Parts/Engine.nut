class Engine {
    vehicleID = null;

    constructor (vehicleID) {
        this.vehicleID = vehicleID;
    }

    function isEngineOn() {
        return getVehicleEngineState( vehicleID );
    }

    function switchOn() {
        setVehicleEngineState( vehicleID, true );
    }

    function switchOff() {
        setVehicleEngineState( vehicleID, false );
    }
}
