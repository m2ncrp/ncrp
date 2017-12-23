class Item.VehicleKey extends Item.Abstract
{
    static classname = "Item.VehicleKey";
    weight      = 0.10;

    constructor () {
        base.constructor();
        this.dataCorrection();
    }

    /**
     * This method should solve the preblem when key's been created
     * but without any data in it for some reason. Also prevents
     * from errors in console and allow to work futher with item.
     */
    function dataCorrection() {
        if (this.data == null || this.data.len() == 0) {
            this.data = {
                id = -2
            }
        }
    }

    function use(playerid, inventory) {
        this.dataCorrection();

        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "Item.VehicleKey", CL_HELP_TITLE);
        // local vehicleid = getVehicleIdFromEntityId(this.data.id);
        // msg(playerid, getVehiclePlateText(vehicleid)+" - "+getVehicleNameByModelId( getVehicleModel(vehicleid) ), CL_WHITE);
        msg(playerid, "  - " + this.data.id, CL_WHITE);
    }

    function setParentId(newParentId) {
        this.dataCorrection();
        this.data.id = newParentId;
    }

    static function getType() {
        return "Item.VehicleKey";
    }
}
