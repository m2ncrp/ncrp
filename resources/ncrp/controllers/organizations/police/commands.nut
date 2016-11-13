// usage: /police job
cmd("police", "job", function(playerid) {
    getPoliceJob(playerid);
});

// usage: /police job leave
cmd("police", ["job", "leave"], function(playerid) {
    leavePoliceJob(playerid);
});


cmd(["r", "ratio"], function(playerid, text) {
    if ( !isOfficer(playerid) ) {
        return;
    }

    // Enhaincment: loop through not players, but police vehicles with radio
    foreach (targetid in playerList) {
        if ( isOfficer(targetid) ) {
            msg( targetid, text, CL_BLUE );
        }
    }
});


cmd(["ticket"], function(playerid, targetid, reason) {
    if ( isOfficer(playerid) ) {
        // Code
    }
});


// Selfshot for now :3
cmd("taser", function( playerid ) {
    if ( isOfficer(playerid) ) {
        local targetid = playerList.nearestPlayer( playerid );
        dbg( targetid ); // Souldn't be NULL
        screenFadeinFadeout(playerid, 800, function() {
            msg( playerid, "You's been shot by taser" );
            togglePlayerControls( playerid, false );
        });
        togglePlayerControls( playerid, true );
    } else {
        msg( playerid, "You have no taser couse you're not a cop." );
    }
    
});


cmd(["cuff"], function(playerid) {
    if ( isOfficer(playerid) ) {
        // Code
    }
});


cmd(["prison", "jail"], function(playerid) {
    if ( isOfficer(playerid) ) {
        // Code
    }
});


// usage: /help job police
cmd("help", ["job", "police"], function(playerid) {
    local title = "List of available commands for Police Officer JOB:";
    local commands = [
        { name = "/police job",             desc = "Get police officer job" },
        { name = "/police job leave",       desc = "Leave from police department job" },
        { name = "/r <text>",               desc = "Send message to all police officers in vehicles"},
        { name = "/ticket <id> <amount>",   desc = "Take ticket to player given <id>. Example: /ticket 0 5.2" },
        { name = "/taser",                  desc = "Shock nearest player for 0.8 seconds" },
        { name = "/cuff",                   desc = "Use cuff for nearest player" },
        { name = "/prison",                 desc = "Put neares cuffed player in jail" }
    ];
    msg_help(playerid, title, commands);
});
