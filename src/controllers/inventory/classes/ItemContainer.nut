class ItemContainer extends Container
{
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
    }

    /**
     * Method shows inventory for player
     * @param  {Integer} playerid
     * @return {Boolean}
     */
    function show(playerid) {
        this.opened[playerid] <- true;
        return trigger(playerid, "invetory:onServerOpen", this.id, this.serialize());
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
            items = [],
        };

        foreach (idx, item in this) {
            data.items.push(item.serialize());
        }

        return JSONEncoder.encode(data);
    }

    function fillInEmpty() {
        // todo
    }
}
