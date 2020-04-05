include("controllers/auth/classes/Account.nut");

IS_AUTHORIZATION_ENABLED <- true;
AUTH_ACCOUNTS_LIMIT      <- 1;
AUTH_AUTOLOGIN_TIME      <- 900; // 15 minutes

local DEFAULT_SPAWN_PLACES = {
    greenfield = {
        position = [-1686.76,1092.44,1.35009],
        cam = [-1.0, -3.3, 1.9]
    }
}

const DEFAULT_SPAWN_PLACE = "greenfield";

const DEFAULT_SPAWN_SKIN = 1;
const DEFAULT_SPAWN_X    =  -479.234; // -143.0;  // 375.439;  // -568.042;  //-143.0;  //-1027.02;
const DEFAULT_SPAWN_Y    =  -689.805; //  1206.0; //  727.43;  // -28.7317;   //1206.0;  //1746.63;
const DEFAULT_SPAWN_Z    =  -18.9356; //  83.5;   //-4.09301;  //  22.2012;   //84.0;    //10.2325;

// little italy 364.219, 651.888,-4.052     1 0.45 1.7
// greenfield -1686.76,1092.44,1.35009    -1 -3.3 1.9



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
// local buffer = {};

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

    // Check if server is under construction
	if(getSettingsValue("isUnderConstruction") && !isPlayerServerAdmin(playerid)) {
        // wait to load client chat and then display message
        return delayedFunction(2000, function() {
            // clear chat
            for (local i = 0; i < 14; i++) {
                msg(playerid, "");
            }

            msg(playerid, "auth.under-construction1", CL_SUCCESS);
            msg(playerid, "auth.under-construction2");

            dbg("kick", "under construction", getIdentity(playerid));

            trigger(playerid, "onServerShowChatTrigger");

            return delayedFunction(20000, function () {
                kickPlayer( playerid );
            });
        });
	}

    introScreen(playerid)
});

event("onClientSuccessfulyStartedAgain", function(playerid) {
    authStart(playerid, "again")
});

