class Item.Box extends Item.Storage
{
    static classname = "Item.Box";

    weight = 4.0;
    model = null;

    static function getType() {
        return "Item.Box";
    }

    constructor () {
        base.constructor();
    }

    function canBeDestroyed() {
        return (this.calculateWeight() == this.weight);
    }
}
