/**
 * Is player near particular car
 * @param  {Integer}  playerid
 * @param  {Integer}  vehicleid
 * @param  {Float}    limit  distance limit, optional
 * @return {Boolean}
 */
function isPlayerNearCar(playerid, vehicleid, limit = 5.0) {
    return (getNearestCarForPlayer(playerid, limit) == vehicleid);
}

/**
 * Is player near any car
 * @param  {Integer}  playerid
 * @param  {Float}    limit
 * @return {Boolean}
 */
function isPlayerNearAnyCar(playerid, limit = 5.0) {
    return (getNearestCarForPlayer(playerid, limit) != -1);
}

/**
 * Find nearest car to player
 * @param  {Integer} playerid
 * @param  {Float}   limit optional
 * @return {Integer} vehicleid or -1
 */
function getNearestCarForPlayer(playerid, limit = 500.0) {
    local min = limit;
    local vid = -1;

    foreach (vehicleid, value in __vehicles) {
        local pos = getVehiclePosition(vehicleid);
        local dis = getDistanceToPoint(playerid, pos[0], pos[1], pos[2]);

        if (dis < min) {
            min = dis;
            vid  = vehicleid;
        }
    }

    return vid;
}

// alieases
isPlayerNearVehicle         <- isPlayerNearCar;
isPlayerNearAnyVehicle      <- isPlayerNearAnyCar;
getNearestVehicleForPlayer  <- getNearestCarForPlayer;
