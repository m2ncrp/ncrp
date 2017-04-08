class PlayerHandsContainer extends ItemContainer
{
    static classname = "PlayerHands";

    id      = null;
    parent  = null;
    limit   = 35.0;

    sizeX = 2;
    sizeY = 2;

    item_state = Item.State.PLAYER_HAND;

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor(playerid) {
        base.constructor();

        this.id     = md5(this.tostring());
        this.title  = "";
        this.parent = playerid;
    }
}
