/**
 * Chat module
 * Authors: LoOnyRider, Inlife, JustPilz
 * Date: nov 2016
 */


const NORMAL_RADIUS = 20.0;
const WHISPER_RADIUS = 4.0;
const SHOUT_RADIUS = 35.0;

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

function msg(playerid, text, color = CL_WHITE ) {
	sendPlayerMessage(playerid, text, color.r, color.g, color.b);
}

function msg_a(text, color = CL_WHITE){
	sendPlayerMessageToAll(text, color.r, color.g, color.b);
}

msga <- msg_a;
msgA <- msg_a;


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

include("controllers/chat/commands.nut"); // dont't touch!!! */
