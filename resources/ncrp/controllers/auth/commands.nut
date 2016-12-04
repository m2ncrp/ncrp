/**
 * Command allows players to register
 * using their current username and specified password
 *
 * TODO: add check for existing
 */
simplecmd("register", function(playerid, password) {
    Account.getSession(playerid, function(err, account) {
        // if player is logined
        if (account) return msg(playerid, "auth.error.login", CL_ERROR);

        // create account
        account = Account();
        account.username = getPlayerName(playerid);
        account.password = md5(password);
        account.ip       = getPlayerIp(playerid);
        account.serial   = getPlayerSerial(playerid);

        Account.findOneBy({ username = account.username }, function(err, result) {
            if (result) {
                msg(playerid, "auth.error.register", CL_ERROR);
            } else {
                account.save(function(err, result) {
                    account.addSession(playerid);
                    msg(playerid, "auth.success.register", CL_SUCCESS);
                    screenFadein(playerid, 250, function() {
                        trigger("onPlayerInit", playerid, getPlayerName(playerid), getPlayerIp(playerid), getPlayerSerial(playerid));
                    });
                });
            }
        });

    });
});

/**
 * Command allows players to login
 * using their current username and specified password
 */
simplecmd("login", function(playerid, password) {
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
            account.ip     = getPlayerIp(playerid);
            account.serial = getPlayerSerial(playerid);
            account.save();

            // save session
            account.addSession(playerid);
            msg(playerid, "auth.success.login", CL_SUCCESS);
            screenFadein(playerid, 250, function() {
                trigger("onPlayerInit", playerid, getPlayerName(playerid), getPlayerIp(playerid), getPlayerSerial(playerid));
            });
        });
    });
});
