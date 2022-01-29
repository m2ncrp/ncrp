acmd("gotophone", function(playerid, phoneid) {
    goToPhone(playerid, phoneid);
});

key("q", function(playerid) {
    if (isPlayingAnim(playerid) == "playing") return;

    local phoneObj = getPlayerPhoneObj(playerid);
    if (!phoneObj) return;

    if(phoneObj.isCalling) {
        stopCall(playerid);
        triggerClientEvent(playerid, "hidePhoneGUI");
        return;
    }

    trigger("onPlayerPhonePickUp", playerid, phoneObj);
}, KEY_UP);
