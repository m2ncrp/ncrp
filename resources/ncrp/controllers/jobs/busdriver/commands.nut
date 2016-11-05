// usage: /help job bus
cmd("help", ["job", "bus"], function(playerid) {
    local title = "List of available commands for BUSDRIVER JOB:";
    local commands = [
        { name = "/bus job",        desc = "Get busdriver job" },
        { name = "/bus job leave",  desc = "Leave busdriver job" },
        { name = "/busready",       desc = "Go to the route (make the bus ready)"},
        { name = "/busstop",        desc = "Check in bus stop" },
    ];
    msg_help(playerid, title, commands);
});
