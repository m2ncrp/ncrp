class Lights {
    vehicleID = null;
    state = null;
    
    constructor (vehicleID) {
        this.vehicleID = vehicleID;
        state = false;
    }

    function isLightsOn() {
        return getVehicleLightState(vehicleID);
    }

    function switchLights() {
        local prevState = isLightsOn();
        setVehicleLightState( vehicleID, !prevState );
    }
}
