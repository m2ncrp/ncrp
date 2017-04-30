class Item.Food extends Item.Abstract
{
    static classname = "Item.Food";

    static function getType() {
        return "Item.Food";
    }

    function use(playerid, inventory) {
        msg(playerid, format("Вы съели: %s", plocalize(playerid, this.classname)));
        addPlayerHunger(playerid, randomf(this.amount - 5.0, this.amount + 5.0));
        inventory.remove(this.slot).remove();
        inventory.sync();
    }
}
