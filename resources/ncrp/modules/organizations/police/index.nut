/** TODO LIST
1. Make police exclusive for players. Join only through admins, write names and serials into script. [DONE]
2. Create rang system. ~3-4 rangs: police chief, officer, junior officer, detective (ability to work plain-clothes).
4. Ability to rang up or down by admins.
5. Remove selfshot by taser in cmds X)
6. To end duty and become simple civilian make duty on and off cmds [HALF DONE]

7. Call da fucking police


И так, полиция:
1. Работа: проверять является ли игрок копом или нет через players[playerid]["job"]. Этого достаточно.
2. Пистолет есть - патронов нет. Как так?
3. Рупор и r проверить не удалось, т.к. нужно два и более игрока.
4. Taser, ticket, cuff - тоже что и пункт 3.
5. prison выдало ошибку AN ERROR HAS OCCURED [wrong number of parameters]
6. Неполный хелп
7. Чёто странное с командами /police duty on и /police duty off (то ли месседжы перепутаны, для duty off вообще не выводится собщение). Непоняяяяяятно
8. По умолчанию при входе на серв я бы ставит duty off и гражданский скин(изменено)
*/

translation("en", {
    "general.admins.serial.get"                 : "Serial of %s: %s",

    "general.message.empty"                     : "[INFO] You cant send an empty message",
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
    "organizations.police.offduty.notaser"      : "You have no taser couse you're not a cop.",

    "organizations.police.shotsomeone.bytaser"  : "You shot %s by taser.",
    "organizations.police.beenshot.bytaser"     : "You's been shot by taser",
    "organizations.police.beencuffed"           : "You've been cuffed by %s.",
    "organizations.police.cuff.someone"         : "You cuffed %s.",
    "organizations.police.cuff.beenuncuffed"    : "You've been uncuffed by %s",
    "organizations.police.cuff.uncuffsomeone"   : "You uncuffed %s",

    "organizations.police.info.howjoin"         : "If you want to join Police Department write one of admins!",
    "organizations.police.info.cmds.helptitle"  : "List of available commands for Police Officer JOB:",
    "organizations.police.info.cmds.ratio"      : "Send message to all police by ratio",
    "organizations.police.info.cmds.rupor"      : "Say smth to police vehicle rupor",
    "organizations.police.info.cmds.ticket"     : "Give ticket to player with given id. Example: /ticket 0 2.1 speed limit",
    "organizations.police.info.cmds.taser"      : "Shock nearset player",
    "organizations.police.info.cmds.cuff"       : "Сuff nearest player",
    "organizations.police.info.cmds.cuff"       : "Uncuff nearest player",
    "organizations.police.info.cmds.prison"     : "Put nearest cuffed player in jail",
    "organizations.police.info.cmds.amnesty"    : "Take out player with given id from prison",

    "organizations.police.onrankup"             : "You was rank up to %s",
    "organizations.police.onleave"              : "You're not a police officer anymore."
});

translation("ru", {
    "general.admins.serial.get"                 : "Cерийный номер игрока %s: %s",

    "general.message.empty"                     : "[INFO] Вы не можете отправить пустую строку",
    "general.noonearound"                       : "Рядом с вами никого нет.",
    "general.job.anotherone"                    : "Вы работаете %s, а не %s!",

    "job.police.officer"                        : "Офицер",
    "job.police.detective"                      : "Детектив",
    "job.police.chief"                          : "Шеф Полиции",
    "organizations.police.job.getmaxrank"       : "Вы достигли максимального звания: %s.",

    "organizations.police.call.withoutaddress"  : "Вы не можете вызвать полицию не указав адреса.",
    "organizations.police.call.new"             : "[R] поступил вызов от %s из %s",
    "organizations.police.call.foruser"         : "Вы вызвали такси из %s",

    "organizations.police.crime.wasdone"        : "Лучше бы ты этого не делал..",
    "organizations.police.alreadyofficer"       : "Вы уже состоите в EBPD.",
    "organizations.police.notanofficer"         : "Вы не являетесь офицером полиции.",
    "organizations.police.duty.on"              : "Вы вышли на смену.",
    "organizations.police.duty.off"             : "Вы закончили свою смену.",
    "organizations.police.duty.alreadyon"       : "Вы уже начали свою смену.",
    "organizations.police.duty.alreadyoff"      : "Вы уже закончили свою смену.",
    "organizations.police.notinpolicevehicle"   : "Вы должны быть в служебной машине!",
    "organizations.police.ticket.givewithreason": "%s выписал вам штраф за %s. Введите /accept %i.",
    "organizations.police.offduty.notickets"    : "Вы закончили свою смену и не имеете квитанций с собой.",
    "organizations.police.offduty.notaser"      : "У вас нет шокера, т.к. вы не полицейский.",

    "organizations.police.shotsomeone.bytaser"  : "Вы выстрелили в %s из шокера.",
    "organizations.police.beenshot.bytaser"     : "В вас попал снаряд шокера", 
    "organizations.police.cuff.beencuffed"      : "%s надел на вас наручники",
    "organizations.police.cuff.someone"         : "Вы арестовали %s",
    "organizations.police.cuff.beenuncuffed"    : "%s снял с вас наручники",
    "organizations.police.cuff.uncuffsomeone"   : "Вы сняли наручники с %s",

    "organizations.police.info.howjoin"         : "Если вы хотите пополнить ряды офицеров департамента Empire Bay, напишите администраторам!",
    "organizations.police.info.cmds.helptitle"  : "Список команд, доступных офицерам полиции:",
    "organizations.police.info.cmds.ratio"      : "Сказать что-либо в полицейскую рацию",
    "organizations.police.info.cmds.rupor"      : "Сказать что-либо в рупор служебной машины",
    "organizations.police.info.cmds.ticket"     : "Выдать штраф игроку с указанным id. Пример: /ticket 0 2.1 превышение скорости",
    "organizations.police.info.cmds.taser"      : "Обездвижить ближайшего игрока",
    "organizations.police.info.cmds.cuff"       : "Надеть наручники на ближайшего игрока",
    "organizations.police.info.cmds.cuff"       : "Снять наручники с ближайшего игрока",
    "organizations.police.info.cmds.prison"     : "Посадить игрока с указанным id в тюрьму",
    "organizations.police.info.cmds.amnesty"    : "Вытащить игрока с указанным id из тюрьмы",

    "organizations.police.onrankup"             : "Вы были повышены до %s",
    "organizations.police.onleave"              : "Вы более не являетесь офицером полиции."
});



const RUPOR_RADIUS = 75.0;
const CUFF_RADIUS = 3.0;
const TASER_RADIUS = 6.0;
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
    // nothing here
});

event("onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if (isPlayerInPoliceVehicle(playerid) && !isOfficer(playerid)) {
        // set player wanted level or smth like that
        return msg(playerid, "organizations.police.crime.wasdone", [], CL_GRAY);
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
        return msg(playerid, "You're police officer already.");
    }

    if (isPlayerHaveJob(playerid)) {
        return msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid));
    }

    // set first rank
    setPlayerJob( playerid, setPoliceRank(playerid, 0) );
    policeSetOnDuty(playerid, false);
    msg(playerid, "You became a police officer.");
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
