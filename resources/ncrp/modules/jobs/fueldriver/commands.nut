// usage: /fuel job
cmd("fuel", "job", function(playerid) {
    fuelJob( playerid );
});

// usage: /fuel job leave
cmd("fuel", ["job", "leave"], function(playerid) {
    fuelJobLeave( playerid );
});

// usage: /fuel ready
cmd("fuel", "ready", function(playerid) {
    fuelJobReady( playerid );
});

// usage: /fuel load
cmd("fuel", "load", function(playerid) {
    fuelJobLoad( playerid );
});

// usage: /fuel unload
cmd("fuel", "unload", function(playerid) {
    fuelJobUnload( playerid );
});

// usage: /fuel finish
cmd("fuel", "park", function(playerid) {
    fuelJobPark( playerid );
});

// usage: /fuel finish
cmd("fuel", "check", function(playerid) {
    fuelJobCheck( playerid );
});

// usage: /fuel finish
cmd("fuel", "list", function(playerid) {
    fuelJobList( playerid );
});

// usage: /help job fuel
cmd("help", ["job", "fuel"], function(playerid) {
    fuelJobHelp ( playerid );
});

// usage: /help fuel job
cmd("help", ["fuel", "job"], function(playerid) {
    fuelJobHelp ( playerid );
});

function fuelJobHelp ( playerid ) {
    local title = "job.fueldriver.help.title";
    local commands = [
        { name = "/fuel job",       desc = "job.fueldriver.help.job" },
        { name = "/fuel job leave", desc = "job.fueldriver.help.leavejob" },
        { name = "/fuel ready",     desc = "job.fueldriver.help.ready" },
        { name = "/fuel load",      desc = "job.fueldriver.help.load" },
        { name = "/fuel unload",    desc = "job.fueldriver.help.unload" },
        { name = "/fuel park",      desc = "job.fueldriver.help.park" },
        { name = "/fuel check",     desc = "job.fueldriver.help.check" },
        { name = "/fuel list",      desc = "job.fueldriver.help.list" }
    ];
    msg_help(playerid, title, commands);
}
