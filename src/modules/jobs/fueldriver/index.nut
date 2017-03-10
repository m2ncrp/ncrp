translation("en", {
"job.fueldriver"                                        : "fuel truck driver"
"job.fueldriver.letsgo"                                 : "[FUEL] Let's go to Trago Oil headquartered in Oyster Bay."
"job.fueldriver.needlevel"                              : "[FUEL] You need level %d to become fuel truck driver."
"job.fueldriver.already"                                : "[FUEL] You're fuel truck driver already."
"job.fueldriver.now"                                    : "[FUEL] You're a fuel truck driver now! Congratulations!"
"job.fueldriver.sitintotruck"                           : "[FUEL] You taken a route. Sit into fuel truck."
"job.fueldriver.not"                                    : "[FUEL] You're not a fuel truck driver."
"job.fueldriver.badworker"                              : "[FUEL] You are a bad worker. We haven't job for you."
"job.fueldriver.badworker.onleave"                      : "[FUEL] You are a bad worker. Get out of here."
"job.fueldriver.goodluck"                               : "[FUEL] Good luck, guy! Come if you need a job."
"job.fueldriver.needfueltruck"                          : "[FUEL] You need a fuel truck."
"job.fueldriver.truck.loaded"                           : "[FUEL] Truck is loaded to %d / 16000. Deliver fuel to gas stations."
"job.fueldriver.truck.empty"                            : "[FUEL] The truck is empty. Go to the warehouse of fuel in South Millville to load fuel truck (yellow icon on minimap)."
"job.fueldriver.truck.toload"                           : "[FUEL] Go to the warehouse of fuel in South Millville to load fuel truck (yellow icon on minimap)."
"job.fueldriver.driving"                                : "[FUEL] You're driving. Please stop the fuel truck."
"job.fueldriver.truck.loading"                          : "[FUEL] Loading. Please, wait..."
"job.fueldriver.truck.unloading"                        : "[FUEL] Unoading. Please, wait..."
"job.fueldriver.truck.alreadyloaded"                    : "[FUEL] Fuel truck already loaded."
"job.fueldriver.truck.fullloaded"                       : "[FUEL] Fuel truck is loaded to 16000 / 16000. Deliver fuel to gas stations."
"job.fueldriver.truck.fuelnotenough"                    : "[FUEL] Fuel is not enough. Go to the warehouse to load fuel truck (yellow icon on minimap)."

"job.fueldriver.alreadybeenhere"                        : "[FUEL] You've already been here. Go to other gas station."
"job.fueldriver.truck.parking"                          : "[FUEL] Nice job! Return the fuel truck to Trago Oil headquartered in Oyster Bay, park truck and take your money."
"job.fueldriver.truck.unloadingcompletedtruckisloaded"  : "[FUEL] Unloading completed. Fuel truck is loaded to %d / 16000. Go to next gas station."
"job.fueldriver.truck.unloadingcompletedfuelnotenough"  : "[FUEL] Unloading completed. Fuel is not enough. Go to the warehouse to load fuel truck (yellow icon on minimap)."
"job.fueldriver.truck.topark"                           : "[FUEL] Go to Trago Oil headquartered to park the fuel truck."
"job.fueldriver.completedelivery"                       : "[FUEL] Complete fuel delivery to all gas stations."
"job.fueldriver.continuedelivery"                       : "[FUEL] Continue delivery to all gas stations."
"job.fueldriver.ifyouwantstart"                         : "[FUEL] You're fuel truck driver. If you want to start route - take route at Trago Oil headquartered in Oyster Bay."
"job.fueldriver.nicejob"                                : "[FUEL] Nice job! You earned $%.2f."
"job.fueldriver.routelist.title"                        : "[FUEL] ========== List of route =========="
"job.fueldriver.routelist.completed"                    : "[FUEL] %d. Gas station in %s - completed"
"job.fueldriver.routelist.waiting"                      : "[FUEL] %d. Gas station in %s - waiting"
"job.fueldriver.truck.loadedto"                         : "[FUEL] Fuel truck is loaded to %d / 16000"

"job.fueldriver.help.title"                             : "List of available commands for FUELDRIVER JOB:"

"job.fueldriver.help.job"                               : "E button"
"job.fueldriver.help.jobtext"                           : "Get fuel truck driver job at Trago Oil in Oyster Bay"
"job.fueldriver.help.jobleave"                          : "Q button"
"job.fueldriver.help.jobleavetext"                      : "Leave bus driver job at Trago Oil in Oyster Bay"
"job.fueldriver.help.loadunload"                        : "E button"
"job.fueldriver.help.loadunloadtext"                    : "Load/unload fuel truck"
"job.fueldriver.help.check"                             : "Checking loading truck"
"job.fueldriver.help.list"                              : "See list of route"

});


