const DEFAULT_PLAYER_MUTE_TIME = 600; // 10 minutes
const DEFAULT_PLAYER_BAN_TIME  = 60; // 30 minutes

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
        return msg(playerid, "admin.error", CL_ERROR);
    }

    freezePlayer( targetid, true );

    if (isPlayerInVehicle(targetid)) {
        stopPlayerVehicle( targetid );
        removePlayerFromVehicle( targetid );
    }

    if (!reason) {
        reason = "inappropriate behavior";
    }

    // clear chat
    for (local i = 0; i < 12; i++) {
        msg(targetid, "");
    }

    msg(targetid, "admin.kick.hasbeenkicked", [ reason ], CL_RED);
    msg(playerid, "admin.kick.kicked"        , [ getPlayerName(targetid), reason ], CL_SUCCESS);

    // remove player from players array (disabling chats and stuff)
    removePlayer(targetid, reason);

    // move player to sky
    movePlayer(targetid, 0.0, 0.0, 150.0);

    delayedFunction(5000, function () {
        kickPlayer( targetid );
        dbg("admin", "kicked", getAuthor(targetid));
    });
};
acmd("kick", kick);

/**
 * Kick all players on server stopping
 */
function kickAll() {
    foreach (playerid, character in players) kickPlayer( playerid );
}

/**
 * Mute player
 * Usage:
 *     /mute target time(minutes) reason
 * EG:
 * /mute 10 20 noob (mute player with id 10 on 20 minutes for reason 'noob')
 */

function newmute(...) {
    local playerid  = vargv[0].tointeger();
    if(vargv.len() < 4){
        return msg(playerid, "USE: /mute id time_in_minutes reason")
    }
    local targetid = vargv[1].tointeger();
    local time = vargv[2].tointeger();
    local reason = "";
    for(local i = 3; i < vargv.len(); i++) reason = reason+" "+vargv[i]; //get mute reason

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "admin.error", CL_ERROR);
    }
    local mutetime = time*60;
    Mute( getAccountName(playerid), getAccountName(targetid), getPlayerSerial(targetid), mutetime, reason).save();

    msga("admin.mute.mutedforall", [ getPlayerName(targetid), time, reason ], CL_RED);

    setPlayerMuted(targetid, true);
    msg(targetid, "admin.mute.hasbeenmuted", [time, reason], CL_RED);
    msg(playerid, "admin.mute.muted", [ getPlayerName(targetid), time, reason ], CL_SUCCESS);
    dbg("admin", "muted", getAuthor(targetid), time);

    // unmute
    return delayedFunction(time * 60000, function() {
        if (isPlayerMuted(targetid)) {
            setPlayerMuted(targetid, false);
            msg(targetid, "admin.mute.unmute", CL_INFO);
            dbg("admin", "unmuted", getAuthor(targetid), time);
        }
    });
};
mcmd(CMD_LEVEL.MLVL1,"mute", newmute);

/**
 * Unmute player
 * Usage:
 *     /unmute 0
 */
function unmute(playerid, targetid) {
    local targetid = toInteger(targetid);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "admin.error", CL_ERROR);
    }

    if (!isPlayerMuted(targetid)) {
        return msg(playerid, "admin.unmute.notmuted", getPlayerName(targetid), CL_INFO);
    }

    setPlayerMuted(targetid, false);
    msg(playerid, "admin.unmute.unmuted", getPlayerName(targetid), CL_SUCCESS);
    msg(targetid, "admin.unmute.hasbeenunmuted", CL_INFO);
    dbg("admin", "unmuted", getAuthor(targetid));
};
acmd("unmute", unmute);


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
        return msg(playerid, "USE: /ban id time_in_minutes reason")
    }
    local targetid = vargv[1].tointeger();
    local time = vargv[2].tointeger();

    local reason = "";
    for(local i = 3; i < vargv.len(); i++) reason = reason+" "+vargv[i]; //get ban reason

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "admin.error", CL_ERROR);
    }

    local bantime = time*60;
    Ban( getAccountName(playerid), getAccountName(targetid), getPlayerSerial(targetid), bantime, reason).save();

    freezePlayer( targetid, true );

    if (isPlayerInVehicle(targetid)) {
        stopPlayerVehicle(targetid);
        removePlayerFromVehicle(targetid);
    }

    // remove player from players array (disabling chats and stuff)
    removePlayer(targetid, reason);
    dbg("admin", "banned", getAuthor(targetid), bantime, reason);

    // move player to sky
    movePlayer(targetid, 0.0, 0.0, 150.0);

    // clear chat
    for (local i = 0; i < 12; i++) {
        msg(targetid, "");
    }

    msga("admin.ban.bannedforall", [ getPlayerName(targetid), time, reason ], CL_RED);

    msg(targetid, "admin.ban.hasbeenbanned", [ time ], CL_RED);
    msg(targetid, "admin.ban.reason", [ reason ], CL_RED);
    msg(playerid, "admin.ban.banned", [ getPlayerName(targetid), time, reason ], CL_SUCCESS);

    delayedFunction(6000, function () {
        kickPlayer( targetid );
        dbg("admin", "kicked", getAuthor(targetid), "banned");
    });

};
mcmd(CMD_LEVEL.MLVL1,"ban", newban);

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

