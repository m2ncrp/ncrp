const MAX_WARNS_COUNT = 5;

/**
 * Add warn to player
 * Usage:
 *     /warn targetid
 * EG:
 * /warn 3 (add 1 warn to player with id 3)
 */
function warnUp(playerid, targetid = null) {
    if(targetid == null) return msg(playerid, "USE: /warn targetid");
    local targetid = getPlayerIdByPlayerSessionId(targetid.tointeger());
    local account = getAccount(targetid);
    account.warns = account.warns + 1;

    msg(targetid, "admin.warn.hasbeenincreased", CL_RED);
    msg(targetid, "admin.warn.info", [ account.warns, MAX_WARNS_COUNT ], CL_RED);
    msg(playerid, "admin.warn.increased", [ getPlayerName(targetid), account.warns], CL_SUCCESS );

    if (account.warns >= MAX_WARNS_COUNT) {
        freezePlayer(targetid, true);
        delayedFunction(2000, function () {
            newban(playerid, targetid, 2628000, plocalize(targetid, "admin.warn.congratulations", [account.warns, MAX_WARNS_COUNT]));
        });
        //account.warns = 0;
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
    local targetid = getPlayerIdByPlayerSessionId(targetid.tointeger());
    local account = getAccount(targetid);
    if (account.warns == 0) {
        return msg(playerid, "admin.warn.minimumlevel", [ getPlayerName(targetid) ], CL_SUCCESS);
    }
    account.warns = account.warns - 1;
    account.save();

    msg(targetid, "admin.warn.hasbeendecreased", CL_RED);
    msg(targetid, "admin.warn.info", [ account.warns, MAX_WARNS_COUNT ], CL_RED);
    msg(playerid, "admin.warn.decreased", [ getPlayerName(targetid), account.warns], CL_SUCCESS );
}
acmd("unwarn", warnDown);

function warnGet(playerid, targetid = null) {
    if(targetid == null) return msg(playerid, "USE: /getwarn targetid");
    local targetid = getPlayerIdByPlayerSessionId(targetid.tointeger());
    local account = getAccount(targetid);
    if (account.warns == 0) {
        return msg(playerid, "admin.warn.minimumlevel", [ getPlayerName(targetid) ], CL_SUCCESS);
    }
    msg(playerid, "admin.warn.get", [ getPlayerName(targetid), account.warns], CL_SUCCESS );
}
acmd("getwarn", warnGet);


alternativeTranslate({

    "en|admin.warn.hasbeenincreased"        :   "[ADMIN] Your warn-level has been increased."
    "ru|admin.warn.hasbeenincreased"        :   "[ADMIN] Вам выдано предупреждение."

    "en|admin.warn.hasbeendecreased"        :   "[ADMIN] Your warn-level has been decreased."
    "ru|admin.warn.hasbeendecreased"        :   "[ADMIN] С вас снято одно предупреждение."

    "en|admin.warn.increased"               :   "You increased warn-level for player %s. Now: %d."
    "ru|admin.warn.increased"               :   "Вы выдали предупреждение игроку %s. Всего: %d."

    "en|admin.warn.decreased"               :   "You decreased warn-level for player %s. Now: %d."
    "ru|admin.warn.decreased"               :   "Вы сняли предупреждение с игрока %s. Всего: %d."

    "en|admin.warn.info"                    :   "You have %d from %d warns. 5 warns = permanent ban."
    "ru|admin.warn.info"                    :   "У вас %d из %d предупреждений. 5 предупреждений = бан навсегда (перманент)."

    "en|admin.warn.minimumlevel"            :   "Player %s have minimum warn-level."
    "ru|admin.warn.minimumlevel"            :   "У игрока %s нет предупреждений."

    "en|admin.warn.get"                     :   "Player %s have %d warn-level."
    "ru|admin.warn.get"                     :   "У игрока %s предупреждений: %d."

    "en|admin.warn.congratulations"         :   "Limit of warns reached."
    "ru|admin.warn.congratulations"         :   "Достигнут лимит нарушений."

});