include("modules/jobs/fueldriver/commands.nut");

local job_fuel = {};
local job_fuel_blocked = {};
local fuelJobStationMarks = {};
local fuelcars = {};
local FUEL_JOB_TIMEOUT = 1800;


const FUEL_JOB_RADIUS = 2.0;
const FUEL_JOB_X = 551.762;
const FUEL_JOB_Y = -266.866;
const FUEL_JOB_Z = -20.1644;
const FUEL_JOB_SKIN = 144;
const FUEL_JOB_DISTANCE = 75;
const FUEL_JOB_SALARY = 22.0;
const FUEL_JOB_WAREHOUSE_X = 788.288;
const FUEL_JOB_WAREHOUSE_Y = -78.0801;
const FUEL_JOB_WAREHOUSE_Z = -20.0379;
const FUEL_JOB_LEVEL = 3;
      FUEL_JOB_COLOR <- CL_CRUSTA;

local fuelname = [
    "Oyster Bay",                       // FuelStation Oyster Bay
    "West Side",                        // FuelStation
    "Little Italy",                     // FuelStation LittleItaly Diamond
    "Little Italy (East)",              // FuelStation LittleItaly East
    "East Side",                        // FuelStation EastSide
    "Sand Island",                      // FuelStation Sand Island
    "Greenfield",                       // FuelStation Greenfield
    "Dipton"                            // FuelStation Dipton
];

// 788.288, -78.0801, -20.132   // coords of place to load fuel truck
// 551.762, -266.866, -20.1644  // coords of place to get job fueldriver

local fuelcoords = [
    [549.207, -0.0450191, -18.2822],    // FuelStation Oyster Bay
    [-632.54, -49.2751, 0.877252],      // FuelStation WestSide
    [-148.01, 610.752, -20.1982],       // FuelStation LittleItaly Diamond
    [336.611, 874.779, -21.3369],       // FuelStation LittleItaly East
    [112.749, 179.167, -20.0528],       // FuelStation EastSide
    [-1679.77, -234.395, -20.3644],     // FuelStation Sand Island
    [-1592.45, 944.839, -5.21593],      // FuelStation Greenfield
    [-708.044, 1762.78, -15.0323]       // FuelStation Dipton
];


event("onServerStarted", function() {
    log("[jobs] loading fueldriver job...");
    // DEPRECATED | fuelcars[i][0] - Truck ready: true/false DEPRECATED
    // fuelcars[i][1] - Fuel load: integer
    fuelcars[createVehicle(5, 510.0, -277.5, -20.19, -179.464, -0.05, 0.1)]  <- [false, 0 ];
    fuelcars[createVehicle(5, 515.0, -277.5, -20.19, -177.742, -0.05, 0.1)]  <- [false, 0 ];
    fuelcars[createVehicle(5, 520.0, -277.5, -20.19, -176.393, -0.05, 0.1)]  <- [false, 0 ];
    fuelcars[createVehicle(5, 525.0, -277.5, -20.19, -176.393, -0.05, 0.1)]  <- [false, 0 ];

    //creating 3dtext for Trago Oil
    create3DText ( FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_Z+0.35, "TRAGO OIL", CL_ROYALBLUE );
    create3DText ( FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_Z+0.20, "Press E to action", CL_WHITE.applyAlpha(150), FUEL_JOB_RADIUS );

    registerPersonalJobBlip("fueldriver", FUEL_JOB_X, FUEL_JOB_Y);

});

