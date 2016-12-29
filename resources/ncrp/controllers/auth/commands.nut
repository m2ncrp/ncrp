/**
 * Command allows players to register
 * using their current username and specified password
 */
function registerFunc(playerid, password, email = null) {
    if (isPlayerAuthBlocked(playerid)) {
        return;
    }

    if (!email) {
        return msg(playerid, "please use /register PASSWORD EMAIL to register");
    }

    Account.getSession(playerid, function(err, account) {
        // if player is logined
        if (account) return msg(playerid, "auth.error.login", CL_ERROR);

        // create account
        account = Account();
        account.username = getPlayerName(playerid);
        account.password = md5(password);
        account.ip       = getPlayerIp(playerid);
        account.serial   = getPlayerSerial(playerid);
        account.locale   = getPlayerLocale(playerid);
        account.created  = getTimestamp();
        account.logined  = getTimestamp();
        account.email    = email.tostring();

        Account.findOneBy({ username = account.username }, function(err, result) {
            if (result) {
                msg(playerid, "auth.error.register", CL_ERROR);
            } else {
                ORM.Query("select count(*) cnt from @Account where serial like ':serial'")
                .setParameter("serial", getPlayerSerial(playerid))
                .getSingleResult(function(err, result) {
                    // no more than N accounts
                    if (result.cnt >= AUTH_ACCOUNTS_LIMIT) {
                        return msg(playerid, "auth.error.tomany", CL_ERROR);
                    }

                    account.save(function(err, result) {
                        account.addSession(playerid);
                        setLastActiveSession(playerid);

                        // send success registration message
                        msg(playerid, "auth.success.register", CL_SUCCESS);
                        dbg("registration", getAuthor(playerid));
                        trigger(playerid, "destroyAuthGUI");

                        screenFadein(playerid, 250, function() {
                            trigger("onPlayerInit", playerid, getPlayerName(playerid), getPlayerIp(playerid), getPlayerSerial(playerid));
                        });
                    });
                });
            }
        });
    });
}

simplecmd("register", registerFunc); // removed, doesn't work with field email
addEventHandler("registerGUIFunction",registerFunc);

/**
 * Command allows players to login
 * using their current username and specified password
 */
function loginFunc(playerid, password) {
    if (isPlayerAuthBlocked(playerid)) {
        return;
    }

    Account.getSession(playerid, function(err, account) {
        // if player is logined
        if (account) {
            return msg(playerid, "auth.error.login", CL_ERROR);
        }

        // try to find logined account
        Account.findOneBy({
            username = getPlayerName(playerid),
            password = md5(password)
        }, function(err, account) {
            // no accounts found
            if (!account) return msg(playerid, "auth.error.notfound", CL_ERROR);

            // update data
            account.ip       = getPlayerIp(playerid);
            account.serial   = getPlayerSerial(playerid);
            account.logined  = getTimestamp();
            account.save();

            // save session
            account.addSession(playerid);
            setLastActiveSession(playerid);

            // send message success
            msg(playerid, "auth.success.login", CL_SUCCESS);
            dbg("login", getAuthor(playerid));
            trigger(playerid, "destroyAuthGUI");

            screenFadein(playerid, 250, function() {
                trigger("onPlayerInit", playerid, getPlayerName(playerid), getPlayerIp(playerid), getPlayerSerial(playerid));
            });
        });
    });
}

simplecmd("login", loginFunc);
addEventHandler("loginGUIFunction",loginFunc);
