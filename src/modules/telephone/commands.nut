cmd("call", function(playerid, number = null, isbind = false) {
    phoneStartCall (playerid, number, false);
    //callByPhone (playerid, number, false);
});

acmd("gotophone", function(playerid, phoneid) {
    goToPhone(playerid, phoneid);
});

key("q", function(playerid) {
    local number = getPlayerPhoneName(playerid);
    if (!number) return;
    local data = getPhoneData(number);
    local charId = getCharacterIdFromPlayerId(playerid);
    if (data.isRinging) {
        animatedPickUp(playerid);
        trigger("onPlayerPhonePickUp", playerid, number);
    } else if (data.isCalling && data.caller == charId) {
        local phone = getUserPhone(data.callee);
        local id = getPlayerIdFromCharacterId(data.callee);
        msg(id, "telephone.callend", CL_WARNING);
        msg(playerid, "telephone.callend", CL_WARNING);
        deleteUserCall(data.callee);
        clearPhoneData(phone);
        clearPhoneData(number);
        animatedPut(playerid);
        animatedPut(id);
        deleteUserCall(charId);
    } else if (data.isCalling && data.callee == charId) {
        if (data.caller == null) return;
        local id = getPlayerIdFromCharacterId(data.caller);
        local phone = getUserPhone(data.caller);
        msg(playerid, "telephone.callend", CL_WARNING)
        msg(id, "telephone.callend", CL_WARNING);
        deleteUserCall(data.caller);
        clearPhoneData(phone);
        clearPhoneData(number);
        animatedPut(playerid);
        animatedPut(id);
        deleteUserCall(charId);
    } else {
        phoneStartCall (playerid, null, true);
    }
}, KEY_UP);
