class Item.Drink extends Item.Abstract
{
    static classname = "Item.Drink";
    hasAnimation = true;
    model = 1;

    static function getType() {
        return "Item.Drink";
    }

    function use(playerid, inventory) {
        this.animate(playerid, "Use" + this.getType(), this.model);
        msg(playerid, format("Вы выпили: %s", plocalize(playerid, this.classname)));
        addPlayerThirst(playerid, randomf(this.amount - 5.0, this.amount + 5.0));
        inventory.remove(this.slot).remove();
        inventory.sync();
    }
}
