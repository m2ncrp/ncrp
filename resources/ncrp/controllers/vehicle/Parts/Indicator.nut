class Indicator extends SwitchableVehiclePart {

    constructor (vehicleID, side) {
        base.constructor(vehicleID, side, false);
    }

    // Works only if player in vehicle
    // Returns true if indicator's on, otherwise return false
    function getState() {
        local native = getIndicatorLightState(vehicleID, id);
        return state || native;
    }

    function setState(to) {
        setIndicatorLightState(vehicleID, id, to);
        base.setState(to);
    }

    function partSwitch() {
        setState( !state );
    }

    function turnOff() {
        setState(false);
    }

    function turnOn() {
        setState(true);
    }
}