event("onPlayerConnect", function(playerid) {
    if ( ! (getPlayerName(playerid) in job_fuel) ) {
        job_fuel[getPlayerName(playerid)] <- {};
        job_fuel[getPlayerName(playerid)]["userstatus"] <- null;
        job_fuel[getPlayerName(playerid)]["fuelstatus"] <- [false, false, false, false, false, false, false, false]; // see sequence of gas stations in variable fuelname
        job_fuel[getPlayerName(playerid)]["fuelBlipTextWarehouse"] <- [];
        job_fuel[getPlayerName(playerid)]["leavejob3dtext"] <- null;
        job_fuel[getPlayerName(playerid)]["fuelcomplete"] <- 0;  // number of completed fuel stations. Default is 0
    }
});


event("onServerPlayerStarted", function( playerid ) {

    if(isFuelDriver(playerid)) {
        if (job_fuel[getPlayerName(playerid)]["userstatus"] == "working") {
            msg( playerid, "job.fueldriver.continuedelivery", FUEL_JOB_COLOR );
        } else {
            msg( playerid, "job.fueldriver.ifyouwantstart", FUEL_JOB_COLOR );
        }
        if (job_fuel[getPlayerName(playerid)]["userstatus"] == "wait") { job_fuel[getPlayerName(playerid)]["userstatus"] = "working"; }

        job_fuel[getPlayerName(playerid)]["fuelBlipTextWarehouse"].clear();
        if ( getPlayerName(playerid) in fuelJobStationMarks ) { fuelJobStationMarks[getPlayerName(playerid)].clear(); }
        job_fuel[getPlayerName(playerid)]["leavejob3dtext"] = createPrivate3DText (playerid, FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), FUEL_JOB_RADIUS );
    }
});


event("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    if (!isPlayerVehicleFuel(playerid)) return;

    // ignore anyhting related to other seats
    if (seat != 0) return;

    // if player on seat 0 is a fuel driver
    if (isFuelDriver(playerid) && job_fuel[getPlayerName(playerid)]["userstatus"] != null) {
        unblockVehicle(vehicleid);

        if(job_fuel[getPlayerName(playerid)]["userstatus"] == "working") {
            delayedFunction(4500, function() {
                    local vehicleid = getPlayerVehicle(playerid);
                    if(vehicleid == -1) return;
                    // create blip and 3text for warehouse
                    fuelJobWarehouseCreateBlipText( playerid );

                    if(fuelcars[vehicleid][1] >= 4000) {
                        createFuelJobStationMarks(playerid, fuelcoords);
                        msg( playerid, "job.fueldriver.truck.loaded", fuelcars[vehicleid][1], FUEL_JOB_COLOR );
                    } else {
                        msg( playerid, "job.fueldriver.truck.empty", FUEL_JOB_COLOR );
                    }
            });
        }
    } else {
        blockVehicle(vehicleid);
    }
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (!isPlayerVehicleFuel(playerid)) return;

    if (seat == 0) {
        blockVehicle(vehicleid);
    }
});

