/**
 * Save new position
 */
local teleportPoints = [];

acmd(["tsave", "ts"], function(playerid, name) {
    if (!name || name.len() < 1) return sendPlayerMessage(playerid, "Usage: /ts <name>");

    local tpp = TeleportPosition();
    local pos = getPlayerPosition(playerid);

    tpp.x = pos[0];
    tpp.y = pos[1];
    tpp.z = pos[2];
    tpp.name = name;

    tpp.save(function(err, result) {
        sendPlayerMessage(playerid, "Created new teleport point #" + tpp.id);
    });
});


/**
 * List all positions (paginated)
 */
acmd(["tlist", "tl"], function(playerid, page = "0") {
    local q = ORM.Query("select * from @TeleportPosition limit :page, 10");

    q.setParameter("page", max(0, page.tointeger()) * 10);
    q.getResult(function(err, results) {
        sendPlayerMessage(playerid, format("Страница %s (cледующая страница /tl %d):", page, (page.tointeger()+1)) );

        // list
        return results.map(function(item) {
            sendPlayerMessage(playerid, format("%d. %s", item.id, item.name), 240, 240, 220);
        })
    });
});

/**
 * Go to position
 */
acmd(["tgoto", "tg"], function(playerid, nameOrId) {
    local callback = function(err, item) {
        if (!item) return sendPlayerMessage(playerid, "No point were found by " + nameOrId);

        if (!isPlayerInVehicle(playerid)) {
            setPlayerPosition(playerid, item.x, item.y, item.z);
        } else {
            setVehicleSpeed(getPlayerVehicle(playerid), 0.0, 0.0, 0.0);
            setVehiclePosition(getPlayerVehicle(playerid), item.x, item.y, item.z+0.5);
        }
        resetVehiclesInstances();
        sendPlayerMessage(playerid, "Teleport to " + item.name +" (#" + item.id + ") completed.", 240, 240, 200);
    };

    if (isInteger(nameOrId)) {
        TeleportPosition.findOneBy({ id = nameOrId.tointeger() }, callback);
    } else {
        TeleportPosition.findOneBy({ name = nameOrId }, callback);
    }
});

/**
 * Remove position
 */
acmd(["tdelete", "td"], function(playerid, nameOrId) {
    local callback = function(err, item) {
        if (!item) return sendPlayerMessage(playerid, "No point were found by " + nameOrId);
        sendPlayerMessage(playerid, "Removed point #" + item.id, 240, 240, 200);
        item.remove();
    };

    if (isInteger(nameOrId)) {
        TeleportPosition.findOneBy({ id = nameOrId.tointeger() }, callback);
    } else {
        TeleportPosition.findOneBy({ name = nameOrId }, callback);
    }
});


/**
 * Get coords of point
 */
acmd(["tcoords", "tc"], function(playerid, nameOrId) {
    local callback = function(err, item) {
        if (!item) return sendPlayerMessage(playerid, "No point were found by " + nameOrId);
        sendPlayerMessage(playerid, format("Coords for %s (#%d): x: %f y: %f z: %f", item.name, item.id, item.x, item.y, item.z), 240, 240, 200);
    };

    if (isInteger(nameOrId)) {
        TeleportPosition.findOneBy({ id = nameOrId.tointeger() }, callback);
    } else {
        TeleportPosition.findOneBy({ name = nameOrId }, callback);
    }
});

/**
 * Rendering tgs in the world
 */
event("onServerStarted", function() {
    TeleportPosition.findAll(function(err, positions) {
        foreach (idx, teleport in positions) {
            teleportPoints.push(teleport);
            // create3DText(teleport.x, teleport.y, teleport.z, "Teleport: " + teleport.name, CL_ROYALBLUE.applyAlpha(150));
        }
    });
});


/**
 * Set player coords
 */
acmd("tpc", function(playerid, x, y, z) {
    setPlayerPosition(playerid, x.tofloat(), y.tofloat(), z.tofloat());
});


/**
 * Set player coords
 */
acmd("move", function(playerid, x, y = 0, z = 0) {
    if (!z) z = 0;
    if (!y) y = 0;
    if(isPlayerInVehicle(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        local vehPos = getVehiclePositionObj(vehicleid);
        setVehiclePosition(vehicleid, vehPos.x + x.tofloat(), vehPos.y + y.tofloat(), vehPos.z + z.tofloat());
    } else {
        local plaPos = getPlayerPositionObj(playerid);
        setPlayerPosition(playerid, plaPos.x + x.tofloat(), plaPos.y + y.tofloat(), plaPos.z + z.tofloat());
    }
});


/**
 * Player to position
 */
acmd(["tp"], function(playerid, playerSessionId, nameOrId) {
    local callback = function(err, item) {
        if (!item) return sendPlayerMessage(playerid, "No point were found by " + nameOrId);

        local targetid = getPlayerIdByPlayerSessionId(playerSessionId.tointeger());

        if(!isPlayerConnected(targetid)) return sendPlayerMessage(playerid, "Player with id ["+playerSessionId+"] is not on server!", 240, 240, 200);

        if (!isPlayerInVehicle(targetid)) {
            setPlayerPosition(targetid, item.x, item.y, item.z);
        } else {
            setVehicleSpeed(getPlayerVehicle(targetid), 0.0, 0.0, 0.0);
            setVehiclePosition(getPlayerVehicle(targetid), item.x, item.y, item.z+0.5);
        }

        sendPlayerMessage(playerid, "Teleport "+getPlayerName(targetid)+" ["+playerSessionId+"] to " + item.name +" (#" + item.id + ") completed.", 240, 240, 200);
    };

    if (isInteger(nameOrId)) {
        TeleportPosition.findOneBy({ id = nameOrId.tointeger() }, callback);
    } else {
        TeleportPosition.findOneBy({ name = nameOrId }, callback);
    }
});

function getNearestTeleport(x, y) {
    local bestIdx = 0;
    local bestDistance = getDistanceBetweenPoints2D(teleportPoints[0].x, teleportPoints[0].y, x, y);
    foreach (idx, value in teleportPoints) {
        local distance = getDistanceBetweenPoints2D(value.x, value.y, x, y);
        if (distance < bestDistance) {
            bestIdx = idx;
            bestDistance = distance;
        }
    };
    return teleportPoints[bestIdx];
}

function getNearestTeleportFromVehicle(vehicleid) {
    local vehPos = getVehiclePosition(vehicleid);
    return getNearestTeleport(vehPos[0], vehPos[1])
}

acmd(["tvehicle", "tv"], function(playerid, plateOrId) {
    local point = getNearestTeleportFromVehicle(isInteger(plateOrId) ? plateOrId.tointeger() : getVehicleByPlateText(plateOrId.toupper()));
    msg(playerid, format("Ближайшая точка - %d. %s", point.id, point.name), CL_INFO);
});