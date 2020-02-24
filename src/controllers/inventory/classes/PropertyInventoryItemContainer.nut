class PropertyInventoryItemContainer extends ItemContainer
{
    static classname = "PropertyInventory";

    id      = null;
    parent  = null;
    limit   = 50.0;

    sizeX = 3;
    sizeY = 1;

    item_state = Item.State.PROPERTY_INV;

    /**
     * Create new instance
     * @return {PropertyInventoryItemContainer}
     */
    constructor(property) {
        base.constructor();

        this.id     = md5(this.tostring());
        this.parent = property;
        this.title  = "inventory.property.title";
        log(property)
        // if (property.data.inventory != null) {
        //     this.sizeX = property.data.inventory.sizeX;
        //     this.sizeY = property.data.inventory.sizeY;
        //     this.limit = property.data.inventory.limit;
        // }
    }

    function canBeInserted(item) {
        dbg("trying to insert item");
        return base.canBeInserted(item);
    }

    function set(key, item) {
        item.parent = this.parent.id;
        return base.set(key, item);
    }
}
