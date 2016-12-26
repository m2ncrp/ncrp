include("controllers/player/respawn/SpawnPosition.nut");

/**
 * Save new position
 */
acmd(["spawnsave", "ss"], function(playerid) {
    // if (!name || name.len() < 1) return sendPlayerMessage(playerid, "Usage: /ts <name>");

    local tpp = SpawnPosition();
    local pos = getPlayerPosition(playerid);

    tpp.x = pos[0];
    tpp.y = pos[1];
    tpp.z = pos[2];

    tpp.save(function(err, result) {
        sendPlayerMessage(playerid, "Created new spawn point #" + tpp.id);
    });
});


/**
 * List all positions (paginated)
 */
acmd(["spawnlist", "sl"], function(playerid, page = "0") {
    local q = ORM.Query("select * from @SpawnPosition limit :page, 10");

    q.setParameter("page", max(0, page.tointeger()) * 10);
    q.getResult(function(err, results) {
        sendPlayerMessage(playerid, format("Page %s (for next page /sl <page>):", page) );

        // list
        return results.map(function(item) {
            sendPlayerMessage(playerid, format("Spawn with id: %d. Info /sc %d", item.id, item.id), 240, 240, 220);
        })
    });
});

/**
 * Go to position
 */
acmd(["spawngo", "sg"], function(playerid, nameOrId) {
    local callback = function(err, item) {
        if (!item) return sendPlayerMessage(playerid, "No point were found by " + nameOrId);

        if (!isPlayerInVehicle(playerid)) {
            setPlayerPosition(playerid, item.x, item.y, item.z);
        } else {
            setVehiclePosition(getPlayerVehicle(playerid), item.x, item.y, item.z);
        }

        sendPlayerMessage(playerid, "Teleport to spawn " + item.name +" (#" + item.id + ") completed.", 240, 240, 200);
    };

    if (isInteger(nameOrId)) {
        SpawnPosition.findOneBy({ id = nameOrId.tointeger() }, callback);
    }
});

/**
 * Remove position
 */
acmd(["spawndelete", "sd"], function(playerid, nameOrId) {
    local callback = function(err, item) {
        if (!item) return sendPlayerMessage(playerid, "No point were found by " + nameOrId);
        sendPlayerMessage(playerid, "Removed spawn point #" + item.id, 240, 240, 200);
        item.remove();
    };

    if (isInteger(nameOrId)) {
        SpawnPosition.findOneBy({ id = nameOrId.tointeger() }, callback);
    }
});


/**
 * Get coords of point
 */
acmd(["spawncoords", "sc"], function(playerid, nameOrId) {
    local callback = function(err, item) {
        if (!item) return sendPlayerMessage(playerid, "No point were found by " + nameOrId);
        sendPlayerMessage(playerid, format("Spawn coords for (#%d): x: %f y: %f z: %f", item.id, item.x, item.y, item.z), 240, 240, 200);
    };

    if (isInteger(nameOrId)) {
        SpawnPosition.findOneBy({ id = nameOrId.tointeger() }, callback);
    }
});

/**
 * Rendering tgs in the world
 */
addEventHandlerEx("onServerStarted", function() {
    SpawnPosition.findAll(function(err, positions) {
        foreach (idx, teleport in positions) {
            // create3DText(teleport.x, teleport.y, teleport.z, "Teleport: " + teleport.name, CL_ROYALBLUE.applyAlpha(150));
        }

        log(format("[players] loaded %d spawn points...", positions.len()));
    });
});

/**
 * TODO: need mysql
 */
event("onPlayerFallingDown", function(playerid) {
    local p = getPlayerPosition(playerid);
    local q = ORM.Query("select p.x, p.y, p.z, ( (p.x - :x) * (p.x - :x) + (p.y - :y) * (p.y - :y)) as dist from @SpawnPosition as p order by dist limit 1");

    dbg("on down");

    q.setParameter("x", p[0]);
    q.setParameter("y", p[1]);

    q.getSingleResult(function(err, pos) {
        dbg("player", "falldown", "respawn", playerid, { x = pos.x, y = pos.y, z = pos.z});

        // respawn on vehicle or on foot
        if (isPlayerInVehicle(playerid)) {
            local vehicleid = getPlayerVehicle(playerid);

            setVehiclePosition(vehicleid, pos.x, pos.y, pos.z);
            setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
            setVehicleRotation(vehicleid, 0.0, 0.0, 0.0);
        } else {
            setPlayerPosition(playerid, pos.x, pos.y, pos.z);
        }
    });
});
