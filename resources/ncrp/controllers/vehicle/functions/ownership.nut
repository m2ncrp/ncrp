/**
 * Set vehicle owner
 * can be passed as playername or playerid(connected)
 *
 * @param {Integer} vehicleid
 * @param {Mixed} playerNameOrId
 */
function setVehicleOwner(vehicleid, playerNameOrId, ownerid = null) {
    local playerid = -1;

    // if its id - get name from it
    if (typeof playerNameOrId == "integer") {
        if (isPlayerConnected(playerNameOrId)) {
            playerid = playerNameOrId;
            playerNameOrId = getPlayerName(playerNameOrId);
        } else {
            return dbg("[vehicle] setVehicleOwner: trying to set for playerid that aint connected #" + playerNameOrId);
        }
    } else {
        playerid = getPlayerIdFromName(playerNameOrId);
    }

    if (!(vehicleid in __vehicles)) {
        return dbg("[vehicle] setVehicleOwner: __vehicles no vehicleid #" + vehicleid);
    }

    __vehicles[vehicleid].ownership.status = VEHICLE_OWNERSHIP_SINGLE;
    __vehicles[vehicleid].ownership.owner = playerNameOrId;

    if (playerid != -1 && isPlayerLoaded(playerid)) {
        __vehicles[vehicleid].ownership.ownerid = players[playerid].id;
    } else if (ownerid) {
        __vehicles[vehicleid].ownership.ownerid = ownerid.tointeger();
    }

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

    return vehicle.ownership.owner;
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

/**
 * Check if current connected player is owner of ther car
 *
 * @param  {integer}  playerid
 * @param  {integer}  vehicleid
 * @return {Boolean}
 */
function isPlayerVehicleOwner(playerid, vehicleid) {
    return (isPlayerConnected(playerid) && isPlayerLoaded(playerid) && getVehicleOwnerId(vehicleid) == players[playerid].id);
}

/**
 * Checks if current vehicle has owner
 * @param  {Integer}  vehicleid
 * @return {Boolean}
 */
function isVehicleOwned(vehicleid) {
    return (vehicleid in __vehicles && getVehicleOwnerId(vehicleid) != -1);
}
