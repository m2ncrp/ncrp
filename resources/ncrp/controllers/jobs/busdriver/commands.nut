// usage: /bus job
cmd("bus", "job", function(playerid) {
    busJob(playerid);
});

// usage: /bus job leave
cmd("bus", ["job", "leave"], function(playerid) {
    busJobLeave(playerid);
});

// usage: /bus job leave
cmd("bus", "ready", function(playerid) {
    busJobReady(playerid);
});

// usage: /bus job leave
cmd("bus", "stop", function(playerid) {
    busJobStop(playerid);
});

// usage: /help job bus
cmd("help", ["job", "bus"], function(playerid) {
    local title = "List of available commands for BUSDRIVER JOB:";
    local commands = [
        { name = "/bus job",        desc = "Get busdriver job" },
        { name = "/bus job leave",  desc = "Leave busdriver job" },
        { name = "/bus ready",      desc = "Go to the route (make the bus ready)"},
        { name = "/bus stop",       desc = "Check in bus stop" },
    ];
    msg_help(playerid, title, commands);
});
