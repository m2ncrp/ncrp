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

    "organizations.police.position.officer"     : "Police Officer",
    "organizations.police.position.detective"   : "Detective",
    "organizations.police.position.chief"       : "Police Chief",
    "organizations.police.position.getmaxrank"  : "You've reached maximum rank: %s.",

    "organizations.police.call.withoutaddress"  : "You can't call police without address.",
    "organizations.police.call.new"             : "[R] %s called police from %s",

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
    "organizations.police.info.cmds.ticket"     : "Give ticket to player with given id. Example: /ticket 0 2.1",
    "organizations.police.info.cmds.taser"      : "Shock nearset player",
    "organizations.police.info.cmds.cuff"       : "Use cuff for nearest player",
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

    "organizations.police.position.officer"     : "Офицер",
    "organizations.police.position.detective"   : "Детектив",
    "organizations.police.position.chief"       : "Шеф Полиции",
    "organizations.police.position.getmaxrank"  : "Вы достигли максимального звания: %s.",

    "organizations.police.call.withoutaddress"  : "Вы не можете вызвать полицию не указав адреса.",
    "organizations.police.call.new"             : "[R] поступил вызов от %s из %s",

    "organizations.police.crime.wasdone"        : "Лучше бы ты этого не делал..",
    "organizations.police.alreadyofficer"       : "Вы уже состоите в EBPD.",
    "organizations.police.notanofficer"         : "Вы не являетесь офицером полиции.",
    "organizations.police.duty.on"              : "Вы вышли на смену.",
    "organizations.police.duty.off"             : "Вы закончили свою смену.",
    "organizations.police.duty.alreadyon"       : "Вы уже закончили свою смену.",
    "organizations.police.duty.alreadyoff"      : "Вы уже начали свою смену.",
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
    "organizations.police.info.cmds.rupor"      : "Скачать что-либо в рупор служебной машины",
    "organizations.police.info.cmds.ticket"     : "Выдать штраф игроку с указанным id. Пример: /ticket 0 2.1",
    "organizations.police.info.cmds.taser"      : "Обездвижить ближайшего игрока",
    "organizations.police.info.cmds.cuff"       : "Надеть наручники на ближайшего игрока",
    "organizations.police.info.cmds.prison"     : "Посадить игрока с указанным id в тюрьму",
    "organizations.police.info.cmds.amnesty"    : "Вытащить игрока с указанным id из тюрьмы",

    "organizations.police.onrankup"             : "Вы были повышены до %s",
    "organizations.police.onleave"              : "Вы более не являетесь офицером полиции."
});



const RUPOR_RADIUS = 100.0;
const CUFF_RADIUS = 3.0;
const POLICE_MODEL = 75;

POLICE_RANK <- [
    "organizations.police.position.officer",    // "Police Officer",
    "organizations.police.position.detective",  // "Detective",
    "organizations.police.position.chief"       // "Mein Führer",
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

include("controllers/organizations/police/commands.nut");

// All players in this list are police officer permanently
officerList <- [
    ["Roberto_Lukini", "CD19A5029AE81BB50B023291846C0DF3"]
];

addEventHandlerEx("onServerStarted", function() {
    log("[police] starting police...");
    createVehicle(42, -387.247, 644.23, -11.1051, -0.540928, 0.0203334, 4.30543 );      // policecar1
    createVehicle(42, -327.361, 677.508, -17.4467, 88.647, -2.7285, 0.00588255 );       // policecarParking3
    createVehicle(42, -327.382, 682.532, -17.433, 90.5207, -3.07545, 0.378189 );        // policecarParking4
    createVehicle(21, -324.296, 693.308, -17.4131, -179.874, -0.796982, -0.196363 );    // policeBusParking1
    createVehicle(51, -326.669, 658.13, -17.5624, 90.304, -3.56444, -0.040828 );        // policeOldCarParking1
    createVehicle(51, -326.781, 663.293, -17.5188, 93.214, -2.95046, -0.0939897 );      // policeOldCarParking2
});

addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial) {
    players[playerid]["serial"] <- serial;
    if ( isOfficer(playerid) ) {
        players[playerid]["job"] <- "policeofficer";
        players[playerid]["rank"] <- 0;
        players[playerid]["skin"] <- POLICE_MODEL;
        players[playerid]["onduty"] <- true;
    }    
});

