include("controllers/jobs/fuel/commands.nut");

local job_fuel = {};
local fuelcars = {};

const FUEL_JOB_RADIUS = 2.0;
const FUEL_JOB_X = 551.762;
const FUEL_JOB_Y = -266.866;
const FUEL_JOB_Z = -20.1644;
const FUEL_JOB_SKIN = 144;
const FUEL_JOB_DISTANCE = 75;

const FUEL_JOB_WAREHOUSE_X = 788.288;
const FUEL_JOB_WAREHOUSE_Y = -78.0801;
const FUEL_JOB_WAREHOUSE_Z = -20.0379;

local fuelname = [
    "Oyster Bay",                       // FuelStation Oyster Bay
    "West Side",                        // FuelStation
    "Little Italy (Diamond Motors)",    // FuelStation LittleItaly Diamond
    "Little Italy East",                // FuelStation LittleItaly East
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


addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading fuel job...");
    // DEPRECATED | fuelcars[i][0] - Truck ready: true/false DEPRECATED
    // fuelcars[i][1] - Fuel load: integer
    fuelcars[createVehicle(5, 511.887, -277.5, -20.19, -179.464, -0.05, 0.1)]  <- [false, 0 ];
    fuelcars[createVehicle(5, 517.782, -277.5, -20.19, -177.742, -0.05, 0.1)]  <- [false, 0 ];
    fuelcars[createVehicle(5, 523.821, -277.5, -20.19, -176.393, -0.05, 0.1)]  <- [false, 0 ];

    //creating 3dtext for Trago Oil
    create3DText ( FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_Z+0.35, "TRAGO OIL", CL_ROYALBLUE );
    create3DText ( FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_Z-0.15, "/help job fuel", CL_WHITE.applyAlpha(75) );

    registerPersonalJobBlip("fueldriver", FUEL_JOB_X, FUEL_JOB_Y);
});

addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial) {
     job_fuel[playerid] <- {};
     job_fuel[playerid]["fuelstatus"] <- [false, false, false, false, false, false, false, false]; // see sequence of gas stations in variable fuelname
     job_fuel[playerid]["fuelBlipText"] <- [ [], [] ];
     job_fuel[playerid]["fuelBlipTextWarehouse"] <- [];
     job_fuel[playerid]["fuelcomplete"] <- 0;  // number of completed fuel stations. Default is 0
});

local fuelJobStationMarks = {};
function createFuelJobStationMarks(playerid, data) {
    if (!(playerid in fuelJobStationMarks)) {
        fuelJobStationMarks[playerid] <- {};
    }

    // ignore creation if they already set
    if (fuelJobStationMarks[playerid].len()) {
        return;
    }

    foreach (id, value in data) {
        fuelJobStationMarks[playerid][id] <- {
            text1 = createPrivate3DText(playerid, value[0], value[1], value[2]-0.15, "/fuel unload", CL_WHITE.applyAlpha(150), 10 ),
            text2 = null, // maybe add later
            blip  = createPrivateBlip(playerid, value[0], value[1], ICON_RED, 4000.0 )
        };
    }
}

function removeFuelJobStationMark(playerid, id) {
    if (playerid in fuelJobStationMarks) {
        if (id in fuelJobStationMarks[playerid]) {
            remove3DText(fuelJobStationMarks[playerid][id].text1);
            // remove3DText(fuelJobStationMarks[playerid][id].text2); // curenlty disabled
            removeBlip(fuelJobStationMarks[playerid][id].blip);

            delete fuelJobStationMarks[playerid][id];
        }
    }
}

function clearFuelJobStationMarks(playerid) {
    if (playerid in fuelJobStationMarks) {
        foreach (id, value in fuelJobStationMarks[playerid]) {
            remove3DText(fuelJobStationMarks[playerid][id].text1);
            // remove3DText(fuelJobStationMarks[playerid][id].text2); // curenlty disabled
            removeBlip(fuelJobStationMarks[playerid][id].blip);
        }
        delete fuelJobStationMarks[playerid];
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
function fuelJob ( playerid ) {

    if(!isPlayerInValidPoint(playerid, FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_RADIUS)) {
        return msg( playerid, "Let's go to Trago Oil headquartered in Oyster Bay (right door at corner of the building) to become fuel truck driver." );
    }

    if(isFuelDriver(playerid)) {
        return msg( playerid, "You're fueldriver already.");
    }

    if(isPlayerHaveJob(playerid)) {
        return msg(playerid, "You already have a job: " + getPlayerJob(playerid) + ".");
    }
    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "You're a fuel truck driver now! Congratulations!" );
        msg( playerid, "Sit into fuel truck." );

        players[playerid]["job"] = "fueldriver";

        players[playerid]["skin"] = FUEL_JOB_SKIN;
        setPlayerModel( playerid, FUEL_JOB_SKIN );

        // create private blip job
        createPersonalJobBlip(playerid, FUEL_JOB_X, FUEL_JOB_Y);
    });
}


