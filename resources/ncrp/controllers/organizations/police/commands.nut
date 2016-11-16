// usage: /police job
// cmd("police", "job", function(playerid) {
//     getPoliceJob(playerid);
// });

// usage: /police job leave
// cmd("police", ["job", "leave"], function(playerid) {
//     leavePoliceJob(playerid);
// });

cmd("serial", function(playerid) {
    msg( playerid, "Your serial is: " + players[playerid]["serial"], CL_RED );
});

// usage: /police duty on
cmd("police", ["duty", "on"], function(playerid) {
    setPlayerModel(playerid, POLICE_MODEL);
});

// usage: /police duty off
cmd("police", ["duty", "off"], function(playerid) {
    setPlayerModel(playerid, players[playerid]["default_skin"]);
});

policecmd(["r", "ratio"], function(playerid, text) {
    if ( !isOfficer(playerid) ) {
        return;
    }
    if( !isPlayerInPoliceVehicle(playerid) ) {
        msg( playerid, "You should be in police vehicle!");
        return;
    }

    // Enhaincment: loop through not players, but police vehicles with radio has on
    foreach (targetid in playerList.getPlayers()) {
        if ( isOfficer(targetid) && isPlayerInPoliceVehicle(targetid) ) {
            msg( targetid, "[R] " + getAuthor(playerid) + ": " + text, CL_BLUE );
        }
    }
});

policecmd("rupor", function(playerid, text) {
    if ( !isOfficer(playerid) ) {
        return;
    }
    if ( !isPlayerInPoliceVehicle(playerid) ) {
        msg( playerid, "You should be in police vehicle!");
        return;
    }
    inRadiusSendToAll(playerid, "[RUPOR] " + text, RUPOR_RADIUS, CL_BLUE);
});


policecmd(["ticket"], function(playerid, targetid, price, reason) {
    if ( isOfficer(playerid) ) {
        msg(targetid, getAuthor(playerid) + " give you ticket for " + reason + " . Type /accept <id>");
        sendInvoice( playerid, targetid, price );
    }
});


cmd("taser", function( playerid ) {
    if ( isOfficer(playerid) ) {
        local targetid = playerList.nearestPlayer( playerid );
        dbg( targetid ); // Souldn't be NULL
        screenFadeinFadeout(playerid, 800, function() {
            msg( targetid, "You shot " + getAuthor(targetid) + " by taser." );
            msg( targetid, "You's been shot by taser" );
            togglePlayerControls( targetid, false );
        });
        togglePlayerControls( targetid, true );
    } else {
        msg( playerid, "You have no taser couse you're not a cop." );
    }
});


cmd(["cuff"], function(playerid) {
    if ( isOfficer(playerid) ) {
        local targetid = playerList.nearestPlayer( playerid );
        togglePlayerControls( targetid, false );
    }
});


// temporary command
cmd(["uncuff"], function(playerid) {
    if ( isOfficer(playerid) ) {
        local targetid = playerList.nearestPlayer( playerid );
        togglePlayerControls( targetid, true );
    }
});

cmd(["prison", "jail"], function(playerid) {
    if ( isOfficer(playerid) ) {
        togglePlayerControls( targetid, false );
        //  fade in, output "Wasted" and set player position
    }
});


// usage: /help job police
cmd("help", ["job", "police"], function(playerid) {
    local title = "List of available commands for Police Officer JOB:";
    local commands = [
        { name = "/police job",             desc = "Get police officer job" },
        { name = "/police job leave",       desc = "Leave from police department job" },
        { name = "/r <text>",               desc = "Send message to all police officers in vehicles"},
        { name = "/rupor <text>",           desc = "Say smth to vehicle rupor"},
        { name = "/ticket <id> <amount>",   desc = "Take ticket to player given <id>. Example: /ticket 0 5.2" },
        { name = "/taser",                  desc = "Shock nearest player for 0.8 seconds" },
        { name = "/cuff",                   desc = "Use cuff for nearest player" },
        { name = "/prison",                 desc = "Put neares cuffed player in jail" }
    ];
    msg_help(playerid, title, commands);
});
