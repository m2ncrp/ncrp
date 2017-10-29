class PlayerHandsContainer extends PlayerItemContainer
{
    static classname = "PlayerHands";

    sizeX = 1;
    sizeY = 1;

    item_state = Item.State.PLAYER_HAND;

    /**
     * Check if hand is free
     * @return {Boolean}
     */
    function isFree() {
        return !this.exists(0);
    }

    /**
     * Set current hand item
     * @param {Item}
     * @return {Boolean}
     */
    function setItem(item) {
        if (!this.isFree()) {
            return false;
        }

        base.set(0, item);
        return true;
    }
}
