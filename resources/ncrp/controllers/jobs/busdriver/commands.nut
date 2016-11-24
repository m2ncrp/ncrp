// usage: /bus job
cmd("bus", "job", function(playerid) {
    busJob(playerid);
});

// usage: /bus job leave
cmd("bus", ["job", "leave"], function(playerid) {
    busJobLeave(playerid);
});

// usage: /bus list
cmd("bus", "list", function(playerid) {
    busJobRoutes(playerid);
});

// usage: /bus route 5
cmd("bus", "route", function(playerid, route) {
    busJobSelectRoute(playerid, route.tointeger());
});


// usage: /bus ready
cmd("bus", "ready", function(playerid) {
    busJobReady(playerid);
});

// usage: /bus stop
cmd("bus", "stop", function(playerid) {
    busJobStop(playerid);
});

// usage: /help job bus
cmd("help", ["job", "bus"], function(playerid) {
    local title = "List of available commands for BUSDRIVER JOB:";
    local commands = [
        { name = "/bus job",        desc = "Get busdriver job" },
        { name = "/bus job leave",  desc = "Leave busdriver job" },
        { name = "/bus list",       desc = "Show list of available routes"},
        { name = "/bus route <id>", desc = "Select route. Example: /bus route 3"},
        { name = "/bus ready",      desc = "Go to the route (make the bus ready)"},
        { name = "/bus stop",       desc = "Check in bus stop" }
    ];
    msg_help(playerid, title, commands);
});

cmd("bus", "enter", function(playerid, busid) {
    foreach (idx, value in players) {
        triggerClientEvent(idx, "onServerPlayerBusEnter", playerid, busid.tointeger());
    }
});

cmd("bus", "exit", function(playerid, busid) {
    foreach (idx, value in players) {
        triggerClientEvent(idx, "onServerPlayerBusExit", playerid, busid.tointeger());
    }
});
