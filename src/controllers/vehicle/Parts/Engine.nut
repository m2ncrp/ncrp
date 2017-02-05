class VehicleComponent.Engine extends VehicleComponent {
    static classname = "VehicleComponent.Engine";

    constructor (vehicleid, status = false) {
        base.constructor(vehicleid, status);

        this.type      = "Engine";
        this.subtype   = "Engine";
        this.partID    = 3;
    }

    function action() {
        this.status = !status;
        setVehicleEngineState( vehicleid, status );
    }

    function correct() {
        setVehicleEngineState( vehicleid, status );
    }
}
