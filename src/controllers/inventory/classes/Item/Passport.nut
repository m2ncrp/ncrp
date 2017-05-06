class Item.Passport extends Item.Abstract
{
    static classname = "Item.Passport";
    weight      = 0.2;

    function use(playerid, inventory) {
        msg(playerid, "=========== COMING SOON ==========", CL_HELP_LINE);
        /*
        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "tax.info.title" , CL_HELP_TITLE);
        msg(playerid, "tax.info.plate"  , [ this.data["plate"]   ], CL_WHITE);
        msg(playerid, "tax.info.model"  , [ getVehicleNameByModelId( this.data["model"] )   ], CL_WHITE);
        msg(playerid, "tax.info.issued" , [ this.data["issued"]  ], CL_WHITE);
        msg(playerid, "tax.info.expired", [ this.data["expired"] ], CL_WHITE);
        */
    }

    static function getType() {
        return "Item.Passport";
    }
}
