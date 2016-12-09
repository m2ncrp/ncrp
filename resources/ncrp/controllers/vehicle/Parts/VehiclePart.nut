/**
 * Base class, declare any type of vehicle components
 * such as doors, windows, lights ect.
 *
 * Use to be an Item, which player could find, buy, sell or exchange.
 */
class VehiclePart { 
    partID = null;
    isOpen = false;
    vehicleID = null;
    
    constructor (vehicleID, partID, isOpen = false) {
        this.vehicleID = vehicleID; // points which one is parent
        this.partID = partID;
        this.isOpen = isOpen;
    }

    function open() {
        setVehiclePartOpen(vehicleID, partID, true);
    }

    function close() {
        setVehiclePartOpen(vehicleID, partID, false);
    }

}
