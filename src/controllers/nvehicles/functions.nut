/**
 * NEW NVEHICLE METHODS
 * should be used ONLY for native events ONLY INSIDE this module
 * for scripting use the OOP aproach
 */

    /**
     * Check if player is in the new vehicle
     * @param  {Character|Integer}  playerOrId
     * @return {Boolean}
     */
    function isPlayerInNVehicle(playerOrId) {
        if (playerOrId instanceof Character) {
            playerOrId = playerOrId.playerid;
        }

        if (!original__isPlayerInVehicle(playerOrId)) {
            return false;
        }

        local vehicleid = original__getPlayerVehicle(playerOrId);
        if (!(vehicleid in vehicles_native)) return false;

        return true;
    }

    /**
     * Return Vehicle by vehicleid
     * @param  {integer} vehicleid
     * @return {Vehicle}
     */
    function getNVehicleByVehicleId(vehicleid) {
        if (!(vehicleid in vehicles_native)) return null;
        return vehicles_native[vehicleid];
    }

    /**
     * Return Vehicle player is currently in
     * @param  {Character|Integer} player/playerid
     * @return {Vehicle}
     */
    function getPlayerNVehicle(playerOrId) {
        if (playerOrId instanceof Character) {
            playerOrId = playerOrId.playerid;
        }

        if (!isPlayerInNVehicle(playerOrId)) {
            return null;
        }

        return vehicles_native[original__getPlayerVehicle(playerOrId)];
    }

    /**
     * Return closest vehicle to player, or the one he is sitting in
     * @param  {Character|Integer} playerOrId
     * @return {Vehicle}
     */
    function getPlayerNearestNVehicle(playerOrId) {
        if (playerOrId instanceof Character) {
            playerOrId = playerOrId.playerid;
        }

        if (isPlayerInNVehicle(playerOrId)) {
            return getPlayerNVehicle(playerOrId);
        }

        return vehicles.nearestVehicle(playerid);
    }

/**
 * ENDOF NEW NVEHICLE METHODS
 */
