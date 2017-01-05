// usage: /porter job
cmd("porter", "job", function(playerid) {
    porterJob( playerid );
});

// usage: /porter job leave
cmd("porter", ["job", "leave"], function(playerid) {
    porterJobLeave( playerid );
});

// usage: /porter ready
cmd("porter", "take", function(playerid) {
    porterJobTakeBox( playerid );
});

// usage: /porter load
cmd("porter", "put", function(playerid) {
    porterJobPutBox( playerid );
});

key(["e"], function(playerid) {
    if ( isPlayerInVehicle(playerid) ) {
        return;
    }
    if ( !isPorter(playerid) ) {
        return;
    }
    if ( !isPorterHaveBox(playerid) ) {
        porterJobTakeBox( playerid );
    } else {
        porterJobPutBox( playerid );
    }
}, KEY_UP);

// usage: /help job porter
cmd("help", ["job", "porter"], function(playerid) {
    porterJobHelp ( playerid );
});

// usage: /help porter job
cmd("help", ["porter", "job"], function(playerid) {
    porterJobHelp ( playerid );
});

// usage: /porter
cmd("porter", function(playerid) {
    porterJobHelp ( playerid );
});

// usage: /help porter
cmd("help", "porter", function(playerid) {
    porterJobHelp ( playerid );
});

function porterJobHelp ( playerid ) {
    local title = "job.porter.help.title";
    local commands = [
        { name = "/porter job",       desc = "job.porter.help.job" },
        { name = "/porter job leave", desc = "job.porter.help.jobleave" },
        { name = "/porter take",      desc = "job.porter.help.take" },
        { name = "/porter put",       desc = "job.porter.help.put" }
    ];
    msg_help(playerid, title, commands);
}
