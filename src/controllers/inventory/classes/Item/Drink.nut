class Item.Drink extends Item.Abstract
{
    static classname = "Item.Drink";

    amount = 0;

    static function getType() {
        return "Item.Drink";
    }

    function use(playerid, inventory) {
        msg(playerid, format("you used drink: %s amout: %d", this.classname, this.amount));
    }
}
