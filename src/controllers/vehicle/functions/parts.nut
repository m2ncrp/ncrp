event("onServerSecondChange", function() {

    if ((getSecond() % 10) != 0) {
        return;
    }

    foreach (vehicleid, object in __vehicles) {

        if (!object) continue;

        local veh = getVehicleEntity(vehicleid);

        if(veh == null) {
            continue;
        }

        if(("options" in veh.data) == false) {
            veh.data.options <- {};
        }

        if(("parts" in veh.data) == false) {
            veh.data.parts <- {};
            veh.data.parts.trunk <- {
                locked = true,
                opened = false
            };
        }

        setVehiclePartOpen(vehicleid, 1, veh.data.parts.trunk.opened);
    }
});
/**
 * Get coordinates of vehicle part
 * @param  {[type]} vehicleid    [description]
 * @param  {[type]} offsetVector [description]
 * @return {[type]}              [description]
 */
function getVehiclePartCoords(vehicleid, offsetVector) {

    local vehPos = getVehiclePositionObj(vehicleid);
    local vehRot = getVehicleRotationObj(vehicleid);

    //Координаты точки без вращения
    local coordsOffset =  [ vehPos.x + offsetVector.x, vehPos.y + offsetVector.y, vehPos.z ]

    // Результирующая матрица поворота
    local angles = customEulerAngles(vehRot);

    // Координаты точки после вращения в локальной системе
    local coordsAfterLocal = multiplyMatrix(
        angles,
        [
            [ offsetVector.x ],
            [ offsetVector.y ],
            [ 0.0 ]
        ]);

    local coordsAfterGlobal = Vector3(
        (coordsOffset[0] + coordsAfterLocal[0][0] - offsetVector.x),
        (coordsOffset[1] + coordsAfterLocal[1][0] - offsetVector.y),
        (coordsOffset[2] + coordsAfterLocal[2][0] - 0.0)
    )

    return coordsAfterGlobal;
}

/**
 * Get vehicle trunk position
 * @param  {[type]} vehicleid [description]
 * @return {[type]}           [description]
 */
function getVehicleTrunkPosition (vehicleid) {
    local modelId = getVehicleModel(vehicleid);

    local trunkOffset = getVehicleTrunkOffset(modelId);
    if(trunkOffset == null) {
        return false;
    }

    return getVehiclePartCoords(vehicleid, trunkOffset);
}

/**
 * Check that player near vehicle trunk
 * @param  {[type]}  playerid  [description]
 * @param  {[type]}  vehicleid [description]
 * @return {Boolean}           [description]
 */
function isPlayerNearVehicleTrunk(playerid = null, vehicleid = null) {
    if(playerid == null || vehicleid == null) return false;

    local plaPos = getPlayerPositionObj(playerid);
    local partCoords = getVehicleTrunkPosition(vehicleid);

    if(!partCoords) {
        return false;
    }

    if ( checkDistanceXYZ( partCoords.x, partCoords.y, partCoords.z, plaPos.x, plaPos.y, plaPos.z, 1.05) ) {
        return true;
    }

    return false;

}


/**
 * Get nearest vehicle for player for trunk
 * @param  {[type]} playerid [description]
 * @return {[type]}          [description]
 */
function getNearestVehicleForPlayerForTrunk(playerid) {

    if (isPlayerInVehicle(playerid)) {
        return false;
    }

    local vehicleid = getNearestVehicleForPlayer(playerid, 5.5);
    if(vehicleid == -1) {
        return false;
    }

    if(!isPlayerNearVehicleTrunk(playerid, vehicleid)) {
        return false;
    }

    return vehicleid;
}


acmd("drawparts", function(playerid, vehicleid) {
    drawVehicleParts(playerid, vehicleid.tointeger())
})

function drawVehicleParts (playerid, vehicleid = null) {

    local vehicleid = vehicleid.tointeger();
    local vehPos = getVehiclePositionObj(vehicleid);
    local vehRot = getVehicleRotationObj(vehicleid);
    local modelId = getVehicleModel(vehicleid);
    local vehInfo = getVehicleInfo(modelId);
    local triggers = {};

    foreach(key, data in vehInfo.triggers) {
        if(data == null) { continue; }

        local offsetVector = Vector3(data[0], data[1], 0.0);

        local coordsGlobal =  getVehiclePartCoords(vehicleid, offsetVector)

        createPrivate3DText ( playerid, coordsGlobal.x, coordsGlobal.y, coordsGlobal.z - 0.9, "V", CL_ROYALBLUE, 50.0);

    }

}
