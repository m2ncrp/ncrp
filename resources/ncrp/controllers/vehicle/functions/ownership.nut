/**
 * Set vehicle owner
 * can be passed as playername or playerid(connected)
 *
 * @param {integer} vehicleid
 * @param {mixed} playerNameOrId
 */
function setVehicleOwner(vehicleid, playerNameOrId) {
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

    __vehicles[vehicleid].ownership.status = VEHICLE_OWNERSHIP_SINGLE;
    __vehicles[vehicleid].ownership.owner  = playerNameOrId;

    return true;
}

/**
 * Get vehicle owner name or null
 *
 * @param  {integer} vehicleid
 * @return {mixed}
 */
function getVehicleOwner(vehicleid) {
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
function isPlayerVehicleOwner(playerid, vehicleid) {
    return (isPlayerConnected(playerid) && getVehicleOwner(vehicleid) == getPlayerName(playerid));
}

/**
 * Checks if current vehicle has owner
 * @param  {Integer}  vehicleid
 * @return {Boolean}
 */
function isVehicleOwned(vehicleid) {
    return ((vehicleid in __vehicles) && __vehicles[vehicleid].status != VEHICLE_OWNERSHIP_NONE);
}
