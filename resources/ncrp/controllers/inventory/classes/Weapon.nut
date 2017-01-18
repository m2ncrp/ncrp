class Item.Weapon extends Item.Item
{
    static classname = "Item.Weapon";
    capacity = 0;

    constructor () {
        base.constructor();
        this.type = ITEM_TYPE.WEAPON;
    }
}
