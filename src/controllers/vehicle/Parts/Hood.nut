class VComponent.Hood extends VehicleComponent {
    static classname = "ComponentHood";

    traits = [
        Openable(),
    ];

    constructor (vehicleid, status = false) {
        base.constructor(vehicleid, status);

        this.type      = "Hood";
        this.subtype   = "Hood";
        this.partID    = VEHICLE_PART_HOOD; // ~ 0
    }

    function action() {
        this.status = !status;
        this.correct();
    }

    function correct() {
        this.setState(vehicleid, partID, status);
    }
}
