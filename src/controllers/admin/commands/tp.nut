/**
 * Teleport player to other player
 * Usage:
 *     /p2p 0 15
 *     /p2p 0 15 32.0
 */
acmd("pp", function(playerid, targetid1 = null, targetid2 = null, offset = 1.0) {
    local targetid1 = toInteger(targetid1);
    local targetid2 = toInteger(targetid2);

    if (targetid1 == null || targetid2 == null || !isPlayerConnected(targetid1) || !isPlayerConnected(targetid2)) {
        return msg(playerid, "Provide connected playerids.", CL_ERROR);
    }

    if (isPlayerInVehicle(targetid1)) {
        return msg(playerid, format("Player is in the vehicle, use /vtop %d %d", targetid1, targetid2), CL_WARNING);
    }

    local pos = getPlayerPosition(targetid2);
    setPlayerPosition(targetid1, pos[0], pos[1], pos[2] + offset.tofloat());
    msg(playerid, format("You've successuly tp'd player #%d to player %d", targetid1, targetid2), CL_SUCCESS);
});

/*

        if (!isPlayerInNVehicle(playerid)) {
            if(isPlayerInVehicle(playerid)) {
                local vehicleid = getPlayerVehicle(playerid);
                setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
                setVehiclePosition(vehicleid, item.x, item.y, item.z+0.5);
            } else {
                setPlayerPosition(playerid, item.x, item.y, item.z);
            }
        } else {
            getPlayerNVehicle(playerid).setPosition(item.x, item.y, item.z+0.5).setSpeed();
        }
 */

/**
 * Teleport vehicle to vehicle
 * NOTE: always offseted +2 by x axis
 * Usage:
 *     /v2v 0 15
 *     /v2v 0 15 32.0
 */
acmd("vv", function(playerid, targetid1 = null, targetid2 = null, offset = 1.0) {
    local targetid1 = toInteger(targetid1);
    local targetid2 = toInteger(targetid2);

    if (targetid1 == null || targetid2 == null || !(targetid1 in __vehicles) || !(targetid2 in __vehicles)) {
        return msg(playerid, "Provide created vehicleids.", CL_ERROR);
    }

    local pos = getVehiclePosition(targetid2);
    setVehiclePosition(targetid1, pos[0] + 2.0, pos[1], pos[2] + offset.tofloat());
    msg(playerid, format("You've successuly tp'd vehicle #%d to vehicle %d", targetid1, targetid2), CL_SUCCESS);
});

/**
 * Teleport player to vehicle
 * Usage:
 *     /p2v 0 15
 *     /p2v 0 15 32.0
 */
acmd("pv", function(playerid, targetid1 = null, targetid2 = null, offset = 1.0) {
    local targetid1 = toInteger(targetid1);
    local targetid2 = toInteger(targetid2);

    if (targetid1 == null || targetid2 == null || !isPlayerConnected(targetid1) || !(targetid2 in __vehicles)) {
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
 *     /v2p 0 15
 *     /v2p 0 15 32.0
 */
acmd("vp", function(playerid, targetid1 = null, targetid2 = null, offset = 1.0) {
    local targetid1 = toInteger(targetid1);
    local targetid2 = toInteger(targetid2);

    if (targetid1 == null || targetid2 == null || !(targetid1 in __vehicles) || !isPlayerConnected(targetid2)) {
        return msg(playerid, "Provide created vehicleid and connected player.", CL_ERROR);
    }

    local pos = getPlayerPosition(targetid2);
    setVehiclePosition(targetid1, pos[0] + 2.0, pos[1], pos[2] + offset.tofloat());
    msg(playerid, format("You've successuly tp'd vehicle #%d to player %d", targetid1, targetid2), CL_SUCCESS);
});
