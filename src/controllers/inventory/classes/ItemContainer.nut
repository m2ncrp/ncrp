class ItemContainer extends Container
{
    static classname = "Inventory";

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
     * Item state setted up by this inventory
     * @type {Integer}
     */
    item_state = Item.State.NONE;

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor() {
        base.constructor(Item.Abstract);

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
        local character = players[playerid];
        this.opened[character.id] <- character;

        return trigger(playerid, "inventory:onServerOpen", this.id, this.serialize());
    }

    /**
     * Method hides inventory for player
     * @param  {Integer} playerid
     * @return {Boolean}
     */
    function hide(playerid) {
        local character = players[playerid];

        if (this.isOpened(playerid)) {
            delete this.opened[character.id];
        }

        dbg("sending hide for ", this.id);
        return trigger(playerid, "inventory:onServerClose", this.id);
    }

    /**
     * Sync inventory containment for all currently viewing it players
     * @return {Boolean}
     */
    function sync() {
        foreach (characterid, character in this.opened) {
            if (character.playerid != -1 && isPlayerConnected(character.playerid)) {
                if (getPlayerName(character.playerid) == character.getName()) {
                    trigger(character.playerid, "inventory:onServerOpen", this.id, this.serialize());
                }
            }
        }

        return true;
    }

    /**
     * Switch current state of inventory for particular player
     * @param  {Integer} playerid
     * @return {Boolean} state
     */
    function toggle(playerid) {
        if (this.isOpened(playerid)) {
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
        return (players[playerid].id in this.opened);
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
        value.slot = key;
        value.state = this.item_state;
        return base.set(key, value);
    }

    /**
     * Try to push item inside
     * return false if there is no space
     * @param  {Item} value
     * @return {Boolean}
     */
    function push(value) {
        for (local i = 0; i < this.sizeX * this.sizeY; i++) {
            if (this.exists(i)) {
                continue;
            }

            this.set(i, value);
            return true;
        }

        return false;
    }

    /**
     * Overrides for syncing
     * @param {Mixed} key
     */
    function remove(key, overrideKey = false) {
        if (overrideKey && this.exists(key)) {
            this.get(key).slot = -1;
        }

        return base.remove(key);
    }

    function freelen() {
        return (this.sizeX * this.sizeY) - this.len();
    }

    /**
     * Get total weight for all current items
     * @return {Float}
     */
    function getTotalWeight() {
        local weight = 0.0;

        foreach (idx, item in this.__data) {
            weight += item.weight;
        }

        return weight;
    }

    /**
     * Check wether item can be inserted
     * @param  {Item} item
     * @return {Boolean}
     */
    function canBeInserted(item) {
        if (((this.sizeX * this.sizeY) - this.len()) < 1) {
            return false;
        }

        if (this.getTotalWeight() + item.weight > this.limit) {
            return false;
        }

        return true;
    }
}
