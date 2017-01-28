class OwnableVehicle extends NativeVehicle {
    ownership = {
        status   = VEHICLE_OWNERSHIP_NONE,
        owner    = null,
        ownerid  = -1,
    };

    /**
     * Set vehicle owner
     * can be passed as playername or playerid(connected)
     *
     * @param {mixed} playerNameOrId
     */
    function setOwner(playerNameOrId) {
        // if its id - get name from it
        if (typeof playerNameOrId == "integer") {
            if (isPlayerConnected(playerNameOrId)) {
                playerNameOrId = getPlayerName(playerNameOrId);
            } else {
                return dbg("[vehicle] OwnableVehicle.setOwner: trying to set for playerid that aint connected #" + playerNameOrId);
            }
        }

        this.ownership.status = VEHICLE_OWNERSHIP_SINGLE;
        this.ownership.owner  = playerNameOrId;
        return true;
    }



    /**
     * Get vehicle owner name or null
     *
     * @param  {integer} vehicleid
     * @return {mixed}
     */
    function getOwner() {
        return this.ownership.owner;
    }


    /**
     * Check if current connected player is owner of ther car
     *
     * @param  {integer}  playerid
     * @param  {integer}  vehicleid
     * @return {Boolean}
     */
    function isOwner(playerid) {
        return (isPlayerConnected(playerid) && isPlayerLoaded(playerid) && getOwnerId(vehicleid) == players[playerid].id);
    }


    /**
     * Checks if current vehicle has owner
     * @param  {Integer}  vehicleid
     * @return {Boolean}
     */
    function isOwned() {
        return (getOwnerId(vehicleid) != -1);
    }


    /**
     * Get vehicle owner name or null
     *
     * @param  {integer} vehicleid
     * @return {mixed}
     */
    function getOwnerId(vehicleid) {
        return this.ownership.ownerid;
    }
}
