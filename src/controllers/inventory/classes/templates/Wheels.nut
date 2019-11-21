class Item.Wheels extends Item.Abstract
{
    static classname = "Item.Wheels";
    name = "";
    static function getType() {
        return "Item.Wheels";
    }

    function use(playerid, inventory) {
        msg(playerid, format("Колёса: %s", plocalize(playerid, this.name)));
        //addPlayerThirst(playerid, randomf(this.amount - 5.0, this.amount + 5.0));
        //inventory.remove(this.slot).remove();
        //inventory.sync();
    }
}
