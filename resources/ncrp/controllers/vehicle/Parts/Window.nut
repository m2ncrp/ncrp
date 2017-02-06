class Window extends OpenableVehiclePart {
    constructor (vehicleID, seatID) {
        base.constructor(vehicleID, seatID, false);
    }

    function open() {
        setVehicleWindowOpen(vehicleID, id, true);
        isOpen = true;
    }

    function close() {
        setVehicleWindowOpen(vehicleID, id, false);
        isOpen = false;
    }

    /**
     * Return true if window visually broken on server side.
     * Needs for different message radius.
     * @return {Boolean}
     */
    function isBroken() {
        return false;
    }
}
