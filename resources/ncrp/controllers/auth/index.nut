include("controllers/auth/classes/Account.nut");

IS_AUTHORIZATION_ENABLED <- true;
AUTH_ACCOUNTS_LIMIT      <- 2;
AUTH_AUTOLOGIN_TIME      <- 900; // 15 minutes

const DEFAULT_SPAWN_SKIN = 4;
const DEFAULT_SPAWN_X    = -762.8;//-143.0;  //-1027.02;
const DEFAULT_SPAWN_Y    = 722.5;//1206.0;  //1746.63;
const DEFAULT_SPAWN_Z    = 4.15;//84.0;    //10.2325;

/**
 * Compiled regex object for
 * validation of usernames
 * @type {Object}
 */
local REGEX_USERNAME = regexp("[A-Za-z0-9_ ]{3,64}");
local buffer = {};

// includes
include("controllers/auth/functions.nut");
include("controllers/auth/commands.nut");

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
    "auth.client.notloaded" : "Seems like your client scripts were not properly loaded. Try reconnecting!"
});

/**
 * On player connects we will
 * check his nickname for validity
 * and then we will show him
 * screen with different text
 * depending if he is logined or not
 */
event("onClientSuccessfulyStarted", function(playerid) {
    if (playerid in buffer) delete buffer[playerid];

    local username = getPlayerName(playerid);

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
            for (local i = 0; i < 14; i++) {
                msg(playerid, "");
            }

            msg(playerid, "auth.wrongname", CL_WARNING);
            msg(playerid, "auth.changename");

            dbg("kick", "invalid unsername", getIdentity(playerid));

            return delayedFunction(12000, function () {
                kickPlayer( playerid );
            });
        });
    }

    // maybe he is banned
    ORM.Query("select * from @Ban where serial = :serial and until > :current")
        .setParameter("serial", getPlayerSerial(playerid))
        .setParameter("current", getTimestamp())
        .getSingleResult(function(err, result) {

            /**
             * Account is banned!
             * Applying actions
             */
            if (result) {
                // disable ability to login
                setPlayerAuthBlocked(playerid, true);

                // wait to load client chat and then display message
                return delayedFunction(2000, function() {
                    // clear chat
                    for (local i = 0; i < 14; i++) {
                        msg(playerid, "");
                    }

                    msg(playerid, "[SERVER] You are banned from the server for: " + result.reason, CL_RED);
                    msg(playerid, "[SERVER] Try connecting again later."    );

                    dbg("kick", "banned connected", getIdentity(playerid));

                    return delayedFunction(6000, function () {
                        kickPlayer( playerid );
                    });
                });
            }

            /**
             * Seems like account is not banned
             * Now we are trying to find account
             * to show login form or show registration form
             */
            Account.findOneBy({ username = username }, function(err, account) {
                // override player locale if registered
                if (account) {
                    setPlayerLocale(playerid, account.locale);
                    setPlayerLayout(playerid, account.layout, false);
                }

                /**
                 * Maybe we shoudl apply autologin ?
                 */
                if (getTimestamp() - getLastActiveSession(playerid) < AUTH_AUTOLOGIN_TIME) {
                    // update data
                    account.ip       = getPlayerIp(playerid);
                    account.serial   = getPlayerSerial(playerid);
                    account.logined  = getTimestamp();
                    account.save();

                    // save session
                    addAccount(playerid, account);
                    setLastActiveSession(playerid);

                    // send message success
                    dbg("login", getIdentity(playerid), "autologin");

                    screenFadein(playerid, 250, function() {
                        trigger("onPlayerInit", playerid);
                    });

                    msg(playerid, "auth.success.autologin", CL_SUCCESS);

                    return;
                }

                if (DEBUG) {
                    return dbg("skipping auth forms for debug mode");
                }

                /**
                 * Or just show the forms
                 * for login or registration
                 */
                msg(playerid, "---------------------------------------------", CL_SILVERSAND);
                msg(playerid, "auth.welcome", username);

                if (account) {
                    showLoginGUI(playerid);
                    msg(playerid, "auth.registered");
                    msg(playerid, "*");
                    msg(playerid, "auth.command.login");
                } else {
                    showRegisterGUI(playerid);
                    msg(playerid, "auth.notregistered");
                    msg(playerid, "*");
                    msg(playerid, "auth.command.register");
                    msg(playerid, "auth.command.regformat");
                }

                msg(playerid, "---------------------------------------------", CL_SILVERSAND);
            });
        });
});

event("onPlayerConnectInit", function(playerid, username, ip, serial) {
    buffer[playerid] <- getTimestamp();
});

event("onServerSecondChange", function() {
    foreach (playerid, value in buffer) {
        if (!isPlayerConnected(playerid) || !buffer[playerid]) {
            buffer[playerid] = null;
            continue;
        }

        if (getTimestamp() - buffer[playerid] > 10) {
            msg(playerid, "auth.client.notloaded", CL_ERROR);
            dbg("player", "clientscripts", getIdentity(playerid));
            buffer[playerid] <- getTimestamp();
        }
    }
});

/**
 * Listen spawn event
 * and spawn for non-authed players
 */
event("native:onPlayerSpawn", function(playerid) {
    if (isPlayerAuthed(playerid)) return;

    // togglePlayerControls(playerid, true);

    // set player position and skin
    setPlayerPosition(playerid, DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z);
    nativeSetPlayerModel(playerid, DEFAULT_SPAWN_SKIN);

    // disable hud and show
    trigger(playerid, "setPlayerIntroScreen");
    togglePlayerHud(playerid, true);
});

/**
 * On player disconnects
 * we will clean up all his data
 */
event("onPlayerDisconnect", function(playerid, reason) {
    if (playerid in buffer) {
        delete buffer[playerid];
    }

    setPlayerAuthBlocked(playerid, false);
    if (!isPlayerAuthed(playerid)) return;

    setLastActiveSession(playerid);
    destroyAuthData(playerid);
});

event("onPlayerAccountChanged", function(playerid) {
    if (!isPlayerAuthed(playerid)) return;

    getPlayerSession(playerid).save();
});

// event("onServerSecondChange", function() {
//     if (getSecond() % 15) return; // each 15 seconds

//     foreach (playerid, data in baseData) {
//         if (isPlayerConnected(playerid) && !isPlayerLogined(playerid) && !isPlayerAuthBlocked(playerid)) {
//             msg(playerid, "auth.notification");
//         }
//     }
// });
