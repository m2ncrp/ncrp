event("onPlayerConnectInit", function(playerid, username, ip, serial) {
    // save base data
    addAccountData(username, {
        playerid = playerid,
        username = username,
        ip = ip,
        serial = serial,
        locale = "ru",
        exist = false
    });
});

event("onPlayerDisconnect", function(playerid, reason) {
    setPlayerMuted(playerid, false);
    if (!isPlayerAuthed(playerid)) return;

    setLastActiveSession(playerid);
});

event("changeModel",function(playerid, model) {
    nativeSetPlayerModel( playerid, model.tointeger() );
});


event("registerGUIFunction", function (playerid, password, email = null) {

    if (!email) {
        return msg(playerid, "Error: email is empty");
    }

		local username = getAccountName(playerid);

    // create account
    local account = Account();

    account.username = getAccountName(playerid);
    account.password = md5(password);
    account.ip       = getPlayerIp(username);
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

                        local username = getAccountName(playerid);

                        account.save(function(err, result) {
                            dbg(account)
                            addAccount(username, account);
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
});

event("loginGUIFunction", function(playerid, password) {

    local username = getAccountName(playerid);

    // try to find logined account
    Account.findOneBy({
        username = username,
        password = md5(password)
    }, function(err, account) {
        // no accounts found
        if (!account){
            trigger(playerid, "authErrorMessage", plocalize(playerid, "auth.GUI.error.notfound"));
            //msg(playerid, "auth.error.notfound", CL_ERROR);
            return ;
        }

        // update data
        account.ip       = getPlayerIp(username);
        account.serial   = getPlayerSerial(playerid);
        account.logined  = getTimestamp();
        account.locale   = getPlayerLocale(playerid);
        account.save();

        // save session
        addAccount(username, account);
        setLastActiveSession(playerid);

        // send message success
        printStartedTips(playerid);

        dbg("login", getIdentity(playerid));
        trigger(playerid, "destroyAuthGUI");

        screenFadein(playerid, 250, function() {
            trigger("onPlayerInit", playerid);
        });
    });
});

event("onPlayerLanguageChange", function(playerid, locale) {
    local lwindow    = localize("auth.GUI.TitleLogin", [], locale);
    local llabel     = localize("auth.GUI.TitleLabelLogin", [ getPlayerName(playerid) ], locale);
    local linput     = localize("auth.GUI.TitleInputLogin", [], locale);
    local lbutton    = localize("auth.GUI.ButtonLogin", [], locale);
    local rwindow    = localize("auth.GUI.TitleRegister", [], locale);
    local rlabel     = localize("auth.GUI.TitleLabelRegister", [], locale);
    local rinputp    = localize("auth.GUI.PasswordInput", [], locale);
    local rinputrp   = localize("auth.GUI.RepeatPasswordInput", [], locale);
    local riptemail  = localize("auth.GUI.Email", [], locale);
    local rbutton    = localize("auth.GUI.ButtonRegister", [], locale);
    local helpText   = localize("auth.haveproblems", [], locale);
    local forgotText = localize("auth.forgot", [], locale);
    trigger(playerid, "changeAuthLanguage", lwindow, llabel, linput, lbutton, rwindow, rlabel, rinputp, rinputrp, riptemail, rbutton, helpText, forgotText);
});