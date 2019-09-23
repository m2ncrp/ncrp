class VehicleInteriorItemContainer extends ItemContainer
{
    static classname = "VehicleInterior";

    id      = null;
    parent  = null;
    limit   = 50.0;

    sizeX = 3;
    sizeY = 1;

    item_state = Item.State.VEHICLE_INTERIOR;

    /**
     * Create new instance
     * @return {VehicleInteriorItemContainer}
     */
    constructor(vehicle, data = null) {
        base.constructor();

        this.id     = md5(this.tostring());
        this.parent = vehicle;
        this.title  = "inventory.interior.title";

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
