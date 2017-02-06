class ItemContainer extends Container
{
    id      = null;
    parent  = null;
    limit   = -1;

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor() {
        base.constructor();
        this.__ref = Item.Abstract;
        this.id = md5(this.tostring());
    }

    function show(playerid) {
        // todo
    }

    function hide(playerid) {
        // todo
    }

    function fillInEmpty() {
        // todo
    }
}
