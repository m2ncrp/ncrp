// usage: /milk job
cmd("milk", "job", function(playerid) {
    milkJob( playerid );
});

// usage: /milk job leave
cmd("milk", ["job", "leave"], function(playerid) {
    milkJobLeave( playerid );
});

// usage: /milk ready
cmd("milk", "ready", function(playerid) {
    milkJobReady( playerid );
});

// usage: /milk load
cmd("milk", "load", function(playerid) {
    milkJobLoad( playerid );
});

// usage: /milk unload
cmd("milk", "unload", function(playerid) {
    milkJobUnload( playerid );
});

// usage: /milk finish
cmd("milk", "park", function(playerid) {
    milkJobPark( playerid );
});

// usage: /milk finish
cmd("milk", "check", function(playerid) {
    milkJobCheck( playerid );
});

// usage: /milk finish
cmd("milk", "list", function(playerid) {
    milkJobList( playerid );
});

// usage: /help job milk
cmd("help", ["job", "milk"], function(playerid) {
    local title = "List of available commands for MILKDRIVER JOB:";
    local commands = [
        { name = "/milk job",       desc = "Get milkdriver job" },
        { name = "/milk job leave", desc = "Leave milkdriver job" },
        { name = "/milk ready",     desc = "Start delivery (make the milk car ready)" },
        { name = "/milk load",      desc = "Load milk into milk car" },
        { name = "/milk unload",    desc = "Unload milk to institution" },
        { name = "/milk park",      desc = "Park the milk car to Empire Bay Milk Company parking" },
        { name = "/milk check",     desc = "Checking loading car" },
        { name = "/milk list",      desc = "See list of route" }
    ];
    msg_help(playerid, title, commands);
});
