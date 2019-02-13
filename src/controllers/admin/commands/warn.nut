
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
