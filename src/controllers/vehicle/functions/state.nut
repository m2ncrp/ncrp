function getVehicleState(vehicleid) {
    local veh = getVehicleEntity(vehicleid);
    return veh ? veh.data.state : null;
}

function setVehicleState(vehicleid, state = "free") {
    local veh = getVehicleEntity(vehicleid);
    if(veh) {
        veh.data.state = state;
        return state;
    }
    return false;
}