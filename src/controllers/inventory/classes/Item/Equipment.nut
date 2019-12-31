class Item.Equipment extends Item.Abstract
{
    static classname = "Item.Equipment";

    static function getType() {
        return "Item.Equipment";
    }

    default_decay = 0; // бесконечное хранение на земле

    function use(playerid, inventory) {
        triggerClientEvent(playerid, "showCraftWindow");
    }

}
