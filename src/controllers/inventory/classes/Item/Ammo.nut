class Item.Ammo extends Item.Abstract
{
    static classname = "Item.Ammo";
    capacity = 0;

    constructor () {
        base.constructor();
        this.stackable = true;
        this.maxstack  = 10;
    }

    function calculateVolume () {
        return this.volume * this.amount;
    }

    function use(playerid, inventory) {
        msg(playerid, format("Вы использовали: %s", this.classname));
    }

    static function getType() {
        return "Item.Ammo";
    }
}
