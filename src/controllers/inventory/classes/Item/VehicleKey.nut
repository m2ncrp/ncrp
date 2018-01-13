class Item.VehicleKey extends Item.Abstract
{
    static classname = "Item.VehicleKey";
    weight      = 0.10;

    constructor (data = null) {
        base.constructor();
        if (data == null) {
            this.data = {
                id = md5("-1"),
            };
        }
    }

    function use(playerid, inventory) {

        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "Item.VehicleKey", CL_HELP_TITLE);
        // local vehicleid = getVehicleIdFromEntityId(this.data.id);
        // msg(playerid, getVehiclePlateText(vehicleid)+" - "+getVehicleNameByModelId( getVehicleModel(vehicleid) ), CL_WHITE);
        msg(playerid, "  - " + this.data.id, CL_WHITE);
    }

    function setIdBy(parentId) {
        this.data.id = md5( parentId.tostring() );
    }

    static function getType() {
        return "Item.VehicleKey";
    }
}
