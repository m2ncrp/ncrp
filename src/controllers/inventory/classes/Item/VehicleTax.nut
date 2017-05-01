class Item.VehicleTax extends Item.Abstract
{
    static classname = "Item.VehicleTax";
    weight      = 0.02;

    function use(playerid, inventory) {
        msg(playerid, "Expired: "+this.data["expired"], CL_SUCCESS);
    }

    static function getType() {
        return "Item.VehicleTax";
    }
}
