/**
 * Storage for current player's chat slots
 * @type {Array}
 */
local chatSlots = {};

/**
 * Set current player chat slot id
 * @param {Integer} playerid
 * @param {Integer} slot
 */
function setPlayerChatSlot(playerid, slot) {
    chatSlots[playerid] <- slot;
    return trigger(playerid, "onServerChatSlotRequested", slot);
}

/**
 * Set current player slot id
 * @param  {Integer} playerid
 * @return {Integer}
 */
function getPlayerChatSlot(playerid) {
    if (playerid in chatSlots) {
        return chatSlots[playerid];
    }

    return 0;
}

event("onPlayerDisconnect", function(playerid, reason) {
    if (playerid in chatSlots) {
        delete chatSlots[playerid];
    }
});

/**
 * Add a comment to this line
 * Send message to all players in radius
 * @param  {int}        sender
 * @param  {string}     message
 * @param  {float}      radius
 * @param  {RGB object} color
 * @return {void}
 */
function inRadiusSendToAll(senderid, message, radius, color = 0) {
    foreach(playerid, player in players) {
        if ( isBothInRadius(senderid, playerid, radius) ) {
            if (color) {
                msg(playerid, message, color);
            } else {
                msg(playerid, message);
            }
        }
    }
}


function sendLocalizedMsgToAll(senderid, phrase_key, message, radius, color = 0) {
    foreach(playerid, player in players) {
        if ( isBothInRadius(senderid, playerid, radius) ) {
            if (color) {
                msg(playerid, localize(phrase_key, message, getPlayerLocale(player.playerid)), color);
            } else {
                msg(playerid, localize(phrase_key, message, getPlayerLocale(player.playerid)));
            }
        }
    }
}

/**
 * Send localized message to all players (in radius from SENDER) with parameters. Working GOOD!!!
 * @param  {int}        sender
 * @param  {string}     message
 * @param  {string}     params
 * @param  {float}      radius
 * @param  {RGB object} color
 * @return {void}
 */
function sendMsgToAllInRadius(senderid, message, params, radius, color = 0) {
    foreach(playerid, player in players) {
        if ( isBothInRadius(senderid, playerid, radius) ) {
            if (color) {
                msg(playerid, message, params, color);
            } else {
                msg(playerid, message, params);
            }
        }
    }
}

/**
 * Send localized message to all players (in radius from POINT with coords X, Y, Z) with parameters. Working GOOD!!!
 * @param  {float}      X
 * @param  {float}      Y
 * @param  {float}      Z
 * @param  {string}     message
 * @param  {string}     params
 * @param  {float}      radius
 * @param  {RGB object} color
 * @return {void}
 */
function sendMsgToAllInRadiusFromPoint(X, Y, Z, message, params, radius, color = 0) {
    foreach(playerid, player in players) {
        if ( isInRadius(playerid, X, Y, Z, radius) ) {
            if (color) {
                msg(playerid, message, params, color);
            } else {
                msg(playerid, message, params);
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

/**
 * Return string "player_name(#playerid)"
 * @param  {int}    playerid
 * @return {string}
 */
function getAuthor3( playerid ) {
    return getPlayerName( playerid.tointeger() ) + "(" + playerid.tostring() + ")";
}

function chatcmd(names, callback)  {
    cmd(names, function(playerid, ...) {
        local text = (concat(vargv));

        if (!text || strip(text).len() < 1) {
            return msg(playerid, "[INFO] You can't send an empty message.", CL_YELLOW);
        }

        if (isPlayerMuted(playerid)) {
            return;
        }

        // call registered callback
        return callback(playerid, strip(text));
    });
}

function msg(playerid, text, ...) {
    local args  = vargv;
    local color = CL_WHITE;
    local params = [];

    if (args.len() && args[args.len() - 1] instanceof Color) {
        color = args[args.len() - 1];
    }

    if (args.len()) {
        if (typeof args[0] == "string" || typeof args[0] == "integer" || typeof args[0] == "float") {
            params = [args[0]];
        } else if (typeof args[0] == "array") {
            params = args[0];
        }
    }

    return sendPlayerMessage(playerid.tointeger(), localize(
        text, params, getPlayerLocale(playerid.tointeger())
    ), color.r, color.g, color.b);
}

function msg_a(text, color = CL_WHITE) {
    // return sendPlayerMessageToAll(text, color.r, color.g, color.b);
    foreach (playerid, value in players) {
        msg(playerid, text, color);
    }
}

function msg_help(playerid, title, commands){

    msg(playerid, "==================================", CL_HELP_LINE);
    msg(playerid, title, CL_HELP_TITLE);

    foreach (idx, icmd in commands) {
        local text = localize(icmd.name, [], getPlayerLocale(playerid)) + "   -   " + localize(icmd.desc, [], getPlayerLocale(playerid));
        if ((idx % 2) == 0) {
            msg(playerid, text, CL_HELP);
        } else {
            msg(playerid, text);
        }
    }
}

function sendPlayerPrivateMessage(playerid, targetid, vargv) {
    if (!isInteger(targetid) || !vargv.len()) {
        return msg(playerid, "chat.player.message.error", CL_ERROR);
    }

    if (!isPlayerConnected(targetid)) {
        return msg(playerid, "chat.player.message.noplayer", CL_ERROR);
    }

    local message = concat(vargv);
    msg(playerid, "chat.player.message.private", [getAuthor( playerid ), getAuthor( targetid ), message], CL_LIGHTWISTERIA);
    msg(targetid, "chat.player.message.private", [getAuthor( playerid ), getAuthor( targetid ), message], CL_LIGHTWISTERIA);
    statisticsPushText("pm", playerid, "to: " + getAuthor( targetid ) + message);
}

// aliases
msga <- msg_a;
msgA <- msg_a;
