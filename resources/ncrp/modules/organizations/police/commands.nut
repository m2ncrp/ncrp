include("modules/organizations/police/models/PoliceTicket.nut");

acmd("a", ["police", "danger"], function(playerid, level) {
    setDangerLevel(playerid, level);
});


// usage: /police job <id>
acmd("a", ["police", "job"], function(playerid, targetid) {
    local targetid = targetid.tointeger();
    getPoliceJob(targetid);
    msg(playerid, "organizations.police.setjob.byadmin", [ getAuthor(targetid), getLocalizedPlayerJob(targetid) ] );
    dbg( "[POLICE JOIN]" + getAuthor(playerid) + " add " + getAuthor(targetid) + "to Police" );
});


// usage: /police job leave <id>
acmd("a", ["police", "job", "leave"], function(playerid, targetid) {
    local targetid = targetid.tointeger();
    msg(playerid, "organizations.police.leavejob.byadmin", [ getAuthor(targetid), getLocalizedPlayerJob(targetid) ]);
    dbg( "[POLICE LEAVE]" + getAuthor(playerid) + " remove " + getAuthor(targetid) + "from Police" );
    leavePoliceJob(targetid);
});


// usage: /police set rank <0..14>
acmd("a", ["police", "set", "rank"], function(playerid, targetid, rank) {
    targetid = targetid.tointeger();
    rank = rank.tointeger();

    if ( !isOfficer(targetid) ) {
        return msg(playerid, "organizations.police.notanofficer"); // not you, but target
    }

    if (rank >= 0 && rank < POLICE_RANK.len()) {
        if ( isOnPoliceDuty(playerid) ) {
            trigger("onPoliceDutyOff", playerid);
            setPoliceRank( targetid, rank );
            trigger("onPoliceDutyOn", playerid);
            setPlayerJob( targetid, POLICE_RANK[rank] );
            msg( playerid, "organizations.police.onrankset", [getAuthor(targetid), getLocalizedPlayerJob(targetid)]);
        } else {
            setPoliceRank( targetid, rank );
            setPlayerJob( targetid, POLICE_RANK[rank] );
            msg( playerid, "organizations.police.onrankset", [getAuthor(targetid), getLocalizedPlayerJob(targetid)]);
        }
    }
});


acmd("serial", function(playerid, targetid) {
    local targetid = targetid.tointeger();
    dbg( [players[targetid]["serial"]] );
    return msg( playerid, "general.admins.serial.get", [getAuthor(targetid), players[targetid]["serial"]], CL_THUNDERBIRD );
});


/*
// usage: /police Train Station
cmd("police", function(playerid, ...) {
    local place = concat(vargv);

    // local pos = getPlayerPositionObj(playerid);
    // local data = url_encode(base64_encode(format("%s: %s; coord [%.3f, %.3f, %.3f]", getAuthor(playerid), concat(vargv), pos.x, pos.y, pos.z)));
    // webRequest(HTTP_TYPE_GET, MOD_HOST, "/discord?type=police&data=" + data, function(a,b,c) {}, MOD_PORT);

});
*/

// usage in phone booth: /police
cmd("police", function(playerid) {
    __commands["call"][COMMANDS_DEFAULT](playerid, "police");
});


// usage: /police job <id>
cmd("police", ["job"], function(playerid, targetid) {
    local targetid = targetid.tointeger();
    if ( getPoliceRank(playerid) == POLICE_MAX_RANK ) {
        if ( isPlayerHaveJob(targetid) ) {
            msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), CL_RED);
            return;
        }

        getPoliceJob(targetid);
        msg(playerid, "organizations.police.setjob.byadmin", [getAuthor(targetid), getLocalizedPlayerJob(targetid)]);
        dbg( "[POLICE JOIN]" + getAuthor(playerid) + " add " + getAuthor(targetid) + "to Police" );
    }
});


// usage: /police job leave <id>
cmd("police", ["job", "leave"], function(playerid, targetid) {
    local targetid = targetid.tointeger();
    if ( getPoliceRank(playerid) == POLICE_MAX_RANK ) {
        dbg( "[POLICE LEAVE]" + getAuthor(playerid) + " remove " + getAuthor(targetid) + "from Police" );
        msg(playerid, "organizations.police.leavejob.byadmin", [ getAuthor(targetid), getLocalizedPlayerJob(targetid) ]);
        leavePoliceJob(targetid);
    }
});


// usage: /police set rank <0..14>
cmd("police", ["set", "rank"], function(playerid, targetid, rank) {
    targetid = targetid.tointeger();
    rank = rank.tointeger();
    if ( getPoliceRank(playerid) == POLICE_MAX_RANK ) {
        if ( !isOfficer(targetid) ) {
            return msg(playerid, "organizations.police.notanofficer"); // not you, but target
        }

        if ( isOnPoliceDuty(playerid) ) {
            trigger("onPoliceDutyOff", playerid);
            setPoliceRank( targetid, rank );
            trigger("onPoliceDutyOn", playerid);
            setPlayerJob ( targetid, POLICE_RANK[rank] );
            msg( playerid, "organizations.police.onrankset", [getAuthor(targetid), getLocalizedPlayerJob(targetid)]);
        } else {
            setPoliceRank( targetid, rank );
            setPlayerJob ( targetid, POLICE_RANK[rank] );
            msg( playerid, "organizations.police.onrankset", [getAuthor(targetid), getLocalizedPlayerJob(targetid)]);
        }
    }
});


