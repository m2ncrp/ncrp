class Item.Coupon extends Item.Abstract
{
    static classname = "Item.Coupon";

    weight = 0.02;

    static function getType() {
        return "Item.Coupon";
    }

    function use(playerid, inventory) {

        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "tax.info.title" , CL_HELP_TITLE);
        //msg(playerid, "tax.info.plate"  , [ this.data["plate"]   ], CL_WHITE);
    }
}
