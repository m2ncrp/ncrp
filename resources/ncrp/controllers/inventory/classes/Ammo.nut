class Item.Ammo extends Item.Item
{
    static classname = "Item.Ammo";
    capacity = 0;

    constructor () {
        base.constructor();
        this.type = ITEM_TYPE.AMMO;
        this.stackable = true;
        this.maxstack  = 10;
    }
}
