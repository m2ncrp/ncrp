// usage: /police job
// cmd("police", "job", function(playerid) {
//     getPoliceJob(playerid);
// });

// usage: /police job leave
// cmd("police", ["job", "leave"], function(playerid) {
//     leavePoliceJob(playerid);
// });

cmd("serial", function(playerid) {
    msg( playerid, "Your serial is: " + players[playerid]["serial"], CL_THUNDERBIRD );
});

// usage: /police duty on
cmd("police", ["duty", "on"], function(playerid) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "You're not a police officer.");
    }
    if ( !isOnDuty(playerid) ) {
        setOnDuty(playerid, true);
        // givePlayerWeapon( playerid, 2, 0 ); // should be called once at spawn or zero ammo to prevent using infinite ammo usage in combats
        return screenFadeinFadeout(playerid, 100, function() {
                    setPlayerModel(playerid, POLICE_MODEL);
                });
    } else {
        return msg(playerid, "You're already on duty now.");
    }
});

// usage: /police duty off
cmd("police", ["duty", "off"], function(playerid) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "You're not a police officer.");
    }
    if ( isOnDuty(playerid) ) {
        setOnDuty(playerid, false);
        // removePlayerWeapon( playerid, 2 ); // remove at all
        return screenFadeinFadeout(playerid, 100, function() {
                    setPlayerModel(playerid, players[playerid]["default_skin"]);
                });
    } else {
        return msg(playerid, "You're already off duty now.");
    }
});

policecmd(["r", "ratio"], function(playerid, text) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "You're not a police officer.");
    }
    if( !isPlayerInPoliceVehicle(playerid) ) {
        msg( playerid, "You should be in police vehicle!");
        return;
    }

    // Enhaincment: loop through not players, but police vehicles with radio has on
    foreach (targetid in playerList.getPlayers()) {
        if ( isOfficer(targetid) && isPlayerInPoliceVehicle(targetid) ) {
            msg( targetid, "[R] " + getAuthor(playerid) + ": " + text, CL_ROYALBLUE );
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
    inRadiusSendToAll(playerid, "[RUPOR] " + text, RUPOR_RADIUS, CL_ROYALBLUE);
});


cmd(["ticket"], function(playerid, targetid, price, ...) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "You're not a police officer.");
    }
    if ( isOnDuty(playerid) ) {
        local reason = makeMeText(playerid, vargv);
        msg(targetid, getAuthor(playerid) + " give you ticket for " + reason + " . Type /accept <id>");
        sendInvoice( playerid, targetid, price );
    } else {
        return msg(playerid, "You off the duty now and you haven't tickets.")
    }
});


cmd("taser", function( playerid ) {
    if ( !isOfficer(playerid) ) {
        return msg( playerid, "You have no taser couse you're not a cop." );
    }

    if ( isOnDuty(playerid) ) {
        local targetid = playerList.nearestPlayer( playerid );
        dbg( targetid ); // Souldn't be NULL
        screenFadeinFadeout(targetid, 800, function() {
            msg( playerid, "You shot " + getAuthor(targetid) + " by taser." );
            msg( targetid, "You's been shot by taser" );
            togglePlayerControls( targetid, false );
        });
        togglePlayerControls( targetid, true );
    } else {
        return msg(playerid, "You off the duty now and you haven't taser.")
    }
});


cmd(["cuff"], function(playerid) {
    if ( isOnDuty(playerid) ) {
        local targetid = playerList.nearestPlayer( playerid );

        if ( targetid == null) {
            return msg(playerid, "There's noone around near you.");
        }

        if ( isBothInRadius(playerid, targetid, CUFF_RADIUS) ) {
            togglePlayerControls( targetid, true );
            msg(targetid, "You've been cuffed by " + getAuthor( playerid ) + " .");
            msg(playerid, "You cuffed " + getAuthor( targetid ) + " .");
        }
    }
});


// temporary command
cmd(["uncuff"], function(playerid) {
    if ( isOnDuty(playerid) ) {
        local targetid = playerList.nearestPlayer( playerid );
        
        if ( targetid == null) {
            return msg(playerid, "There's noone around near you.");
        }

        if ( isBothInRadius(playerid, targetid, CUFF_RADIUS) ) {
            togglePlayerControls( targetid, false );
            msg(targetid, "You've been uncuffed by " + getAuthor( playerid ) + " .");
            msg(playerid, "You uncuffed " + getAuthor( targetid ) + " .");
        }
    }
});

cmd(["prison", "jail"], function(playerid, targetid) {
    targetid = targetid.tointeger();
    if ( isOnDuty(playerid) ) {
        screenFadein(targetid, 1500, function() {
            togglePlayerControls( targetid, true );
        //  output "Wasted" and set player position
            setPlayerPosition( targetid, 0.0, 0.0, 0.0 );
        });        
    }
});

cmd(["amnesty"], function(playerid, targetid) {
    targetid = targetid.tointeger();
    if ( isOnDuty(playerid) ) {
        screenFadeout(targetid, 1500, function() {
            togglePlayerControls( targetid, false );
            local spawnID = players[targetid]["spawn"];
            local x = default_spawns[spawnID][0];
            local y = default_spawns[spawnID][1];
            local z = default_spawns[spawnID][2];
            setPlayerPosition(targetid, x, y, z);
        });        
    }
})


// usage: /help job police
cmd("help", ["job", "police"], function(playerid) {
    msg( playerid, "If you want to join Police Department write one of admins!" );
    local title = "List of available commands for Police Officer JOB:";
    local commands = [
        // { name = "/police job",             desc = "Get police officer job" },
        // { name = "/police job leave",       desc = "Leave from police department job" },
        { name = "/r <text>",               desc = "Send message to all police officers in vehicles"},
        { name = "/rupor <text>",           desc = "Say smth to vehicle rupor"},
        { name = "/ticket <id> <amount>",   desc = "Take ticket to player given <id>. Example: /ticket 0 5.2" },
        { name = "/taser",                  desc = "Shock nearest player for 0.8 seconds" },
        { name = "/cuff",                   desc = "Use cuff for nearest player" },
        { name = "/prison",                 desc = "Put neares cuffed player in jail" }
    ];
    msg_help(playerid, title, commands);
});
