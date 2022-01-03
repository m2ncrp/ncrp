class Item.Xmas extends Item.Abstract
{
    static classname = "Item.Xmas";
    hasAnimation = false;

    static function getType() {
        return "Item.Xmas";
    }

    function use(playerid, inventory) {
        msg(playerid, format("Коллекционный предмет: %s", plocalize(playerid, this.classname)));
    }
}
