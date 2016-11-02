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
        sendPlayerMessage(playerid, "You have saved new teleport point with #" + tpp.id);
    });
});

/**
 * List all positions (paginated)
 */
acmd(["tlist", "tl"], function(playerid, page = "0") {
    local q = ORM.Query("select * from @TeleportPosition limit :page, 10");

    q.setParameter("page", max(0, page.tointeger()) * 10);
    q.getResult(function(err, results) {
        sendPlayerMessage(playerid, format("Page %s of teleport (for next page /tl <page>):", page));

        // list
        return results.map(function(item) {
            sendPlayerMessage(playerid, format(" #%d. '%s' at x: %f y: %f z: %f", item.id, item.name, item.x, item.y, item.z), 240, 240, 220);
        })
    });
});

/**
 * Go to position
 */
acmd(["tgoto", "tg"], function(playerid, nameOrId) {
    local callback = function(err, item) {
        if (!item) return sendPlayerMessage(playerid, "No point were found by " + nameOrId);

        if (!isPlayerInVehicle(playeid)) {
            setPlayerPosition(playerid, item.x, item.y, item.z);
        } else {
            setVehiclePosition(getPlayerVehicle(playerid), item.x, item.y, item.z);
        }

        sendPlayerMessage(playerid, "Youve been successfully teleported to #" + item.id, 240, 240, 200);
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
        sendPlayerMessage(playerid, "Youve been successfully removed point #" + item.id, 240, 240, 200);
        item.remove();
    };

    if (isInteger(nameOrId)) {
        TeleportPosition.findOneBy({ id = nameOrId.tointeger() }, callback);
    } else {
        TeleportPosition.findOneBy({ name = nameOrId }, callback);
    }
});
