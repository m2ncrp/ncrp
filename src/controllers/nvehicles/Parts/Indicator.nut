class SwitchableVehiclePart
{
    vehicleID = null;  // points which one is parent
    id = null;
    switchState = null;

    constructor (vehicleID, partID, state = 0) {
        this.vehicleID = vehicleID;
        this.id = partID;
        this.switchState = state;
    }

    function getState() {
        return this.switchState;
    }

    function setState( to ) {
        this.switchState = to;
    }

    function switches() {
        setState( !this.switchState );
    }

    function correct() {
        if (this.switchState) {
            setState( true );
        } else {
            setState( false );
        }
    }
}

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
