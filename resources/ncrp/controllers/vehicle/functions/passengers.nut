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
            if (!vehicleid in occupatedVehicles) {
                occupatedVehicles[vehicleid] <- [];
            }

            occupatedVehicles[vehicleid].push(playerid);
        }
    }

    passengers = occupatedVehicles;
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
    return (vehicleid in passengers && passengers[vehicleid].len() > 0);
}
