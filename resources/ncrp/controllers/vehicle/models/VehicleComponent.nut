class VehicleComponent extends ORM.Entity
{
    static classname = "VehicleComponent";
    static table = "tbl_vcomponents";

    static fields = [
        ORM.Field.Integer({ name = "vehicleid", value = -1}), // link to vehicle in tbl_vehicles
        ORM.Field.Integer({ name = "type",      value = ""}), // Like is it door or is it trunk
        ORM.Field.Integer({ name = "subtype",   value = ""}), // Like is it left front door or right one
        ORM.Field.Integer({ name = "status",    value = 0 }), // Is it open/close or is it on or smth else
    ];

    traits = [
        ORM.Trait.Positionable(), // Couse its could be placed on the ground in future
    ];

    partID = null;

    constructor (vehicleid, status = false) {
        base.constructor();
        this.vehicleid = vehicleid;
        this.status    = status;
        partID = -1;
    }

    function beforeAction() {
        // overridable function
        // Some instructions before action starts
    }

    function action() {
        // overridable function
        // Run action instructions
    }

    function afterAction() {
        // overridable function
        // Some instructions after action's done
    }

    /**
     * Correct status from time to time
     * Also overridable function
     */
    function correct() {
        // Code
    }
}




class Openable extends ORM.Trait.Interface {
    function setState(vehicleID, partID, state) {
        setVehiclePartOpen(vehicleID, partID, state);
    }
}




class ComponentTrunk extends VehicleComponent {
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
        this.setState(vehicleid, partID, status); // so it will be closed
    }
}




class ComponentHood extends VehicleComponent {
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
        this.setState(vehicleid, partID, status);
    }
}




class ComponentEngine extends VehicleComponent {
    static classname = "ComponentEngine";

    constructor (vehicleid, status = false) {
        base.constructor(vehicleid, status);

        this.type      = "Engine";
        this.subtype   = "Engine";
        this.partID    = 3;
    }

    function action() {
        this.status = !status;
        setVehicleEngineState( vehicleID, status );
    }
}