cmd("police", ["danger"], function(playerid, level) {
    if ( getPoliceRank(playerid) == POLICE_MAX_RANK ) {
        setDangerLevel(playerid, level);
    }
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


// show badge
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
        if ( isPlayerNearPoliceDepartment(playerid) ) { // <------------------------------- Set only on police dep
            return policeSetOnDuty(playerid, true);
        }
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
        if ( isPlayerNearPoliceDepartment(playerid) ) { // <------------------------------- Set only on police dep
            return policeSetOnDuty(playerid, false);
        }
    } else {
        return msg(playerid, "organizations.police.duty.alreadyoff");
    }
});


// set duty on or off
key(["e"], function(playerid) {
    if ( isPlayerInVehicle(playerid) ) {
        return;
    }
    if ( !isOfficer(playerid) && isPlayerNearPoliceDepartment(playerid) ) {
        return msg( playerid, "organizations.police.notanofficer" );
    }
    if ( isOfficer(playerid) && isPlayerNearPoliceDepartment(playerid) ) {
        local bool = isOnPoliceDuty(playerid);
        policeSetOnDuty(playerid, !bool);
    }
}, KEY_UP);


policecmd(["r", "radio"], function(playerid, text) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.notanofficer");
    }
    if( !isPlayerInPoliceVehicle(playerid) ) {
        return msg( playerid, "organizations.police.notinpolicevehicle");
    }

    // Enhaincment: loop through not players, but police vehicles with radio has on
    foreach (targetid, player in players) {
        if ( (isOfficer(targetid) && isPlayerInPoliceVehicle(targetid)) || isPlayerAdmin(targetid) ) {
            msg( targetid, "[POLICE RADIO] " + getAuthor(playerid) + ": " + text, CL_ROYALBLUE );
        }
    }
});


policecmd("m", function(playerid, text) {
    if ( !isOfficer(playerid) ) {
        return;
    }
    if ( !isPlayerInPoliceVehicle(playerid) ) {
        return msg( playerid, "organizations.police.notinpolicevehicle");
    }
    inRadiusSendToAll(playerid, "[POLICE RUPOR] " + text, RUPOR_RADIUS, CL_ROYALBLUE);
});


// /ticket <id or plate> <reason-id>
cmd(["ticket"], function(playerid, target, reason) {
    policeFindThatMotherfucker(playerid, target, reason);
});


// cmd(["tickets"], function( playerid, targetid = null ) {
//     if ( targetid == null ) {
//         // show all player assign tickets
//     } else {
//         targetid = targetid.tointeger();
//         // show target player asign tickets
//     }
// });


// stun nearest player for some time
key(["g"], function(playerid) {
    local targetid = playerList.nearestPlayer( playerid );

    if ( isPlayerInVehicle(playerid) || isPlayerInVehicle(playerid) ) {
        return;
    }
    if ( !isOfficer(playerid) || isOfficer(targetid) ) {
        return;
    }
    if ( isOfficer(playerid) && !isOnPoliceDuty(playerid) ) {
        return msg( playerid, "organizations.police.duty.off" );
    }
    baton(playerid);
});


// cuff nearest stunned player
key(["v"], function(playerid) {
    local targetid = playerList.nearestPlayer( playerid );

    if ( isPlayerInVehicle(playerid) ) {
        return;
    }
    if ( !isOfficer(playerid) || isOfficer(targetid) ) { // check if not office
        return;
    }
    if ( isOfficer(playerid) && !isOnPoliceDuty(playerid) ) {
        return msg( playerid, "organizations.police.duty.off" );
    }
    cuff(playerid);
});


// local function policetestitout(playerid, targetid, vehid) {
//     putPlayerInVehicle(targetid, vehid, 1);
//     setPlayerToggle(playerid, false);
// }

// acmd(["transport", "suspect"], function(playerid, targetid) {
//     targetid = targetid.tointeger();
//     local veh = getPlayerVehicle(playerid);
//     policetestitout(playerid, targetid, veh);
// });

// put nearest cuffed player in jail
cmd(["prison", "jail"], function(playerid, targetid) {
    targetid = targetid.tointeger();
    putInJail(playerid, targetid);
});


// take out player from jail
cmd(["amnesty"], function(playerid, targetid) {
    targetid = targetid.tointeger();
    takeOutOfJail(playerid, targetid);
});


key("e", function(playerid) {
    __commands["call"][COMMANDS_DEFAULT](playerid, "police", true);
});

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
        { name = "/ticket ID REASON",           desc = "organizations.police.info.cmds.ticket" },
        { name = "G button",                    desc = "organizations.police.info.cmds.baton" },
        { name = "V button",                    desc = "organizations.police.info.cmds.cuff" },
        { name = "/prison ID",                  desc = "organizations.police.info.cmds.prison" },
        { name = "/amnesty ID",                 desc = "organizations.police.info.cmds.amnesty" }
    ];
    msg_help(playerid, title, commands);
}

// usage: /help job police
cmd("help", ["job", "police"], policeHelp);
cmd("help", ["police"], policeHelp);
cmd("help", ["police", "job"], policeHelp);
