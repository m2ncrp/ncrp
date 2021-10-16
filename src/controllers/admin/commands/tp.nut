/**
 * Teleport player to other player
 * Usage:
 *     /pp 0 15
 *     /pp 0 15 32.0
 */
acmd("pp", function(playerid, targetid1 = null, targetid2 = null, offset = 2.0) {
    local targetid1 = toInteger(targetid1);
    local targetid2 = toInteger(targetid2);

    if (targetid1 == null || targetid2 == null || !isPlayerConnected(targetid1) || !isPlayerConnected(targetid2)) {
        return msg(playerid, "Provide connected playerids.", CL_ERROR);
    }

    if (isPlayerInVehicle(targetid1)) {
        return msg(playerid, format("Player is in the vehicle, use /vp %d %d", targetid1, targetid2), CL_WARNING);
    }

    local pos = getPlayerPosition(targetid2);
    setPlayerPosition(targetid1, pos[0], pos[1], pos[2] + offset.tofloat());
    msg(playerid, format("You've successuly tp'd player #%d to player %d", targetid1, targetid2), CL_SUCCESS);
});

/**
 * Teleport vehicle to vehicle
 * NOTE: always offseted +2 by x axis
 * Usage:
 *     /vv 0 15
 *     /vv 0 15 32.0
 */
acmd("vv", function(playerid, targetid1 = null, targetid2 = null, offset = 1.0) {
    local targetid1 = toInteger(targetid1);
    local targetid2 = toInteger(targetid2);

    if (targetid1 == null || targetid2 == null || !(targetid1 in __vehicles) || !(targetid2 in __vehicles) || !__vehicles[targetid1].spawned || !__vehicles[targetid2].spawned) {
        return msg(playerid, "Provide created vehicleids.", CL_ERROR);
    }

    local pos = getVehiclePosition(targetid2);
    setVehiclePosition(targetid1, pos[0] + 2.0, pos[1], pos[2] + offset.tofloat());
    msg(playerid, format("You've successuly tp'd vehicle #%d to vehicle %d", targetid1, targetid2), CL_SUCCESS);
});

/**
 * Teleport player to vehicle
 * Usage:
 *     /pv 0 15
 *     /pv 0 15 32.0
 */
acmd("pv", function(playerid, targetid1 = null, targetid2 = null, offset = 1.2) {
    local targetid1 = toInteger(targetid1);
    local targetid2 = toInteger(targetid2);

    if (targetid1 == null || targetid2 == null || !isPlayerConnected(targetid1) || !(targetid2 in __vehicles) || !__vehicles[targetid2].spawned) {
        return msg(playerid, "Provide connected player and created vehicleid.", CL_ERROR);
    }

    local pos = getVehiclePosition(targetid2);
    setPlayerPosition(targetid1, pos[0], pos[1], pos[2] + offset.tofloat());
    msg(playerid, format("You've successuly tp'd player #%d to vehicle %d", targetid1, targetid2), CL_SUCCESS);
});

/**
 * Teleport vehicle to player
 * NOTE: always offseted +2 by x axis
 * Usage:
 *     /vp 0 15
 *     /vp 0 15 32.0
 */
acmd("vp", function(playerid, targetid1 = null, targetid2 = null, offset = 0.1) {
    local targetid1 = toInteger(targetid1);
    local targetid2 = toInteger(targetid2);

    if (targetid1 == null || targetid2 == null || !(targetid1 in __vehicles) || !__vehicles[targetid1].spawned || !isPlayerConnected(targetid2)) {
        return msg(playerid, "Provide created vehicleid and connected player.", CL_ERROR);
    }

    local pos = getPlayerPosition(targetid2);
    setVehiclePosition(targetid1, pos[0] + 2.0, pos[1], pos[2] + offset.tofloat());
    msg(playerid, format("You've successuly tp'd vehicle #%d to player %d", targetid1, targetid2), CL_SUCCESS);
});
