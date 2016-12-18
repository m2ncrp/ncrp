/*
    BINDS SHOW UP MESSAGE EVERY TIME IF PLAYER CONTACT WITH VEHICLE OR DOORS WHILE ON DUTY
 */

// usage: /police job <id>
acmd("police", "job", function(playerid, targetid) {
    local targetid = targetid.tointeger();
    getPoliceJob(targetid);
    msg(playerid, "organizations.police.setjob.byadmin", [ getAuthor(targetid), getLocalizedPlayerJob(targetid) ] );
    dbg( "[POLICE JOIN]" + getAuthor(playerid) + " add " + getAuthor(targetid) + "to Police" );
});

// usage: /police job leave <id>
acmd("police", ["job", "leave"], function(playerid, targetid) {
    local targetid = targetid.tointeger();
    msg(playerid, "organizations.police.leavejob.byadmin", [ getAuthor(targetid), getLocalizedPlayerJob(targetid) ]);
    dbg( "[POLICE LEAVE]" + getAuthor(playerid) + " remove " + getAuthor(targetid) + "from Police" );
    leavePoliceJob(targetid);
});

// usage: /police set rank <1..3>
acmd("police", ["set", "rank"], function(playerid, targetid, rank) {
    targetid = targetid.tointeger();
    rank = rank.tointeger();
    if ( !isOfficer(targetid) ) {
        return msg(playerid, "organizations.police.notanofficer"); // not you, but target
    }

    if ( isOnPoliceDuty(playerid) ) {
        // onPoliceDutyRemoveWeapon( playerid );
        trigger("onPoliceDutyOff", playerid);
        setPoliceRank( playerid, rank );
        // onPoliceDutyGiveWeapon( playerid );
        trigger("onPoliceDutyOn", playerid);
        setPlayerJob ( playerid, getPlayerJob(playerid) );
    } else {
        setPoliceRank( playerid, rank );
        setPlayerJob ( playerid, getPlayerJob(playerid) );
    }
});

acmd("serial", function(playerid, targetid) {
    local targetid = targetid.tointeger();
    dbg( [players[targetid]["serial"]] );
    return msg( playerid, "general.admins.serial.get", [getAuthor(targetid), players[targetid]["serial"]], CL_THUNDERBIRD );
});

// usage: /police Train Station
cmd("police", function(playerid, ...) {
    local place = concat(vargv);
    policeCall(playerid, place);

    local data = url_encode(base64_encode(format("%s: %s", getAuthor(playerid), concat(vargv))));
    webRequest(HTTP_TYPE_GET, MOD_HOST, "/discord?type=police&data=" + data, function(a,b,c) {}, 7790);
});


cmd("police", ["badge"], function(playerid, targetid = null) {
    local nearestid = targetid;
    if (targetid != null) {
        nearestid = targetid.tointeger();
    } else {
        nearestid = playerList.nearestPlayer( playerid );
    }

    if ( nearestid == null) {
        return msg(playerid, "general.noonearound");
    }

    showBadge(playerid, targetid);
});

key(["b"], function(playerid) {
    if ( !isOfficer(playerid) ) {
        return;
    }
    if ( isOfficer(playerid) && !isOnPoliceDuty(playerid) ) {
        return msg( playerid, "organizations.police.duty.off" );
    }
    
    local target = playerList.nearestPlayer( playerid );
    if ( target == null) {
        return msg(playerid, "general.noonearound");
    }

    if ( isBothInRadius(playerid, target, POLICE_BADGE_RADIUS) ) {
        showBadge(playerid);
    }
}, KEY_UP);



// usage: /police duty on
cmd("police", ["duty", "on"], function(playerid) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.notanofficer");
    }
    if ( !isOnPoliceDuty(playerid) ) {
        policeSetOnDuty(playerid, true);    // <------------------------------- Set only on police dep
    } else {
        return msg(playerid, "organizations.police.duty.alreadyon");
    }
});

// usage: /police duty off
cmd("police", ["duty", "off"], function(playerid) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.notanofficer");
    }
    if ( isOnPoliceDuty(playerid) ) {
        return policeSetOnDuty(playerid, false);// <------------------------------- Set only on police dep
    } else {
        return msg(playerid, "organizations.police.duty.alreadyoff");
    }
});

policecmd(["r", "ratio"], function(playerid, text) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.notanofficer");
    }
    if( !isPlayerInPoliceVehicle(playerid) ) {
        return msg( playerid, "organizations.police.notinpolicevehicle");
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
        return msg( playerid, "organizations.police.notinpolicevehicle");
    }
    inRadiusSendToAll(playerid, "[RUPOR] " + text, RUPOR_RADIUS, CL_ROYALBLUE);
});


cmd(["ticket"], function(playerid, targetid, price, ...) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.notanofficer");
    }
    if ( isOnPoliceDuty(playerid) ) {
        local reason = makeMeText(playerid, vargv);
        msg(targetid, "organizations.police.ticket.givewithreason", [getAuthor(playerid), reason, playerid]);
        sendInvoice( playerid, targetid, price );
    } else {
        return msg(playerid, "organizations.police.offduty.notickets")
    }
});


