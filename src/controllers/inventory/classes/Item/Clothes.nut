class Item.Clothes extends Item.Abstract
{
    static classname = "Item.Clothes";

    function use(playerid, inventory) {
        msg(playerid, format("you used: %s with model: %s", this.classname, this.amount));
    }

    static function getType() {
        return "Item.Clothes";
    }
}
