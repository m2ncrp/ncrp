dofile("libs/index.nut", true);

/**
 * Command allows players to register
 * using their current username and specified password
 *
 * TODO: add check for existing
 */
cmd(["r", "register"], function(playerid, password) {
    Account.getSession(playerid, function(err, account) {
        // if player is logined
        if (account) return sendPlayerMessage(playerid, "* You already logined in.");

        // create account
        account = Account();
        account.username = getPlayerName(playerid);
        account.password = password;
        
        account.save(function(err, result) {
            account.addSession(playerid);
        });
    });
});

/**
 * Command allows players to login
 * using their current username and specified password
 */
cmd(["l", "login"], function(playerid, password) {
    Account.getSession(playerid, function(err, account) {
        // if player is logined
        if (account) {
            return sendPlayerMessage(playerid, "* You already logined in.");
        }

        // try to find logined account
        Account.findOneBy({
            username = getPlayerName(playerid),
            password = password
        }, function(err, account) {
            // no accounts found
            if (!account) return sendPlayerMessage(playerid, "* No specified account found.");

            // save session
            account.addSession(playerid);
        });
    });
});
