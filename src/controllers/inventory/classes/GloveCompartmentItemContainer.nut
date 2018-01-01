class GloveCompartmentItemContainer extends ItemContainer
{
    static classname = "Glove compartment";

    id      = null;
    parent  = null;
    limit   = 1.5;

    sizeX = 3;
    sizeY = 1;

    item_state = Item.State.GLOVE_COMPART;

    /**
     * Create new instance
     */
    constructor(vehicle) {
        base.constructor();

        this.id     = md5(this.tostring());
        this.parent = vehicle;
        this.title  = "Vehicle glove compartment";
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
