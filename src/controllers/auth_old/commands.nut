/**
 * Command allows players to register
 * using their current username and specified password
 */
function registerFunc(playerid, password, email = null) {

    if (!email) {
        return msg(playerid, "Error: email is empty");
    }

    // create account
    local account = Account();

    account.username = getAccountName(playerid);
    account.password = md5(password);
    account.ip       = getPlayerIp(playerid);
    account.serial   = getPlayerSerial(playerid);
    account.locale   = getPlayerLocale(playerid);
    account.created  = getTimestamp();
    account.logined  = getTimestamp();
    account.email    = email.tostring();

    Account.findOneBy({ email = account.email}, function(err, result) {
        if(result){
            return trigger(playerid, "authErrorMessage", plocalize(playerid, "auth.error.email"));
        }
        else {
            Account.findOneBy({ username = account.username }, function(err, result) {
                if (result) {
                    trigger(playerid, "authErrorMessage", plocalize(playerid, "auth.error.register"));
                    //msg(playerid, "auth.error.register", CL_ERROR);
                } else {
                    ORM.Query("select count(*) cnt from @Account where serial like :serial")
                    .setParameter("serial", getPlayerSerial(playerid))
                    .getSingleResult(function(err, result) {
                        // no more than N accounts
                        if (result.cnt >= AUTH_ACCOUNTS_LIMIT) {
                            trigger(playerid, "authErrorMessage", plocalize(playerid, "auth.error.tomany"));
                            //msg(playerid, "auth.error.tomany", CL_ERROR);
                            return;
                        }

                        account.save(function(err, result) {
                            dbg(account)
                            addAccount(account.id, account);
                            setLastActiveSession(playerid);

                            // send success registration message
                            msg(playerid, "auth.success.register", CL_SUCCESS);
                            printStartedTips(playerid);
                            dbg("registration", getIdentity(playerid));
                            trigger(playerid, "destroyAuthGUI");

                            screenFadein(playerid, 500, function() {
                                trigger("onPlayerInit", playerid);
                            });
                        });
                    });
                }
            });
        }
    });

}

addEventHandler("registerGUIFunction",registerFunc);

/**
 * Command allows players to login
 * using their current username and specified password
 */
addEventHandler("loginGUIFunction", function(playerid, password) {
    if (isPlayerAuthed(playerid)) {
        trigger(playerid, "authErrorMessage", plocalize(playerid, "auth.error.login"));
        //msg(playerid, "auth.error.login", CL_ERROR);
        return;
    }

    // try to find logined account
    Account.findOneBy({
        username = getAccountName(playerid),
        password = md5(password)
    }, function(err, account) {
        // no accounts found
        if (!account){
            trigger(playerid, "authErrorMessage", plocalize(playerid, "auth.GUI.error.notfound"));
            //msg(playerid, "auth.error.notfound", CL_ERROR);
            return ;
        }

        // update data
        account.ip       = getPlayerIp(playerid);
        account.serial   = getPlayerSerial(playerid);
        account.logined  = getTimestamp();
        account.locale   = getPlayerLocale(playerid);
        account.save();

        // save session
        addAccount(account.id, account);
        setLastActiveSession(playerid);

        // send message success
        msg(playerid, "auth.success.login", CL_SUCCESS);
        printStartedTips(playerid);

        dbg("login", getIdentity(playerid));
        trigger(playerid, "destroyAuthGUI");

        screenFadein(playerid, 250, function() {
            trigger("onPlayerInit", playerid);
        });
    });
});


function printStartedTips (playerid) {
        // send message success
        msg(playerid, "");
        msg(playerid, "hello.1", CL_LIGHTGRAY);
        msg(playerid, "hello.2", CL_CASCADE);
        msg(playerid, "hello.3", CL_LIGHTGRAY);
        msg(playerid, "hello.4", CL_CASCADE);
        msg(playerid, "hello.5", CL_LIGHTGRAY);
        msg(playerid, "hello.6", CL_CASCADE);
        msg(playerid, "");
        msg(playerid, "hello.end", CL_SUCCESS);
        msg(playerid, "");
}
