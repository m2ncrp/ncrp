// includes
include("controllers/auth/commands.nut");

IS_AUTHORIZATION_ENABLED <- true;
AUTH_ACCOUNTS_LIMIT <- 2;
AUTH_AUTOLOGIN_TIME <- 900; // 15 minutes

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

translation("en", {
    "auth.wrongname"        : "Your name should be at least 4 symbols and should not contain any symbols except letters, nubmers, space and underscore."
    // "auth.wrongname"        : "Sorry, your name should be original (not from the game) and have Firstname_Lastname format."
    "auth.changename"       : "Please, change you name in the settings, and reconnect. Thank you!"
    "auth.welcome"          : "* Welcome there, %s!"
    "auth.registered"       : "* Your account is registered."
    "auth.notregistered"    : "* Your account is not registered."
    "auth.command.register" : "* Please register using /register PASSWORD"
    "auth.command.regformat": "* Example: Joe_Barbaro"
    "auth.command.login"    : "* Please enter using /login PASSWORD"
    "auth.error.logined"    : "[AUTH] You are already logined!"
    "auth.error.login"      : "[AUTH] You are already logined!"
    "auth.error.register"   : "[AUTH] Account with this name is already registered!"
    "auth.error.notfound"   : "[AUTH] This account is not registered"
    "auth.success.register" : "[AUTH] You've successfuly registered!"
    "auth.success.login"    : "[AUTH] You've successfuly logined!"
    "auth.success.autologin": "[AUTH] You've been automatically logined!"
    "auth.error.cmderror"   : "[AUTH] You can't execute commands without registration."
    "auth.notification"     : "[AUTH] You should enter into your account via /login PASSWORD, or create new one via /register PASSWORD"
    "auth.error.tomany"     : "[AUTH] You cant register more accounts."
});


/**
 * Compiled regex object for
 * validation of usernames
 * @type {Object}
 */
local REGEX_USERNAME = regexp("[A-Za-z0-9_ ]{3,64}");


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
 * On player connects we will
 * check his nickname for validity
 * and then we will show him
 * screen with different text
 * depending if he is logined or not
 */
event("onPlayerConnectInit", function(playerid, username, ip, serial) {
    // save base data
    baseData[playerid] <- {
        playerid = playerid,
        username = username,
        ip = ip,
        serial = serial,
        locale = "ru"
    };

    if (DEBUG) {
        return dbg("skipping auth for debug mode");
    }

    // check playername validity
    if (!REGEX_USERNAME.match(username) ||
        username.find("  ") != null ||
        username.find("__") != null
    ) {
        // disable ability to login
        setPlayerAuthBlocked(playerid, true);

        // wait to load client chat and then display message
        return delayedFunction(2000, function() {
            // // clear chat
            for (local i = 0; i < 12; i++) {
                msg(playerid, "");
            }

            msg(playerid, "auth.wrongname", CL_WARNING);
            msg(playerid, "auth.changename");

            dbg("kick", "invalid unsername", getPlayerName(playerid));

            return delayedFunction(6000, function () {
                kickPlayer( playerid );
            });
        });
    }

    // maybe he is banned
    ORM.Query("select * from @Ban where serial = ':serial' and until > :current")
        .setParameter("serial", getPlayerSerial(playerid))
        .setParameter("current", getTimestamp())
        .getSingleResult(function(err, result) {
            if (result) {
                // disable ability to login
                setPlayerAuthBlocked(playerid, true);

                // wait to load client chat and then display message
                return delayedFunction(2000, function() {
                    // // clear chat
                    for (local i = 0; i < 12; i++) {
                        msg(playerid, "");
                    }

                    msg(playerid, "[SERVER] You are banned from the server for: " + result.reason, CL_RED);
                    msg(playerid, "[SERVER] Try connecting again later."    );

                    dbg("kick", "banned connected", getPlayerName(playerid));

                    return delayedFunction(6000, function () {
                        kickPlayer( playerid );
                    });
                });
            }

            Account.findOneBy({ username = username }, function(err, account) {
                // override player locale if registered
                if (account) {
                    setPlayerLocale(playerid, account.locale);
                    setPlayerLayout(playerid, account.layout, false);
                }

                if (getTimestamp() - getLastActiveSession(playerid) < AUTH_AUTOLOGIN_TIME) {
                    // update data
                    account.ip       = getPlayerIp(playerid);
                    account.serial   = getPlayerSerial(playerid);
                    account.logined  = getTimestamp();
                    account.save();

                    // save session
                    account.addSession(playerid);
                    setLastActiveSession(playerid);

                    // send message success
                    msg(playerid, "auth.success.autologin", CL_SUCCESS);
                    dbg("login", getAuthor(playerid), "autologin");
                    screenFadein(playerid, 250, function() {
                        trigger("onPlayerInit", playerid, getPlayerName(playerid), getPlayerIp(playerid), getPlayerSerial(playerid));
                    });

                    return;
                }

                msg(playerid, "---------------------------------------------", CL_SILVERSAND);
                msg(playerid, "auth.welcome", username);
                if (account) {
                    delayedFunction(1000, function() {trigger(playerid, "showAuthGUI");});
                    msg(playerid, "auth.registered");
                    msg(playerid, "*");
                    msg(playerid, "auth.command.login");
                } else {
                    delayedFunction(1000, function() {trigger(playerid, "showRegGUI");});
                    msg(playerid, "auth.notregistered");
                    msg(playerid, "*");
                    msg(playerid, "auth.command.register");
                    msg(playerid, "auth.command.regformat");
                }

                msg(playerid, "---------------------------------------------", CL_SILVERSAND);
            });
        });
});


/**
 * On player disconnects
 * we will clean up all his data
 */
event("onPlayerDisconnect", function(playerid, reason) {
    setPlayerAuthBlocked(playerid, false);
    if (!(playerid in accounts)) return;

    setLastActiveSession(playerid);

    // clean up data for GC
    accounts[playerid].clean();
    accounts[playerid] = null;

    delete baseData[playerid];
    delete accounts[playerid];
});

event("onPlayerAccountChanged", function(playerid) {
    if (!(playerid in accounts)) return;

    accounts[playerid].save();
});

event("onServerSecondChange", function() {
    if (getSecond() % 15) return; // each 15 seconds

    foreach (playerid, data in baseData) {
        if (isPlayerConnected(playerid) && !isPlayerLogined(playerid) && !isPlayerAuthBlocked(playerid)) {
            msg(playerid, "auth.notification");
        }
    }
});

/**
 * Cross resource handling
 */
addEventHandlerEx("__networkRequest", function(request) {
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
    local key = md5(getPlayerName(playerid) + "@" + getPlayerSerial(playerid));

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
    return sessions[md5(getPlayerName(playerid) + "@" + getPlayerSerial(playerid))] <- getTimestamp();
}


