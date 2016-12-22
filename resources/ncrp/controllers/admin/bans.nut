const DEFAULT_PLAYER_MUTE_TIME = 300; // 5 minutes
const DEFAULT_PLAYER_BAN_TIME  = 30; // 30 minutes

include("controllers/admin/models/Ban.nut");

/**
 * Kick player with 5 sec delay
 * Usage:
 *     /kick 0 shitposting
 *     /kick 0
 */
function kick(playerid, targetid, ...) {
    local targetid = toInteger(targetid);
    local reason   = concat(vargv);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "You should provide playerid of connected player you want to kick", CL_ERROR);
    }

    freezePlayer( targetid, true );

    if (isPlayerInVehicle(targetid)) {
        stopPlayerVehicle( targetid );
        removePlayerFromVehicle( targetid );
    }

    // remove player from players array (disabling chats and stuff)
    removePlayer(targetid, reason);

    // move player to sky
    movePlayer(targetid, 0.0, 0.0, 150.0);

    // clear chat
    for (local i = 0; i < 12; i++) {
        msg(targetid, "");
    }

    msg(targetid, format("[SERVER] You has been kicked for: %s.", reason), CL_RED);
    msg(playerid, format("You've kicked %s for: %s.", getPlayerName(targetid), reason), CL_SUCCESS);

    delayedFunction(5000, function () {
        kickPlayer( targetid );
        dbg("admin", "kicked", getAuthor(targetid));
    });
};
acmd("kick", kick);

/**
 * Mute player for a period of time
 * Usage:
 *     /mute 0
 *     /mute 0 150
 *     /mute 1 150 spam, flood
 */
function mute(playerid, targetid, ...) {
    local targetid = toInteger(targetid);
    local amount   = vargv.len() ? toInteger(vargv.pop()) : null;
    local reason   = concat(vargv);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "You should provide playerid of connected player you want to mute", CL_ERROR);
    }

    if (amount == null || amount < 1) {
        amount = DEFAULT_PLAYER_MUTE_TIME;
    }

    if (!reason) {
        reason = "inappropriate behavior";
    }

    setPlayerMuted(targetid, true);
    msg(targetid, format("[SERVER] You has been muted on: %d seconds, for: %s.", amount, reason), CL_RED);
    msg(playerid, format("You've muted %s on: %d seconds, for: %s.", getPlayerName(targetid), amount, reason), CL_SUCCESS);
    dbg("admin", "muted", getAuthor(targetid), amount);

    // unmute
    return delayedFunction(amount * 1000, function() {
        if (isPlayerMuted(targetid)) {
            setPlayerMuted(targetid, false);
            msg(targetid, "[SERVER] You has been unmuted", CL_INFO);
            dbg("admin", "unmuted", getAuthor(targetid), amount);
        }
    });
};
acmd("mute", mute);

/**
 * Unmute player
 * Usage:
 *     /unmute 0
 */
function unmute(playerid, targetid) {
    local targetid = toInteger(targetid);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "You should provide playerid of connected player you want to mute", CL_ERROR);
    }

    if (!isPlayerMuted(targetid)) {
        return msg(playerid, format("Player %s is not muted.", getPlayerName(targetid)), CL_INFO);
    }

    setPlayerMuted(targetid, false);
    msg(playerid, format("Player %s is unmuted.", getPlayerName(targetid)), CL_SUCCESS);
    msg(targetid, "[SERVER] You has been unmuted", CL_INFO);
    dbg("admin", "unmuted", getAuthor(targetid))
};
acmd("unmute", unmute);

/**
 * Ban player
 * Usage:
 *     /ban 0           <- (30 minutes)
 *     /ban 0 15        <- (15 minutes)
 *     /ban 0 1 day
 *     /ban 0 15 mins
 *     /ban 0 3 hours cheating
 *     /ban 0 1 year killing other people, bad stuff.
 */
