/** TODO LIST

И так, полиция:
3. Рупор и r проверить не удалось, т.к. нужно два и более игрока.
4. baton, ticket, cuff - тоже что и пункт 3.
5. prison выдало ошибку AN ERROR HAS OCCURED [wrong number of parameters]
6. Неполный хелп
7. Чёто странное с командами /police duty on и /police duty off (то ли месседжы перепутаны, для duty off вообще не выводится собщение). Непоняяяяяятно
8. По умолчанию при входе на серв я бы ставит duty off и гражданский скин(изменено)
*/

translation("en", {
    "general.admins.serial.get"                 : "Serial of %s: %s",

    "general.message.empty"                     : "[INFO] You can't send an empty message",
    "general.noonearound"                       : "There's noone around near you.",
    "general.job.anotherone"                    : "You've got %s job, not %s!",

    "job.police.officer"                        : "Police Officer",
    "job.police.detective"                      : "Detective",
    "job.police.chief"                          : "Police Chief",
    "organizations.police.job.getmaxrank"       : "You've reached maximum rank: %s.",

    "organizations.police.call.withoutaddress"  : "You can't call police without address.",
    "organizations.police.call.new"             : "[R] %s called police from %s",
    "organizations.police.call.foruser"         : "You've called police from %s",

    "organizations.police.crime.wasdone"        : "You would better not to do it..",
    "organizations.police.alreadyofficer"       : "You're already working in EBPD.",
    "organizations.police.notanofficer"         : "You're not a police officer.",
    "organizations.police.duty.on"              : "You're on duty now.",
    "organizations.police.duty.off"             : "You're off duty now.",
    "organizations.police.duty.alreadyon"       : "You're already on duty now.",
    "organizations.police.duty.alreadyoff"      : "You're already off duty now.",
    "organizations.police.notinpolicevehicle"   : "You should be in police vehicle!",
    "organizations.police.ticket.givewithreason": "%s give you ticket for %s. Type /accept %i.",
    "organizations.police.offduty.notickets"    : "You off the duty now and you haven't tickets.",
    "organizations.police.offduty.nobaton"      : "You have no baton couse you're not a cop.",

    "organizations.police.bitsomeone.bybaton"   : "You bet %s by baton.",
    "organizations.police.beenbit.bybaton"      : "You's been bet by baton",
    "organizations.police.beencuffed"           : "You've been cuffed by %s.",
    "organizations.police.cuff.someone"         : "You cuffed %s.",
    "organizations.police.cuff.beenuncuffed"    : "You've been uncuffed by %s",
    "organizations.police.cuff.uncuffsomeone"   : "You uncuffed %s",

    "organizations.police.info.howjoin"         : "If you want to join Police Department write one of admins!",
    "organizations.police.info.cmds.helptitle"  : "List of available commands for Police Officer JOB:",
    "organizations.police.info.cmds.ratio"      : "Send message to all police by ratio",
    "organizations.police.info.cmds.rupor"      : "Say smth to police vehicle rupor",
    "organizations.police.info.cmds.ticket"     : "Give ticket to player with given id. Example: /ticket 0 2.1 speed limit",
    "organizations.police.info.cmds.baton"      : "Stun nearset player",
    "organizations.police.info.cmds.cuff"       : "Cuff or uncuff nearest stunned player",
    "organizations.police.info.cmds.prison"     : "Put nearest cuffed player in jail",
    "organizations.police.info.cmds.amnesty"    : "Take out player with given id from prison",
    "organizations.police.info.cmds.dutyon"     : "To go on duty.",
    "organizations.police.info.cmds.dutyoff"    : "To go off duty",

    "organizations.police.onrankup"             : "You was rank up to %s",
    "organizations.police.onbecame"             : "You became a police officer."
    "organizations.police.onleave"              : "You're not a police officer anymore."

});


const RUPOR_RADIUS = 75.0;
const CUFF_RADIUS = 3.0;
const BATON_RADIUS = 6.0;
const POLICE_MODEL = 75;

POLICE_RANK <- [
    "police.officer",    // "Police Officer",
    "police.detective",  // "Detective",
    "police.chief"       // "Mein Führer",
];
MAX_RANK <- POLICE_RANK.len()-1;

