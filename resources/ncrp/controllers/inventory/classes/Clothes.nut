class Item.Clothes extends Item.Item
{
    static classname = "Item.Clothes";
    capacity = 0;

    constructor () {
        base.constructor();
        this.type = ITEM_TYPE.CLOTHES;
        this.stackable = false;
    }

    function calculateWeight () {
        return this.weight * this.amount;
    }

    function use(playerid) {
        msg(playerid, format("Вы использовали: %s", this.classname));
    }

}