function baton( playerid ) {
    if ( !isOfficer(playerid) ) {
        return msg( playerid, "organizations.police.notanofficer" );
    }

    if ( isOnPoliceDuty(playerid) ) {
        local targetid = playerList.nearestPlayer( playerid );
        if ( targetid == null ) {
            return msg(playerid, "general.noonearound");
        }

        if ( isBothInRadius(playerid, targetid, BATON_RADIUS) ) {
            screenFadeinFadeout(targetid, 1000, function() {
                msg( playerid, "organizations.police.bitsomeone.bybaton", [getAuthor(targetid)] );
                msg( targetid, "organizations.police.beenbit.bybaton" );
                if ( getPlayerState(targetid) == "free" ) {
                    setPlayerToggle( targetid, true );
                    setPlayerState(targetid, "tased");
                }
            }, function() {
                if ( getPlayerState(targetid) == "tased" ) {
                    setPlayerToggle( targetid, false );
                    setPlayerState(targetid, "free");
                }
            });
        }        
    } else {
        return msg(playerid, "organizations.police.offduty.nobaton")
    }
}

key(["e"], function(playerid) {
    if ( isPlayerInVehicle(playerid) || isPlayerInVehicle(playerid) ) {
        return;
    }
    if ( !isOfficer(playerid) ) {
        return;
    }
    if ( isOfficer(playerid) && !isOnPoliceDuty(playerid) ) {
        return msg( playerid, "organizations.police.duty.off" );
    }
    // print("Player pressed e");
    baton(playerid);
}, KEY_UP);


function cuff(playerid) {
    if ( isOnPoliceDuty(playerid) ) {
        local targetid = playerList.nearestPlayer( playerid );

        if ( targetid == null ) {
            return msg(playerid, "general.noonearound");
        }

        if ( isBothInRadius(playerid, targetid, CUFF_RADIUS) ) {
            if ( getPlayerState(targetid) == "tased" ) {
                setPlayerToggle( targetid, true ); // cuff dat bitch
                setPlayerState(targetid, "cuffed");
                msg(targetid, "organizations.police.beencuffed", [getAuthor( playerid )]);
                msg(playerid, "organizations.police.cuff.someone", [getAuthor( targetid )]);
                return;
            }
            if ( getPlayerState(targetid) == "cuffed" ) {
                setPlayerToggle( targetid, false ); // uncuff him...
                setPlayerState(targetid, "free");
                msg(targetid, "organizations.police.cuff.beenuncuffed", [getAuthor( playerid )] );
                msg(playerid, "organizations.police.cuff.uncuffsomeone", [getAuthor( targetid )] );
                return;
            }
            // throw out cuffes and disable arrest any players till officer didn't take them from the ground 
        }
    }
}

key(["q"], function(playerid) {
    if ( isPlayerInVehicle(playerid) ) {
        return;
    }
    if ( !isOfficer(playerid) ) {
        return;
    }
    if ( isOfficer(playerid) && !isOnPoliceDuty(playerid) ) {
        return msg( playerid, "organizations.police.duty.off" );
    }
    // print("Player pressed q");
    cuff(playerid);
}, KEY_UP);

// put nearest cuffed player in jail
cmd(["prison", "jail"], function(playerid, targetid) {
    targetid = targetid.tointeger();
    if ( isOnPoliceDuty(playerid) ) {
        togglePlayerControls( targetid, true );
        screenFadein(targetid, 2000, function() {
        //  output "Wasted" and set player position
            setPlayerPosition( targetid, 0.0, 0.0, 0.0 );
        });
    }
});

// take out player from jail
cmd(["amnesty"], function(playerid, targetid) {
    targetid = targetid.tointeger();
    if ( isOnPoliceDuty(playerid) ) {
        setPlayerPosition(targetid, -380.856, 652.657, -11.6902); // police department
        //setPlayerRotation(targetid, -137.53, 0.00309768, -0.00414733);

        screenFadeout(targetid, 2200, function() {
            togglePlayerControls( targetid, false );
        });
    }
})

function policeHelp(playerid, a = null, b = null) {
    msg( playerid, "organizations.police.info.howjoin" );
    local title = "organizations.police.info.cmds.helptitle";
    local commands = [
        // { name = "/police job",             desc = "Get police officer job" },
        // { name = "/police job leave",       desc = "Leave from police department job" },
        { name = "/police duty on",             desc = "organizations.police.info.cmds.dutyon"},
        { name = "/police duty off",            desc = "organizations.police.info.cmds.dutyoff"},
        { name = "/r TEXT",                     desc = "organizations.police.info.cmds.ratio"},
        { name = "/rupor TEXT",                 desc = "organizations.police.info.cmds.rupor"},
        { name = "/ticket ID AMOUNT REASON",    desc = "organizations.police.info.cmds.ticket" },
        { name = "E button",                    desc = "organizations.police.info.cmds.baton" },
        { name = "Q button",                    desc = "organizations.police.info.cmds.cuff" },
        { name = "/prison ID",                  desc = "organizations.police.info.cmds.prison" },
        { name = "/amnesty ID",                 desc = "organizations.police.info.cmds.amnesty" }
    ];
    msg_help(playerid, title, commands);
}

// usage: /help job police
cmd("help", ["job", "police"], policeHelp);
cmd("help", ["police"], policeHelp);
cmd("help", ["police", "job"], policeHelp);
