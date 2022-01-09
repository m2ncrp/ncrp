class Item.XmasGift extends Item.Abstract
{
    static classname = "Item.XmasGift";

    default_decay = 0;
    volume = 0.75;

    function use(playerid, inventory) {
        inventory.remove(this.slot).remove();

        local charid = getCharacterIdFromPlayerId(playerid);

        local itemName = generateNewYearGiftName();

        local item = Item[itemName]();

        inventory.set(this.slot, item);
        inventory.sync();
        item.save();
    }

    static function getType() {
        return "Item.XmasGift";
    }
}