function ban(playerid, targetid, ...) {
    local targetid = toInteger(targetid);
    vargv.reverse();
    local amount   = vargv.len() ? toInteger(vargv.pop()) : DEFAULT_PLAYER_BAN_TIME;
    local type     = vargv.len() ? vargv.pop() : "mins";
    vargv.reverse();
    local reason   = concat(vargv);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "You should provide playerid of connected player you want to ban", CL_ERROR);
    }

    local time = null;
    local amount_title = "minute";

    if (type == null) {
        time = amount * 60;
    }

    else if (type == "year" || type == "years") {
        time = amount * 31104000; amount_title = "year";
    }

    else if (type == "month" || type == "months") {
        time = amount * 2592000; amount_title = "month";
    }

    else if (type == "day" || type == "day") {
        time = amount * 86400; amount_title = "day";
    }

    else if (type == "hour" || type == "hours") {
        time = amount * 3600; amount_title = "hour";
    }

    else if (type == "minute" || type == "minutes" || type == "min" || type == "mins") {
        time = amount * 60; amount_title = "minute";
    }

    if (amount > 1) { amount_title = amount_title+"s";  }

    if (!reason) {
        reason = "inappropriate behavior";
    }

    // save the ban
    Ban(getPlayerName(targetid), getPlayerSerial(targetid), time, reason).save();

    freezePlayer( targetid, true );

    if (isPlayerInVehicle(targetid)) {
        stopPlayerVehicle(targetid);
        removePlayerFromVehicle(targetid);
    }

    // remove player from players array (disabling chats and stuff)
    removePlayer(targetid, reason);
    dbg("admin", "banned", getAuthor(targetid), amount, reason);

    // move player to sky
    movePlayer(targetid, 0.0, 0.0, 150.0);

    // clear chat
    for (local i = 0; i < 12; i++) {
        msg(targetid, "");
    }

    msg(targetid, format("[SERVER] You has been banned on: %d %s for: %s.", amount, amount_title, reason), CL_RED);
    msg(playerid, format("You've banned %s for: %s on %d %s.", getPlayerName(targetid), reason, amount, amount_title), CL_SUCCESS);

    delayedFunction(5000, function () {
        kickPlayer( targetid );
        dbg("admin", "kicked", getAuthor(targetid), "banned");
    });
};
acmd("ban", ban);

/**
 * List current bans
 * Usage:
 *     /ban list
 */
function banlist(playerid, page = "0") {
    msg(playerid, "Listing current server bans:");
    msg(playerid, "----------------------------------------", CL_WARNING);
    local q = ORM.Query("select * from @Ban where until > :current limit :page, 10");

    q.setParameter("current", getTimestamp())
    q.setParameter("page", max(0, page.tointeger()) * 10);
    q.getResult(function(err, results) {
        msg(playerid, format("Page %s (for next page /ban list %d):", page, page.tointeger() + 1), CL_INFO);
        local list = "";

        // list
        results.map(function(item) {
            local entry = format("Player: %s, seconds left: %d. Unban via: /unban %d", item.name, item.until - getTimestamp(), item.id);
            msg(playerid, entry);
            list += entry + "\n";
        });

        dbg("admin", "banlist", list);
    });
};
acmd("ban", "list", banlist);

/**
 * Remove ban record by id
 * Usage:
 *     /unban 51
 */
function unban(playerid, id = null) {
    local q = ORM.Query("select * from @Ban where until > :current and id = :id")

    q.setParameter("id", toInteger(id));
    q.setParameter("current", getTimestamp())

    q.getSingleResult(function(err, result) {
        if (err || !result) {
            return msg(playerid, "No bans has been found for id #" + id, CL_WARNING);
        }

        local name = result.name;

        result.remove();
        msg(playerid, format("Ban for player %s has been successfuly removed", name), CL_SUCCESS);
        dbg("admin" "unban", name);
    });
};
acmd("unban", unban);

function handleAdminInput(data) {
    local mappings = {
        kick = kick,
        mute = mute,
        unmute = unmute,
        ban = ban,
        banlist = banlist,
        unban = unban,
    };

    if (!data.len() || !(data[0] in mappings)) {
        return dbg("admin", "error", "handling input");
    }
    local callback = mappings[data[0]];
    data[0] = getroottable();
    data.insert(1, -1);
    callback.acall(data);
}
