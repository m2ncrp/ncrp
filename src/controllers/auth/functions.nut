/**
 * Return player account name
 * @param  {Integer} playerid
 * @return {String}
 */
function getAccountName(playerid) {
    return "nativeGetPlayerName" in getroottable() ? nativeGetPlayerName(playerid) : getPlayerName(playerid);
}

/**
 * Trigger showing gui window with message about bad nickname: Player
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function showBadPlayerNicknameGUI(playerid) {
    return delayedFunction(2500, function() {
        trigger(playerid, "showBadPlayerNicknameGUI");
    });
}

/**
 * Trigger showing logging in gui
 * adding translation for player
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function showLoginGUI(playerid, delay = 0) {
    local window    = plocalize(playerid, "auth.GUI.TitleLogin");
    local label     = plocalize(playerid, "auth.GUI.TitleLabelLogin", [getPlayerName(playerid)]);
    local input     = plocalize(playerid, "auth.GUI.TitleInputLogin");
    local button    = plocalize(playerid, "auth.GUI.ButtonLogin");
    local helpText  = plocalize(playerid, "auth.haveproblems");
    local forgotText  = plocalize(playerid, "auth.forgot");
    return delayedFunction(delay, function() {
        trigger(playerid, "showAuthGUI", window, label, input, button, helpText, forgotText);
    });
}

/**
 * Trigger showing regisration gui
 * for player addding translations
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function showRegisterGUI(playerid, delay = 0) {
    local window    = plocalize(playerid, "auth.GUI.TitleRegister");
    local label     = plocalize(playerid, "auth.GUI.TitleLabelRegister");
    local inputp    = plocalize(playerid, "auth.GUI.PasswordInput");
    local inputrp   = plocalize(playerid, "auth.GUI.RepeatPasswordInput");
    local iptemail  = plocalize(playerid, "auth.GUI.Email");
    local button    = plocalize(playerid, "auth.GUI.ButtonRegister");
    local helpText  = plocalize(playerid, "auth.haveproblems");
    local forgotText  = plocalize(playerid, "auth.forgot");
    return delayedFunction(delay, function() {
        trigger(playerid, "showRegGUI", window, label, inputp, inputrp, iptemail, button, helpText, forgotText);
    });
}

function printStartedTips (playerid) {
        // send message success
        msg(playerid, "");
        msg(playerid, "hello.1", CL_LIGHTGRAY);
        msg(playerid, "hello.2", CL_CASCADE);
        msg(playerid, "hello.3", CL_LIGHTGRAY);
        msg(playerid, "hello.4", CL_CASCADE);
        msg(playerid, "hello.5", CL_LIGHTGRAY);
        msg(playerid, "hello.6", CL_CASCADE);
        msg(playerid, "");
        msg(playerid, "hello.end", CL_SUCCESS);
        msg(playerid, "");
}