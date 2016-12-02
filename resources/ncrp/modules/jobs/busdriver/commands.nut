// usage: /bus job
cmd("bus", "job", function(playerid) {
    busJob(playerid);
});

// usage: /bus job leave
cmd("bus", ["job", "leave"], function(playerid) {
    busJobLeave(playerid);
});

// usage: /bus route list
cmd("bus", ["route", "list"], function(playerid) {
    busJobRoutes(playerid);
});

// usage: /bus route 5
cmd("bus", "route", function(playerid, route = null) {
    busJobSelectRoute(playerid, route);
});

// usage: /bus ready
cmd("bus", "ready", function(playerid) {
    busJobReady(playerid);
});

// usage: /bus stop
cmd("bus", "stop", function(playerid) {
    busJobStop(playerid);
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

function busJobHelp ( playerid ) {
    local title = "job.bus.help.title";
    local commands = [
        { name = "/bus job",        desc = "job.bus.help.job" },
        { name = "/bus job leave",  desc = "job.bus.help.jobleave" },
        { name = "/bus route list", desc = "job.bus.help.routelist" },
        { name = "/bus route ID", desc = "job.bus.help.route" },
        { name = "/bus ready",      desc = "job.bus.help.ready" },
        { name = "/bus stop",       desc = "job.bus.help.busstop" }
    ];
    msg_help(playerid, title, commands);
}

cmd("help", "bus", busJobHelp );
cmd("help", ["job", "bus"], busJobHelp );
cmd("help", ["bus", "job"], busJobHelp );
cmd("job", ["bus", "help"], busJobHelp );
cmd("bus", ["job", "help"], busJobHelp );
cmd("bus", busJobHelp );
