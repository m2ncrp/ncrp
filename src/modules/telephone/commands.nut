cmd("call", function(playerid, number = null, isbind = false) {
    phoneStartCall (playerid, number, false);
    //callByPhone (playerid, number, false);
});

acmd("gotophone", function(playerid, phoneid) {
    goToPhone(playerid, phoneid);
});

key("q", function(playerid) {
    phoneStartCall (playerid, null, true);
}, KEY_UP);
