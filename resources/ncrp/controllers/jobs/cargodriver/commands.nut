// usage: /help job cargo
cmd("help", ["job", "cargo"], function(playerid) {
    local title = "List of available commands for CARGODRIVER JOB:";
    local commands = [
        { name = "/job_cargo",        desc = "Get cargo delivery driver job" },
        { name = "/job_cargo_leave",  desc = "Leave cargo delivery driver job" },
        { name = "/loadcargo",        desc = "Load cargo into truck" },
        { name = "/unloadcargo",      desc = "Unload cargo" },
        { name = "/cargofinish",      desc = "Report to Derek and get money" }
    ];
    msg_help(playerid, title, commands);
});
