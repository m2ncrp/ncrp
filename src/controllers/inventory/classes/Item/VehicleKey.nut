class Item.VehicleKey extends Item.Abstract
{
    static classname = "Item.VehicleKey";
    default_decay = 259200;
    weight        = 0.10;

    function use(playerid, inventory) {
        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "Item.VehicleKey", CL_HELP_TITLE);
        local vehicleid = getVehicleIdFromEntityId(this.data.id);
        msg(playerid, getVehiclePlateText(vehicleid)+" - "+getVehicleNameByModelId( getVehicleModel(vehicleid) ), CL_WHITE);
    }

    static function getType() {
        return "Item.VehicleKey";
    }
}