/*
key("5", function(playerid) {
    dbg(job_fuel[getPlayerName(playerid)]["userstatus"]);
    dbg(job_fuel[getPlayerName(playerid)]["fuelstatus"]);
    //dbg(job_fuel[getPlayerName(playerid)]["fuelBlipText"]);
    dbg(job_fuel[getPlayerName(playerid)]["fuelBlipTextWarehouse"]);
    dbg(job_fuel[getPlayerName(playerid)]["leavejob3dtext"]);
    dbg(job_fuel[getPlayerName(playerid)]["fuelcomplete"]);
    dbg(fuelJobStationMarks[getPlayerName(playerid)]);
}, KEY_UP);

key("6", function(playerid) {
    local vehicleid = getPlayerVehicle(playerid);
    setVehiclePosition(vehicleid, 787.877, -77.7658, -20.1317);
    setVehicleRotation(vehicleid, 0.693768, -0.384452, 0.0634007);
}, KEY_UP);

key("7", function(playerid) {
    local vehicleid = getPlayerVehicle(playerid);
    setVehiclePosition(vehicleid, 549.05, -1.73748, -18.2829);
    setVehicleRotation(vehicleid, -6.24619, -0.00735363, -0.134775);

}, KEY_UP);
*/
key("e", function(playerid) {
    fuelJobGet ( playerid );
    fuelJobLoadUnload ( playerid );
}, KEY_UP);

key("q", function(playerid) {
    fuelJobRefuseLeave ( playerid )
}, KEY_UP);



function createFuelJobStationMarks(playerid, data) {
    if (!(getPlayerName(playerid) in fuelJobStationMarks)) {
        fuelJobStationMarks[getPlayerName(playerid)] <- {};
    }

    // ignore creation if they already set
    if (fuelJobStationMarks[getPlayerName(playerid)].len()) {
        return;
    }

    foreach (id, value in data) {
        if (job_fuel[getPlayerName(playerid)]["fuelstatus"][id] == false) {
            fuelJobStationMarks[getPlayerName(playerid)][id] <- {
                text1 = createPrivate3DText(playerid, value[0], value[1], value[2]-0.15, "Press E to unload", CL_WHITE.applyAlpha(150), 8.0 ),
                text2 = null, // maybe add later
                blip  = createPrivateBlip(playerid, value[0], value[1], ICON_RED, 4000.0 )
            };
        }
    }
}

function removeFuelJobStationMark(playerid, id) {
    if (getPlayerName(playerid) in fuelJobStationMarks) {
        if (id in fuelJobStationMarks[getPlayerName(playerid)]) {
            remove3DText(fuelJobStationMarks[getPlayerName(playerid)][id].text1);
            // remove3DText(fuelJobStationMarks[getPlayerName(playerid)][id].text2); // curenlty disabled
            removeBlip(fuelJobStationMarks[getPlayerName(playerid)][id].blip);

            delete fuelJobStationMarks[getPlayerName(playerid)][id];
        }
    }
}

function clearFuelJobStationMarks(playerid) {
    if (getPlayerName(playerid) in fuelJobStationMarks) {
        foreach (id, value in fuelJobStationMarks[getPlayerName(playerid)]) {
            remove3DText(fuelJobStationMarks[getPlayerName(playerid)][id].text1);
            // remove3DText(fuelJobStationMarks[getPlayerName(playerid)][id].text2); // curenlty disabled
            removeBlip(fuelJobStationMarks[getPlayerName(playerid)][id].blip);
        }
        delete fuelJobStationMarks[getPlayerName(playerid)];
    }
}





