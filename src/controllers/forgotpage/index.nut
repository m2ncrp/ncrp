include("controllers/auth/classes/Account.nut");

alternativeTranslate({
    "en|auth.forgot"           : "I forgot my login/password"
    "ru|auth.forgot"           : "Я забыл логин/пароль"

    "en|auth.forgot.found"     : "Your login: %s"
    "ru|auth.forgot.found"     : "Ваш логин: %s"

    "en|auth.forgot.notfound"  : "Account not found"
    "ru|auth.forgot.notfound"  : "Аккаунт не найден"

    "en|auth.forgot.detect"  : "Email: %s"
    "ru|auth.forgot.detect"  : "Email: %s"

    "en|auth.forgot.notdetect"  : "Can't detect Email"
    "ru|auth.forgot.notdetect"  : "Email не определён"



    "en|auth.forgot.youremail"  : "Email for your account is %s"
    "ru|auth.forgot.youremail"  : "Email для вашего аккаунта: %s"

    "en|auth.forgot.emailhasbeenchanged"  : "Email has been changed to %s"
    "ru|auth.forgot.emailhasbeenchanged"  : "Email был успешно изменён на %s"

    "en|auth.forgot.failedchanged"  : "Changing email to %s failed"
    "ru|auth.forgot.failedchanged"  : "Не удалось изменить email на %s"
});

/**
 * Trigger showing logging in gui
 * adding translation for player
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function showForgotGUI(playerid) {
    local window    = plocalize(playerid, "auth.GUI.TitleLogin");
    local label     = plocalize(playerid, "auth.GUI.TitleLabelLogin", [getPlayerName(playerid)]);
    local input     = plocalize(playerid, "auth.GUI.TitleInputLogin");
    local button    = plocalize(playerid, "auth.GUI.ButtonLogin");
    local helpText  = plocalize(playerid, "auth.haveproblems");
    local forgotText  = plocalize(playerid, "auth.forgot");

    trigger(playerid, "destroyAuthGUI");

    screenFadein(playerid, 500, function() {
        trigger(playerid, "showForgotGUI", getPlayerLocale(playerid), forgotText);
        screenFadeout(playerid, 250);
    });
}

event("onPlayerShowForgotGUI", function(playerid) {
    showForgotGUI(playerid);
});

/**
 * Trigger hiding logging in gui
 * adding translation for player
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function hideForgotGUI(playerid) {

    trigger(playerid, "destroyForgotGUI");
    screenFadein(playerid, 500, function() {
        trigger("onClientSuccessfulyStartedAgain", playerid);
        screenFadeout(playerid, 250);
    });
}

event("onPlayerHideForgotGUI", function(playerid) {
    hideForgotGUI(playerid);
});


event("onPlayerGetLoginByEmail", function(playerid, email) {

    Account.findOneBy({ email = email }, function(err, account) {

        if (account) {
            trigger(playerid, "showFindLoginResult", true, plocalize(playerid, "auth.forgot.found", [account.username]));
        } else {
            trigger(playerid, "showFindLoginResult", false, plocalize(playerid, "auth.forgot.notfound"));
        }

    });
});

event("onPlayerGetEmailBySerial", function(playerid) {

    local serial = getPlayerSerial(playerid);

    Account.findOneBy({ serial = serial }, function(err, account) {

        if (account && account.email != "") {
            trigger(playerid, "showFindEmailResult", true, plocalize(playerid, "auth.forgot.detect", [encodeEmail(account.email)]));
        } else {
            trigger(playerid, "showFindEmailResult", false, plocalize(playerid, "auth.forgot.notdetect"));
        }

    });
});

event("onPlayerChangePassword", function(playerid, email, password) {

    Account.findOneBy({ email = email }, function(err, account) {

        if (account) {
            account.password = md5(password);
            account.save();
            dbg("chat", "report", account.username, "Изменён пароль");
            trigger(playerid, "onChangedPassword", true);
        } else {
            trigger(playerid, "onChangedPassword", false);
        }

    });
});


cmd("email", "get", function(playerid) {
    msg(playerid, "auth.forgot.youremail", [ getPlayerEmail(playerid) ], CL_SUCCESS);
});

cmd("email", "set", function(playerid, email) {
    if(getPlayerEmail(playerid) == "" && setPlayerEmail( playerid, email )) {
        return msg(playerid, "auth.forgot.emailhasbeenchanged", [ email ], CL_SUCCESS);
    }
    msg(playerid, "auth.forgot.failedchanged", [ email ], CL_ERROR);
});

function encodeEmail(email) {

    local parts = split(email, "@");
    local domain = split(parts[1], ".");

    local part0len = parts[0].len();

    return parts[0].slice(0, 2)+generateMask("*", part0len - 3)+parts[0].slice(part0len - 1)+"@"+generateMask("*", domain[0].len())+"."+domain[1];
}

function generateMask(symbol, count) {

    local str = "";
    for (local i = 0; i < count; i++) {
        str+=symbol;
    }
    return str;
}
