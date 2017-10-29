/*
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
    fuelJobLoadUnload ( playerid );
});

// usage: /fuel unload
cmd("fuel", "unload", function(playerid) {
    fuelJobUnload( playerid );
});

// usage: /fuel finish
cmd("fuel", "park", function(playerid) {
    fuelJobPark( playerid );
});

*/
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
        { name = "job.fueldriver.help.job",      desc = "job.fueldriver.help.jobtext" },
        { name = "job.fueldriver.help.jobleave", desc = "job.fueldriver.help.jobleavetext" },
        { name = "job.fueldriver.help.loadunload",      desc = "job.fueldriver.help.loadunloadtext" },
        { name = "/fuel check",     desc = "job.fueldriver.help.check" },
        { name = "/fuel list",      desc = "job.fueldriver.help.list" }
    ];
    msg_help(playerid, title, commands);
}
