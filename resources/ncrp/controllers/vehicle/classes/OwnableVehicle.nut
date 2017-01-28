class OwnableVehicle extends NativeVehicle {
    ownership = {
        status   = VEHICLE_OWNERSHIP_NONE,
        owner    = null,
        ownerid  = -1,
    };

    /**
     * Set vehicle owner
     * can be passed as playername or connected playerid
     *
     * @param {Mixed} playerNameOrId
     */
    function setOwner(playerNameOrId, ownerid = null) {
        local playerid = -1;

        // if its id - get name from it
        if (typeof playerNameOrId == "integer") {
            if (isPlayerConnected(playerNameOrId)) {
                playerid = playerNameOrId;
                playerNameOrId = getPlayerName(playerNameOrId);
            } else {
                return dbg("[vehicle] OwnableVehicle.setOwner: trying to set for playerid that aint connected #" + playerNameOrId);
            }
        } else {
            playerid = getPlayerIdFromName(playerNameOrId);
        }

        this.ownership.status = VEHICLE_OWNERSHIP_SINGLE;
        this.ownership.owner = playerNameOrId;

        if (playerid != -1 && isPlayerLoaded(playerid)) {
            this.ownership.ownerid = players[playerid].id;
        } else if (ownerid) {
            this.ownership.ownerid = ownerid.tointeger();
        }

        dbg("id: " + this.vid + "; owner: " + this.ownership.owner);
        return true;
    }


    /**
     * Get vehicle owner name or null
     *
     * @return {mixed}
     */
    function getOwner() {
        return this.ownership.owner;
    }


    /**
     * Check if current connected player is owner of ther car
     *
     * @param  {integer}  playerid
     * @return {Boolean}
     */
    function isOwner(playerid) {
        return (isPlayerConnected(playerid) && isPlayerLoaded(playerid) && getOwnerId() == players[playerid].id);
    }


    /**
     * Checks if current vehicle has owner
     * @return {Boolean}
     */
    function isOwned() {
        return (getOwnerId() != -1);
    }


    /**
     * Get vehicle owner name or null
     *
     * @return {mixed}
     */
    function getOwnerId() {
        return this.ownership.ownerid;
    }
}