// working good, check
function fuelJobLeave ( playerid ) {

    if(!isPlayerInValidPoint(playerid, FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_RADIUS)) {
        return msg( playerid, "Let's go to Trago Oil headquartered in Oyster Bay (right door at corner of the building) to become fuel truck driver." );
    }

    if(!isFuelDriver(playerid)) {
        return msg( playerid, "You're not a fuel truck driver.");
    }
    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "You leave this job." );

        players[playerid]["job"] = null;

        players[playerid]["skin"] = players[playerid]["default_skin"];
        setPlayerModel( playerid, players[playerid]["default_skin"]);

        // remove private blip job
        removePersonalJobBlip ( playerid );

        // clear all marks
        clearFuelJobStationMarks(playerid);
        fuelJobWarehouseRemoveBlipText( playerid );
    });
}


// working good, check
function fuelJobReady ( playerid ) {

    if(!isFuelDriver(playerid)) {
        return msg( playerid, "You're not a fuel truck driver.");
    }

    if (!isPlayerVehicleFuel(playerid)) {
        return msg(playerid, "You need a fuel truck.");
    }

    local vehicleid = getPlayerVehicle(playerid);

    // create blip and 3text for warehouse
    fuelJobWarehouseCreateBlipText( playerid );

    if(fuelcars[vehicleid][1] >= 4000) {
        msg( playerid, "Truck is loaded to " + fuelcars[vehicleid][1] + " / 16000. Deliver fuel to gas stations.");
    } else {
        msg( playerid, "The truck is empty. Go to the warehouse of fuel in South Millville to load fuel truck (yellow icon on radar)." );
    }
}

// working good, check
function fuelJobLoad ( playerid ) {

    if(!isFuelDriver(playerid)) {
        return msg( playerid, "You're not a fuel truck driver.");
    }

    if (!isPlayerVehicleFuel(playerid)) {
        return msg(playerid, "You need a fuel truck.");
    }

    local vehicleid = getPlayerVehicle(playerid);

    if(!isVehicleInValidPoint(playerid, FUEL_JOB_WAREHOUSE_X, FUEL_JOB_WAREHOUSE_Y, 5.0)) {
        // create blip and 3text for warehouse
        fuelJobWarehouseCreateBlipText( playerid );
        return msg( playerid, "Go to the warehouse of fuel in South Millville to load fuel truck (yellow icon on radar)." );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "You're driving. Please stop the fuel truck.");
    }

    if(fuelcars[vehicleid][1] == 16000) {
       return msg( playerid, "Fuel truck already loaded." );
    }

    if(fuelcars[vehicleid][1] < 16000) {
        fuelcars[vehicleid][1] = 16000;
        msg( playerid, "Fuel truck is loaded to 16000 / 16000. Deliver fuel to gas stations." );
    }

    // create fuel marks
    createFuelJobStationMarks(playerid, fuelcoords);
}

// working good, check
function fuelJobUnload ( playerid ) {

    if(!isFuelDriver(playerid)) {
        return msg( playerid, "You're not a fuel truck driver.");
    }

    if (!isPlayerVehicleFuel(playerid)) {
        return msg(playerid, "You need a fuel truck.");
    }

    local vehicleid = getPlayerVehicle(playerid);

    if(fuelcars[vehicleid][1] < 4000) {
        return msg( playerid, "Fuel is not enough. Go to the warehouse to load fuel truck (yellow icon on radar)." );
    }

    local check = false;
    local i = -1;
    foreach (key, value in fuelcoords) {
        if (isVehicleInValidPoint(playerid, value[0], value[1], 5.0 )) {
            check = true;
            i = key;
            break;
        }
    }

    if (!check) {
       return  msg( playerid, "Go to gas station to unload fuel." );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "You're driving. Please stop the fuel truck.");
    }

    if(job_fuel[playerid]["fuelstatus"][i]) {
        return msg( playerid, "You've already been here. Go to other gas station." );
    }

    fuelcars[vehicleid][1] -= 4000;
    job_fuel[playerid]["fuelstatus"][i] = true;
    job_fuel[playerid]["fuelcomplete"] += 1;

    // remove blip on complete unload
    removeFuelJobStationMark(playerid, i);

    if (job_fuel[playerid]["fuelcomplete"] == 8) {
        msg( playerid, "Nice job! Return the fuel truck to Trago Oil headquartered in Oyster Bay, park truck and take your money." );
    } else {
        if (fuelcars[vehicleid][1] >= 4000) {
            msg( playerid, "Unloading completed. Fuel truck is loaded to " + fuelcars[vehicleid][1] + " / 16000. Go to next gas station." );
        } else {
            msg( playerid, "Unloading completed. Fuel is not enough. Go to the warehouse to load fuel truck (yellow icon on radar)." );
        }
    }
}


