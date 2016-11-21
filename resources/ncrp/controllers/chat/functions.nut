function chatcmd(names, callback)  {
    cmd(names, function(playerid, ...) {
        local text = concat(vargv);

        if (!text || text.len() < 1) {
            return msg(playerid, "[INFO] You cant send an empty message.", CL_YELLOW);
        }

        // call registered callback
        return callback(playerid, text);
    });
}

// @params playerid - string
// @return "Player_Name[id]" string
function getAuthor( playerid ) {
    return getPlayerName( playerid.tointeger() ) + "[" + playerid.tostring() + "]";
}

function msg(playerid, text, color = CL_WHITE ) {
    sendPlayerMessage(playerid, text, color.r, color.g, color.b);
}

function msg_a(text, color = CL_WHITE){
    sendPlayerMessageToAll(text, color.r, color.g, color.b);
}

function msg_help(playerid, title, commands){

    msg(playerid, "==================================", CL_HELP_LINE);
    msg(playerid, title, CL_HELP_TITLE);

    foreach (idx, icmd in commands) {
        local text = icmd.name + "   -   " + icmd.desc;
        if ((idx % 2) == 0) {
            msg(playerid, text, CL_HELP);
        } else {
            msg(playerid, text);
        }
    }
}

// aliases
msga <- msg_a;
msgA <- msg_a;
