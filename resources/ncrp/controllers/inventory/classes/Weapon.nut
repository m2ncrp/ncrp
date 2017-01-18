class Item.Weapon extends Item.Item
{
    static classname = "Item.Weapon";

    capacity    = 0;
    model       = 0;
    ammo        = "";
    constructor () {
        base.constructor();
        this.type = ITEM_TYPE.WEAPON;
    }

    function calculateWeight () {
        return this.weight;
    }
}
