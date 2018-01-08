class TrunkItemContainer extends ItemContainer
{
    static classname = "Trunk";

    id      = null;
    parent  = null;
    limit   = 10.0;

    sizeX = 3;
    sizeY = 3;

    item_state = Item.State.TRUNK;

    /**
     * Create new instance
     * @return {TrunkItemContainer}
     */
    constructor(vehicle, model = null) {
        base.constructor();

        this.id     = md5(this.tostring());
        this.parent = vehicle;
        this.title  = "Vehicle trunk";

        if (model != null) {
            this.sizeX = getTrunkDefaultSizeX(model);
            this.sizeY = getTrunkDefaultSizeY(model);
            this.limit = getTrunkDefaultWeightLimit(model);
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
