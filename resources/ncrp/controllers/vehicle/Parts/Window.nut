class Window extends VehiclePart {
    constructor (vehicleID, seatID) {
        this.vehicleID = vehicleID;
        this.partID = seatID;
    }
    
    function open() {
        setVehicleWindowOpen(vehicleID, partID, true);
    }

    function close() {
        setVehicleWindowOpen(vehicleID, partID, false);
    }

    function isOpen() {
        return isVehicleWindowOpen( vehicleID, partID );
    }
}
