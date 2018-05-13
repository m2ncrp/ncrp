class Item.VehicleTitle extends Item.Abstract
{
    static classname = "Item.VehicleTitle";
    default_decay = 0;
    weight        = 0.05;

    function use(playerid, inventory) {
        local vehicleid = getVehicleIdFromEntityId(this.data.id);
        local ownerid   = this.data.ownerid;

        make, and year of manufacture.
        weight, motive power, price

        history


        if (!vehicleid) {
            return msg(playerid, "inventory.vehicletitle.removedcar", CL_HELP_TITLE);
        }

        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "Item.VehicleTitle", CL_HELP_TITLE);
        msg(playerid, getVehiclePlateText(vehicleid)+" - "+getVehicleNameByModelId( getVehicleModel(vehicleid) ), CL_WHITE);
    }

    static function getType() {
        return "Item.VehicleTitle";
    }
}
