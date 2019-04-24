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
        if (this.parent.id == item.id || item instanceof Item.Storage) {
            return false;
        }
        return base.canBeInserted(item);
    }

    function isFreeVolume(value) {

        if (value instanceof Item.Abstract) {
            value = value.calculateVolume();
        } else {
            value = value.tofloat();
        }

        if (this.parent && (this.parent.state == Item.State.PLAYER || this.parent.state == Item.State.VEHICLE_INV || this.parent.state == Item.State.BUILDING_INV)) {
                // item is in some inventory (player, vehicle) (do the new code)
                msga("Base: "+base.calculateVolume(), [], CL_CHAT_MONEY_ADD)
                msga("Value: "+value, [], CL_CHAT_MONEY_ADD)
                msga("Limit: "+this.limit, [], CL_CHAT_MONEY_ADD)
                // алгоритм расчёта если ящик находится у игрока/авто/здания
                return base.isFreeVolume(value)
        } else {
            // item is on ground or elsewhere (do the old code)
            return base.isFreeVolume(value)
        }
    }

    /**
     * Overrides for syncing
     * @param {Mixed} key
     * @param {Item.Abstract} item
     */
    function set(key, item) {
        if (this.parent.id != item.id && !(item instanceof Item.Storage)) {
            item.parent = this.parent.id;
            return base.set(key, item);
        } else {
            throw "Can't storage into storage in StorageItemContainer.nut";
            //return false;
        }
    }
}
