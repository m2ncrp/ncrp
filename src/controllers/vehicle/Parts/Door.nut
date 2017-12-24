class Door extends OpenableVehiclePart {
    window = null;
    
    constructor (vehicleID, seatID) {
        base.constructor(vehicleID, seatID, false);
        this.window = Window(vehicleID, seatID);
    }

    function open() {
        // Code
    }

    function close() {
        // Code
    }
}
