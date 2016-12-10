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
}
