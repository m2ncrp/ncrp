class PlayerItemContainer extends ItemContainer
{
    static classname = "InteractableInventory";

    id      = null;
    parent  = null;
    limit   = 35.0;

    sizeX = 4;
    sizeY = 5;

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor(playerid) {
        base.constructor();

        this.id     = md5(this.tostring());
        this.title  = "Inventory of " + getPlayerName(playerid);
        this.parent = playerid;
    }
}
