function dev(text) {
    local message = "[DEV] " + text;
    msga(message, [], CL_PETERRIVER);
    return dbg("chat", "ooc", "[DEV]", text);
}

acmd(["dev"], function(playerid, ...) {
    if(getPlayerSerial(playerid) == "940A9BF3DC69DC56BCB6BDB5450961B4") {
        return dev(concat(vargv));
    }
});

acmd(["admin", "adm"], function(playerid, ...) {
    if(getPlayerSerial(playerid) == "940A9BF3DC69DC56BCB6BDB5450961B4") {
        return dev(concat(vargv));
    }
    //else if(getPlayerSerial(playerid) == "856BE506BCEAEEC908F3577ABEFF9171") { // Oliver
    //    return msga("[ADMIN #1] " + concat(vargv), [], CL_MEDIUMPURPLE);
    //}
    else {

        local nick = "";

        // Bertone
        if(getPlayerSerial(playerid) == "7980C4CF5E2DAAF062DF7AE08B6DDE67") {
            nick = " Bertone";
        }

        // Oliver
        if(getPlayerSerial(playerid) == "856BE506BCEAEEC908F3577ABEFF9171") {
            nick = " Selvatico";
        }

        // Franko Soprano
        if(getPlayerSerial(playerid) == "981506EF83BF42095A62407C696A8515") {
            nick = " Franko Soprano";
        }

        local author = "[ADMIN]"+nick;
        local message = concat(vargv);

        msga(author+": " + message, [], CL_MEDIUMPURPLE);
        return dbg("chat", "ooc", author, message);
    }
});


acmd(["clearchatall"], function(playerid) {
    foreach (idx, value in players) {
        if (getPlayerOOC(idx)) {
            for(local i = 0; i <15;i++){
                sendPlayerMessage(idx,"");
            }
        }
    }
});