/**
 * Check is player is a fuel driver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isFuelDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "fueldriver"));
}

/**
 * Check is player's vehicle is a fuel truck
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleFuel(playerid) {
    return (isPlayerInValidVehicle(playerid, 5));
}


/**
 * Check is FuelReady
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isFuelReady(playerid) {
    return fuelcars[vehicleid][0];
}


// working good, check
function fuelJobGet( playerid ) {
    if(!isPlayerInValidPoint(playerid, FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_RADIUS)) {
        return;
    }

    // если у игрока недостаточный уровень
    if(!isPlayerLevelValid ( playerid, FUEL_JOB_LEVEL )) {
        return msg(playerid, "job.fueldriver.needlevel", FUEL_JOB_LEVEL, FUEL_JOB_COLOR );
    }

    if (getPlayerName(playerid) in job_fuel_blocked) {
        if (getTimestamp() - job_fuel_blocked[getPlayerName(playerid)] < FUEL_JOB_TIMEOUT) {
            return msg( playerid, "job.fueldriver.badworker", FUEL_JOB_COLOR);
        }
    }

    // если у игрока статус работы == null
    if(job_fuel[getPlayerName(playerid)]["userstatus"] == null) {

        // если у игрока уже есть другая работа
        if(isPlayerHaveJob(playerid) && !isFuelDriver(playerid)) {
            return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), FUEL_JOB_COLOR );
        }

        if(!isPlayerHaveJob(playerid)) {
            msg( playerid, "job.fueldriver.now", FUEL_JOB_COLOR );

            setPlayerJob( playerid, "fueldriver");
            screenFadeinFadeoutEx(playerid, 250, 200, function() {
                setPlayerModel( playerid, FUEL_JOB_SKIN );
            });
        }

        fuelJobStartRoute( playerid );

        if(job_fuel[getPlayerName(playerid)]["leavejob3dtext"] == null) {
            job_fuel[getPlayerName(playerid)]["leavejob3dtext"] = createPrivate3DText (playerid, FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), FUEL_JOB_RADIUS );
        }
        return;
    }

    // если у игрока статус работы == выполняет работу
    if (job_fuel[getPlayerName(playerid)]["userstatus"] == "working") {
        return msg( playerid, "job.fueldriver.completedelivery", FUEL_JOB_COLOR );
    }
    // если у игрока статус работы == завершил работу
    if (job_fuel[getPlayerName(playerid)]["userstatus"] == "complete") {
        job_fuel[getPlayerName(playerid)]["userstatus"] = null;
        fuelGetSalary( playerid );
        job_fuel[getPlayerName(playerid)]["fuelstatus"] <- [false, false, false, false, false, false, false, false];
        job_fuel[getPlayerName(playerid)]["fuelcomplete"] = 0;
        return;
    }

}


// working good, check
function fuelJobStartRoute( playerid ) {
    msg( playerid, "job.fueldriver.sitintotruck", FUEL_JOB_COLOR );
    job_fuel[getPlayerName(playerid)]["userstatus"] = "working";
}


function fuelGetSalary( playerid ) {
    local amount = FUEL_JOB_SALARY + (random(-5, 1)).tofloat();
    msg( playerid, "job.fueldriver.nicejob", amount, FUEL_JOB_COLOR );
    addMoneyToPlayer(playerid, amount);
}


/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */


function fuelJobRefuseLeave( playerid ) {
    if(!isFuelDriver(playerid)) {
        return;
    }

    if(!isPlayerInValidPoint(playerid, FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_RADIUS)) {
        return;
    }

    if(job_fuel[getPlayerName(playerid)]["userstatus"] == null) {
        msg( playerid, "job.fueldriver.goodluck", FUEL_JOB_COLOR);
    }

    if (job_fuel[getPlayerName(playerid)]["userstatus"] == "working") {
        msg( playerid, "job.fueldriver.badworker.onleave", FUEL_JOB_COLOR);
        job_fuel[getPlayerName(playerid)]["userstatus"] = "nojob";
        job_fuel[getPlayerName(playerid)]["userstatus"] = null;
        job_fuel_blocked[getPlayerName(playerid)] <- getTimestamp();
    }

    if (job_fuel[getPlayerName(playerid)]["userstatus"] == "complete") {
        job_fuel[getPlayerName(playerid)]["userstatus"] = null;
        fuelGetSalary( playerid );
        msg( playerid, "job.fueldriver.goodluck", FUEL_JOB_COLOR);
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        remove3DText ( job_fuel[getPlayerName(playerid)]["leavejob3dtext"] );

        msg( playerid, "job.leave", FUEL_JOB_COLOR );

        job_fuel[getPlayerName(playerid)]["leavejob3dtext"] = null;

        setPlayerJob( playerid, null );
        restorePlayerModel(playerid);

        // remove private blip job
        removePersonalJobBlip ( playerid );

        // clear all marks
        clearFuelJobStationMarks(playerid);
        fuelJobWarehouseRemoveBlipText( playerid );
    });

}


