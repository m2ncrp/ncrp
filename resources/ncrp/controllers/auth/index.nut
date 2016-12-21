// includes
include("controllers/auth/commands.nut");

IS_AUTHORIZATION_ENABLED <- true;
AUTH_ACCOUNTS_LIMIT <- 2;

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
    "auth.error.cmderror"   : "[AUTH] You can't execute commands without registration."
    "auth.notification"     : "[AUTH] You should enter into your account via /login PASSWORD, or create new one via /register PASSWORD"
    "auth.error.tomany"     : "[AUTH] You cant register more accounts."
});


/**
 * Compiled regex object for
 * validation of usernames
 * @type {Object}
 */
local REGEX_USERNAME = regexp("[A-Za-z0-9_ ]{4,64}")

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
        locale = "en"
    };

    // disable for a while
    if (!REGEX_USERNAME.match(username) || username.find("  ") != null || username.find("__") != null) {
        return delayedFunction(2000, function() {
            // // clear chat
            for (local i = 0; i < 12; i++) {
                msg(playerid, "");
            }

            msg(playerid, "auth.wrongname", CL_WARNING);
            msg(playerid, "auth.changename");

            dbg("kick", "invalid unsername", getPlayerName(playerid));

            return delayedFunction(5000, function () {
                kickPlayer( playerid );
            });
        })
    }

    Account.findOneBy({ username = username }, function(err, account) {
        // override player locale if registered
        if (account) {
            setPlayerLocale(playerid, account.locale);
            setPlayerLayout(playerid, account.layout, false);
        }

        msg(playerid, "---------------------------------------------", CL_SILVERSAND);
        msg(playerid, "auth.welcome", username);

        if (account) {
            msg(playerid, "auth.registered");
            msg(playerid, "*");
            msg(playerid, "auth.command.login");
        } else {
            msg(playerid, "auth.notregistered");
            msg(playerid, "*");
            msg(playerid, "auth.command.register");
            msg(playerid, "auth.command.regformat");
        }

        msg(playerid, "---------------------------------------------", CL_SILVERSAND);
    });
});

/**
 * On player disconnects
 * we will clean up all his data
 */
event("onPlayerDisconnect", function(playerid, reason) {
    if (!(playerid in accounts)) return;

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
        if (isPlayerConnected(playerid) && !isPlayerLogined(playerid)) {
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

    return "en";
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
