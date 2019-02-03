const DEFAULT_PLAYER_MUTE_TIME = 600; // 10 minutes
const DEFAULT_PLAYER_BAN_TIME  = 60; // 30 minutes

include("controllers/admin/models/Ban.nut");

event("onServerStarted", function() {
    log("[admin] Removing expired bans...");

    ORM.Query("select * from @Ban where until < :current")
        .setParameter("current", getTimestamp())
        .getResult(function(err, result) {

        if (result && result.len() > 0) {
            foreach (idx, value in result) {
                value.remove();
            }
        }
    });
});

/**
 * Ban player
 * Usage:
 *     /ban target time(minutes) reason
 * EG:
 * /ban 10 20 noob (ban player with id 10 on 20 minutes for reason 'noob')
 */

function newban(...) {
    local playerid  = vargv[0].tointeger();
    if(vargv.len() < 4){
        return msg(playerid, "Формат: /ban id время_в_минутах причина")
    }
    local targetid = vargv[1].tointeger();
    local time = vargv[2].tointeger();

    local reason = "";
    for(local i = 3; i < vargv.len(); i++) reason = reason+" "+vargv[i]; //get ban reason

    // уберём пробелы по краям
    reason = trim(reason);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "admin.error", CL_ERROR);
    }

    local bantime = time*60;
    Ban( getAccountName(playerid), getAccountName(targetid), getPlayerName(targetid), getPlayerSerial(targetid), bantime, reason).save();

    freezePlayer( targetid, true );

    if (isPlayerInVehicle(targetid)) {
        stopPlayerVehicle(targetid);
        removePlayerFromVehicle(targetid);
    }

    msga("admin.ban.banned", [ getPlayerName(targetid), epochToHuman(getTimestamp() + bantime).format("d.m.Y H:i:s"), reason ], CL_RED);

    // remove player from players array (disabling chats and stuff)
    removePlayer(targetid, reason);
    dbg("admin", "banned", getAuthor(targetid), bantime, reason);

    // move player to sky
    movePlayer(targetid, 0.0, 0.0, 150.0);

    // clear chat
    for (local i = 0; i < 13; i++) {
        msg(targetid, "");
    }

    delayedFunction(10000, function () {
        kickPlayer( targetid );
        dbg("admin", "kicked", getAuthor(targetid), "banned");
    });

};
acmd("ban", newban);

/**
 * List current bans
 * Usage:
 *     /ban list
 */
function banlist(playerid, page = "0") {
    local q = ORM.Query("select * from @Ban where until > :current limit :page, 10");

    q.setParameter("current", getTimestamp())
    q.setParameter("page", max(0, page.tointeger()) * 10);
    q.getResult(function(err, result) {

        if(result && result.len() == 0) {
            return msg(playerid, "Список забаненных игроков пуст", CL_WARNING);
        }

        msg(playerid, "----------------------------------------", CL_WARNING);
        msg(playerid, "Список забаненных игроков:");

        msg(playerid, format("Страница %s (следующая страница: /ban list %d):", page, page.tointeger() + 1), CL_INFO);

        local list = "";

        // list
        result.map(function(item) {
            local entry = format("%s - до: %s. Разбанить: /unban %d", item.charname, epochToHuman(item.until).format("d.m.Y H:i:s"), item.id);
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
            return msg(playerid, "Не найден бан с номером " + id +". Весь список: /ban list", CL_WARNING);
        }

        local charname = result.charname;

        result.remove();
        msg(playerid, "admin.ban.unbanned", [ charname ], CL_SUCCESS);
        dbg("admin" "unban", charname);
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
/*
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
    Ban(getAccountName(targetid), getPlayerSerial(targetid), time, reason).save();

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
//acmd("ban", ban);
*/
/**
 * Mute player for a period of time
 * Usage:
 *     /mute 0
 *     /mute 0 150
 *     /mute 1 150 spam, flood
 */
/*
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

    msg(targetid, format("[SERVER] You has been muted on: %d seconds, for: %s.", amount, reason), CL_RED);
    msg(playerid, format("You've muted %s on: %d seconds, for: %s.", getPlayerName(targetid), amount, reason), CL_SUCCESS);
    dbg("admin", "muted", getAuthor(targetid), amount);

    // unmute
    return delayedFunction(amount * 1000, function() {
        if (isPlayerMuted(targetid)) {
            msg(targetid, "[SERVER] You has been unmuted", CL_INFO);
            dbg("admin", "unmuted", getAuthor(targetid), amount);
        }
    });
};
acmd("mute", mute);
*/