// working good, check
function fuelJobLoadUnload ( playerid ) {

    if(!isFuelDriver(playerid)) {
        return;
    }

    if(job_fuel[getPlayerName(playerid)]["userstatus"] != "working" || !isPlayerInVehicle(playerid) || !isPlayerVehicleDriver(playerid)) {
        return;
    }

    if (!isPlayerVehicleFuel(playerid)) {
        return msg(playerid, "job.fueldriver.needfueltruck", FUEL_JOB_COLOR );
    }

    local vehicleid = getPlayerVehicle(playerid);

    local check_ware = false;
    local check = false;
    local i = -1;
    foreach (key, value in fuelcoords) {
        if (isPlayerVehicleInValidPoint(playerid, value[0], value[1], 8.0 )) {
            check = true;
            i = key;
            break;
        }
    }

    if(isPlayerVehicleInValidPoint(playerid, FUEL_JOB_WAREHOUSE_X, FUEL_JOB_WAREHOUSE_Y, 5.0)) {
        check_ware = true;
    }

    if (!check && !check_ware) {
       return;
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.fueldriver.driving", CL_RED );
    }

    setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);

    if(check && job_fuel[getPlayerName(playerid)]["fuelstatus"][i]) {
        return msg( playerid, "job.fueldriver.alreadybeenhere", FUEL_JOB_COLOR );
    }

    if(check && fuelcars[vehicleid][1] < 4000) {
        // create blip and 3text for warehouse
        fuelJobWarehouseCreateBlipText( playerid );
        return msg( playerid, "job.fueldriver.truck.fuelnotenough", FUEL_JOB_COLOR );
    }


    if(check_ware && fuelcars[vehicleid][1] == 16000) {
        return msg( playerid, "job.fueldriver.truck.alreadyloaded", FUEL_JOB_COLOR );
    }

    job_fuel[getPlayerName(playerid)]["userstatus"] = "wait";

    // to load
    if(check_ware && fuelcars[vehicleid][1] < 16000) {

        msg( playerid, "job.fueldriver.truck.loading", FUEL_JOB_COLOR );
        freezePlayer( playerid, true);
        setVehicleEngineState(vehicleid, false);
        trigger(playerid, "hudCreateTimer", 30.0, true, true);
        delayedFunction(30000, function () {
            job_fuel[getPlayerName(playerid)]["userstatus"] = "working";
            freezePlayer( playerid, false);
            delayedFunction(1000, function () { freezePlayer( playerid, false); });

            fuelcars[vehicleid][1] = 16000;
            msg( playerid, "job.fueldriver.truck.fullloaded", FUEL_JOB_COLOR );
            createFuelJobStationMarks(playerid, fuelcoords);
        });

        return;
    }

    msg( playerid, "job.fueldriver.truck.unloading", FUEL_JOB_COLOR );
    freezePlayer( playerid, true);
    setVehicleEngineState(vehicleid, false);
    trigger(playerid, "hudCreateTimer", 10.0, true, true);
    delayedFunction(10000, function () {
        freezePlayer( playerid, false);
        delayedFunction(1000, function () { freezePlayer( playerid, false); });

        fuelcars[vehicleid][1] -= 4000;
        job_fuel[getPlayerName(playerid)]["fuelstatus"][i] = true;
        job_fuel[getPlayerName(playerid)]["fuelcomplete"] += 1;

        // remove blip on complete unload
        removeFuelJobStationMark(playerid, i);

        if (job_fuel[getPlayerName(playerid)]["fuelcomplete"] == 8) {
            msg( playerid, "job.fueldriver.truck.parking", FUEL_JOB_COLOR );
            fuelJobWarehouseRemoveBlipText( playerid );
            job_fuel[getPlayerName(playerid)]["userstatus"] = "complete";
        } else {
            job_fuel[getPlayerName(playerid)]["userstatus"] = "working";
            if (fuelcars[vehicleid][1] >= 4000) {
                msg( playerid, "job.fueldriver.truck.unloadingcompletedtruckisloaded", fuelcars[vehicleid][1], FUEL_JOB_COLOR );
            } else {
                msg( playerid, "job.fueldriver.truck.unloadingcompletedfuelnotenough", FUEL_JOB_COLOR );
            }
        }
    });
}


