const RUPOR_RADIUS = 75.0;
const POLICERADIO_RADIUS = 10.0;
const CUFF_RADIUS = 3.0;
const BATON_RADIUS = 6.0;
const POLICE_MODEL = 75;
const POLICE_BADGE_RADIUS = 3.5;
const POLICE_TICKET_DISTANCE = 3.0;

const POLICE_SALARY = 0.5; // for 1 minute

const POLICE_PHONEREPLY_RADIUS = 0.25;
const POLICE_PHONENORMAL_RADIUS = 20.0;

POLICE_EBPD_ENTERES <- [
    [-360.342, 785.954, -19.9269],  // parade
    [-379.444, 654.207, -11.6451]   // stuff only
];

POLICE_JAIL_COORDS <- [
    [-1054.28, 1725.5, 10.348]
];

const EBPD_ENTER_RADIUS = 2.0;
const EBPD_TITLE_DRAW_DISTANCE = 35.0;

// jail
const JAIL_X = -1018.93;
const JAIL_Y = 1731.82;
const JAIL_Z = 10.3252;

POLICE_RANK <- [ // source: https://youtu.be/i7o0_PMv72A && https://en.wikipedia.org/wiki/Los_Angeles_Police_Department#Rank_structure_and_insignia
    "police.cadet",          //"Police cadet"       0
    "police.patrol",         //"Police patrolman",  1
    "police.officer",        //"Police officer",    2
    "police.detective",      //"Detective"          3
    "police.sergeant.1",     //"Sergeant"           4
    "police.sergeant.2",     //"Sergeant"           5
    "police.lieutenant.1",   //"Lieutenant"         6
    "police.lieutenant.2",   //"Lieutenant"         7
    "police.Captain.1",      //"Captain I"          8
    "police.Captain.2",      //"Captain II"         9
    "police.Captain.3",      //"Captain III"        10
    "police.commander",      //"Commander"          11
    "police.deputychief",    //"Deputy chief"       12
    "police.assistantchief", //"Assistant chief"    13
    "police.chief",          //"Police chief"       14
];
POLICE_MAX_RANK <- POLICE_RANK.len()-1;

/*
                                                    №   car  detective_car    wanted    ticket    park    arrest    jail    amnesty    weapons          change_rangs    give_key  civilian_clothes  salary
    "police.cadet",          //"Police cadet"       0    -         -            -         -         -       -        -         -          -                  -              -             -          0.15
    "police.patrol",         //"Police officer"     1    +         -            +         +         +       +        -         -          -                  -              -             -          0.20
    "police.sergeant",       //"Sergeant"           2    +         -                      +         +       +        -         -          -                  -              -             -          0.20
    "police.lieutenant",     //"Lieutenant"         3    +         -                      +         +       +        -         -          -                  -              -             -          0.20
    "police.сaptain",        //"Captain"            4    +         -                      +         +       +        -         -          -                  -              +             -          0.20
    "police.detective",      //"Detective"          5    -         +                      -         -       +        +         +          +                  -              -             +          0.20
    "police.assistantchief", //"Assistant chief"    6    +         +                      +         +       +        +         +          +                  +              +             +          0.20
    "police.chief",          //"Police chief"       7    +         +                      +         +       +        +         +          +                  +              +             +          0.20

 */

/**
 * Permission description for diffent ranks
 * @param  {Boolean} ride could ride vehicle on duty
 * @param  {Boolean} gun  could have a gun on duty
 * @return {obj}
 */
function policeRankPermission(ride, gun, getvehinfo) {
    return {r = ride, g = gun, i = getvehinfo};
}

POLICE_RANK_SALLARY_PERMISSION_SKIN <- [ // calculated as: (-i^2 + 27*i + 28)/200; i - rank number
    [0.14, policeRankPermission(false, false, false), [75, 76] ], // 0 - "police.cadet"
    [0.27, policeRankPermission(false, true, false),  [75, 76] ], // 1 - "police.patrol"
    [0.39, policeRankPermission(true, true, false),   [75, 76] ], // 2 - "police.officer"
    [0.50, policeRankPermission(true, true, true),    [69]     ], // 3 - "police.detective"
    [0.60, policeRankPermission(true, true, true),    [75, 76] ], // 4 - "police.sergeant.wa1"
    [0.69, policeRankPermission(true, true, true),    [75, 76] ], // 5 - "police.sergeant.2"
    [0.77, policeRankPermission(true, true, true),    [75, 76] ], // 6 - "police.lieutenant.1"
    [0.84, policeRankPermission(true, true, true),    [75, 76] ], // 7 - "police.lieutenant.2"
    [0.90, policeRankPermission(true, true, true),    [75, 76] ], // 8 - "police.Captain.1"
    [0.95, policeRankPermission(true, true, true),    [75, 76] ], // 9 - "police.Captain.2"
    [0.99, policeRankPermission(true, true, true),    [75, 76] ], // 10 - "police.Captain.3"
    [1.02, policeRankPermission(true, true, true),    [75, 76] ], // 11 - "police.commander"
    [1.04, policeRankPermission(true, true, true),    [75, 76] ], // 12 - "police.deputychief"
    [1.05, policeRankPermission(true, true, true),    [75, 76] ], // 13 - "police.assistantchief"
    [1.05, policeRankPermission(true, true, true),    [75, 76] ]  // 14 - "police.chief"
];


