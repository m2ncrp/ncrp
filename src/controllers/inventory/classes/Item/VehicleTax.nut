class Item.VehicleTax extends Item.Abstract
{
    static classname = "Item.VehicleTax";
    weight      = 0.02;

    function use(playerid, inventory) {
        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "tax.info.title" , CL_HELP_TITLE);
        msg(playerid, "tax.info.plate"  , [ this.data["plate"]   ], CL_WHITE);
        msg(playerid, "tax.info.model"  , [ ::getVehicleNameByModelId( this.data["model"] )   ], CL_WHITE);
        msg(playerid, "tax.info.issued" , [ this.data["issued"]  ], CL_WHITE);
        msg(playerid, "tax.info.expired", [ this.data["expired"] ], CL_WHITE);
    }

    static function getType() {
        return "Item.VehicleTax";
    }
}