// working good, check
function fuelJobList ( playerid ) {
    if(isFuelDriver(playerid))    {
        msg( playerid, "job.fueldriver.routelist.title", CL_JOB_LIST);
        foreach (key, value in job_fuel[getPlayerName(playerid)]["fuelstatus"]) {
            local i = key+1;
            if (value == true) {
                msg( playerid, "job.fueldriver.routelist.completed", [i , fuelname[key]], CL_JOB_LIST_GR);
            } else {
                msg( playerid, "job.fueldriver.routelist.waiting", [i, fuelname[key]], CL_JOB_LIST_R);
            }
        }
    } else { msg( playerid, "job.fueldriver.not", FUEL_JOB_COLOR ); }
}

// working good, check
function fuelJobCheck ( playerid ) {

    if(!isFuelDriver(playerid)) {
        return msg( playerid, "job.fueldriver.not", FUEL_JOB_COLOR );
    }

    if (!isPlayerVehicleFuel(playerid)) {
        return msg(playerid, "job.fueldriver.needfueltruck", FUEL_JOB_COLOR );
    }

    local vehicleid = getPlayerVehicle(playerid);
    msg( playerid, "job.fueldriver.truck.loadedto", fuelcars[vehicleid][1], FUEL_JOB_COLOR  );
}


function fuelJobWarehouseCreateBlipText( playerid ) {
    if(job_fuel[getPlayerName(playerid)]["fuelBlipTextWarehouse"].len() < 1) {
       job_fuel[getPlayerName(playerid)]["fuelBlipTextWarehouse"].push( createPrivate3DText (playerid, FUEL_JOB_WAREHOUSE_X, FUEL_JOB_WAREHOUSE_Y, FUEL_JOB_WAREHOUSE_Z+0.35, "=== FUEL WAREHOUSE ===", CL_RIPELEMON, 100.0 ));
       job_fuel[getPlayerName(playerid)]["fuelBlipTextWarehouse"].push( createPrivate3DText (playerid, FUEL_JOB_WAREHOUSE_X, FUEL_JOB_WAREHOUSE_Y, FUEL_JOB_WAREHOUSE_Z-0.15, "Press E to load", CL_WHITE.applyAlpha(150), 5.0 ));
       job_fuel[getPlayerName(playerid)]["fuelBlipTextWarehouse"].push( createPrivateBlip(playerid, FUEL_JOB_WAREHOUSE_X, FUEL_JOB_WAREHOUSE_Y, ICON_YELLOW, 4000.0));
    }
}

function fuelJobWarehouseRemoveBlipText( playerid ) {
    if(job_fuel[getPlayerName(playerid)]["fuelBlipTextWarehouse"].len() > 0) {
        remove3DText(job_fuel[getPlayerName(playerid)]["fuelBlipTextWarehouse"][0]);
        remove3DText(job_fuel[getPlayerName(playerid)]["fuelBlipTextWarehouse"][1]);
        removeBlip(job_fuel[getPlayerName(playerid)]["fuelBlipTextWarehouse"][2]);
        job_fuel[getPlayerName(playerid)]["fuelBlipTextWarehouse"].clear();
    }
}