function authStart(playerid, source = "first") {
    dbg("authStart: "+source)

    // if (playerid in buffer) delete buffer[playerid];

    local username = getPlayerName(playerid);

    // check playername validity
    if (!REGEX_USERNAME.match(username) ||
        username.find("  ") != null ||
        username.find("__") != null
    ) {

        // wait to load client chat and then display message
        return delayedFunction(2000, function() {
            // clear chat
            for (local i = 0; i < 14; i++) {
                msg(playerid, "");
            }

            msg(playerid, "auth.wrongname", CL_WARNING);
            msg(playerid, "auth.wrongname2", CL_GRAY);
            msg(playerid, "auth.changename");

            dbg("kick", "invalid unsername", getIdentity(playerid));

            trigger(playerid, "onServerShowChatTrigger");

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

                    trigger(playerid, "onServerShowChatTrigger");

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

                    dbg("trigger onPlayerInit")
                    trigger("onPlayerInit", playerid);
                    // trigger native game fadeout to fix possible black screen

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

                    // trigger native game fadeout to fix possible black screen
                    delayedFunction(calculateFPSDelay(playerid) + 2000, function() {
                        nativeScreenFadeout(playerid, 100);
                        screenFadeout(playerid, 250);
                    });

                    if (account) {
                        dbg("call showLoginGUI")
                        showLoginGUI(playerid, delay);
                    } else {
                        dbg("call showRegisterGUI")
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


/**
 * Define player spawns
 * @type {Array}
 */
local defaultPlayerSpawns = [
    [-555.251,  1702.31, -22.2408], // railway
    [-344.028, -952.702, -21.7457], // new port
];

/**
 * Handle player spawn event
 * Tirggers only for players which are already loaded (loaded character)
 */
function spawnPlayer(playerid) {
    dbg("spawnPlayer")
    if (!isPlayerLoaded(playerid)) {
        return setPlayerHealth(playerid, 720.0);
    }

    screenFadein(playerid, 2500);

    // draw default fadeout
    //screenFadeout(playerid, calculateFPSDelay(playerid) + 50000);

    // trigger native game fadeout to fix possible black screen
    delayedFunction(calculateFPSDelay(playerid) + 3000, function() {
        nativeScreenFadeout(playerid, 100);
        screenFadeout(playerid, 250);
    });

    // reset freeze and set default model
    freezePlayer(playerid, false);
    setPlayerModel(playerid, players[playerid].cskin);

    trigger("onPlayerSpawn", playerid);
    trigger("onPlayerSpawned", playerid);

    // set player position according to data
    setPlayerPosition(playerid, players[playerid].x, players[playerid].y, players[playerid].z);
    setPlayerHealth(playerid, players[playerid].health);

    // maybe player spawned not far from spawn
    local isPlayerNearSpawn = (5.0 > getDistanceBetweenPoints3D (
        players[playerid].x, players[playerid].y, players[playerid].z
        DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z
    ));

    // maybe position was not yet set or spanwed in 0, 0, 0
    if (players[playerid].getPosition().isNull() || isPlayerNearSpawn) {
        dbg("player", "spawn", getIdentity(playerid), "spawned on null or on spawn, warping to spawn...");

        // select random spawn
        local spawnID = random(0, defaultPlayerSpawns.len() - 1);

        local x = defaultPlayerSpawns[spawnID][0];
        local y = defaultPlayerSpawns[spawnID][1];
        local z = defaultPlayerSpawns[spawnID][2];

        setPlayerPosition(playerid, x, y, z);
        setPlayerHealth(playerid, 720.0);
    }

    // mark player as spawned
    // and available for saving coords
    players[playerid].spawned = true;
}



function introScreen(playerid) {
    screenFadein(playerid, 0);

    dbg(isPlayerAuthed(playerid))
    dbg(isPlayerLoaded(playerid))

    if(isPlayerAuthed(playerid)) {
        return spawnPlayer(playerid);
    }

    dbg("introScreen")
    authStart(playerid)


    // set player position and skin
    setPlayerPosition(playerid, DEFAULT_SPAWN_PLACES[DEFAULT_SPAWN_PLACE].position[0], DEFAULT_SPAWN_PLACES[DEFAULT_SPAWN_PLACE].position[1], DEFAULT_SPAWN_PLACES[DEFAULT_SPAWN_PLACE].position[2]);

    nativeSetPlayerModel(playerid, DEFAULT_SPAWN_SKIN);

    // disable hud and show
    trigger(playerid, "setPlayerIntroScreen",
        DEFAULT_SPAWN_PLACES[DEFAULT_SPAWN_PLACE].cam[0],
        DEFAULT_SPAWN_PLACES[DEFAULT_SPAWN_PLACE].cam[1],
        DEFAULT_SPAWN_PLACES[DEFAULT_SPAWN_PLACE].cam[2],
        getWeather()
    );

    togglePlayerHud(playerid, true);
    freezePlayer(playerid, true);
    triggerClientEvent(playerid, "hidePlayerModel");
}

/**
 * On player disconnects
 * we will clean up all his data
 */
event("onPlayerDisconnect", function(playerid, reason) {
    //if (playerid in buffer) {
    //    delete buffer[playerid];
    //}

    setPlayerMuted(playerid, false);
    if (!isPlayerAuthed(playerid)) return;

    setLastActiveSession(playerid);
    // destroyAuthData(playerid);
});

event("onPlayerAccountChanged", function(playerid) {
    if (!isPlayerAuthed(playerid)) return;

    getAccount(playerid).save();
});




//event("onPlayerConnectInit", function(playerid, username, ip, serial) {
//    buffer[playerid] <- getTimestamp();
//    dbg(buffer)
//});
/*
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
*/
