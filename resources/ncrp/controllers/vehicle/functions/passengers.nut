local passengers = {};

/**
 * Iterate over all players
 * and fill array with ones that are passangers
 */
function updateVehiclePassengers() {
    local players = getPlayers();

    // reset vehicles
    local occupatedVehicles = {};

    foreach (playerid, value in players) {
        if (isPlayerInVehicle(playerid)) {
            local vehicleid = getPlayerVehicle(playerid);

            if (!(vehicleid in occupatedVehicles)) {
                occupatedVehicles[vehicleid] <- [];
            }

            // push player to vehicle
            occupatedVehicles[vehicleid].push(playerid);
        }
    }

    passengers = occupatedVehicles;
}

/**
 * Add passanger to vehicle
 * @param {int} vehicleid
 * @param {int} playerid
 */
function addVehiclePassenger(vehicleid, playerid) {
    if (!(vehicleid in passengers)) {
        passengers[vehicleid] <- [];
    }

    // push player to vehicle
    passengers[vehicleid].push(playerid);
}

/**
 * Add passanger to vehicle
 * @param {int} vehicleid
 * @param {int} playerid
 */
function removeVehiclePassenger(vehicleid, playerid) {
    if (!(vehicleid in passengers)) {
        return;
    }

    // push player to vehicle
    local index = passengers[vehicleid].find(playerid);

    if (index >= 0) {
        passengers[vehicleid].remove(index);
    }
}

/**
 * Return all players in particular vehicle
 * @param  {int} vehicleid
 * @return {array}
 */
function getVehiclePassengers(vehicleid) {
    return (vehicleid in passengers) ? passengers[vehicleid] : [];
}

/**
 * Return if vehicle empty
 * @param  {int}  vehicleid
 * @return {Boolean}
 */
function isVehicleEmpty(vehicleid) {
    return (getVehiclePassengers(vehicleid).len() < 1);
}
