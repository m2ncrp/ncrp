class Item.None extends Item.Abstract
{
    static classname = "Item.None";

    constructor (slot = 0) {
        this.slot = slot;
    }

    function save() {
        return;
    }

    static function getType() {
        return "Item.None";
    }
}
