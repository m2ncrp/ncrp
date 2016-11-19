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
        { name = "/bus ready",      desc = "Go to the route (make the bus ready)"},
        { name = "/bus stop",       desc = "Check in bus stop" }
    ];
    msg_help(playerid, title, commands);
});

cmd("bus", "enter", function(playerid, busid) {
    triggerClientEvent(playerid, "onServerPlayerBusEnter", busid);
});

cmd("bus", "exit", function(playerid) {
    triggerClientEvent(playerid, "onServerPlayerBusExit");
});

addEventHandler("onClientRequestedPosition", function(playerid, x, y, z) {
    setPlayerPosition(playerid, x, y, z);
});
