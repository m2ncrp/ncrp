// usage: /fish job
cmd("fish", "job", function(playerid) {
    fishJob( playerid );
});

// usage: /fish job leave
cmd("fish", ["job", "leave"], function(playerid) {
    fishJobLeave( playerid );
});

// usage: /fish load
cmd("fish", "load", function(playerid) {
    fishJobLoad( playerid );
});

// usage: /fish unload
cmd("fish", "unload", function(playerid) {
    fishJobUnload( playerid );
});

// usage: /fish finish
cmd("fish", "finish", function(playerid) {
    fishJobFinish( playerid );
});

// usage: /help job fish
cmd("help", ["job", "fish"], function(playerid) {
    fishJobHelp ( playerid );
});

// usage: /help fish job
cmd("help", ["fish", "job"], function(playerid) {
    fishJobHelp ( playerid );
});

function fishJobHelp ( playerid ) {
    local title = "job.fishdriver.help.title";
    local commands = [
        { name = "/fish job",        desc = "job.fishdriver.help.job" },
        { name = "/fish job leave",  desc = "job.fishdriver.help.jobleave" },
        { name = "/fish load",        desc = "job.fishdriver.help.load" },
        { name = "/fish unload",      desc = "job.fishdriver.help.unload" },
        { name = "/fish finish",      desc = "job.fishdriver.help.finish" }
    ];
    msg_help(playerid, title, commands);
}


// usage: /help fish job
acmd("fish", ["limit", "set"], function(playerid, limit) {
    fishJobSetFishLimit( playerid, limit );
});

acmd("fish", ["limit", "get"], function(playerid) {
    fishJobGetFishLimit( playerid );
});

acmd("fish", ["limit", "new"], function(playerid, limit) {
    fishJobSetDefaultFishLimit( playerid, limit );
});
