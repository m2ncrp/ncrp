class TaxiLight extends VehicleComponent {

    static classname = "VehicleComponent.TaxiLight";

    constructor (data = null) {
        base.constructor(data);

        if (this.data == null) {
            this.data = {
                status = false
            }
        }
    }

    function getState() {
        return getTaxiLightState( vehicleID );
    }

    function setState(to) {
        setTaxiLightState( vehicleID, to );
        base.setState( to );
    }
}
