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
    cargoJobHelp ( playerid );
});

// usage: /help cargo job
cmd("help", ["cargo", "job"], function(playerid) {
    cargoJobHelp ( playerid );
});

function cargoJobHelp ( playerid ) {
    local title = "job.cargodriver.help.title";
    local commands = [
        { name = "/cargo job",        desc = "job.cargodriver.help.job" },
        { name = "/cargo job leave",  desc = "job.cargodriver.help.jobleave" },
        { name = "/cargo load",        desc = "job.cargodriver.help.load" },
        { name = "/cargo unload",      desc = "job.cargodriver.help.unload" },
        { name = "/cargo finish",      desc = "job.cargodriver.help.finish" }
    ];
    msg_help(playerid, title, commands);
}


// usage: /help cargo job
acmd("cargo", ["limit", "set"], function(playerid, limit) {
    cargoJobSetFishLimit( playerid, limit );
});

acmd("cargo", ["limit", "get"], function(playerid) {
    cargoJobGetFishLimit( playerid );
});
