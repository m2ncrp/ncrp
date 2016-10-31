// local chat
cmd(["i","say"], function( playerid, ... ) {
    local text = concat(vargv);
    inRadius(getPlayerName( playerid ) + " says: " + text, playerid, NORMAL_RADIUS, CL_YELLOW);
});


// shout
cmd(["s","shout"], function( playerid, ... ) {
    local text = concat(vargv);
    inRadius(getPlayerName( playerid ) + " shout: " + text, playerid, SHOUT_RADIUS, CL_WHITE);
});


// nonRP local chat
cmd(["b"], function( playerid, ... ) {
    local text = concat(vargv);
    inRadius("[nonRP] " + getPlayerName( playerid ) + ": " + text, playerid, NORMAL_RADIUS, CL_GRAY);
});


// global nonRP chat
cmd(["o","ooc"], function( playerid, ... ) {
    local text = concat(vargv);
    sendPlayerMessageToAll("[OOC] " + getPlayerName( playerid ) + ": " + text, CL_GRAY.r, CL_GRAY.g, CL_GRAY.b);
});


cmd("me", function( playerid, ... ) {
    local text = concat(vargv);
    inRadius("[ME] " + getPlayerName( playerid ) + " " + text, playerid, NORMAL_RADIUS, CL_YELLOW);
});


// random for some actions
cmd("try", function(playerid, ...) {
    local text = getPlayerName( playerid ) + "[TRY] " + concat(vargv);

    local res = random(0,1);
    if(res == 1)
        inRadius(text + " (success).", playerid, NORMAL_RADIUS);
    else
        inRadius(text + " (failed).", playerid, NORMAL_RADIUS);
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
        { name = "/b <text>",           desc = "Local nonRP chat"},
        { name = "/ooc <text>",         desc = "Global nonRP chat"},
        { name = "/me <action text>",   decs = "Some action of your person"},
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
