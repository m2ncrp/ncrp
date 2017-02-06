class Trunk extends OpenableVehiclePart {
    capacity = null;
    
    constructor (vehicleID) {
        base.constructor(vehicleID, VEHICLE_PART_TRUNK); // int ~ 1
        capacity = 100; // m^3
    }

}