POLICE_TICKET_PRICELIST <- [
    [17.0, "organizations.police.lawbreak.warning"          ],  // 0 - Предупреждение aka warning
    [18.5, "organizations.police.lawbreak.trafficviolation" ],  // 1 - Нарушение ПДД aka traffic violation
    [20.0,"organizations.police.lawbreak.roadaccident"      ]   // 2 - ДТП aka road acident
];

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
    local rank = getPoliceRank(playerid);
    local coeff = POLICE_RANK_SALLARY_PERMISSION_SKIN[rank][0];
    local summa = police[playerid]["ondutyminutes"] * POLICE_SALARY * coeff;
    addMoneyToPlayer(playerid, summa);
    msg(playerid, "organizations.police.income", [summa.tofloat(), getLocalizedPlayerJob(playerid)], CL_SUCCESS);
    police[playerid]["ondutyminutes"] = 0;
}

include("modules/organizations/police/commands.nut");
include("modules/organizations/police/functions.nut");
include("modules/organizations/police/messages.nut");
// include("modules/organizations/police/Gun.nut");
include("modules/organizations/police/PoliceBuffer.nut");
include("modules/organizations/police/PoliceOfficersList.nut");
include("modules/organizations/police/garage.nut");
//include("modules/organizations/police/dispatcher.nut");
include("modules/organizations/police/translations.nut");

police <- {};

vehicleWanted <- [];

event("onServerStarted", function() {
    log("[police] starting police...");
    createVehicle(42, -387.247, 644.23, -11.1051, -0.540928, 0.0203334, 4.30543 );      // policecar1
    createVehicle(42, -327.361, 677.508, -17.4467, 88.647, -2.7285, 0.00588255 );       // policecarParking3
    createVehicle(42, -327.382, 682.532, -17.433, 90.5207, -3.07545, 0.378189 );        // policecarParking4
    createVehicle(21, -324.296, 693.308, -17.4131, -179.874, -0.796982, -0.196363 );    // policeBusParking1
    createVehicle(51, -326.669, 658.13, -17.5624, 90.304, -3.56444, -0.040828 );        // policeOldCarParking1
    createVehicle(51, -326.781, 663.293, -17.5188, 93.214, -2.95046, -0.0939897 );      // policeOldCarParking2
    createVehicle(42, 160.689, -351.494, -20.087, 0.292563, 0.457066, -0.15319 );       // policeCarKosoyPereulok

    create3DText( POLICE_EBPD_ENTERES[1][0], POLICE_EBPD_ENTERES[1][1], POLICE_EBPD_ENTERES[1][2]+0.35, "=== EMPIRE BAY POLICE DEPARTMENT ===", CL_ROYALBLUE, EBPD_TITLE_DRAW_DISTANCE );
    create3DText( POLICE_EBPD_ENTERES[1][0], POLICE_EBPD_ENTERES[1][1], POLICE_EBPD_ENTERES[1][2]+0.20, "Press E", CL_WHITE.applyAlpha(150), EBPD_ENTER_RADIUS );

    vehicleWanted  = getVehicleWantedForTax();

    createPlace("KosoyPereulok", 171.597, -302.503, 161.916, -326.178);
    // Create Police Officers Manager here
    // POLICE_MANAGER = OfficerManager();
});

event("onPlayerPlaceEnter", function(playerid, name) {
    if(name != "KosoyPereulok" || !isPlayerInVehicle(playerid) || !isPlayerVehicleDriver(playerid) ) return;

    local ticketcost = 45.0;
    //local vehicleid = getPlayerVehicle(playerid);
    //if(!canMoneyBeSubstracted(playerid, ticketcost)) { msg(playerid, "organizations.police.kosoypereulok.nomoney", CL_THUNDERBIRD); return; }
    subMoneyToPlayer(playerid, ticketcost);
    addMoneyToTreasury(ticketcost);
    msg(playerid, "organizations.police.kosoypereulok.ticket", [ticketcost], CL_THUNDERBIRD); return;
});

event("onServerPlayerStarted", function( playerid ){
    if (players[playerid].state == "cuffed") {
        delayedFunction(1100, function() { freezePlayer(playerid, true); });
        msg(playerid, "You cuffed.");
    }
});

