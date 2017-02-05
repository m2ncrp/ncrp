/**
 * Get vehicle position and return to OBJECT
 * @param  {int} vehicleid
 * @return {object}
 */
function getVehiclePositionObj ( vehicleid ) {
    local vehPos = getVehiclePosition( vehicleid );
    return { x = vehPos[0], y = vehPos[1], z = vehPos[2] };
}

/**
 * Set vehicle position to coordinates from objpos.x, objpos.y, objpos.z
 * @param {int} vehicleid
 * @param {object} objpos
 */
function setVehiclePositionObj ( vehicleid, objpos ) {
    setVehiclePosition( vehicleid, objpos.x, objpos.y, objpos.z);
}
