/*
// usage: /milk job
cmd("milk", "job", function(playerid) {
    milkJob( playerid );
});

// usage: /milk job leave
cmd("milk", ["job", "leave"], function(playerid) {
    milkJobLeave( playerid );
});

// usage: /milk ready
cmd("milk", "ready", function(playerid) {
    milkJobReady( playerid );
});

// usage: /milk load
cmd("milk", "load", function(playerid) {
    milkJobLoad( playerid );
});

// usage: /milk unload
cmd("milk", "unload", function(playerid) {
    milkJobUnload( playerid );
});

// usage: /milk finish
cmd("milk", "park", function(playerid) {
    milkJobPark( playerid );
});
*/

// usage: /milk finish
cmd("milk", "check", function(playerid) {
    milkJobCheck( playerid );
});

// usage: /milk finish
cmd("milk", "list", function(playerid) {
    milkJobList( playerid );
});

// usage: /help job milk
cmd("help", ["job", "milk"], function(playerid) {
    milkJobHelp ( playerid );
});

// usage: /help job milk
cmd("help", ["milk", "job"], function(playerid) {
    milkJobHelp ( playerid );
});



function milkJobHelp ( playerid ) {
    local title = "job.milkdriver.help.title";
    local commands = [
        { name = "job.milkdriver.help.all",     desc = "" },
        { name = "/milk check",     desc = "job.milkdriver.help.check" },
        { name = "/milk list",      desc = "job.milkdriver.help.list" }
    ];
    msg_help(playerid, title, commands);
}
