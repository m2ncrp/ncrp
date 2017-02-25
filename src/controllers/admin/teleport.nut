/**
 * Save new position
 */
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
        sendPlayerMessage(playerid, format("Page %s (for next page /tl <page>):", page) );

        // list
        return results.map(function(item) {
            sendPlayerMessage(playerid, format(" #%d. %s", item.id, item.name), 240, 240, 220);
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
addEventHandlerEx("onServerStarted", function() {
    TeleportPosition.findAll(function(err, positions) {
        foreach (idx, teleport in positions) {
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
 * Player to position
 */
acmd(["tp"], function(playerid, targetid, nameOrId) {
    local callback = function(err, item) {
        if (!item) return sendPlayerMessage(playerid, "No point were found by " + nameOrId);

        local targetid = targetid.tointeger();

        if(!isPlayerConnected(targetid)) return sendPlayerMessage(playerid, "Player with id ["+targetid+"] is not on server!", 240, 240, 200);

        if (!isPlayerInVehicle(targetid)) {
            setPlayerPosition(targetid, item.x, item.y, item.z);
        } else {
            setVehicleSpeed(getPlayerVehicle(targetid), 0.0, 0.0, 0.0);
            setVehiclePosition(getPlayerVehicle(targetid), item.x, item.y, item.z+0.5);
        }

        sendPlayerMessage(playerid, "Teleport "+getPlayerName(targetid)+" ["+targetid+"] to " + item.name +" (#" + item.id + ") completed.", 240, 240, 200);
    };

    if (isInteger(nameOrId)) {
        TeleportPosition.findOneBy({ id = nameOrId.tointeger() }, callback);
    } else {
        TeleportPosition.findOneBy({ name = nameOrId }, callback);
    }
});
