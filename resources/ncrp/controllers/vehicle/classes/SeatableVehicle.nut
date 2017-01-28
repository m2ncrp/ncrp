class SeatableVehicle extends OwnableVehicle
{
    passengers = {};

    /**
     * Iterate over all players
     * and fill array with ones that are passangers
     */
    function updatePassengers() {
        foreach (vehicleid, value in __vehicles) {
            if (!(vehicleid in passengers)) continue;

            foreach (seat, playerid in passengers[vehicleid]) {
                if (!isPlayerConnected(playerid)) {
                    passengers[vehicleid][seat] = -1;
                }
            }
        }
    }

    /**
     * Return all players in particular vehicle
     * @return {array}
     */
    function getPassengers() {
        local table = {};

        if (!(vid in passengers)) {
            return table;
        }

        foreach (seat, playerid in passengers[vid]) {
            if (playerid == -1) continue;
            table[seat] <- playerid;
        }

        return table;
    }

    /**
     * Add passanger to vehicle
     * @param {int} vehicleid
     * @param {int} playerid
     */
    function addPassenger(playerid, seat) {
        if (!(vid in passengers)) {
            passengers[vehicleid] <- array(4, -1);
        }
        // push player to vehicle
        passengers[vid][seat] = playerid;
        return true;
    }


    /**
     * Remove passanger from vehicle
     * @param {int} vehicleid
     * @param {int} playerid
     */
    function removePassenger(playerid, seat) {
        if (!(vid in passengers)) {
            return;
        }

        // migrate passanger to driver
        if (seat == 0 && passengers[vid][1] != -1) {
            passengers[vid][0] = passengers[vid][1];
            passengers[vid][1] = -1;
            return true;
        }

        passengers[vid][seat] = -1;
        return true;
    }


    /**
     * Return count of all players in particular vehicle
     * @param  {int} vehicleid
     * @return {int}
     */
    function getPassengersCount(vehicleid) {
        return (getVehiclePassengers(vehicleid).len());
    }


    /**
     * Return if vehicle empty
     * @param  {int}  vehicleid
     * @return {Boolean}
     */
    function isEmpty(vehicleid) {
        return (getVehiclePassengersCount(vehicleid) < 1);
    }


    /**
     * Get current player seat id
     * or null if is not int the vehicle, or not found
     * @param  {Integer} playerid
     * @return {Integer} seat
     */
    function getPlayerSeat(playerid) {
        if (!isPlayerInVehicle(playerid)) {
            return null;
        }

        local vehicleid  = getPlayerVehicle(playerid);

        foreach (seat, targetid in passengers[vehicleid]) {
            if (playerid == targetid) return seat;
        }

        return null;
    }


    /**
     * Check if player is sitting in correct seat
     * @param  {Integer} playerid
     * @param  {Integer} seat
     * @return {Boolean} result
     */
    function isPlayerInSeat(playerid, seat = 0) {
        return (isPlayerInVehicle(playerid) && getPlayerVehicleSeat(playerid) == seat);
    }


    /**
     * Alias for driver
     * @param  {Integer}  playerid
     * @return {Boolean}
     */
    function isPlayerDriver(playerid) {
        return isPlayerInVehicleSeat(playerid, 0);
    }
}
