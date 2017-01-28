local passengers = {};

/**
 * Iterate over all players
 * and fill array with ones that are passangers
 */
function updateVehiclePassengers() {
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
 * Add passanger to vehicle
 * @param {int} vehicleid
 * @param {int} playerid
 */
function addVehiclePassenger(vehicleid, playerid, seat) {
    if (!(vehicleid in passengers)) {
        passengers[vehicleid] <- array(4, -1);
    }

    // push player to vehicle
    passengers[vehicleid][seat] = playerid;
    return true;
}

/**
 * Add passanger to vehicle
 * @param {int} vehicleid
 * @param {int} playerid
 */
function removeVehiclePassenger(vehicleid, playerid, seat) {
    if (!(vehicleid in passengers)) {
        return;
    }

    // migrate passanger to driver
    if (seat == 0 && passengers[vehicleid][1] != -1) {
        passengers[vehicleid][0] = passengers[vehicleid][1];
        passengers[vehicleid][1] = -1;
        return true;
    }

    passengers[vehicleid][seat] = -1;
    return true;
}

/**
 * Return all players in particular vehicle
 * @param  {int} vehicleid
 * @return {array}
 */
function getVehiclePassengers(vehicleid) {
    local table = {};

    if (!(vehicleid in passengers)) {
        return table;
    }

    foreach (seat, playerid in passengers[vehicleid]) {
        if (playerid == -1) continue;
        table[seat] <- playerid;
    }

    return table;
}

/**
 * Return count of all players in particular vehicle
 * @param  {int} vehicleid
 * @return {int}
 */
function getVehiclePassengersCount(vehicleid) {
    return (getVehiclePassengers(vehicleid).len());
}

/**
 * Return if vehicle empty
 * @param  {int}  vehicleid
 * @return {Boolean}
 */
function isVehicleEmpty(vehicleid) {
    return (getVehiclePassengersCount(vehicleid) < 1);
}

/**
 * Get current player seat id
 * or null if is not int the vehicle, or not found
 * @param  {Integer} playerid
 * @return {Integer} seat
 */
function getPlayerVehicleSeat(playerid) {
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
function isPlayerInVehicleSeat(playerid, seat = 0) {
    return (isPlayerInVehicle(playerid) && getPlayerVehicleSeat(playerid) == seat);
}

/**
 * Alias for driver
 * @param  {[type]}  playerid [description]
 * @return {Boolean}          [description]
 */
function isPlayerVehicleDriver(playerid) {
    return isPlayerInVehicleSeat(playerid, 0);
}
