busses <- {};

event("onServerPlayerStarted", function(targetid) {
    delayedFunction(3000, function() {
        foreach (busid, bus_players in busses) {
            bus_players.map(function(playerid) {
                trigger(targetid, "onPlayerPutInBus", playerid.tostring(), busid.tostring());
            });
        }
    });
});

event("onPlayerDisconnect", function(playerid, reason) {
    removePlayerFromBus(playerid);
});

/**
 * Put player in bus
 * @param  {Integer} playerid
 * @param  {Integer} vehicleid
 * @return {Boolean} result
 */
function putPlayerInBus(playerid, vehicleid) {
    if (getVehicleModel( vehicleid ) != 20) {
        return dbg("bus", "cannot put player in non-bus vehicle") && false;
    }

    if (isPlayerBusPassanger(playerid)) {
        return dbg("bus", "cannot put player, he is already in bus") && false;
    }

    if (!(vehicleid in busses)) {
        busses[vehicleid] <- [];
    }

    busses[vehicleid].push(playerid);

    players.each(function(targetid) {
        trigger(targetid, "onPlayerPutInBus", playerid.tostring(), vehicleid.tostring());
    });

    return true;
}

/**
 * Remove player from any bus if he is in any
 * @param  {Integer} playerid
 * @return {Boolean} result
 */
function removePlayerFromBus(playerid) {
    if (!isPlayerBusPassanger(playerid)) {
        return dbg("bus", "cannot remove player, he is not in bus") && false;
    }

    local vehicleid = getPlayerBusPassangerVehicle(playerid);
    busses[vehicleid].remove(busses[vehicleid].find(playerid));

    players.each(function(targetid) {
        trigger(targetid, "onPlayerRemovedFromBus", playerid.tostring(), vehicleid.tostring());
    });

    return true;
}

/**
 * Get vehicle player is currently passanger is
 * @param  {Integer} playerid
 * @return {Integer}
 */
function getPlayerBusPassangerVehicle(playerid) {
    foreach (busid, bus_players in busses) {
        if (bus_players.find(playerid) != null) {
            return busid;
        }
    }

    return -1;
}

/**
 * Check if player is in any bus (vehicleid == null)
 * or in a particular bus (vehicleid == any number)
 * @param  {Integer}  playerid
 * @param  {Integer}  vehicleid
 * @return {Boolean}
 */
function isPlayerBusPassanger(playerid, vehicleid = null) {
    if (!vehicleid && getPlayerBusPassangerVehicle(playerid) != -1) {
        return true;
    }

    if (!vehicleid || !(vehicleid in busses) || getVehicleModel( vehicleid ) != 20) {
        return false;
    }

    return (busses[vehicleid].find() != null);
}
