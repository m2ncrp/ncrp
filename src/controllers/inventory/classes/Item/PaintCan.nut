class Item.PaintCan extends Item.Abstract
{
    static classname = "Item.PaintCan";

    function use(playerid, inventory) {
        local vehicleid = getPlayerVehicle(playerid);

        setVehicleColor(vehicleid, this.data.r, this.data.g, this.data.b, this.data.r, this.data.g, this.data.b);
    }

    static function getType() {
        return "Item.PaintCan";
    }
}
