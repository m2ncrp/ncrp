class Openable extends ORM.Trait.Interface {
    function setState(vehicleID, partID, state) {
        setVehiclePartOpen(vehicleID, partID, state);
    }
}
