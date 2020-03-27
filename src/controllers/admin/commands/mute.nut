include("controllers/admin/models/Mute.nut");

event("onServerStarted", function() {
    logStr("[admin] Removing expired mutes...");

    ORM.Query("select * from @Mute where until < :current")
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
 * Mute player
 * Usage:
 *     /mute target time(minutes) reason
 * EG:
 * /mute 10 20 noob (mute player with id 10 on 20 minutes for reason 'noob')
 */

function newmute(...) {
    local playerid  = vargv[0].tointeger();
    if(vargv.len() < 4){
        return msg(playerid, "Формат: /mute id время_в_минутах причина")
    }
    local targetid = vargv[1].tointeger();
    local time = vargv[2].tointeger();
    local reason = "";
    for(local i = 3; i < vargv.len(); i++) reason = reason+" "+vargv[i]; //get mute reason

    // уберём пробелы по краям
    reason = trim(reason);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "admin.error", CL_ERROR);
    }

    local mutetime = time*60;

    Mute( getAccountName(playerid), getAccountName(targetid), getPlayerName(targetid), getPlayerSerial(targetid), mutetime, reason).save();

    msga("admin.mute.muted", [ targetid.tostring(), time, reason ], CL_RED);

    local timestamp = getTimestamp();

    setPlayerMuted(targetid, { amount = mutetime, until = timestamp + mutetime, created = timestamp, reason = reason  });

    //msg(targetid, "admin.mute.hasbeenmuted", [time, reason], CL_RED);
    //msg(playerid, "admin.mute.muted", [ getPlayerName(targetid), time, reason ], CL_SUCCESS);
    dbg("admin", "muted", getAuthor(targetid), time);
};
acmd("mute", newmute);

/**
 * List current mutes
 * Usage:
 *     /mute list
 */
function mutelist(playerid, page = "0") {
    local q = ORM.Query("select * from @Mute where until > :current limit :page, 10");

    q.setParameter("current", getTimestamp())
    q.setParameter("page", max(0, page.tointeger()) * 10);
    q.getResult(function(err, result) {

        if(result && result.len() == 0) {
            return msg(playerid, "Список заглушенных игроков пуст", CL_WARNING);
        }

        msg(playerid, "----------------------------------------", CL_WARNING);
        msg(playerid, "Список заглушенных игроков:");

        msg(playerid, format("Страница %s (следующая страница: /mute list %d):", page, page.tointeger() + 1), CL_INFO);

        local list = "";

        // list
        result.map(function(item) {
            local entry = format("%s - до: %s. Снять мут: /unmute %d", item.charname, epochToHuman(item.until).format("d.m.Y H:i:s"), item.id);
            msg(playerid, entry);
            list += entry + "\n";
        });

        dbg("admin", "mutelist", list);
    });
};
acmd("mute", "list", mutelist);

/**
 * Remove mute record by id
 * Usage:
 *     /unmute 51
 */
function unmute(playerid, id = null) {
    local q = ORM.Query("select * from @Mute where until > :current and id = :id")

    q.setParameter("id", toInteger(id));
    q.setParameter("current", getTimestamp())

    q.getSingleResult(function(err, result) {
        if (err || !result) {
            return msg(playerid, "Не найдена заглушка с номером " + id +". Весь список: /mute list", CL_WARNING);
        }

        local charname = result.charname;

        result.remove();

        local targetid = getPlayerIdFromCharacterName(charname);

        msga("admin.mute.unmuted", [ targetid.tostring() ], CL_RED);

        if(targetid >= 0) {
            setPlayerMuted(targetid, false);
        }

        dbg("admin" "unmute", charname);
    });
};
acmd("unmute", unmute);
