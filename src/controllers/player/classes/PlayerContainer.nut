class PlayerContainer extends Container
{
    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor() {
        base.constructor();
        this.__ref = Character;
    }


    /**
     * @deprecated alias for getAll
     * @return {Table}
     */
    function getPlayers() {
        return this.getAll();
    }


    /**
     * Meta impelemtation for set
     * @param {Integer} name
     * @param {Character} value
     */
    function _set(playerid, value) {
        throw "PlayerContainer: you cant insert new data directly!";
    }


    /**
     * Deprecated
     * @param  {Integer} id
     * @return {Character}
     */
    function getPlayer(playerid) {
        return this.get(playerid);
    }


    /**
     * Find nearest player id to particular player
     * @param  {Integer} playerid
     * @return {Integer}
     */
    function nearestPlayer(playerid) {
        local min = null;
        local closestid = null;

        // iterate over player, and calculate distance with each one
        foreach(targetid, data in this.getPlayers()) {
            local dist = getDistance(playerid, targetid);

            // compare with smallest, and if less - override smallest
            if ((dist < min || !min) && targetid != playerid) {
                min = dist;
                closestid = targetid;
            }
        }
        return closestid;
    }
}
