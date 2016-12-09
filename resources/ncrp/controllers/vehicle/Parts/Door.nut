class Door extends VehiclePart {
    window = null;
    
    constructor (vehicleID, seatID) {
        this.vehicleID = vehicleID;
        this.partID = seatID;

        this.window = Window(vehicleID, seatID);
    }

    function open() {
        // Code
    }

    function close() {
        // Code
    }
}
