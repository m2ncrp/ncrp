class Item.Drink extends Item.Abstract
{
    static classname = "Item.Drink";

    static function getType() {
        return "Item.Drink";
    }

    function use(playerid, inventory) {
        msg(playerid, format("Вы выпили: %s", plocalize(playerid, this.classname)));
        addPlayerThirst(playerid, randomf(this.amount - 5.0, this.amount + 5.0));
        inventory.remove(this.slot).remove();
        inventory.sync();
    }
}
