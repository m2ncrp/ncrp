class VehicleItemContainer extends ItemContainer
{
    static classname = "VehicleInventory";

    id      = null;
    parent  = null;
    limit   = 10.0;

    sizeX = 3;
    sizeY = 3;

    item_state = Item.State.VEHICLE_INV;

    /**
     * Create new instance
     * @return {VehicleItemContainer}
     */
    constructor(vehicle, data = null) {
        base.constructor();

        this.id     = md5(this.tostring());
        this.parent = vehicle;
        this.title  = "inventory.trunk.title";

        if (data != null) {
            this.sizeX = data.sizeX;
            this.sizeY = data.sizeY;
            this.limit = data.limit;
        }
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
