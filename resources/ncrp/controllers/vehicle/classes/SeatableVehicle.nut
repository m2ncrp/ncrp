class SeatableVehicle extends OwnableVehicle
{
    maxPassengers = null;
    passengers = {};

    constructor (model, seats, px, py, pz, rx = 0.0, ry = 0.0, rz = 0.0) {
        base.constructor(model, px, py, pz, rx, ry, rz);
        maxPassengers = seats;
    }

    /**
     * Iterate over all players
     * and fill array with ones that are passangers
     */
    function updatePassengers() {
        if (!(vid in passengers)) return;

        foreach (seat, playerid in passengers[vid]) {
            if (!isPlayerConnected(playerid)) {
                passengers[vid][seat] = -1;
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
            passengers[vid] <- array(maxPassengers, -1);
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
     * @return {int}
     */
    function getPassengersCount() {
        return (getPassengers().len());
    }


    /**
     * Return if vehicle empty
     * @param  {int}  vehicleid
     * @return {Boolean}
     */
    function isEmpty() {
        return (getVehiclePassengersCount() < 1);
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


    events = [
        event("native:onPlayerVehicleEnter", function( playerid, vehicleid, seat ) {
            // handle vehicle passangers
            local veh = __vehicles.get(vehicleid);
            veh.addPassenger(playerid, seat);
        }),

        event("native:onPlayerVehicleExit", function( playerid, vehicleid, seat ) {
            // handle vehicle passangers
            local veh = __vehicles.get(vehicleid);
            veh.removePassenger(playerid, seat);
        })
    ];
}
