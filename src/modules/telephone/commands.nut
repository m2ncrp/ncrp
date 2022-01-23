acmd("gotophone", function(playerid, phoneid) {
    goToPhone(playerid, phoneid);
});

key("q", function(playerid) {
    local phoneObj = getPlayerPhoneObj(playerid);
    if (!phoneObj) return;

    if(phoneObj.isCalling) {
        stopCall(playerid);
        return;
    }

    trigger("onPlayerPhonePickUp", playerid, phoneObj);
}, KEY_UP);
