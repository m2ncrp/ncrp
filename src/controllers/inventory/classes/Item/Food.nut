class Item.Food extends Item.Abstract
{
    static classname = "Item.Food";

    amount = 0;

    static function getType() {
        return "Item.Food";
    }

    function use(playerid, inventory) {
        msg(playerid, format("you used food: %s amout: %d", this.classname, this.amount));
    }
}
