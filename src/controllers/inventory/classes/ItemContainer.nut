class ItemContainer extends Container
{
    static classname = "ItemContainer";

    id      = null;
    parent  = null;
    title   = "Default Container";

    /**
     * Current conainer size
     * @type {Number}
     */
    sizeX = 3;
    sizeY = 3;

    /**
     * Curent container size limit (weight)
     * @type {Number}
     */
    limit = -1;

    /**
     * List of players container
     * is currently opened for
     * @type {Table}
     */
    opened = null;

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor() {
        base.constructor();
        this.__ref = Item.Abstract;

        this.id = md5(this.tostring());
        this.opened = {};

        trigger("onInventoryRegistred", this);
    }

    /**
     * Method shows inventory for player
     * @param  {Integer} playerid
     * @return {Boolean}
     */
    function show(playerid) {
        this.opened[playerid] <- true;
        return trigger(playerid, "inventory:onServerOpen", this.id, this.serialize());
    }

    /**
     * Method hides inventory for player
     * @param  {Integer} playerid
     * @return {Boolean}
     */
    function hide(playerid) {
        if (playerid in this.opened) {
            delete this.opened[playerid];
        }

        return trigger(playerid, "inventory:onServerClose", this.id);
    }

    /**
     * Sync inventory containment for all currently viewing it players
     * @return {Boolean}
     */
    function sync() {
        foreach (playerid, value in this.opened) {
            trigger(playerid, "inventory:onServerOpen", this.id, this.serialize());
        }

        return true;
    }

    /**
     * Switch current state of inventory for particular player
     * @param  {Integer} playerid
     * @return {Boolean} state
     */
    function toggle(playerid) {
        if (playerid in this.opened) {
            return this.hide(playerid);
        }

        return this.show(playerid);
    }

    /**
     * Check if current player have this inventory opened
     * @param  {Integer} playerid
     * @return {Boolean}
     */
    function isOpened(playerid) {
        return (playerid in this.opened);
    }

    /**
     * Serializes containing items into json string
     * @return {String}
     */
    function serialize() {
        local data = {
            title = this.title,
            sizeX = this.sizeX,
            sizeY = this.sizeY,
            sizeY = this.sizeY,
            limit = this.limit,
            type  = this.classname,
            items = [],
        };

        foreach (idx, item in this) {
            data.items.push(item.serialize());
        }

        return JSONEncoder.encode(data);
    }

    /**
     * Overrides for syncing
     * @param {Mixed} key
     * @param {Item.Abstract} value
     */
    function set(key, value) {
        base.set(key, value);
        return this.sync();
    }

    /**
     * Overrides for syncing
     * @param {Mixed} key
     */
    function remove(key) {
        base.remove(key);
        return this.sync();
    }

    /**
     * Overrides for syncing
     * @param {Mixed} key1
     * @param {Mixed} key2
     */
    function swap(key1, key2) {
        base.swap(key1, key2);
        return this.sync();
    }
}
