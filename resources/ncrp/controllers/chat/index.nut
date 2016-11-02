/**
 * Chat module
 */
const NORMAL_RADIUS = 20.0;
const SHOUT_RADIUS = 35.0;

function chatcmd(names, callback)  {
    cmd(names, function(playerid, ...) {
        local text = concat(vargv);

        if (!text || text.len() < 1) {
            return sendPlayerMessage(playerid, "[INFO] You cant send an empty message.", CL_YELLOW.r, CL_YELLOW.g, CL_YELLOW.g);
        }

        // call registered callback
        return callback(playerid, text);
    });
}

include("controllers/chat/commands.nut");