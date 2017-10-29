class Item.Weapon extends Item.Abstract
{
    static classname = "Item.Weapon";

    capacity    = 0;
    model       = 0;
    ammo        = "";

    function calculateWeight () {
        return this.weight;
    }

    function use(playerid, inventory) {
        msg(playerid, format("Вы использовали: %s", this.classname));
    }

    static function getType() {
        return "Item.Weapon";
    }
}
