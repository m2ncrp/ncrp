event("onServerSecondChange", function() {

    if ((getSecond() % 10) != 0) {
        return;
    }

    foreach (vehicleid, object in __vehicles) {

        local veh = getVehicleEntity(vehicleid);

        if(veh == null) {
            continue;
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


function getVehicleTrunkPosition (vehicleid) {
    local modelId = getVehicleModel(vehicleid);


    local trunkOffset = getVehicleTrunkOffset(modelId);
    if(trunkOffset == null) {
        return false;
    }

    local distance = trunkOffset.y; // offset by Y

    local vehPos = getVehiclePositionObj(vehicleid);
    local angel = 90 - getVehicleRotationObj(vehicleid).rx;

    local y = vehPos.y + Math.sin(torad(angel)) * distance;
    local x = vehPos.x + Math.cos(torad(angel)) * distance;

    return Vector3(x, y, vehPos.z);
}
