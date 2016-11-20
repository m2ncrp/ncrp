// usage: /bank account
cmd("bank", "account", function(playerid) {
    bankAccount(playerid);
});

// usage: /bank deposit
cmd("bank", "deposit", function(playerid, amount) {
    bankDeposit(playerid, amount);
});

// usage: /bank deposit all
cmd("bank", ["deposit", "all"], function(playerid) {
    bankDeposit(playerid, players[playerid]["money"]);
});

// usage: /bank withdraw
cmd("bank", "withdraw", function(playerid, amount) {
    bankWithdraw(playerid, amount);
});

// usage: /bank withdraw all
cmd("bank", ["withdraw", "all"], function(playerid) {
    bankWithdraw(playerid, players[playerid]["deposit"]);
});

// usage: /help bank
cmd("help", "bank", function(playerid) {
    helpBank(playerid);
});

// usage: /bank
cmd("bank", function(playerid) {
    helpBank(playerid);
});

