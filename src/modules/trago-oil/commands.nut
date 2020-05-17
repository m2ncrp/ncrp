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
