class Item.VehicleTitle extends Item.Abstract
{
    static classname = "Item.VehicleTitle";
    default_decay = 0;
    volume        = 0.0063;

    function use(playerid, inventory) {

        local vehicleid = getVehicleByPlateText(this.data.plate.toupper());

        if (vehicleid == null) {
            return msg(playerid, "inventory.vehicletitle.removedcar", CL_HELP_TITLE);
        }

        local ownerid   = this.data.ownerid;
        local date      = this.data.date;
        local year      = this.data.year;
        local price     = this.data.price;
        local owners    = this.data.owners;
        local ownersCount = this.data.owners.len() + 1;

        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "Item.VehicleTitle", CL_HELP_TITLE);
        msg(playerid, "inventory.vehicletitle.modelandplate", [ getVehicleNameByModelId( getVehicleModel(vehicleid) ), getVehiclePlateText(vehicleid) ], CL_WHITE);
        msg(playerid, "inventory.vehicletitle.manufactureyear", year, CL_WHITE);
        msg(playerid, "inventory.vehicletitle.manufactureprice", price, CL_WHITE);

        msg(playerid, "inventory.vehicletitle.owners", ownersCount, CL_WHITE);
        msg(playerid, "  "+date+" - "+getPlayerName(getPlayerIdFromCharacterId(ownerid)), CL_SUCCESS);
        local ownersStrings = 7;
        for (local i = (ownersCount - 1); i > (ownersCount - 1 - ownersStrings); i--) {
            if (!(i in owners)) return;
            msg(playerid, "  "+owners[i][1]+" - "+owners[i][2]+" "+owners[i][0], CL_WHITE);
        }

    }

    function canBeDestroyed() {
        return false;
    }

    static function getType() {
        return "Item.VehicleTitle";
    }
}

