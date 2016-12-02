// local chat
chatcmd(["i", "say"], function(playerid, message) {
    inRadiusSendToAll(playerid, 
        localize("chat.player.says", [getAuthor( playerid ), message], getPlayerLocale(playerid)), 
        NORMAL_RADIUS, CL_YELLOW);

    // statistics
    statisticsPushMessage(playerid, message, "say");
});

// shout
chatcmd(["s", "shout"], function(playerid, message) {
    inRadiusSendToAll(playerid, 
        localize("chat.player.shout", [getAuthor( playerid ), message], getPlayerLocale(playerid)), 
        SHOUT_RADIUS, CL_WHITE);

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

// nonRP local chat
chatcmd(["b"], function(playerid, message) {
    inRadiusSendToAll(playerid, "[nonRP] " + getAuthor( playerid ) + ": " + message, NORMAL_RADIUS, CL_GRAY);

    // statistics
    statisticsPushMessage(playerid, message, "non-rp-local");
});

// global nonRP chat
chatcmd(["o","ooc"], function(playerid, message) {
    msg_a("[OOC] " + getAuthor( playerid ) + ": " + message, CL_GRAY);

    // statistics
    statisticsPushMessage(playerid, message, "ooc");
});

chatcmd(["me"], function(playerid, message) {
    inRadiusSendToAll(playerid, "[ME] " + getAuthor( playerid ) + " " + message, NORMAL_RADIUS, CL_YELLOW);

    // statistics
    statisticsPushMessage(playerid, message, "me");
});

// random for some actions
chatcmd(["try"], function(playerid, message) {
    message = localize("chat.player.try.body", [getAuthor( playerid ), message], getPlayerLocale(playerid));
    local res = random(0,1);
    if(res)
        inRadiusSendToAll(playerid, localize("chat.player.try.end.success", [message], getPlayerLocale(playerid)), NORMAL_RADIUS);
    else
        inRadiusSendToAll(playerid, localize("chat.player.try.end.fail", [message], getPlayerLocale(playerid)), NORMAL_RADIUS);

    // statistics
    statisticsPushMessage(playerid, message, "try");
});

cmd(["help", "h", "halp", "info"], function(playerid) {
    local title = "Here is list of available commands:";
    local commands = [
        { name = "/help chat",              desc = "Show list of commands for chat" },
        { name = "/help subway",            desc = "Show list of commands for subway" },
        { name = "/help taxi",              desc = "Show list of commands for taxi" },
        { name = "/help rent",              desc = "Show list of commands for rent car" },
        { name = "/help job <job name>",    desc = "Show list of commands for job. Example: /help job taxi" },
        { name = "/help car",               desc = "Show list of commands for cars" },
        { name = "/help fuel",              desc = "Show list of commands for fuel stations" },
        { name = "/help repair",            desc = "Show list of commands for repiair shop" }
    ];
    msg_help(playerid, title, commands);
});


cmd(["help", "h", "halp", "info"], "chat", function(playerid) {
    local title = "List of available commands for CHAT:";
    local commands = [
        { name = "/say <text>",         desc = "Put your text in local RP chat"},
        { name = "/shout <text>",       desc = "Your message could be heard far enough :)"},
        { name = "/whisper <text>",     desc = "Say something to nearest player very quiet"},
        { name = "/b <text>",           desc = "Local nonRP chat"},
        { name = "/ooc <text>",         desc = "Global nonRP chat"},
        { name = "/me <action text>",   desc = "Some action of your person"},
        { name = "/try <action text>",  desc = "Any action simulation that could be failed"}
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
