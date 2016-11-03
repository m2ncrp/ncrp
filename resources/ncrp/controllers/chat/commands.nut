// local chat
chatcmd(["i", "say"], function(playerid, message) {
    inRadiusToAll(getAuther( playerid ) + " says: " + message, playerid, NORMAL_RADIUS, CL_YELLOW);
});

// shout
chatcmd(["s", "shout"], function(playerid, message) {
    inRadiusToAll(getAuther( playerid ) + " shout: " + message, playerid, SHOUT_RADIUS, CL_WHITE);
});

// whisper
chatcmd(["w", "whisper"], function(playerid, message) {
    local targetid = playerList.nearestPlayer( playerid );
    inRadius(playerid, targetid, WHISPER_RADIUS, function() {
        msg(targetid, getAuther( playerid ) + " whisper: " + message);
    })
});

// nonRP local chat
chatcmd(["b"], function(playerid, message) {
    inRadiusToAll("[nonRP] " + getAuther( playerid ) + ": " + message, playerid, NORMAL_RADIUS, CL_GRAY);
});

// global nonRP chat
chatcmd(["o","ooc"], function(playerid, message) {
    msg_a("[OOC] " + getAuther( playerid ) + ": " + message, CL_GRAY);
});

chatcmd(["me"], function(playerid, message) {
    inRadiusToAll("[ME] " + getAuther( playerid ) + " " + message, playerid, NORMAL_RADIUS, CL_YELLOW);
});

// random for some actions
chatcmd(["try"], function(playerid, message) {
    message = "[TRY] " + getAuther( playerid ) + " try " + message;
    local res = random(0,1);
    if(res)
        inRadiusToAll(message + " (success).", playerid, NORMAL_RADIUS);
    else
        inRadiusToAll(message + " (failed).", playerid, NORMAL_RADIUS);
});


cmd(["help", "h", "halp", "info"], function(playerid) {
    local commands = [
        { name = "/spawn",              desc = "Teleport to spawn" },
        { name = "/weapons",            desc = "Give yourself some damn guns!" },
        { name = "/heal",               desc = "Restore your precious health points :p"},
        { name = "/die",                desc = "If you dont wanna live there anymore" },
        { name = "/vehicle <id>",       desc = "Spawn vehicle, example /vehicle 45" },
        { name = "/tune",               desc = "Tune up your vehicle!" },
        { name = "/fix",                desc = "Fix up your super vehicle" },
        { name = "/destroyVehicle",     desc = "Remove car you are in" },
        { name = "/skin <id>",          desc = "Change your skin :O. Example: /skin 63" },
        { name = "/say <text>",         desc = "Put your text in local RP chat"},
        { name = "/shout <text>",       desc = "Your message could be heard far enough :)"},
        { name = "/whisper <text>",     desc = "Say something to nearest player very quiet"},
        { name = "/b <text>",           desc = "Local nonRP chat"},
        { name = "/ooc <text>",         desc = "Global nonRP chat"},
        { name = "/me <action text>",   desc = "Some action of your person"},
        { name = "/try <action text>",  desc = "Any action simulation that could be failed"}
    ];

    sendPlayerMessage(playerid, "");
    sendPlayerMessage(playerid, "==================================", 200, 100, 100);
    sendPlayerMessage(playerid, "Here is list of available commands:", 200, 200, 0);

    foreach (idx, icmd in commands) {
        local text = " * Command: " + icmd.name + "   -   " + icmd.desc;
        if ((idx % 2) == 0) {
            sendPlayerMessage(playerid, text, 200, 230, 255);
        } else {
            sendPlayerMessage(playerid, text);
        }
    }
});