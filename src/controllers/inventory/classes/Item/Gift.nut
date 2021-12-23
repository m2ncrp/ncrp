class Item.Gift extends Item.Abstract
{
    static classname = "Item.Gift";

    default_decay = 0;
    volume = 1.0;

    function use(playerid, inventory) {
        inventory.remove(this.slot).remove();

        local charid = getCharacterIdFromPlayerId(playerid);

        local itemName = generateNewYearGiftName();

        local item = Item[itemName]();

        inventory.set(this.slot, item);
        inventory.sync();
    }

    static function getType() {
        return "Item.Gift";
    }
}
