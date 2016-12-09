// includes
include("controllers/auth/commands.nut");

IS_AUTHORIZATION_ENABLED <- true;

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

local bannedNames = [
    "Joe_Barbaro",
    "Joe_Barbero",
    "Joe_Barbera",
    "Joe_Barbara",
    "Vito_Scaletta",
    "Vito_Scaletto",
    "Vito_Scaleto",
    "Vito_Scaleta",
    "Vito_Skaletta",
    "Vito_Skaletto",
    "Vito_Skaleto",
    "Vito_Skaleta",
    "Vitorio_Scaletta",
    "Vitorio_Scaletto",
    "Vittorio_Scaletta",
    "Vittorio_Scaletto",
    "Frank_Vinci",
    "Frank_Vinchi",
    "Leo_Galante",
    "Leo_Galanta",
    "Leo_Galanto",
    "Derek_Pappalardo",
    "Derek_Papalardo",
    "Luca_Gurino",
    "Luka_Gurino",
    "Brian_O'Neill",
    "Brian_ONeill",
    "Brian_O'Nill",
    "Brian_ONill",
    "Tommy_Angelo",
    "Tommy_Angela",
    "Tomas_Angelo",
    "Tomas_Angela",
    "Tom_Angelo",
    "Tom_Angela",
    "Richard_Beck",
    "Mike_Bruski",
    "Frankie_Potts",
    "Henry_Tomasino",
    "Henry_Tomasina",
    "Henry_Tamasina",
    "Genry_Tamasina",
    "Genry_Tomasino",
    "Genry_Tomasina",
    "Carlo_Falcone",
    "Carlo_Falkone",
    "Carlo_Folcone",
    "Carlo_Folkone",
    "Alberto_Clemente",
];

translation("en", {
    "auth.wrongname"        : "Sorry, your name should be original (not from the game) and have Firstname_Lastname format."
    "auth.changename"       : "Please, change you name in the settings, and reconnect. Thank you!"
    "auth.welcome"          : "* Welcome there, %s!"
    "auth.registered"       : "* Your account is registered."
    "auth.notregistered"    : "* Your account is not registered."
    "auth.command.register" : "* Please register using /register PASSWORD"
    "auth.command.regformat": "* Example: Joe_Barbaro"
    "auth.command.login"    : "* Please enter using /login PASSWORD"
    "auth.error.logined"    : "[AUTH] You are already logined!"
    "auth.error.register"   : "[AUTH] Account with this name is already registered!"
    "auth.error.notfound"   : "[AUTH] This account is not registered"
    "auth.success.register" : "[AUTH] You've successfuly registered!"
    "auth.success.login"    : "[AUTH] You've successfuly logined!"
    "auth.error.cmderror"   : "[AUTH] You can't execute commands without registration."
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
        serial = serial,
        locale = "en"
    };

    // disable for a while
    // if (!REGEX_USERNAME.match(username) && bannedNames.find(username) != null && username != "Inlife") {
    //     // return kickPlayer(playerid);
    //     msg(playerid, "auth.wrongname", CL_WARNING);
    //     msg(playerid, "auth.changename");
    //     return;
    // }

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
