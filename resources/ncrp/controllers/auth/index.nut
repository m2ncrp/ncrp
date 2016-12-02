// includes
include("controllers/auth/commands.nut");

IS_AUTHORIZATION_ENABLED <- false;

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
    "auth.wrongname"        : "Sorry, your name should be in Firstname_Lastname format."
    "auth.changename"       : "Please, change you name in the settings, and reconnect. Thank you!"
    "auth.welcome"          : "* Welcome there, %s!"
    "auth.registered"       : "* Your account is registered"
    "auth.notregistered"    : "* Your account is not registered"
    "auth.command.register" : "* Please register using /register [password]"
    "auth.command.regformat": "* Example: Joe_Barbaro"
    "auth.command.login"    : "* Please enter using /login [password]"
    "auth.error.logined"    : "[AUTH] You are already logined!"
    "auth.error.register"   : "[AUTH] Account with this name is already registered!"
    "auth.error.notfound"   : "[AUTH] This account is not registered"
    "auth.success.register" : "[AUTH] You've successfuly registered!"
    "auth.success.login"    : "[AUTH] You've successfuly logined!"
    "auth.error.cmderror"   : "[AUTH] You cant execute commands without registration"
});

/**
 * Compiled regex object for
 * validation of usernames
 * @type {Object}
 */
local REGEX_USERNAME = regexp("([A-Za-z0-9]{1,32}_[A-Za-z0-9]{1,32})")

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
        serial = serial
    };

    // disable for a while
    if (!REGEX_USERNAME.match(username) && username != "Inlife") {
        // return kickPlayer(playerid);
        msg(playerid, "auth.wrongname", CL_WARNING);
        msg(playerid, "auth.changename");
        return;
    }

    Account.findOneBy({ username = username }, function(err, account) {
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

function getPlayerIp(playerid) {
    return baseData[playerid];
}
