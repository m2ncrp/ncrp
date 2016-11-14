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
    local title = "List of available commands for FUELDRIVER JOB:";
    local commands = [
        { name = "/fuel job",       desc = "Get fueldriver job" },
        { name = "/fuel job leave", desc = "Leave fueldriver job" },
        { name = "/fuel ready",     desc = "Start delivery (make the truck ready)" },
        { name = "/fuel load",      desc = "Load fuel into truck" },
        { name = "/fuel unload",    desc = "Unload fuel to fuel station" },
        { name = "/fuel park",      desc = "Park the truck to Trago Oil parking" },
        { name = "/fuel check",     desc = "Checking loading truck" },
        { name = "/fuel list",      desc = "See list of route" }
    ];
    msg_help(playerid, title, commands);
});
