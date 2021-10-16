class Item.VehicleKey extends Item.Abstract
{
    static classname = "Item.VehicleKey";
    default_decay = 0;
    volume        = 0.0105;

    function use(playerid, inventory) {
        local vehicleid = getVehicleIdFromEntityId(this.data.id);

        if (vehicleid == false) {
                   msg(playerid, "inventory.vehiclekey.removedcar", CL_HELP_TITLE);
            return msg(playerid, "inventory.vehiclekey.removedcar-hint", CL_LYNCH);
        }

        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "Item.VehicleKey", CL_HELP_TITLE);
        msg(playerid, getVehiclePlateText(vehicleid)+" - "+getVehicleNameByModelId( getVehicleModel(vehicleid) ), CL_WHITE);
    }

    function serialize() {
        local data = base.serialize();

        local vehicleid = getVehicleIdFromEntityId(this.data.id);

        if(vehicleid != false) {
            data.temp = {
                plate = getVehiclePlateText(vehicleid),
                modelName = getVehicleNameByModelId(getVehicleModel(vehicleid))
            }
        }

        return data;
    }

    static function getType() {
        return "Item.VehicleKey";
    }
}
