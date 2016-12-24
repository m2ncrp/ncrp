/**
 * Table containing settings for
 * vehicle anti speed hacl
 *
 * Left side is a vehicle model
 * and right side is a array with
 * [soft limit, hard limit] where
 * soft limit is logging limit
 * hard limit is when player will be kicked
 *
 * @type {Object}
 */
local vehicleSpeedLimits = {
    all = [60.0, 70.0],
    5   = [32.0, 35.0],
    38  = [30.0, 32.5],
    35  = [30.0, 32.5],
    19  = [28.0, 30.0],
    20  = [26.0, 28.0],
};

event("onServerStarted", function() {
    local ticker = timer(function() {
        foreach (idx, value in getPlayers()) {
            // anticheat check for speed-hack
            if (isPlayerInVehicle(playerid)) {
                local speed = getVehicleSpeed(getPlayerVehicle(playerid));
                local maxsp = max(fabs(speed[0]), fabs(speed[1]));
                local limits = vehicleSpeedLimits.all;

                if (getVehicleModel(vehicleid) in vehicleSpeedLimits) {
                    limits = vehicleSpeedLimits[getVehicleModel(vehicleid)];
                }

                // debug
                // msg(playerid, "your speed " + maxsp);

                // check soft limit
                if (maxsp > limit[0]) {
                    dbg("anticheat", "speed", getAuthor(playerid), "model: " + getVehicleModel(vehicleid), maxsp);
                }

                // check hard limit
                if (maxsp > limits[1]) {
                    kick( -1, playerid, "speed-hack protection" );
                }
            }

            // anticheat - remove weapons
            if (!isOfficer(playerid) && !isPlayerAdmin(playerid)) {
                local weaponlist = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 17, 21];
                weaponlist.apply(function(id) {
                    removePlayerWeapon( playerid, id );
                })
            }
        }
    }, 500, -1);
});
