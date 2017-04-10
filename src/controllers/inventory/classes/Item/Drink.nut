class Item.Drink extends Item.Abstract
{
    static classname = "Item.Drink";

    amount = 0;

    static function getType() {
        return "Item.Drink";
    }

    function use(playerid, inventory) {
        msg(playerid, "Вы успешно выпили напиток");
        addPlayerThirst(playerid, this.amount);
        inventory.remove(this.slot).remove();
        inventory.sync();
    }
}