/**
 * Add warn to player
 * Usage:
 *     /warn targetid
 * EG:
 * /warn 3 (add 1 warn to player with id 3)
 */
function warnUp(playerid, targetid = null) {
    if(targetid == null) return msg(playerid, "USE: /warn targetid");
    local targetid = targetid.tointeger();
    local account = getAccount(targetid);
    account.warns = account.warns + 1;

    msg(targetid, "admin.warn.hasbeenincreased", CL_RED);
    msg(targetid, "admin.warn.info", [ account.warns ], CL_RED);
    msg(playerid, "admin.warn.increased", [ getPlayerName(targetid), account.warns], CL_SUCCESS );

    if (account.warns >= 3) {
        freezePlayer(targetid, true);
        delayedFunction(2000, function () {
            newban(playerid, targetid, 4320, plocalize(targetid, "admin.warn.congratulations"));
        });
        account.warns = 0;
        account.save();
        return;
    }
    account.save();
}
acmd("warn", warnUp);

/**
 * Remove warn from player
 * Usage:
 *     /unwarn targetid
 * EG:
 * /unwarn 3 (remove 1 warn from player with id 3)
 */
function warnDown(playerid, targetid = null) {
    if(targetid == null) return msg(playerid, "USE: /unwarn targetid");
    local targetid = targetid.tointeger();
    local account = getAccount(targetid);
    if (account.warns == 0) {
        return msg(playerid, "admin.warn.minimumlevel", [ getPlayerName(targetid) ], CL_SUCCESS);
    }
    account.warns = account.warns - 1;
    account.save();

    msg(targetid, "admin.warn.hasbeendecreased", CL_RED);
    msg(targetid, "admin.warn.info", [ account.warns ], CL_RED);
    msg(playerid, "admin.warn.decreased", [ getPlayerName(targetid), account.warns], CL_SUCCESS );
}
acmd("unwarn", warnDown);

function warnGet(playerid, targetid = null) {
    if(targetid == null) return msg(playerid, "USE: /getwarn targetid");
    local targetid = targetid.tointeger();
    local account = getAccount(targetid);
    if (account.warns == 0) {
        return msg(playerid, "admin.warn.minimumlevel", [ getPlayerName(targetid) ], CL_SUCCESS);
    }
    msg(playerid, "admin.warn.get", [ getPlayerName(targetid), account.warns], CL_SUCCESS );
}
acmd("getwarn", warnGet);

