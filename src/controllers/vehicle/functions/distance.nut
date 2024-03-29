/**
 * Is player near particular car
 * @param  {Integer}  playerid
 * @param  {Integer}  vehicleid
 * @param  {Float}    limit  distance limit, optional
 * @return {Boolean}
 */
function isPlayerNearCar(playerid, vehicleid, limit = 5.0) {
    local pos = getVehiclePosition(vehicleid);
    local dis = getDistanceToPoint(playerid, pos[0], pos[1], pos[2]);

    return (dis < limit);
}

/**
 * Is player near particular car model
 * @param  {Integer}  playerid
 * @param  {Integer}  modelid
 * @param  {Float}    limit
 * @return {Boolean}
 */
function isPlayerNearCarModel(playerid, modelid, limit = 5.0) {
    foreach (vehicleid, value in __vehicles) {
        if(!value) continue;
        local pos = getVehiclePosition(vehicleid);
        local dis = getDistanceToPoint(playerid, pos[0], pos[1], pos[2]);

        // invalidate model
        if (getVehicleModel(vehicleid) != modelid) continue;

        if (dis < limit) {
            return true;
        }
    }

    return false;
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
        if(!value) continue;
        local pos = getVehiclePosition(vehicleid);
        local dis = getDistanceToPoint(playerid, pos[0], pos[1], pos[2]);

        if (dis < min) {
            min = dis;
            vid = vehicleid;
        }
    }

    return vid;
}

// alieases
isPlayerNearVehicle         <- isPlayerNearCar;
isPlayerNearAnyVehicle      <- isPlayerNearAnyCar;
isPlayerNearVehicleModel    <- isPlayerNearCarModel;
getNearestVehicleForPlayer  <- getNearestCarForPlayer;
