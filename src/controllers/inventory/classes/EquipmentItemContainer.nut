class EquipmentItemContainer extends ItemContainer
{
    static classname = "Equipment";

    id      = null;
    parent  = null;
    limit   = 10.0;

    sizeX = 3;
    sizeY = 3;

    item_state = Item.State.EQUIPMENT_INV;

    /**
     * Create new instance
     * @return {EquipmentItemContainer}
     */
    constructor(item, data = null) {
        base.constructor();

        this.id     = md5(this.tostring());
        this.parent = item;
        this.title  = item.classname;

        if (data != null) {
            this.sizeX = data.sizeX;
            this.sizeY = data.sizeY;
            this.limit = data.limit;
        }
    }
}