alternativeTranslate({

    "en|admin.error"                        :   "Error: id empty or player not connected."
    "ru|admin.error"                        :   "Ошибка: id не указан или игрок не подключен."

    "en|admin.kick.hasbeenkicked"           :   "[SERVER] You has been kicked for: %s."
    "ru|admin.kick.hasbeenkicked"           :   "[CЕРВЕР] Вы были кикнуты по причине: %s."

    "en|admin.kick.kicked"                  :   "You've kicked %s for: %s."
    "ru|admin.kick.kicked"                  :   "Вы кикнули %s по причине: %s."



    "en|admin.mute.hasbeenmuted"            :   "[SERVER] You has been muted on: %d minutes for:%s."
    "ru|admin.mute.hasbeenmuted"            :   "[СЕРВЕР] Вы были заглушены на %d минут по причине:%s."

    "en|admin.mute.muted"                   :   "You've muted %s on %d minutes for:%s."
    "ru|admin.mute.muted"                   :   "Вы заглушили игрока %s на %d минут по причине:%s."

    "en|admin.mute.mutedforall"             :   "[Player %s has been muted on %d minutes. Reason:%s]"
    "ru|admin.mute.mutedforall"             :   "[Игрок %s заглушен на %d минут. Причина:%s]"

    "en|admin.mute.unmute"                  :   "[SERVER] You has been unmuted."
    "ru|admin.mute.unmute"                  :   "[СЕРВЕР] Заглушка чата снята."

    "en|admin.mute.youhave"                  :   "[SERVER] You are muted."
    "ru|admin.mute.youhave"                  :   "[СЕРВЕР] Вы заглушены."



    "en|admin.unmute.hasbeenunmuted"        :   "[SERVER] You has been unmuted"
    "ru|admin.unmute.hasbeenunmuted"        :   "[СЕРВЕР] Заглушка чата снята."

    "en|admin.unmute.notmuted"              :   "Player %s is not muted."
    "ru|admin.unmute.notmuted"              :   "Игрок %s не заглушен."

    "en|admin.unmute.unmuted"               :   "Player %s is unmuted."
    "ru|admin.unmute.unmuted"               :   "Заглушка чата с игрока %s снята."



    "en|admin.ban.hasbeenbanned"            :   "[SERVER] You has been banned on: %d min."
    "ru|admin.ban.hasbeenbanned"            :   "[СЕРВЕР] Вы забанена на "

    "en|admin.ban.bannedforall"             :   "[Player %s has been banned on %d minutes. Reason: %s]"
    "ru|admin.ban.bannedforall"             :   "[Игрок %s забанен на %d минут. Причина: %s]"

    "en|admin.ban.reason"                   :   "Reason: %s."
    "ru|admin.ban.reason"                   :   "Причина: %s."

    "en|admin.ban.banned"                   :   "You've banned %s on %d min. Reason: %s."
    "ru|admin.ban.banned"                   :   "Вы забанили игрока %s на %d минут. Причина: %s."



    "en|admin.warn.increased"               :   "You increased warn-level for player %s. Now: %d."
    "ru|admin.warn.increased"               :   "Вы выдали предупреждение игроку %s. Всего: %d."

    "en|admin.warn.hasbeenincreased"        :   "[ADMIN] Your warn-level has been increased."
    "ru|admin.warn.hasbeenincreased"        :   "[ADMIN] Вам выдано предупреждение."

    "en|admin.warn.decreased"               :   "You decreased warn-level for player %s. Now: %d."
    "ru|admin.warn.decreased"               :   "Вы сняли предупреждение с игрока %s. Всего: %d."

    "en|admin.warn.hasbeendecreased"        :   "[ADMIN] Your warn-level has been decreased."
    "ru|admin.warn.hasbeendecreased"        :   "[ADMIN] С вас снято одно предупреждение."

    "en|admin.warn.info"                    :   "You have %d from 3 warns-level. Level 3 = ban."
    "ru|admin.warn.info"                    :   "У вас %d из 3 предупреждений. 3 предупреждения = бан."

    "en|admin.warn.minimumlevel"            :   "Player %s have minimum warn-level."
    "ru|admin.warn.minimumlevel"            :   "У игрока %s нет предупреждений."

    "en|admin.warn.get"                     :   "Player %s have %d warn-level."
    "ru|admin.warn.get"                     :   "У игрока %s предупреждений: %d."

    "en|admin.warn.congratulations"         :   "Achieved success: 3 of 3 warns. Congratulations!"
    "ru|admin.warn.congratulations"         :   "Достижение получено: 3 из 3 варнов. Поздравляем!"

/*
    "en|admin.warn.msga.playerreceived"     :   "Player %s received a warning."
    "ru|admin.warn.msga.playerreceived"     :   "Игрок %s получил одно предупреждение."

    "en|admin.warn.msga.removefromplayer"   :   "Warning removed from player %s."
    "ru|admin.warn.msga.removefromplayer"   :   "С игрока %s снято одно предупреждение"
*/
});


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
*/
