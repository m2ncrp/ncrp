class PlayerItemContainer extends ItemContainer
{
    static classname = "PlayerInventory";

    id      = null;
    parent  = null;
    limit   = 35.0;
    blocked = true;

    sizeX = 4;
    sizeY = 5;

    item_state = Item.State.PLAYER;

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor(playerid) {
        base.constructor();

        this.id     = md5(this.tostring());
        this.title  = "Inventory of " + getPlayerName(playerid);
        this.parent = players[playerid];
    }

    /**
     * Overrides for syncing
     * @param {Mixed} key
     * @param {Item.Abstract} value
     */
    function set(key, value) {
        value.parent = this.parent.id;
        return base.set(key, value);
    }

    /**
     * Show invetory for particular player
     * or for current player if no playerid
     * @param  {Integer} playerid
     * @return {Boolean}
     */
    function show(playerid = null) {
        if (!playerid) {
            playerid = this.parent.playerid;
        }

        base.show(playerid);
        trigger(playerid, "onPlayerInventoryShow");
        trigger("onPlayerInventoryShow", playerid);
    }

    /**
     * Hide invetory for particular player
     * or for current player if no playerid
     * @param  {Integer} playerid
     * @return {Boolean}
     */
    function hide(playerid = null) {
        if (!playerid) {
            playerid = this.parent.playerid;
        }

        base.hide(playerid);
        trigger(playerid, "onPlayerInventoryHide");
        trigger("onPlayerInventoryHide", playerid);
    }
}
