include("controllers/auth/classes/Account.nut");

IS_AUTHORIZATION_ENABLED <- true;
AUTH_ACCOUNTS_LIMIT      <- 1;
AUTH_AUTOLOGIN_TIME      <- 900; // 15 minutes

const DEFAULT_SPAWN_SKIN = 4;
const DEFAULT_SPAWN_X    =  -479.234; // -143.0;  // 375.439;  // -568.042;  //-143.0;  //-1027.02;
const DEFAULT_SPAWN_Y    =  -689.805; //  1206.0; //  727.43;  // -28.7317;   //1206.0;  //1746.63;
const DEFAULT_SPAWN_Z    =  -18.9356; //  83.5;   //-4.09301;  //  22.2012;   //84.0;    //10.2325;

// Roof in Uptown
//-762.8;
// 722.5;
//  4.15;

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


/**
 * On player connects we will
 * check his nickname for validity
 * and then we will show him
 * screen with different text
 * depending if he is logined or not
 */
event("onClientSuccessfulyStarted", function(playerid) {
    authStart(playerid)
});

event("onClientSuccessfulyStartedAgain", function(playerid) {
    authStart(playerid, "again")
});

function authStart(playerid, source = "first") {

    if (playerid in buffer) delete buffer[playerid];

    local username = getPlayerName(playerid);

    // check playername validity
    if (!REGEX_USERNAME.match(username) ||
        username.find("  ") != null ||
        username.find("__") != null
    ) {

        // wait to load client chat and then display message
        return delayedFunction(2000, function() {
            // // clear chat
            for (local i = 0; i < 14; i++) {
                msg(playerid, "");
            }

            msg(playerid, "auth.wrongname", CL_WARNING);
            msg(playerid, "auth.wrongname2", CL_GRAY);
            msg(playerid, "auth.changename");

            dbg("kick", "invalid unsername", getIdentity(playerid));

            trigger(playerid, "onServerChatTrigger");

            return delayedFunction(20000, function () {
                kickPlayer( playerid );
            });
        });
    }

    // maybe he is banned
    ORM.Query("select * from @Ban where (serial = :serial or name = :name) and until > :current")
        .setParameter("serial", getPlayerSerial(playerid))
        .setParameter("name", getAccountName(playerid))
        .setParameter("current", getTimestamp())
        .getSingleResult(function(err, result) {
            /**
             * Account is banned!
             * Applying actions
             */
            if (result) {

                // wait to load client chat and then display message
                return delayedFunction(2000, function() {
                    // clear chat
                    for (local i = 0; i < 12; i++) {
                        msg(playerid, "");
                    }

                    trigger(playerid, "onServerChatTrigger");

                    msg(playerid, "Вы забанены!", CL_RED);
                    msg(playerid, "Причина: " + result.reason, CL_RED);
                    msg(playerid, "Дата окончания: " + epochToHuman(result.until).format("d.m.Y H:i:s") + " по Москве", CL_RED);
                    msg(playerid, "Попробуйте подключиться после даты окончания бана.");

                    dbg("kick", "banned connected", getIdentity(playerid));

                    return delayedFunction(20000, function () {
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

                ORM.Query("select * from @Mute where serial = :serial and until > :current")
                    .setParameter("serial", getPlayerSerial(playerid))
                    .setParameter("current", getTimestamp())
                    .getSingleResult(function(err, result) {
                        /**
                         * Account is muted!
                         * Applying actions
                         */
                        if (result) {
                            setPlayerMuted(playerid, {
                                amount = result.amount,
                                until = result.until,
                                created = result.created,
                                reason = result.reason
                            });
                        }
                });

                /**
                 * Maybe we shoudl apply autologin ?
                 */
                if (account && getTimestamp() - getLastActiveSession(playerid) < AUTH_AUTOLOGIN_TIME) {
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
                    printStartedTips(playerid);
                    return;
                }

                if (DEBUG) {
                    return dbg("skipping auth forms for debug mode");
                }

                /**
                 * Or just show the forms
                 * for login or registration
                 */
                if (username == "Player") {
                    showBadPlayerNicknameGUI(playerid);
                } else {
                    local delay = source == "first" ? 2500 : 0;

                    if (account) {
                        showLoginGUI(playerid, delay);
                    } else {
                        showRegisterGUI(playerid, delay);
                    }
                    msg(playerid, "Что-то пошло не так :(", CL_RED);
                    msg(playerid, "Попробуйте переподключиться к серверу.", CL_SILVERSAND);
                    msg(playerid, "Если данная проблема повторяется более 5 раз - напишите нам:", CL_SILVERSAND);
                    msg(playerid, "VK: vk.com/m2ncrp", CL_SILVERSAND);
                    msg(playerid, "Discord: bit.ly/m2ncrp", CL_SILVERSAND);
                }
            });
        });
}

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
            msg(playerid, "auth.client.notloaded1", CL_SUCCESS);
            msg(playerid, "auth.client.notloaded2");
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
    freezePlayer(playerid, true);
});

/**
 * On player disconnects
 * we will clean up all his data
 */
event("onPlayerDisconnect", function(playerid, reason) {
    if (playerid in buffer) {
        delete buffer[playerid];
    }

    setPlayerMuted(playerid, false);
    if (!isPlayerAuthed(playerid)) return;

    setLastActiveSession(playerid);
    destroyAuthData(playerid);
});

event("onPlayerAccountChanged", function(playerid) {
    if (!isPlayerAuthed(playerid)) return;

    getPlayerSession(playerid).save();
});
