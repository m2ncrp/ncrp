class StorageItemContainer extends ItemContainer
{
    static classname = "Storage";

    id      = null;
    parent  = null;
    limit   = 10.0;

    sizeX = 3;
    sizeY = 3;

    item_state = Item.State.STORAGE;

    /**
     * Create new instance
     * @return {StorageItemContainer}
     */
    constructor(item) {
        base.constructor();

        this.id     = md5(this.tostring());
        this.parent = item;
        this.title  = item.classname;
    }

    function canBeInserted(item) {
        if ((this.parent.id == item.id && (this.parent.id != 0 || item.id != 0)) || item instanceof Item.Storage) {
            return false;
        }
        return base.canBeInserted(item);
    }

    function sync() {
        base.sync();

        local item = this.parent;
        if (item.inventory) {
            item.inventory.sync();
        }
    }

    /**
     * Overrides for syncing
     * @param {Mixed} key
     * @param {Item.Abstract} item
     */
    function set(key, item) {
        item.parent = this.parent.id;
        return base.set(key, item);
    }
}
