dofile("./resources/libs/index.nut", true);

cmd("register", function(playerid, password) {
    local account = Account();
    
    account.username = getPlayerName(playerid);
    account.password = password;

    account.save();
});

cmd("login", function(playerid, password) {
    
});
