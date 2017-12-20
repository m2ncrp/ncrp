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
    constructor(item) {
        base.constructor();

        this.id     = md5(this.tostring());
        this.parent = item;
        this.title  = "Vehicle trunk";
    }

    // function canBeInserted(item) {
    //     if (this.parent.id == item.id || item instanceof Item.Storage) {
    //         return false;
    //     }
    //     return base.canBeInserted(item);
    // }

    // /**
    //  * Overrides for syncing
    //  * @param {Mixed} key
    //  * @param {Item.Abstract} item
    //  */
    // function set(key, item) {
    //     if (this.parent.id != item.id && !(item instanceof Item.Storage)) {
    //         item.parent = this.parent.id;
    //         return base.set(key, item);
    //     } else {
    //         throw "Can't storage into storage in TrunkItemContainer.nut";
    //         //return false;
    //     }
    // }
}
