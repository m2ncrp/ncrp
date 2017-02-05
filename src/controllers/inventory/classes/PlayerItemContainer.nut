class PlayerItemContainer extends Container
{
    id      = null;
    parent  = null;
    limit   = 35;

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor(playerid) {
        base.constructor();
        this.__ref = Item.Abstract;

        this.id     = md5(this.tostring());
        this.parent = playerid;
    }
}
