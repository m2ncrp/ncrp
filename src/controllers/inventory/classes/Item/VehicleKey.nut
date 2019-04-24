class Item.VehicleKey extends Item.Abstract
{
    static classname = "Item.VehicleKey";
    default_decay = 0;
    volume        = 0.10;

    function use(playerid, inventory) {
        local vehicleid = getVehicleIdFromEntityId(this.data.id);

        if (vehicleid == false) {
            return msg(playerid, "inventory.vehiclekey.removedcar", CL_HELP_TITLE);
        }

        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "Item.VehicleKey", CL_HELP_TITLE);
        msg(playerid, getVehiclePlateText(vehicleid)+" - "+getVehicleNameByModelId( getVehicleModel(vehicleid) ), CL_WHITE);
    }

    static function getType() {
        return "Item.VehicleKey";
    }
}
