class PlayerItemContainer extends ItemContainer
{
    static classname = "PlayerItemContainer";

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
        base.constructor(Item.Abstract);

        this.id     = md5(this.tostring());
        this.parent = playerid;
    }
}
