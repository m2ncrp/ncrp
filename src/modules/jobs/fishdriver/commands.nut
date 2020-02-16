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
