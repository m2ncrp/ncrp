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

    "job.police.officer"                        : "police officer",
    "job.police.detective"                      : "detective",
    "job.police.chief"                          : "police chief",
    "organizations.police.job.getmaxrank"       : "You've reached maximum rank: %s.",

    "organizations.police.setjob.byadmin"       : "You've successfully set job for %s as %s."
    "organizations.police.leavejob.byadmin"     : "You fired %s from %s job."

    "organizations.police.call.withoutaddress"  : "You can't call police without address.",
    "organizations.police.call.new"             : "[R] %s called police from %s",
    "organizations.police.call.foruser"         : "You've called police from %s",

    "organizations.police.income"               : "[EBPD] We send $%.2f to you for duty as %s.",

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
    "organizations.police.offduty.nobadge"      : "You have no badge with you couse you're off duty now.",

    "organizations.police.bitsomeone.bybaton"   : "You bet %s by baton.",
    "organizations.police.beenbit.bybaton"      : "You's been bet by baton",
    "organizations.police.beencuffed"           : "You've been cuffed by %s.",
    "organizations.police.cuff.someone"         : "You cuffed %s.",
    "organizations.police.cuff.beenuncuffed"    : "You've been uncuffed by %s",
    "organizations.police.cuff.uncuffsomeone"   : "You uncuffed %s",

    "organizations.police.beenshown.badge"      : "You're showing your badge to %s",
    "organizations.police.show.badge"           : "%s %s is showing his badge to you .",

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
const POLICE_BADGE_RADIUS = 3.5;

const POLICE_SALARY = 0.5; // for 1 minute

POLICE_EBPD_ENTERES <- [
    [-360.342, 785.954, -19.9269],  // parade
    [-379.444, 654.207, -11.6451]   // stuff only
];

const EBPD_ENTER_RADIUS = 2.0;
const TITLE_DRAW_DISTANCE = 12.0;

POLICE_RANK <- [
    "police.officer",    // "Police Officer",
    "police.detective",  // "Detective",
    "police.chief"       // "Mein Führer",
];
MAX_RANK <- POLICE_RANK.len()-1;

DENGER_LEVEL <- "green";

/**
 * Any cmd only with any text, without specific parameters
 * @param  {[type]}   names    [description]
 * @param  {Function} callback [description]
 * @return {[type]}            [description]
 */
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

/**
 * Format message from parameters package (vargv)
 * @param  {[type]} playerid [description]
 * @param  {[type]} vargv    [description]
 * @return {[type]}          [description]
 */
function makeMeText(playerid, vargv)  {
    local text = concat(vargv);

    if (!text || text.len() < 1) {
        return msg(playerid, "general.message.empty", CL_YELLOW);
    }
    return text;
}

/**
 * Calculate salary for police based on time on duty
 * @param  {[type]} playerid [description]
 * @return {[type]}          [description]
 */
function policeJobPaySalary(playerid) {
    local summa = police[playerid]["ondutyminutes"] * POLICE_SALARY;
    addMoneyToPlayer(playerid, summa);
    msg(playerid, "organizations.police.income", [summa.tofloat(), getLocalizedPlayerJob(playerid)], CL_SUCCESS);
    police[playerid]["ondutyminutes"] = 0;
}

include("modules/organizations/police/commands.nut");
include("modules/organizations/police/functions.nut");


police <- {};


event("onServerStarted", function() {
    log("[police] starting police...");
    createVehicle(42, -387.247, 644.23, -11.1051, -0.540928, 0.0203334, 4.30543 );      // policecar1
    createVehicle(42, -327.361, 677.508, -17.4467, 88.647, -2.7285, 0.00588255 );       // policecarParking3
    createVehicle(42, -327.382, 682.532, -17.433, 90.5207, -3.07545, 0.378189 );        // policecarParking4
    createVehicle(21, -324.296, 693.308, -17.4131, -179.874, -0.796982, -0.196363 );    // policeBusParking1
    createVehicle(51, -326.669, 658.13, -17.5624, 90.304, -3.56444, -0.040828 );        // policeOldCarParking1
    createVehicle(51, -326.781, 663.293, -17.5188, 93.214, -2.95046, -0.0939897 );      // policeOldCarParking2

    create3DText( POLICE_EBPD_ENTERES[0][0], POLICE_EBPD_ENTERES[0][1], POLICE_EBPD_ENTERES[0][2]+0.35, "=== EMPIRE BAY POLICE DEPARTMENT ===", CL_ROYALBLUE, TITLE_DRAW_DISTANCE );
    create3DText( POLICE_EBPD_ENTERES[0][0], POLICE_EBPD_ENTERES[0][1], POLICE_EBPD_ENTERES[0][2]-0.15, "/police duty on/off", CL_WHITE.applyAlpha(150), EBPD_ENTER_RADIUS );
});




/*
event("onPlayerSpawn", function( playerid ) {
    if ( isOfficer(playerid) && isOnPoliceDuty(playerid) ) {
        onPoliceDutyGiveWeapon( playerid );
        setPlayerModel(playerid, POLICE_MODEL);
        police[playerid]["ondutyminutes"] <- 0;
    }
});
*/



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




event("onPlayerDisconnect", function(playerid, reason) {
    foreach (playerid, value in police) {
        policeJobPaySalary( playerid );
    }
    if(playerid in police) delete police[playerid];
});



event("onServerMinuteChange", function() {
    foreach (playerid, value in police) {
        if("ondutyminutes" in police[playerid] && isOnPoliceDuty(playerid)) {
            police[playerid]["ondutyminutes"] += 1;

        }
    }
});



event("onPoliceDutyOn", function(playerid, rank = null) {
    if (rank == null) {
        rank = getPlayerJob(playerid);
    }

    if (rank == POLICE_RANK[0]) {
        givePlayerWeapon( playerid, 2, 42 ); // Model 12 Revolver
        if (DENGER_LEVEL == "red") {
            givePlayerWeapon( playerid, 12, 120 ); // M1A1 Thompson
        }
    }
    if (rank == POLICE_RANK[1]) {
        givePlayerWeapon( playerid, 4, 56 ); // Colt M1911A1
        if (DENGER_LEVEL == "red") {
            givePlayerWeapon( playerid, 8, 48 ); // Remington Model 870 Field gun // on RED level
        }
    }
    if (rank == POLICE_RANK[2]) {
        givePlayerWeapon( playerid, 6, 42 ); // Model 19 Revolver
        if (DENGER_LEVEL == "red") {
            givePlayerWeapon( playerid, 8, 48 ); // Remington Model 870 Field gun // on RED level
            givePlayerWeapon( playerid, 12, 120 ); // M1A1 Thompson
        }
    }
});


event("onPoliceDutyOff", function(playerid, rank = null) {
    if (rank == null) {
        rank = getPlayerJob(playerid);
    }

    if (rank == POLICE_RANK[0]) {
        removePlayerWeapon( playerid, 2 ); // Model 12 Revolver
        removePlayerWeapon( playerid, 12 ); // M1A1 Thompson // on RED level
    }
    if (rank == POLICE_RANK[1]) {
        removePlayerWeapon( playerid, 4 ); // Colt M1911A1
        removePlayerWeapon( playerid, 8 ); // Remington Model 870 Field gun // on RED level
    }
    if (rank == POLICE_RANK[2]) {
        removePlayerWeapon( playerid, 6 ); // Model 19 Revolver
        removePlayerWeapon( playerid, 8 ); // Remington Model 870 Field gun // on RED level
        removePlayerWeapon( playerid, 12 ); // M1A1 Thompson
    }
});
