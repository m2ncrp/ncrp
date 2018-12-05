function generateAdminNick (playerid) {
    local nick = "";

    // Bertone
    // if(getPlayerSerial(playerid) == "561A1E7BB51FD437E210E932FA296DD5") {
    //     nick = " Ovsianka";
    // }

    // Oliver
    if(getPlayerSerial(playerid) == "856BE506BCEAEEC908F3577ABEFF9171") {
        nick = " Selvatico";
    }

    // Franko Soprano
    // if(getPlayerSerial(playerid) == "981506EF83BF42095A62407C696A8515") {
    //     nick = " Odin";
    // }

    // Hurfy
    if(getPlayerSerial(playerid) == "2F3701604B3669FCA3D3B7BC1BF3F6B8") {
        nick = " Hurfy";
    }

    // Vittorio Genovese
    if(getPlayerSerial(playerid) == "71818C229464A61DA21C9FC522BA7B08") {
        nick = " MadHatter";
    }

    return "[ADMIN]"+nick;
}

function sendAdminDevMsg(playerid, author, message, color, important, targetid) {
    if(targetid != null) {
        trigger(targetid, "onServerShowChatTrigger");
        msg(playerid, "chat.player.message.private", [author, getAuthor( targetid ), message], color );
        msg(targetid, "chat.player.message.private", [author, getAuthor( targetid ), message], color );
        return statisticsPushText("pm", playerid, "to: " + getAuthor( targetid ) + message);
    }

    local text = author+": " + message;

    if(important) {
        foreach (plaid, character in players) {
            trigger(plaid, "onServerShowChatTrigger");
        }
        return msga(text, [], color);
    }

    // send message to all enabled chat
    foreach (plaid, value in players) {
        if (isPlayerOOCEnabled(plaid) && plaid != playerid) {
            msg(plaid, text, color);
        }
    }
    msg(playerid, text, color);
    return dbg("chat", "ooc", author, message);
}

function dev(message) {
    msga("[DEV] "+message, [], CL_PETERRIVER);
}

function devMsg(playerid, message, important = false, targetid = null) {
    sendAdminDevMsg(playerid, "[DEV]", message, CL_PETERRIVER, important, targetid);
}

function adminMsg(playerid, message, important = false, targetid = null) {
    sendAdminDevMsg(playerid, generateAdminNick(playerid), message, CL_MEDIUMPURPLE, important, targetid);
}

mcmd(["admin.chat"], "adm", function(playerid, ...) {
    adminMsg(playerid, concat(vargv));
});

mcmd(["admin.chat.important"], "admw", function(playerid, ...) {
    adminMsg(playerid, concat(vargv), true);
});

mcmd(["admin.chat.pm"], "apm", function(playerid, targetid, ...) {
    targetid = targetid ? targetid.tointeger() : null;
    if (targetid == null || !isPlayerConnected(targetid)) {
               msg(playerid, "admin.error", CL_ERROR);
        return msg(playerid, "Формат: /apm id текст");
    }

    adminMsg(playerid, concat(vargv), false, targetid);
});

mcmd(["dev.chat"], "dev", function(playerid, ...) {
    return devMsg(playerid, concat(vargv));
});

mcmd(["dev.chat.important"], "devw", function(playerid, ...) {
    return devMsg(playerid, concat(vargv), true);
});

mcmd(["dev.chat.pm"], "pmd", function(playerid, targetid, ...) {
    targetid = targetid ? targetid.tointeger() : null;
    if (targetid == null || !isPlayerConnected(targetid)) {
               msg(playerid, "admin.error", CL_ERROR);
        return msg(playerid, "Формат: /pmd id текст");
    }
    return devMsg(playerid, concat(vargv), false, targetid);
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


