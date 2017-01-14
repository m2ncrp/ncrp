cmd("call", function(playerid, number = null, isbind = false) {
    callByPhone (playerid, number, isbind);
});

acmd("gotophone", function(playerid, phoneid) {
    goToPhone(playerid, phoneid);
});