// working good, check
function fuelJobPark ( playerid ) {

    if(!isFuelDriver(playerid)) {
        return msg( playerid, "You're not a fuel truck driver.");
    }

    if (!isPlayerVehicleFuel(playerid)) {
        return msg(playerid, "You need a fuel truck.");
    }

    local vehicleid = getPlayerVehicle(playerid);

    if(!isVehicleInValidPoint(playerid, 517.782, -277.5, 10.0)) {
        return msg( playerid, "Go to Trago Oil headquartered to park the fuel truck." );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "You're driving. Please stop the fuel truck.");
    }

    if (job_fuel[playerid]["fuelcomplete"] < 8) {
        return msg( playerid, "Complete fuel delivery to all gas stations." );
    }

    job_fuel[playerid]["fuelcomplete"] = 0;
    msg( playerid, "Nice job! You earned $40." );
    addMoneyToPlayer(playerid, 40);

    // clear all marks
    clearFuelJobStationMarks( playerid );
    fuelJobWarehouseRemoveBlipText( playerid );
}


// working good, check
function fuelJobList ( playerid ) {
    if(players[playerid]["job"] == "fueldriver")    {
        msg( playerid, "========== List of route ==========", CL_JOB_LIST);
        foreach (key, value in job_fuel[playerid]["fuelstatus"]) {
            local i = key+1;
            if (value == true) {
                msg( playerid, i + ". Gas station in " + fuelname[key] + " - completed", CL_JOB_LIST_GR);
            } else {
                msg( playerid, i + ". Gas station in " + fuelname[key] + " - waiting", CL_JOB_LIST_R);
            }
        }
    } else { msg( playerid, "You're not a fuel truck driver"); }
}

// working good, check
function fuelJobCheck ( playerid ) {

    if(!isFuelDriver(playerid)) {
        return msg( playerid, "You're not a fuel truck driver.");
    }

    if (!isPlayerVehicleFuel(playerid)) {
        return msg(playerid, "You need a fuel truck.");
    }

    local vehicleid = getPlayerVehicle(playerid);
    msg( playerid, "Fuel truck is loaded to " + fuelcars[vehicleid][1] + " / 16000" );
}


function fuelJobWarehouseCreateBlipText( playerid ) {
    if(job_fuel[playerid]["fuelBlipTextWarehouse"].len() < 1) {
        job_fuel[playerid]["fuelBlipTextWarehouse"].push( createPrivate3DText (playerid, FUEL_JOB_WAREHOUSE_X, FUEL_JOB_WAREHOUSE_Y, FUEL_JOB_WAREHOUSE_Z+0.35, "=== FUEL WAREHOUSE ===", CL_RIPELEMON, 100.0 ));
        job_fuel[playerid]["fuelBlipTextWarehouse"].push( createPrivate3DText (playerid, FUEL_JOB_WAREHOUSE_X, FUEL_JOB_WAREHOUSE_Y, FUEL_JOB_WAREHOUSE_Z-0.15, "/fuel load", CL_WHITE.applyAlpha(150), 5.0 ));
        job_fuel[playerid]["fuelBlipTextWarehouse"].push( createPrivateBlip(playerid, FUEL_JOB_WAREHOUSE_X, FUEL_JOB_WAREHOUSE_Y, ICON_YELLOW, 4000.0));
    }
}

function fuelJobWarehouseRemoveBlipText( playerid ) {
    if(job_fuel[playerid]["fuelBlipTextWarehouse"].len() > 0) {
        remove3DText(job_fuel[playerid]["fuelBlipTextWarehouse"][0]);
        remove3DText(job_fuel[playerid]["fuelBlipTextWarehouse"][1]);
        removeBlip(job_fuel[playerid]["fuelBlipTextWarehouse"][2]);
        job_fuel[playerid]["fuelBlipTextWarehouse"].clear();
    }
}
