class Item.VehicleKey extends Item.Abstract
{
    static classname = "Item.VehicleKey";
    default_decay = 259200;
    weight        = 0.10;

    constructor (data = null) {
        base.constructor();
        if (data == null) {
            this.data = { code = generateHash(3) };
        }
    }

    function use(playerid, inventory) {
        // TODO: add new print
        msg(playerid, "ADD NICE KEY PRINT STUFF", CL_HELP_LINE);

        // local vehicleid = getVehicleIdFromEntityId(this.data.id);

        // if (!vehicleid) {
        //     return msg(playerid, "inventory.vehiclekey.removedcar", CL_HELP_TITLE);
        // }

        // msg(playerid, "==================================", CL_HELP_LINE);
        // msg(playerid, "Item.VehicleKey", CL_HELP_TITLE);
        // msg(playerid, getVehiclePlateText(vehicleid)+" - "+getVehicleNameByModelId( getVehicleModel(vehicleid) ), CL_WHITE);
    }

    static function getType() {
        return "Item.VehicleKey";
    }
}
