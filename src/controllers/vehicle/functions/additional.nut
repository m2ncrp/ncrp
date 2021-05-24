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
    setVehiclePosition( vehicleid, objpos.x.tofloat(), objpos.y.tofloat(), objpos.z.tofloat());
}

/**
 * Get vehicle rotation and return to OBJECT
 * @param  {int} vehicleid
 * @return {object}
 */
function getVehicleRotationObj ( vehicleid ) {
    local vehRot = getVehicleRotation( vehicleid );
    return { x = vehRot[0], y = vehRot[1], z = vehRot[2] };
}

/**
 * Set vehicle rotation to coordinates from objrot.x, objrot.y, objrot.z
 * @param {int} vehicleid
 * @param {object} objrot
 */
function setVehicleRotationObj ( vehicleid, objrot ) {
    setVehicleRotation(vehicleid, objrot.x, objrot.y, objrot.z);
}
