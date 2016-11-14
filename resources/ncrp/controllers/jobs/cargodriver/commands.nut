// usage: /cargo job
cmd("cargo", "job", function(playerid) {
    cargoJob( playerid );
});

// usage: /cargo job leave
cmd("cargo", ["job", "leave"], function(playerid) {
    cargoJobLeave( playerid );
});

// usage: /cargo load
cmd("cargo", "load", function(playerid) {
    cargoJobLoad( playerid );
});

// usage: /cargo unload
cmd("cargo", "unload", function(playerid) {
    cargoJobUnload( playerid );
});

// usage: /cargo finish
cmd("cargo", "finish", function(playerid) {
    cargoJobFinish( playerid );
});

// usage: /help job cargo
cmd("help", ["job", "cargo"], function(playerid) {
    local title = "List of available commands for CARGODRIVER JOB:";
    local commands = [
        { name = "/cargo job",        desc = "Get cargo delivery driver job" },
        { name = "/cargo job leave",  desc = "Leave cargo delivery driver job" },
        { name = "/cargo load",        desc = "Load cargo into truck" },
        { name = "/cargo unload",      desc = "Unload cargo" },
        { name = "/cargo finish",      desc = "Report to Derek and get money" }
    ];
    msg_help(playerid, title, commands);
});
