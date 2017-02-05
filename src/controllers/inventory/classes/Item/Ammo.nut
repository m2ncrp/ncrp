class Item.Ammo extends Item.Abstract
{
    static classname = "Item.Ammo";
    capacity = 0;

    constructor () {
        base.constructor();
        this.stackable = true;
        this.maxstack  = 10;
    }

    function calculateWeight () {
        return this.weight * this.amount;
    }

    function use(playerid) {
        msg(playerid, format("Вы использовали: %s", this.classname));
    }
}
