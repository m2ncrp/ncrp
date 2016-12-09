class TaxiLight extends Horn {
    constructor (vehicleID) {
        base.constructor(vehicleID);
    }
    
    function getState() {
        return getTaxiLightState( vehicleID );
    }

    function setState(to) {
        setTaxiLightState( vehicleID, to );
    }
}
