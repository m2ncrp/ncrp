class TaxiLight extends SwitchableVehiclePart {
    constructor (vehicleID) {
        base.constructor(vehicleID, null, false);
    }
    
    function getState() {
        return getTaxiLightState( vehicleID );
    }

    function setState(to) {
        setTaxiLightState( vehicleID, to );
        base.setState( to );
    }
}
