class VehicleComponent extends ORM.Entity
{
    static classname = "VehicleComponent";
    static table = "tbl_vcomponents";

    static fields = [
        ORM.Field.Integer({ name = "vehicleid", value = -1}), // link to vehicle in tbl_vehicles
        ORM.Field.String({  name = "type",      value = ""}), // Like is it door or is it trunk
        ORM.Field.String({  name = "subtype",   value = ""}), // Like is it left front door or right one
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
