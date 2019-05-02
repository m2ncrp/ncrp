class Item.VehicleTax extends Item.Abstract
{
    static classname = "Item.VehicleTax";
    volume      = 0.0056;

    function use(playerid, inventory) {
        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "tax.info.title" , CL_HELP_TITLE);
        msg(playerid, "tax.info.plate"  , [ this.data["plate"]   ], CL_WHITE);
        msg(playerid, "tax.info.model"  , [ getVehicleNameByModelId( this.data["model"] )   ], CL_WHITE);
        msg(playerid, "tax.info.issued" , [ this.data["issued"]  ], CL_WHITE);
        msg(playerid, "tax.info.expires", [ this.data["expires"] ], CL_WHITE);
    }

    static function getType() {
        return "Item.VehicleTax";
    }
}
