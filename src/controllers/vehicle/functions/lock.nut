local doorsIndex = {
    front = {
        left = 0,
        right = 1,
    }
    rear = {
        left = 2,
        right = 3,
    }
}

event("onServerPlayerStarted", function(playerid) {
    foreach (vehicleid, value in getVehicles()) {
        local veh = getVehicleEntity(vehicleid);
        if(!veh) continue;

        local vehInfo = getVehicleInfo(veh.model);

        // Делает игрока овнером каждого автомобиля, чтобы убрать подсказку Разбить стекло
        triggerClientEvent(playerid, "setPlayerVehicleOwner", vehicleid);

        if(vehInfo.seats >= 1) triggerClientEvent(playerid, "setVehicleDoorLocked", vehicleid, 0, veh.data.parts.doors.front.left);

        if(vehInfo.seats >= 2) triggerClientEvent(playerid, "setVehicleDoorLocked", vehicleid, 1, veh.data.parts.doors.front.right);

        if(vehInfo.seats == 4) {
            triggerClientEvent(playerid, "setVehicleDoorLocked", vehicleid, 2, veh.data.parts.doors.rear.left);
            triggerClientEvent(playerid, "setVehicleDoorLocked", vehicleid, 3, veh.data.parts.doors.rear.right);
        }
    }
});

event("setVehicleDoorLocked", function(playerid, vehicleid, frontOrRear, leftOrRight, value) {
    local doorIndex = doorsIndex[frontOrRear][leftOrRight];

    foreach (playerid, name in getPlayers()) {
        triggerClientEvent(playerid, "setVehicleDoorLocked", vehicleid, doorIndex, value);
    }

    local veh = getVehicleEntity(vehicleid);

    if(!veh) return;

    veh.data.parts.doors[frontOrRear][leftOrRight] = value;
});