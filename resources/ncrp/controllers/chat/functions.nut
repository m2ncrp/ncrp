/**
 * Add a comment to this line
 * Send message to all players in radius
 * @param  {int}        sender
 * @param  {string}     message
 * @param  {float}      radius
 * @param  {RGB object} color
 * @return {void}
 */
function inRadiusSendToAll(sender, message, radius, color = 0) {
    local players = playerList.getPlayers();
    foreach(player in players) {
        if ( isBothInRadius(sender, player, radius) ) {
            if (color) {
                msg(player, message, color);
            } else {
                msg(player, message);
            }
        }
    }
}

// /**
//  * Send message to all players in radius
//  * @param  {int}        sender
//  * @param  {string}     message
//  * @param  {float}      radius
//  * @param  {RGB object} color
//  * @return {void}
//  */
// function inRadiusSendToAll(sender, message, radius, color = 0) {
//     local players = playerList.getPlayers();
//     foreach(player in players) {
//         intoRadiusDo(sender, player, radius, function() {
//             if (color) {
//                 msg(player, message, color);
//             } else {
//                 msg(player, message);
//             }
//         });
//     }
// }

/**
 * Return string "player_name[playerid]"
 * @param  {int}    playerid
 * @return {string}
 */
function getAuthor( playerid ) {
    return getPlayerName( playerid.tointeger() ) + "[" + playerid.tostring() + "]";
}

/**
 * Return string "player_name(#playerid)"
 * @param  {int}    playerid
 * @return {string}
 */
function getAuthor2( playerid ) {
    return getPlayerName( playerid.tointeger() ) + "(#" + playerid.tostring() + ")";
}

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
