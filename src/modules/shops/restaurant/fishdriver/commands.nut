/*
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
*/
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
    local desc = "job.fishdriver.help.all";
    msg(playerid, "==================================", CL_HELP_LINE);
    msg(playerid, plocalize(playerid, title), CL_HELP_TITLE);
    msg(playerid, plocalize(playerid, desc), CL_HELP);
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
