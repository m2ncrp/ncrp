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
 * Основная функция оправки массовых сообщения игрокам.
 * Поддерживает систему рукопожатий и локализацию
 * Поддерживает отправку в радиусе от игрока-отправителя
 */

function sendLocalizedMsgToAll(senderid, phrase_key, params, radius, color = 0) {
    foreach(playerid, player in players) {
        local tempParams = clone(params);
        if ( isBothInRadius(senderid, playerid, radius) ) {

            local results = []
            // перебираем массив параметров
            foreach (idx, param in tempParams) {
                if(typeof param == "function") {
                    tempParams[idx] = param(playerid, senderid);
                }

                //  Если параметр является массивом, то 0й элемент в нём - это функция, а 1й элемент - массив с параметрами этой функции
                if(typeof param == "array") {
                    tempParams[idx] = param[0].acall(param[1]);
                }
            }

            // Для IC чата цвет своих сообщений иной, нежели от других игроков
            if(senderid == playerid && phrase_key == "chat.player.says") {
                color = CL_GOLDENSAND;
            }

            if (color) {
                msg(playerid, localize(phrase_key, tempParams, getPlayerLocale(player.playerid)), color);
            } else {
                msg(playerid, localize(phrase_key, tempParams, getPlayerLocale(player.playerid)));
            }
        }
    }
}

/**
 * Send localized message to all players (in radius from POINT with coords X, Y, Z) with parameters.
 * Не имеет системы рукопожатий.
 * В проекте нигде не используется, поэтому не стоит и начинать
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

/**
 * Return string "player_name [playerid]"
 * @param  {int}    playerid
 * @return {string}
 */
function getAuthor( playerid ) {
    return getPlayerName( playerid.tointeger() ) + " [" + playerid.tostring() + "]";
}

function chatcmd(names, callback)  {
    cmd(names, function(playerid, ...) {
        local text = (concat(vargv));

        if (!text || strip(text).len() < 1) {
            return msg(playerid, "general.message.empty", CL_ERROR);
        }

        if (isPlayerMuted(playerid)) {
            return msg(playerid, "admin.mute.youhave", CL_RED);
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

    local message = localize(text, params, getPlayerLocale(playerid.tointeger()));

    addMessageToChatHistory(playerid.tointeger(), message, color);

    return sendPlayerMessage(playerid.tointeger(), message, color.r, color.g, color.b);
}

function msg_a(text, args, color = CL_WHITE) {
    // return sendPlayerMessageToAll(text, color.r, color.g, color.b);
    foreach (playerid, value in players) {
        msg(playerid, text, args, color);
    }
}

function msg_help(playerid, title, commands){

    msg(playerid, "===========================================", CL_HELP_LINE);
    msg(playerid, title, CL_HELP_TITLE);

    foreach (idx, icmd in commands) {
        local text = null;
        if(icmd.desc.len() > 0) {
            text = localize(icmd.name, [], getPlayerLocale(playerid)) + "   -   " + localize(icmd.desc, [], getPlayerLocale(playerid));
        } else {
            text = localize(icmd.name, [], getPlayerLocale(playerid));
        }
        if ((idx % 2) == 0) {
            msg(playerid, text, CL_HELP);
        } else {
            msg(playerid, text);
        }
    }
}

function msg_help_new(playerid, title, commands){

    msg(playerid, "===========================================", CL_HELP_LINE);
    msg(playerid, title, CL_HELP_TITLE);

    foreach (idx, icmd in commands) {
        local text = null;
        if("desc" in icmd) {
            text = localize(icmd.name, [], getPlayerLocale(playerid)) + "   -   " + localize(icmd.desc, [], getPlayerLocale(playerid));
        } else {
            text = localize(icmd.name, [], getPlayerLocale(playerid));
        }
        if ((idx % 2) == 0) {
            msg(playerid, text, CL_SILVERSAND);
        } else {
            msg(playerid, "  "+text, CL_LYNCH);
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
    msg(playerid, "chat.player.message.private.from", [getKnownCharacterNameWithId( playerid, targetid ), message], CL_CHAT_PM );
    msg(targetid, "chat.player.message.private.to", [getKnownCharacterNameWithId( targetid, playerid ), message], CL_CHAT_PM );
    statisticsPushText("pm", playerid, getPlayerName( playerid ) + " to " + getPlayerName( targetid ) + ": " + message);
}

// aliases
msga <- msg_a;
msgr <- sendLocalizedMsgToAll;
