class Item.Coupon extends Item.Abstract
{
    static classname = "Item.Coupon";

    weight = 0.02;
    model = null;

    static function getType() {
        return "Item.Coupon";
    }

    function use(playerid, inventory) {

        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "tax.info.title" , CL_HELP_TITLE);
        msg(playerid, "key "+this.model, CL_WHITE);
        msg(playerid, "amount"+this.amount, CL_WHITE);
    }

    function canBeDestroyed() {
        
    }
}