addEventHandler ( "onPlayerSpawn", function( playerid ) {
    if ( isOfficer(playerid) ) {
        givePlayerWeapon( playerid, 2, 0 );
    }
});


addEventHandler ( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if(isPlayerInPoliceVehicle(playerid) && getPlayerJob(playerid) != "policeofficer") {
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
    foreach (playerRecord in officerList) {
        local name = playerRecord[0];
        local ser = playerRecord[1];
        if ( name == getPlayerName(playerid) && ser == players[playerid]["serial"] )
            return true;
    }
    return false;
}

/**
 * Check if player is a police officer and on duty now
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isOnDuty(playerid) {
    return ( isOfficer(playerid) && players[playerid]["onduty"] );
}

function setOnDuty(playerid, bool) {
    players[playerid]["onduty"] <- bool;
    if (bool) {
        // givePlayerWeapon( playerid, 2, 0 ); // should be called once at spawn or zero ammo to prevent using infinite ammo usage in combats
        return screenFadeinFadeout(playerid, 100, function() {
                setPlayerModel(playerid, POLICE_MODEL);
                msg(playerid, "organizations.police.duty.on");
            });
    } else {
        // removePlayerWeapon( playerid, 2 ); // remove at all
        return screenFadeinFadeout(playerid, 100, function() {
                setPlayerModel(playerid, players[playerid]["default_skin"]);
                msg(playerid, "organizations.police.duty.off");
            });
    }
    
}

/**
 * Return formated string with player rank
 * @param  {integer} playerid
 * @return {string}  player rank
 */
function getPoliceRank(playerid) {
    if (players[playerid]["rank"] == 0) {
        return "organizations.police.position.officer";
    }
    if (players[playerid]["rank"] == 1) {
        return "organizations.police.position.detective";
    }
    if (players[playerid]["rank"] == 2) {
        return "organizations.police.position.chief";
    }
}

/**
 * Set player rank to given ID
 * @param  {integer} playerid
 * @return {string}  player rank
 */
function setPoliceRank(playerid, rankID) {
    if (rankID >= 0 && rankID < POLICE_RANK.len()) {
        players[playerid]["rank"] = rankID;
    }
}

function isRankUpPossible(playerid, rank) {
    rank = rank.tointeger();
    if ( players[playerid]["rank"] != MAX_RANK && rank >= 0 ) {
        return true;
    }
    return false;
}

function rankUpPolice(playerid) {
    local next;
    if ( players[playerid]["rank"] != null ) {
        next = players[playerid]["rank"] + 1;
    } else {
        next = 0;
    }
    
    if ( isRankUpPossible(playerid, next) ) {
        players[playerid]["rank"] = next;
        msg( playerid, "organizations.police.onrankup", [ localize( POLICE_RANK[players[playerid]["rank"]], [], getPlayerLocale(playerid)) ] );
    } else {
        msg( playerid, "organizations.police.position.getmaxrank", [ localize( POLICE_RANK[MAX_RANK], [], getPlayerLocale(playerid)) ] );
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

    foreach(player in playerList.getPlayers()) {
        if ( isOfficer(player) && isOnDuty(player) ) {
            msg(player, "organizations.police.call.new", [getAuthor(playerid), place], CL_ROYALBLUE);
        }
    }
}


/**
 * Become police officer ABANDONED
 * @param  {int} playerid
 */
function getPoliceJob(playerid) {
    if( isOfficer(playerid) ) {
        return msg(playerid, "You're police officer already.");
    }

    if(isPlayerHaveJob(playerid) && !isOfficer(playerid)) {
        return msg(playerid, "general.job.anotherone", [getPlayerJob(playerid), "Police Officer"]);
    }
    
    setOnDuty(playerid, false);
    players[playerid]["job"] = "policeofficer";
    players[playerid]["rank"] = 0;
    msg(playerid, "You became a police officer.");
}


/**
 * Leave from police ABANDONED
 * @param  {int} playerid
 */
function leavePoliceJob(playerid) {
    if(!isOfficer(playerid)) {
        return msg(playerid, "organizations.police.notanofficer");
    }

    if(isPlayerHaveJob(playerid) && !isOfficer(playerid)) {
        return msg(playerid, "general.job.anotherone", [getPlayerJob(playerid), "Police Officer"]);
    }

    setOnDuty(playerid, false);
    players[playerid]["job"] = null;
    players[playerid]["rank"] = null;
    msg(playerid, "organizations.police.onleave");
}
