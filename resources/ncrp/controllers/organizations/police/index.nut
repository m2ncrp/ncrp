/** TODO LIST
1. Make police exclusive for players. Join only through admins, write names and serials into script. [DONE]
2. Create rang system. ~3-4 rangs: police chief, officer, junior officer, detective (ability to work plain-clothes).
4. Ability to rang up or down by admins.
5. Remove selfshot by taser in cmds X)
6. To end duty and become simple civilian make duty on and off cmds [HALF DONE]

7. Call da fucking police
*/

translation("en", {
    "general.message.empty"                     : "[INFO] You cant send an empty message",
    "general.noonearound"                       : "There's noone around near you.",

    "organizations.police.crime.wasdone"        : "You would better not to do it..",
    "organizations.police.getserial"            : "Your serial is: %s",
    "organizations.police.notanofficer"         : "You're not a police officer.",
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
    "organizations.police.info.cmds.helptitle"  : "List of available commands for Police Officer JOB:"
});

translation("ru", {
    "general.message.empty"                     : "[INFO] Вы не можете отправить пустую строку",
    "general.noonearound"                       : "Рядом с вами никого нет.",

    "organizations.police.crime.wasdone"        : "Лучше бы ты этого не делал..",
    "organizations.police.getserial"            : "Ваш серийный номер: %s",
    "organizations.police.notanofficer"         : "Вы не являетесь офицером полиции.",
    "organizations.police.duty.alreadyon"       : "Вы закончили свою смену.",
    "organizations.police.duty.alreadyoff"      : "Вы уже начали свою смену.",
    "organizations.police.notinpolicevehicle"   : "Вы должны быть в служебной машине!",
    "organizations.police.ticket.givewithreason": "%s выписал вам штраф за %s. Введите /accept %s.",
    "organizations.police.offduty.notickets"    : "Вы закончили свою смену и не имеете квитанций с собой.",
    "organizations.police.offduty.notaser"      : "У вас нет шокера, т.к. вы не полицейский.",

    "organizations.police.shotsomeone.bytaser"  : "Вы выстрелили в %s из шокера.",
    "organizations.police.beenshot.bytaser"     : "В вас попал снаряд шокера", 
    "organizations.police.cuff.beencuffed"      : "%s надел на вас наручники",
    "organizations.police.cuff.someone"         : "Вы арестовали %s",
    "organizations.police.cuff.beenuncuffed"    : "%s снял с вас наручники",
    "organizations.police.cuff.uncuffsomeone"   : "Вы сняли наручники с %s",
    
    "organizations.police.info.howjoin"         : "Если вы хотите пополнить ряды офицеров департамента Empire Bay, напишите администраторам!",
    "organizations.police.info.cmds.helptitle"  : "Список команд, доступных офицерам полиции:"
});



const RUPOR_RADIUS = 100.0;
const CUFF_RADIUS = 3.0;
const POLICE_MODEL = 75;

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
    createVehicle(42, -387.247, 644.23, -11.1051, -0.540928, 0.0203334, 4.30543 ); // policecar1
    createVehicle(42, -327.361, 677.508, -17.4467, 88.647, -2.7285, 0.00588255 ); // policecarParking3
    createVehicle(42, -327.382, 682.532, -17.433, 90.5207, -3.07545, 0.378189 ); // policecarParking4
    createVehicle(21, -324.296, 693.308, -17.4131, -179.874, -0.796982, -0.196363 ); // policeBusParking1
    createVehicle(51, -326.669, 658.13, -17.5624, 90.304, -3.56444, -0.040828 ); // policeOldCarParking1
    createVehicle(51, -326.781, 663.293, -17.5188, 93.214, -2.95046, -0.0939897 ); // policeOldCarParking2
});

addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial) {
    players[playerid]["serial"] <- serial;
    if ( isOfficer(playerid) ) {
        players[playerid]["job"] <- "policeofficer";
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
        return msg(playerid, "organizations.police.crime.wasdone", CL_GRAY);
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
    // return (isPlayerHaveValidJob(playerid, "policeofficer"));
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
}


/**
 * Become police officer ABANDONED
 * @param  {int} playerid
 */
// function getPoliceJob(playerid) {
//     if(isOfficer(playerid)) {
//         return msg(playerid, "You're police officer already.");
//     }

//     if(isPlayerHaveJob(playerid)) {
//         return msg(playerid, "You already have a job: " + getPlayerJob(playerid) + ".");
//     }

//     if (!isPlayerInPoliceVehicle(playerid)) {
//         return msg(playerid, "You need a police car."); // not a car, but PD or PD chief
//     }

//     //setVehicleFuel( getPlayerVehicle(playerid), 56.0 );
//     players[playerid]["job"] = "policeofficer";
//     msg(playerid, "You became a police officer.");
// }


/**
 * Leave from police ABANDONED
 * @param  {int} playerid
 */
// function leavePoliceJob(playerid) {
//     if(!isOfficer(playerid)) {
//         return msg(playerid, "You're not a police officer.");
//     }

//     if(isPlayerHaveJob(playerid) && !isOfficer(playerid)) {
//         return msg(playerid, "You already have got a job: " + getPlayerJob(playerid) + ".");
//     }

//     // IDK Y, but I'll leave it here
//     if( isPlayerInPoliceVehicle(playerid) ) {
//         setVehicleFuel( getPlayerVehicle(playerid), 0.0 );
//     }

//     players[playerid]["job"] = null;
//     msg(playerid, "You leave police department.");
// }
