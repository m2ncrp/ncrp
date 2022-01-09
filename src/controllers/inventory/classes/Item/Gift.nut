class Item.Gift extends Item.Abstract
{
    static classname = "Item.Gift";

    default_decay = 0;
    volume = 0.75;

    function use(playerid, inventory) {
        return msg(playerid, "Just a box");

        inventory.remove(this.slot).remove();

        local charid = getCharacterIdFromPlayerId(playerid);

        local itemName = generateNewYearGiftName();

        local item = Item[itemName]();

        inventory.set(this.slot, item);
        inventory.sync();
        item.save();
    }

    static function getType() {
        return "Item.Gift";
    }
}
