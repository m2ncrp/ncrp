class VehicleContainer extends Container
{
    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor() {
        base.constructor();
        this.__ref = Vehicle;
    }

    /**
     * Meta impelemtation for set
     * @param {Integer} name
     * @param {Character} value
     */
    function _set(playerid, value) {
        throw "VehicleContainer: you cant insert new data directly!";
    }

    function push(object) {
        return this.add(this.len(), object);
    }

    /**
     * Find nearest vehicle id to particular player
     * @param  {Integer} playerid
     * @return {Integer}
     */
    function nearestVehicle(playerid) {
        local min = null;
        local closestid = null;

        // iterate over player, and calculate distance with each one
        foreach(targetid, data in this.getAll()) {
            local dist = getDistance(playerid, targetid);

            // compare with smallest, and if less - override smallest
            if ((dist < min || !min) && targetid != playerid) {
                min = dist;
                closestid = targetid;
            }
        }
        return closestid;
    }
}



/**
 * Is player near particular car
 * @param  {Integer}  playerid
 * @param  {Integer}  vehicleid
 * @param  {Float}    limit  distance limit, optional
 * @return {Boolean}
 */
// function isPlayerNearCar(playerid, vehicleid, limit = 5.0) {
//     local pos = getVehiclePosition(vehicleid);
//     local dis = getDistanceToPoint(playerid, pos[0], pos[1], pos[2]);

//     return (dis < limit);
// }

/**
 * Is player near particular car model
 * @param  {Integer}  playerid
 * @param  {Integer}  modelid
 * @param  {Float}    limit
 * @return {Boolean}
 */
// function isPlayerNearCarModel(playerid, modelid, limit = 5.0) {
//     foreach (vehicleid, value in __vehicles) {
//         local pos = getVehiclePosition(vehicleid);
//         local dis = getDistanceToPoint(playerid, pos[0], pos[1], pos[2]);

//         // invalidate model
//         if (getVehicleModel(vehicleid) != modelid) continue;

//         if (dis < limit) {
//             return true;
//         }
//     }

//     return false;
// }

/**
 * Is player near any car
 * @param  {Integer}  playerid
 * @param  {Float}    limit
 * @return {Boolean}
 */
// function isPlayerNearAnyCar(playerid, limit = 5.0) {
//     return (getNearestCarForPlayer(playerid, limit) != -1);
// }

/**
 * Find nearest car to player
 * @param  {Integer} playerid
 * @param  {Float}   limit optional
 * @return {Integer} vehicleid or -1
 */
// function getNearestCarForPlayer(playerid, limit = 500.0) {
//     local min = limit;
//     local vid = -1;

//     foreach (vehicleid, value in __vehicles) {
//         local pos = getVehiclePosition(vehicleid);
//         local dis = getDistanceToPoint(playerid, pos[0], pos[1], pos[2]);

//         if (dis < min) {
//             min = dis;
//             vid = vehicleid;
//         }
//     }

//     return vid;
// }

// // alieases
// isPlayerNearVehicle         <- isPlayerNearCar;
// isPlayerNearAnyVehicle      <- isPlayerNearAnyCar;
// isPlayerNearVehicleModel    <- isPlayerNearCarModel;
// getNearestVehicleForPlayer  <- getNearestCarForPlayer;


/**
 * Get vehicle position and return to OBJECT
 * @param  {int} vehicleid
 * @return {object}
 */
// function getVehiclePositionObj ( vehicleid ) {
//     local vehPos = getVehiclePosition( vehicleid );
//     return { x = vehPos[0], y = vehPos[1], z = vehPos[2] };
// }

/**
 * Set vehicle position to coordinates from objpos.x, objpos.y, objpos.z
 * @param {int} vehicleid
 * @param {object} objpos
 */
// function setVehiclePositionObj ( vehicleid, objpos ) {
//     setVehiclePosition( vehicleid, objpos.x, objpos.y, objpos.z);
// }
