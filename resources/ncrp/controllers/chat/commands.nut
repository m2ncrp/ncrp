// local chat
chatcmd(["i", "say"], function(playerid, message) {
    inRadiusSendToAll(playerid, getAuthor( playerid ) + " says: " + message, NORMAL_RADIUS, CL_YELLOW);
});

// shout
chatcmd(["s", "shout"], function(playerid, message) {
    inRadiusSendToAll(playerid, getAuthor( playerid ) + " shout: " + message, SHOUT_RADIUS, CL_WHITE);
});

// whisper
chatcmd(["w", "whisper"], function(playerid, message) {
    local targetid = playerList.nearestPlayer( playerid );
    intoRadiusDo(playerid, targetid, WHISPER_RADIUS, function() {
        msg(targetid, getAuthor( playerid ) + " whisper: " + message);
        msg(playerid, getAuthor( playerid ) + " whisper: " + message);
    });
});

// nonRP local chat
chatcmd(["b"], function(playerid, message) {
    inRadiusSendToAll(playerid, "[nonRP] " + getAuthor( playerid ) + ": " + message, NORMAL_RADIUS, CL_GRAY);
});

// global nonRP chat
chatcmd(["o","ooc"], function(playerid, message) {
    msg_a("[OOC] " + getAuthor( playerid ) + ": " + message, CL_GRAY);
});

chatcmd(["me"], function(playerid, message) {
    inRadiusSendToAll(playerid, "[ME] " + getAuthor( playerid ) + " " + message, NORMAL_RADIUS, CL_YELLOW);
});

// random for some actions
chatcmd(["try"], function(playerid, message) {
    message = "[TRY] " + getAuthor( playerid ) + " try " + message;
    local res = random(0,1);
    if(res)
        inRadiusSendToAll(playerid, message + " (success).", NORMAL_RADIUS);
    else
        inRadiusSendToAll(playerid, message + " (failed).", NORMAL_RADIUS);
});


cmd(["help", "h", "halp", "info"], function(playerid) {
    local title = "Here is list of available commands:";
    local commands = [
        { name = "/spawn",                  desc = "Teleport to spawn" },
        { name = "/weapons",                desc = "Give yourself some damn guns!" },
        { name = "/heal",                   desc = "Restore your precious health points :p"},
        { name = "/die",                    desc = "If you dont wanna live there anymore" },
        { name = "/skin <id>",              desc = "Change your skin :O. Example: /skin 63" },
        { name = "/help chat",              desc = "Show list of commands for chat" },
        { name = "/help vehicle",           desc = "Show list of commands for vehicles" },
        { name = "/help subway",           desc = "Show list of commands for subway" },
        { name = "/help job <job name>",    desc = "Show list of commands for job. Example: /help job taxi" }
    ];
    msg_help(playerid, title, commands);
});


cmd(["help", "h", "halp", "info"], ["chat"], function(playerid) {
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

cmd(["help", "h", "halp", "info"], ["vehicle"], function(playerid) {
    local title = "List of available commands for VEHICLES:";
    local commands = [
        { name = "/vehicle <id>",       desc = "Spawn vehicle. Example: /vehicle 45" },
        { name = "/tune",               desc = "Tune up your vehicle!" },
        { name = "/fix",                desc = "Fix up your super vehicle" },
        { name = "/destroyVehicle",     desc = "Remove car you are in" }
    ];
    msg_help(playerid, title, commands);
});

cmd(["help", "h", "halp", "info"], ["subway"], function(playerid) {
    local title = "List of available commands for SUBWAY:";
    local commands = [
        { name = "/subway <id>",        desc = "Go to <id> metro station. Example: /subway 3" },
        { name = "/sub <id>",           desc = "Analog /subway <id>" },
        { name = "/metro <id>",         desc = "Analog /subway <id>" }
    ];
    msg_help(playerid, title, commands);
});
