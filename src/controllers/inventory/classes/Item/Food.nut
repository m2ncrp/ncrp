class Item.Food extends Item.Abstract
{
    static classname = "Item.Food";

    amount = 0;

    static function getType() {
        return "Item.Food";
    }

    function use(playerid, inventory) {
        msg(playerid, "Вы успешно употребили пищу");
        addPlayerHunger(playerid, this.amount);
        inventory.remove(this.slot).remove();
        inventory.sync();
    }
}