function policecmd(names, callback)  {
    cmd(names, function(playerid, ...) {
        local text = concat(vargv);

        if (!text || text.len() < 1) {
            return msg(playerid, "general.message.empty", CL_YELLOW);
        }

        // call registered callback
        return callback(playerid, text);
    });
}

function makeMeText(playerid, vargv)  {
    local text = concat(vargv);

    if (!text || text.len() < 1) {
        return msg(playerid, "general.message.empty", CL_YELLOW);
    }
    return text;
}

include("modules/organizations/police/commands.nut");

local police = {};

event("onServerStarted", function() {
    log("[police] starting police...");
    createVehicle(42, -387.247, 644.23, -11.1051, -0.540928, 0.0203334, 4.30543 );      // policecar1
    createVehicle(42, -327.361, 677.508, -17.4467, 88.647, -2.7285, 0.00588255 );       // policecarParking3
    createVehicle(42, -327.382, 682.532, -17.433, 90.5207, -3.07545, 0.378189 );        // policecarParking4
    createVehicle(21, -324.296, 693.308, -17.4131, -179.874, -0.796982, -0.196363 );    // policeBusParking1
    createVehicle(51, -326.669, 658.13, -17.5624, 90.304, -3.56444, -0.040828 );        // policeOldCarParking1
    createVehicle(51, -326.781, 663.293, -17.5188, 93.214, -2.95046, -0.0939897 );      // policeOldCarParking2
});

event("onPlayerConnect", function(playerid, name, ip, serial) {
    // if ( isOfficer(playerid) ) {
    //     police[playerid] <- { onduty = false };
    // }
});

event("onPlayerSpawn", function( playerid ) {
    if ( isOfficer(playerid) && isOnPoliceDuty(playerid) ) {
        onPoliceDutyGiveWeapon( playerid );
        setPlayerModel(playerid, POLICE_MODEL);
    }
});

event("onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if (isPlayerInPoliceVehicle(playerid)) {
        if (!isOfficer(playerid)) {
            // set player wanted level or smth like that
            blockVehicle(vehicleid);
            return msg(playerid, "organizations.police.crime.wasdone", [], CL_GRAY);
        } else {
            unblockVehicle(vehicleid);
        }
    }
});


/**
 * Check is player's vehicle is a police car
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerInPoliceVehicle(playerid) {
    return (isPlayerInValidVehicle(playerid, 42) || isPlayerInValidVehicle(playerid, 51) || isPlayerInValidVehicle(playerid, 21));
}


/**
 * Check if player is a police officer
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isOfficer(playerid) {
    if (!(playerid in players)) {
        return false;
    }

    // return if playerjob (might be job.police.officer)
    return (POLICE_RANK.find(players[playerid].job) != null);
}

/**
 * Check if player is a police officer and on duty now
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isOnPoliceDuty(playerid) {
    return (isOfficer(playerid) && playerid in police && police[playerid].onduty);
}

function policeSetOnDuty(playerid, bool) {
    if (!(playerid in police)) {
        police[playerid] <- {};
    }

    police[playerid].onduty <- bool;

    if (bool) {
        return screenFadeinFadeout(playerid, 100, function() {
            onPoliceDutyGiveWeapon( playerid );
            setPlayerModel(playerid, POLICE_MODEL);
            msg(playerid, "organizations.police.duty.on");
        });
    } else {
        onPoliceDutyRemoveWeapon( playerid );
        return screenFadeinFadeout(playerid, 100, function() {
            setPlayerModel(playerid, players[playerid]["default_skin"]);
            msg(playerid, "organizations.police.duty.off");
        });
    }
}

/**
 * Return integer with player rank
 * @param  {integer} playerid
 * @return {Integer} player rank
 */
function getPoliceRank(playerid) {
    return POLICE_RANK.find(players[playerid].job);
}

/**
 * Set player rank to given ID
 * @param  {integer} playerid
 * @param  {integer} rank number
 * @return {string}  player rank
 */
