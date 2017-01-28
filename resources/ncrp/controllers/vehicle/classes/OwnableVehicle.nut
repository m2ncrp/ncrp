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
     * @param {integer} vehicleid
     * @param {mixed} playerNameOrId
     */
    function setOwner(playerNameOrId) {
        // if its id - get name from it
        if (typeof playerNameOrId == "integer") {
            if (isPlayerConnected(playerNameOrId)) {
                playerNameOrId = getPlayerName(playerNameOrId);
            } else {
                return dbg("[vehicle] setVehicleOwner: trying to set for playerid that aint connected #" + playerNameOrId);
            }
        }

        if (!(vehicleid in __vehicles)) {
            return dbg("[vehicle] setVehicleOwner: __vehicles no vehicleid #" + vehicleid);
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
    function getOwner(vehicleid) {
        if (!(vehicleid in __vehicles)) {
            dbg("[vehicle] getVehicleOwner: __vehicles no vehicleid #" + vehicleid);
            return VEHICLE_DEFAULT_OWNER;
        }
        local vehicle = __vehicles[vehicleid];
        // if (vehicle.ownership.status != VEHICLE_OWNERSHIP_NONE) {
            return vehicle.ownership.owner;
        // }
        // return VEHICLE_DEFAULT_OWNER;
    }


    /**
     * Check if current connected player is owner of ther car
     *
     * @param  {integer}  playerid
     * @param  {integer}  vehicleid
     * @return {Boolean}
     */
    function isOwner(playerid) {
        throw "TODO";
    }


    /**
     * Checks if current vehicle has owner
     * @param  {Integer}  vehicleid
     * @return {Boolean}
     */
    function isOwned() {
        return ((vehicleid in __vehicles) && __vehicles[vehicleID].status != VEHICLE_OWNERSHIP_NONE);
    }


    /**
     * Get vehicle owner name or null
     *
     * @param  {integer} vehicleid
     * @return {mixed}
     */
    function getVehicleOwnerId(vehicleid) {
        if (!(vehicleid in __vehicles)) {
            dbg("[vehicle] getVehicleOwner: __vehicles no vehicleid #" + vehicleid);
            return -1;
        }

        local vehicle = __vehicles[vehicleid];

        return vehicle.ownership.ownerid;
    }
}


/**
 * Check if current connected player is owner of ther car
 *
 * @param  {integer}  playerid
 * @param  {integer}  vehicleid
 * @return {Boolean}
 */
// function isPlayerVehicleOwner(playerid, vehicleid) {
//     return (isPlayerConnected(playerid) && isPlayerLoaded(playerid) && getVehicleOwnerId(vehicleid) == players[playerid].id);
// }

/**
 * Checks if current vehicle has owner
 * @param  {Integer}  vehicleid
 * @return {Boolean}
 */
// function isVehicleOwned(vehicleid) {
//     return (vehicleid in __vehicles && getVehicleOwnerId(vehicleid) != -1);
// }
