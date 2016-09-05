dofile("libs/index.nut", true);

cmd("register", function(playerid, password) {
    Account.getSession(playerid, function(err, account) {
        // if player is logined
        if (account) return ::print("you logined");

        // create account
        account = Account();
        account.username = getPlayerName(playerid);
        account.password = password;
        
        account.save(function(err, result) {
            account.addSession(playerid);
        });
    });
});

cmd("login", function(playerid, password) {
    Account.getSession(playerid, function(err, account) {
        // if player is logined
        if (account) return;

        // create account
        account = Account();
        account.username = getPlayerName(playerid);
        account.password = password;
        
        account.save(function(err, result) {
            account.addSession();
        });
    });
});