function setPoliceRank(playerid, rankID) {
    if (rankID >= 0 && rankID < POLICE_RANK.len()) {
        players[playerid].job = POLICE_RANK[rankID];
        return POLICE_RANK[rankID];
    }
    return players[playerid].job;
}

function isPoliceRankUpPossible(playerid) {
    return (getPoliceRank(playerid) != null && getPoliceRank(playerid) < MAX_RANK);
}

function rankUpPolice(playerid) {
    if (isPoliceRankUpPossible(playerid)) {
        // increase rank
        setPoliceRank(playerid, getPoliceRank(playerid) + 1);

        // send message
        msg( playerid, "organizations.police.onrankup", [ getLocalizedPlayerJob(playerid) ] );
    } else {
        msg( playerid, "organizations.police.job.getmaxrank", [ localize( "job." + POLICE_RANK[MAX_RANK], [], getPlayerLocale(playerid)) ] );
    }
}


function onPoliceDutyGiveWeapon(playerid, rank = null) {
    if (rank == null) {
        rank = getPlayerJob(playerid);
    }

    if (rank == POLICE_RANK[0]) {
        givePlayerWeapon( playerid, 2, 36 ); // Model 12 Revolver
    }
    if (rank == POLICE_RANK[1]) {
        givePlayerWeapon( playerid, 4, 36 ); // Colt M1911A1
        givePlayerWeapon( playerid, 8, 48 ); // Remington Model 870 Field gun
    }
    if (rank == POLICE_RANK[2]) {
        givePlayerWeapon( playerid, 6, 36 ); // Model 19 Revolver
        givePlayerWeapon( playerid, 8, 48 ); // Remington Model 870 Field gun
        givePlayerWeapon( playerid, 9, 80 ); // M3 Grease Gun
    }
}


function onPoliceDutyRemoveWeapon(playerid, rank = null) {
    if (rank == null) {
        rank = getPlayerJob(playerid);
    }

    if (rank == POLICE_RANK[0]) {
        removePlayerWeapon( playerid, 2 ); // Model 12 Revolver
    }
    if (rank == POLICE_RANK[1]) {
        removePlayerWeapon( playerid, 4 ); // Colt M1911A1
        removePlayerWeapon( playerid, 8 ); // Remington Model 870 Field gun
    }
    if (rank == POLICE_RANK[2]) {
        removePlayerWeapon( playerid, 6 ); // Model 19 Revolver
        removePlayerWeapon( playerid, 8 ); // Remington Model 870 Field gun
        removePlayerWeapon( playerid, 9 ); // M3 Grease Gun
    }
}

/**
 * Call police officers from <place>
 * @param  {int} playerid
 * @param  {string} place   - address place of call
 */
function policeCall(playerid, place) {
    if (!place || place.len() < 1) {
        return msg(playerid, "organizations.police.call.withoutaddress");
    }

    msg(playerid, "organizations.police.call.foruser", [place], CL_ROYALBLUE);

    foreach(player in playerList.getPlayers()) {
        if ( isOfficer(player) && isOnPoliceDuty(player) ) {
            msg(player, "organizations.police.call.new", [getAuthor(playerid), place], CL_ROYALBLUE);
        }
    }
}


/**
 * Become police officer
 * @param  {int} playerid
 */
function getPoliceJob(playerid) {
    if( isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.alreadyofficer");
    }

    if (isPlayerHaveJob(playerid)) {
        return msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid));
    }

    // set first rank
    setPlayerJob( playerid, setPoliceRank(playerid, 0) );
    policeSetOnDuty(playerid, false);
    msg(playerid, "organizations.police.onbecame");
}


/**
 * Leave from police
 * @param  {int} playerid
 */
function leavePoliceJob(playerid) {
    if(!isOfficer(playerid)) {
        return msg(playerid, "organizations.police.notanofficer");
    }

    if (isPlayerHaveJob(playerid) && !isOfficer(playerid)) {
        return msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid));
    }

    if (isOnPoliceDuty(playerid)) {
        policeSetOnDuty(playerid, false);
    }
    setPlayerJob( playerid, null );
    msg(playerid, "organizations.police.onleave");
}
