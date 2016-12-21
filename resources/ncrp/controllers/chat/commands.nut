// local chat
chatcmd(["i", "say"], function(playerid, message) {
    sendLocalizedMsgToAll(playerid, "chat.player.says", message, NORMAL_RADIUS, CL_YELLOW);

    // statistics
    statisticsPushMessage(playerid, message, "say");
});

// shout
chatcmd(["s", "shout"], function(playerid, message) {
    sendLocalizedMsgToAll(playerid, "chat.player.shout", message, SHOUT_RADIUS, CL_WHITE);

    // statistics
    statisticsPushMessage(playerid, message, "shout");
});

// whisper
chatcmd(["w", "whisper"], function(playerid, message) {
    local targetid = playerList.nearestPlayer( playerid );
    if ( targetid == null) {
        msg(playerid, "general.noonearound");
        return;
    }
    if ( isBothInRadius(playerid, targetid, WHISPER_RADIUS) ) {
        msg(targetid, "chat.player.whisper", [getAuthor( playerid ), message]);
        msg(playerid, "chat.player.whisper", [getAuthor( playerid ), message]);
    }

    // statistics
    statisticsPushMessage(playerid, message, "whisper");
});

chatcmd(["global", "g"], function(playerid, message) {
    msg_a("[Global OOC] " + getAuthor( playerid ) + ": " + message, CL_SILVERSAND);

    statisticsPushMessage(playerid, message, "global");
});

// private message
cmd("pm", function(playerid, targetid, ...) {
    local targetid = toInteger(targetid);

    if (!isInteger(targetid) || !vargv.len()) {
        return msg(playerid, "chat.player.message.error", CL_ERROR);
    }

    if (!isPlayerConnected(targetid)) {
        return msg(playerid, "chat.player.message.noplayer", CL_ERROR);
    }

    local message = concat(vargv);
    msg(playerid, "chat.player.message.private", [getAuthor( playerid ), message], CL_LIGHTWISTERIA);
    msg(targetid, "chat.player.message.private", [getAuthor( playerid ), message], CL_LIGHTWISTERIA);
    statisticsPushText("pm", playerid, "to: " + getAuthor( targetid ) + message);
});


// nonRP local chat
chatcmd(["b"], function(playerid, message) {
    inRadiusSendToAll(playerid, format("[nonRP] %s: %s", getAuthor( playerid ), message), NORMAL_RADIUS, CL_GRAY);

    // statistics
    statisticsPushMessage(playerid, message, "non-rp-local");
});

// global nonRP chat
chatcmd(["o","ooc"], function(playerid, message) {
    // msg_a("[OOC] " + getAuthor( playerid ) + ": " + message, CL_GRAY);
    foreach (targetid, value in players) {
        if (getPlayerLocale(targetid) == getPlayerLocale(playerid) || isPlayerAdmin(targetid)) {
            msg(targetid, "[OOC " + getPlayerLocale(playerid).toupper() + "] " + getAuthor( playerid ) + ": " + message, CL_GRAY);
        }
    }

    // statistics
    statisticsPushMessage(playerid, message, "ooc");
});

chatcmd(["me"], function(playerid, message) {
    inRadiusSendToAll(playerid, "[ME] " + getAuthor( playerid ) + " " + message, NORMAL_RADIUS, CL_YELLOW);

    // statistics
    statisticsPushMessage(playerid, message, "me");
});

cmd("idea", function(playerid, ...) {
    msg(playerid, "chat.idea.success", CL_SUCCESS);
    statisticsPushText("idea", playerid, concat(vargv));

    local data = url_encode(base64_encode(format("%s: %s", getAuthor(playerid), concat(vargv))));
    webRequest(HTTP_TYPE_GET, MOD_HOST, "/discord?type=idea&data=" + data, function(a,b,c) {}, 7790);
});

cmd("report", function(playerid, id, ...) {
    if (!isInteger(id) || !vargv.len()) {
        return msg(playerid, "chat.report.error", CL_ERROR);
    }

    if (!isPlayerConnected(id.tointeger())) {
        return msg(playerid, "chat.report.noplayer", CL_ERROR);
    }

    vargv.insert(0, getPlayerName(id.tointeger()) + " ");

    msg(playerid, "chat.report.success", CL_SUCCESS);
    statisticsPushText("report", playerid, concat(vargv));

    local data = url_encode(base64_encode(format("%s: %s", getAuthor(playerid), concat(vargv))))
    webRequest(HTTP_TYPE_GET, MOD_HOST, "/discord?type=report&data=" + data, function(a,b,c) {}, 7790);
});

// random for some actions
chatcmd(["try"], function(playerid, message) {
    local res = random(0,1);
    if(res)
        sendLocalizedMsgToAll(playerid, "chat.player.try.end.success", message, NORMAL_RADIUS);
    else
        sendLocalizedMsgToAll(playerid, "chat.player.try.end.fail", message, NORMAL_RADIUS);

    // statistics
    statisticsPushMessage(playerid, message, "try");
});

cmd(["help", "h", "halp", "info"], function(playerid) {
    local title = "Here is list of available commands:";
    local commands = [
        { name = "/help chat",              desc = "help.chat" },
        { name = "/help subway",            desc = "help.subway" },
        { name = "/help taxi",              desc = "help.taxi" },
        { name = "/help rent",              desc = "help.rentcar" },
        { name = "/help job JOBNAME",       desc = "help.job" },
        { name = "/help bank",              desc = "help.ban" },
        { name = "/help car",               desc = "help.cars" },
        { name = "/help fuel",              desc = "help.fuel" },
        { name = "/help repair",            desc = "help.repair" },
        { name = "/report ID TEXT",         desc = "help.report" },
        { name = "/idea TEXT",              desc = "help.idea" }
    ];
    msg_help(playerid, title, commands);
});

cmd(["help", "h", "halp", "info"], "chat", function(playerid) {
    local title = "List of available commands for CHAT:";
    local commands = [
        { name = "/say TEXT",         desc = "help.chat.say"},
        { name = "/shout TEXT",       desc = "help.chat.shout"},
        { name = "/whisper TEXT",     desc = "help.chat.whisper"},
        { name = "/b TEXT",           desc = "help.chat.localooc"},
        { name = "/ooc TEXT",         desc = "help.chat.ooc"},
        { name = "/pm ID TEXT",       desc = "help.chat.privatemsg"},
        { name = "/me ACTION_TEXT",   desc = "help.chat.me"},
        { name = "/try ACTION_TEXT",  desc = "help.chat.try"}
    ];
    msg_help(playerid, title, commands);
});

/*
cmd(["help", "h", "halp", "info"], "vehicle", function(playerid) {
    local title = "List of available commands for VEHICLES:";
    local commands = [
        { name = "/vehicle <id>",       desc = "Spawn vehicle. Example: /vehicle 45" },
        { name = "/tune",               desc = "Tune up your vehicle!" },
        { name = "/fix",                desc = "Fix up your super vehicle" },
        { name = "/destroyVehicle",     desc = "Remove car you are in" }
    ];
    msg_help(playerid, title, commands);
});
*/
