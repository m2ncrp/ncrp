/**
 * Base class, declare any type of vehicle components
 * such as doors, windows, lights ect.
 *
 * Use to be an Item, which player could find, buy, sell or exchange.
 */
class BaseVehiclePart {
    vehicleID = null;  // points which one is parent
    id = null;

    constructor (vehicleID, partID) {
        this.vehicleID = vehicleID;
        this.id = partID;
    }
}




class OpenableVehiclePart extends BaseVehiclePart {
    isOpen = false;

    constructor (vehicleID, partID, isOpen = false) {
        base.constructor(vehicleID, partID);
        this.isOpen = isOpen;
    }

    function isPartOpen() {
        return isOpen;
    }

    function open() {
        setVehiclePartOpen(vehicleID, partID, true);
        isOpen = true;
    }

    function close() {
        setVehiclePartOpen(vehicleID, partID, false);
        isOpen = false;
    }

    function correct() {
        if (state) {
            open();
        } else {
            close();
        }
    }
}




class SwitchableVehiclePart extends BaseVehiclePart {
    state = null;

    constructor (vehicleID, partID, state = 0) {
        base.constructor(vehicleID, partID);
        this.state = state;
    }

    function getState() {
        return state;
    }

    function setState( to ) {
        state = to;
    }

    function switch() {
        setState( !state );
    }

    function correct() {
        if (state) {
            setState( true );
        } else {
            setState( false );
        }
    }
}
