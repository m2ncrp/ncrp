class VComponent.Trunk extends VehicleComponent {
    static classname = "ComponentTrunk";

    traits = [
        Openable(),
    ];

    constructor (vehicleid, status = false) {
        base.constructor(vehicleid, status);

        this.type      = "Engine";
        this.subtype   = "Engine";
        this.partID    = VEHICLE_PART_TRUNK; // ~ 1
    }

    function action() {
        this.status = !status; // if it's true so it was open. Become false
        this.correct(); // so it will be closed
    }

    function correct() {
        this.setState(vehicleid, partID, status);
    }
}
