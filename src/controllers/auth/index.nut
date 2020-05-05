include("controllers/auth/classes/Account.nut");

IS_AUTHORIZATION_ENABLED <- true;
AUTH_AUTOLOGIN_TIME      <- 900; // 15 minutes
AUTH_ACCOUNTS_LIMIT      <- 1;

/**
 * Compiled regex object for
 * validation of usernames
 * @type {Object}
 */
local REGEX_USERNAME = regexp("[A-Za-z0-9_ ]{3,64}");

// includes
include("controllers/auth/events.nut");
include("controllers/auth/accounts.nut");
include("controllers/auth/functions.nut");
include("controllers/auth/sessions.nut");
include("controllers/auth/data-names.nut");

/*
Авторизация и регистрация
1. Запускаем интро для скрытия элементов интерфейса
2. Определяем, доступен ли сервер (не находится ли он на техническом перерыве).
3. Определяем валидноть логина
4. Определяем, не забанен ли игрок, проверкой сериала и отдельно логина.

5. Определяем, надо ли показывать окна, или делать автологин (это проверяем по объекту сессий, сессия это 'логин@сериал = время создания сессии'). Если разница между текущим временем и временем создания сессии меньше 15 минут - делаем автологин. То есть вызываем событие onPlayerInit
6. Определяем нет ли мута
7. Если надо показывать окна - запускаем интро, которое устанавливает параметры отображения. Делаем запрос в базу, определяя существует ли аккаунт или логин свободен для регистрации. Показываем нужное окно.
*/
event("onClientSuccessfulyStarted", function(playerid) {
    // 1. Set ui settings (hide ui elements, skin, set camera rotation)
    trigger(playerid, "setWeather",
        getWeather()
    );

    // 2. Check if server is under construction
	if(getSettingsValue("isUnderConstruction") && !isPlayerServerAdmin(playerid)) {
        introUISetter(playerid);
        introPlayerSetter(playerid);
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

    // 3. Detect username valid

    local username = getAccountName(playerid);

    // check playername validity
    if (!REGEX_USERNAME.match(username) ||
        username.find("  ") != null ||
        username.find("__") != null
    ) {
        introUISetter(playerid);
        introPlayerSetter(playerid);
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

    // 4. Detect player banned
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
                introUISetter(playerid);
                introPlayerSetter(playerid);
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

                if (account) {
                    setAccountIsExist(username, true);

                    if (account.disabled) {
                        introUISetter(playerid);
                        introPlayerSetter(playerid);
                        // wait to load client chat and then display message
                        return delayedFunction(2000, function() {
                            // clear chat
                            for (local i = 0; i < 12; i++) {
                                msg(playerid, "");
                            }

                            trigger(playerid, "onServerShowChatTrigger");

                            msg(playerid, "Данный аккаунт отключен!", CL_RED);
                            msg(playerid, "Для выяснения подробностей свяжитесь с администрацией сервера");

                            dbg("kick", "banned connected", getIdentity(playerid));

                            return delayedFunction(20000, function () {
                                kickPlayer( playerid );
                            });
                        });
                    }

                    ORM.Query("select * from @Mute where (serial = :serial or name = :name) and until > :current")
                        .setParameter("serial", getPlayerSerial(playerid))
                        .setParameter("name", getAccountName(playerid))
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
                    * Maybe we should apply autologin ?
                    */
                    if (getTimestamp() - getLastActiveSession(playerid) < AUTH_AUTOLOGIN_TIME) {
                        // update data
                        account.ip       = getPlayerIp(username);
                        account.serial   = getPlayerSerial(playerid);
                        account.logined  = getTimestamp();
                        account.save();

                        // save session
                        addAccount(username, account);
                        setLastActiveSession(playerid);

                        // send message success
                        dbg("login", getIdentity(playerid), "autologin");

                        trigger("onPlayerInit", playerid);

                        msg(playerid, "auth.success.autologin", CL_SUCCESS);

                        printStartedTips(playerid);
                        return;
                    }

                }

                delayedFunction(calculateFPSDelay(playerid) + 2000,function() {
                    nativeScreenFadeout(playerid, 100);
                    screenFadeout(playerid, 250);
                });

                if (DEBUG) {
                    return dbg("skipping auth forms for debug mode");
                }

                delayedFunction(1000, function() {
                    introUISetter(playerid);
                    introPlayerSetter(playerid);
                });
                showIdentificationGui(playerid, 2000);



            });
        });
});

function showIdentificationGui(playerid, delay = 2000) {
    local username = getAccountName(playerid);

    if (username == "Player") {
        showBadPlayerNicknameGUI(playerid);
    } else {

        local accountData = getAccountData(username);

        if(accountData.exist) {
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
}

function introUISetter(playerid) {
    screenFadein(playerid, 0);

    local defaultSpawn = getDefaultSpawn();

    // disable hud and show
    trigger(playerid, "setPlayerIntroScreen",
        defaultSpawn.cam[0],
        defaultSpawn.cam[1],
        defaultSpawn.cam[2]
    );

    togglePlayerHud(playerid, true);
    freezePlayer(playerid, true);
    triggerClientEvent(playerid, "hidePlayerModel");
}

function introPlayerSetter(playerid) {
    local defaultSpawn = getDefaultSpawn();
    // set player position and skin
    setPlayerPosition(playerid, defaultSpawn.position[0], defaultSpawn.position[1], defaultSpawn.position[2]);
}