event("onPlayerSpawn", function( playerid ) {
    if (!isPlayerLoaded(playerid)) return;
    if (!(getPlayerState(playerid) == "jail")) return;

    players[playerid].setPosition(JAIL_X, JAIL_Y, JAIL_Z);
});


event("onPlayerVehicleEnter", function( playerid, vehicleid, seat ) {
    if (isPlayerInPoliceVehicle(playerid) && seat == 0) {
        if (!isOfficer(playerid)) {
            // set player wanted level or smth like that
            blockVehicle(vehicleid);
            return msg(playerid, "organizations.police.crime.wasdone", [], CL_GRAY);
        }
        if ( isOfficer(playerid) && getPoliceRank(playerid) < 1 ) {
            blockVehicle(vehicleid);
            return msg(playerid, "organizations.police.lowrank", [], CL_GRAY);
        }
        if ( isOfficer(playerid) && !isOnPoliceDuty(playerid) ) {
            blockVehicle(vehicleid);
            return msg(playerid, "organizations.police.offduty.nokeys", [], CL_GRAY);
        } else {
            unblockVehicle(vehicleid);
        }
    }

    if ( getPlayerState(playerid) == "cuffed" ) { //  && seat != 0
        setPlayerToggle(playerid, false);
    }
});


event("onPlayerVehicleExit", function( playerid, vehicleid, seat ) {
    if ( getPlayerState(playerid) == "cuffed" ) {
        setPlayerToggle(playerid, true);
    }
});


event("onPlayerDisconnect", function(playerid, reason) {
    if ( getPlayerState(playerid) == "cuffed" ) {
        setPlayerState(playerid, "jail");
    }
});


event("onServerMinuteChange", function() {
    foreach (playerid, value in police) {
        if ( isPlayerAfk(playerid) ) {
            return;
        }

        if ("ondutyminutes" in police[playerid] && isOnPoliceDuty(playerid)) {
            police[playerid]["ondutyminutes"] += 1;
        }
    }
});

event("onServerHourChange", function() {
    //if (getHour() == 6) {
        vehicleWanted  = getVehicleWantedForTax();
    //}
});

event("onPoliceDutyOn", function(playerid, rank = null) {
    if (rank == null) {
        rank = getPoliceRank(playerid);
    }

    if (rank == 2) {
        givePlayerWeapon( playerid, 2, 42 ); // Model 12 Revolver
        if (DENGER_LEVEL == "red") {
            givePlayerWeapon( playerid, 12, 120 ); // M1A1 Thompson
        }
    }
    if (rank >= 3 && rank <= 7) {
        givePlayerWeapon( playerid, 2, 42 ); // Model 12 Revolver
        if (DENGER_LEVEL == "red") {
            givePlayerWeapon( playerid, 8, 48 ); // Remington Model 870 Field gun // on RED level
        }
    }
    if (rank >= 8 && rank <= 10) {
        givePlayerWeapon( playerid, 4, 56 ); // Colt M1911A1
        if (DENGER_LEVEL == "red") {
            givePlayerWeapon( playerid, 12, 120 ); // M1A1 Thompson
        }
    }
    if (rank >= 11 && rank <= 14) {
        givePlayerWeapon( playerid, 6, 42 ); // Model 19 Revolver
        if (DENGER_LEVEL == "red") {
            givePlayerWeapon( playerid, 12, 120 ); // M1A1 Thompson
        }
    }
});


event("onPoliceDutyOff", function(playerid, rank = null) {
    if (rank == null) {
        rank = getPoliceRank(playerid);
    }

    if (rank == 2) {
        removePlayerWeapon( playerid, 2 ); // Model 12 Revolver
        removePlayerWeapon( playerid, 12 ); // M1A1 Thompson
    }
    if (rank >= 3 && rank <= 7) {
        removePlayerWeapon( playerid, 2 ); // Model 12 Revolver
        removePlayerWeapon( playerid, 8 ); // Remington Model 870 Field gun // on RED level
    }
    if (rank >= 8 && rank <= 10) {
        removePlayerWeapon( playerid, 4 ); // Colt M1911A1
        removePlayerWeapon( playerid, 12 ); // M1A1 Thompson
    }
    if (rank >= 11 && rank <= 14) {
        removePlayerWeapon( playerid, 6 ); // Model 19 Revolver
        removePlayerWeapon( playerid, 12 ); // M1A1 Thompson
    }
});


event("onBatonBitStart", function (playerid) {
    setPlayerAnimStyle(playerid, "common", "ManColdWeapon");
    setPlayerHandModel(playerid, 1, 28); // policedubinka right hand
});



event("onPlayerPhoneCall", function(playerid, number, place) {
    if (number == "police") {
        policeCall(playerid, place);
        dbg("chat", "police", getAuthor(playerid), localize( place, [], "ru") );
    }
});

