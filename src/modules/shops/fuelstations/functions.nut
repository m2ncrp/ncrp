function isNearFuelStation(playerid) {
    foreach (station in fuel_stations) {
        if ( isInRadius(playerid, station[0], station[1], station[2], FUEL_RADIUS) ) {
            return true;
        }
    }
    return false;
}
