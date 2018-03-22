class TaxiLight extends NVC {

    static classname = "NVC.TaxiLight";

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
