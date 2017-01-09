/**
 * Storage for our sessions
 * no direct acess
 *
 * for access from remote resources use:
 *     Account.getSession(playerid, callback)
 *     Account.addSession(playerid)
 */
local accounts = {};
local baseData = {};
local sessions = {};
local blockedAccounts = [];

/**
 * Check if player account is blocked via kick or ban
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function isPlayerAuthBlocked(playerid) {
    return false;//blockedAccounts.find(getPlayerName(playerid)) != null;
}

/**
 * Sets player account blocked
 * @param {Integer} playerid
 * @param {Boolean} value
 */
function setPlayerAuthBlocked(playerid, value) {
    // if (value && !isPlayerAuthBlocked(playerid)) {
    //     return blockedAccounts.push(getPlayerName(playerid));
    // }

    // if (!value && isPlayerAuthBlocked(playerid)) {
    //     return blockedAccounts.remove(blockedAccounts.find(getPlayerName(playerid)));
    // }

    return false;
}

/**
 * Return true if player is authed
 * @param  {Integer}  playerid
 * @return {Boolean}
 */
function isPlayerAuthed(playerid) {
    return (playerid in accounts);
}

/**
 * Return player account name
 * @param  {Integer} playerid
 * @return {String}
 */
function getAccountName(playerid) {
    return "nativeGetPlayerName" in getroottable() ? nativeGetPlayerName(playerid) : getPlayerName(playerid);
}

/**
 * Get player account id (if logined, or 0)
 * @param  {Integer} playerid
 * @return {Integer}
 */
function getAccountId(playerid) {
    return (isPlayerAuthed(playerid) ? accounts[playerid].id : 0);
}

/**
 * Get player account object (if logined or null)
 * @param  {Integer} playerid
 * @return {Account}
 */
function getAccount(playerid) {
    return (isPlayerAuthed(playerid) ? accounts[playerid] : null);
}

/**
 * Get account object by playerid or null
 * @param  {Integer} playerid
 * @return {Account}
 */
function getPlayerSession(playerid) {
    return (isPlayerAuthed(playerid) ? accounts[playerid] : null);
}

/**
 * Clean up player session object
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function destroyAuthData(playerid) {
    // clean up data for GC
    accounts[playerid].clean();
    accounts[playerid] = null;

    delete baseData[playerid];
    delete accounts[playerid];

    return true;
}


/**
 * Get player ip
 * @param  {Integer} playerid
 * @return {String}
 */
function getPlayerIp(playerid) {
    return (playerid in baseData) ? baseData[playerid].ip : "0.0.0.0";
}

/**
 * Return current player locale
 *
 * @param  {Integer} playerid
 * @return {String}
 */
function getPlayerLocale(playerid) {
    if (playerid in accounts) {
        return accounts[playerid].locale;
    }

    if (playerid in baseData) {
        return baseData[playerid].locale;
    }

    return "ru";
}

/**
 * Set current player locale
 *
 * @param  {Integer} playerid
 * @return {String}
 */
function setPlayerLocale(playerid, locale = "en") {
    if (playerid in accounts) {
        accounts[playerid].locale = locale;
        accounts[playerid].save();
        return true;
    }

    if (!(playerid in baseData)) {
        baseData[playerid] <- { locale = locale }
        return true;
    }

    if (playerid in baseData) {
        baseData[playerid].locale = locale;
        return true;
    }

    return false;
}

/**
 * Get last active session for the player
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function getLastActiveSession(playerid) {
    local key = md5(getAccountName(playerid) + "@" + getPlayerSerial(playerid));

    if (key in sessions) {
        return sessions[key];
    }

    return 0;
}

/**
 * Set last active session to current timestamp
 * @param {Integer} playerid
 * @return {Boolean}
 */
function setLastActiveSession(playerid) {
    return sessions[md5(getAccountName(playerid) + "@" + getPlayerSerial(playerid))] <- getTimestamp();
}

/**
 * Trigger showing logging in gui
 * adding translation for player
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function showLoginGUI(playerid) {
    local window    = plocalize(playerid, "auth.GUI.TitleLogin");
    local label     = plocalize(playerid, "auth.GUI.TitleLabelLogin");
    local input     = plocalize(playerid, "auth.GUI.TitleInputLogin");
    local button    = plocalize(playerid, "auth.GUI.ButtonLogin");

    return delayedFunction(2500, function() {
        trigger(playerid, "showAuthGUI", window, label, input, button);
    });
}

/**
 * Tigger showing regisration gui
 * for player addding translations
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function showRegisterGUI(playerid) {
    local window    = plocalize(playerid, "auth.GUI.TitleRegister");
    local label     = plocalize(playerid, "auth.GUI.TitleLabelRegister");
    local inputp    = plocalize(playerid, "auth.GUI.PasswordInput");
    local inputrp   = plocalize(playerid, "auth.GUI.RepeatPasswordInput");
    local iptemail  = plocalize(playerid, "auth.GUI.Email");
    local button    = plocalize(playerid, "auth.GUI.ButtonRegister");

    return delayedFunction(2500, function() {
        trigger(playerid, "showRegGUI", window, label, inputp, inputrp, iptemail, button);
    });
}

/**
 * Cross resource handling
 */
event("__networkRequest", function(request) {
    local data = request.data;

    // we are working with current resource
    if (!("destination" in data) || data.destination != "auth") return;

    if (data.method == "getSession") {
        Response({result = data.id in accounts ? accounts[data.id] : null}, request).send();
    }

    if (data.method == "addSession") {
        accounts[data.id] <- data.object;
    }
});

event("onPlayerConnectInit", function(playerid, username, ip, serial) {
    // save base data
    baseData[playerid] <- {
        playerid = playerid,
        username = username,
        ip = ip,
        serial = serial,
        locale = "ru"
    };
});


event("changeModel",function(playerid, model) {
    nativeSetPlayerModel( playerid, model.tointeger() );
});
