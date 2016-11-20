include("controllers/jobs/fuel/commands.nut");

local job_fuel = {};
local fuelcars = {};

const RADIUS_JOB_FUEL = 2.0;
const FUEL_JOB_X = 551.762;
const FUEL_JOB_Y = -266.866;
const FUEL_JOB_SKIN = 144;

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
    // fuelcars[i][0] - Truck ready: true/false
    // fuelcars[i][1] - Fuel load: integer
    fuelcars[createVehicle(5, 511.887, -277.5, -20.19, -179.464, -0.05, 0.1)]  <- [false, 0 ];
    fuelcars[createVehicle(5, 517.782, -277.5, -20.19, -177.742, -0.05, 0.1)]  <- [false, 0 ];
    fuelcars[createVehicle(5, 523.821, -277.5, -20.19, -176.393, -0.05, 0.1)]  <- [false, 0 ];
});

addEventHandler("onPlayerConnect", function(playerid, name, ip, serial) {
     job_fuel[playerid] <- {};
     job_fuel[playerid]["fuelstatus"] <- [false, false, false, false, false, false, false, false]; // see sequence of gas stations in variable fuelname
     job_fuel[playerid]["fuelcomplete"] <- 0;  // number of completed fuel stations. Default is 0
});


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

    if(!isPlayerInValidPoint(playerid, FUEL_JOB_X, FUEL_JOB_Y, RADIUS_JOB_FUEL)) {
        return msg( playerid, "Let's go to Trago Oil headquartered in Oyster Bay (right door at corner of the building) to become fuel truck driver." );
    }

    if(isFuelDriver(playerid)) {
        return msg( playerid, "You're fueldriver already.");
    }

    if(isPlayerHaveJob(playerid)) {
        return msg(playerid, "You already have a job: " + getPlayerJob(playerid) + ".");
    }

    msg( playerid, "You're a fuel truck driver now! Congratulations!" );
    msg( playerid, "Sit into fuel truck." );

    players[playerid]["job"] = "fueldriver";

    players[playerid]["skin"] = FUEL_JOB_SKIN;
    setPlayerModel( playerid, FUEL_JOB_SKIN );

}


// working good, check
function fuelJobLeave ( playerid ) {

    if(!isPlayerInValidPoint(playerid, FUEL_JOB_X, FUEL_JOB_Y, RADIUS_JOB_FUEL)) {
        return msg( playerid, "Let's go to Trago Oil headquartered in Oyster Bay (right door at corner of the building) to become fuel truck driver." );
    }

    if(!isFuelDriver(playerid)) {
        return msg( playerid, "You're not a fuel truck driver.");
    }

    msg( playerid, "You leave this job." );

    players[playerid]["job"] = null;

    players[playerid]["skin"] = players[playerid]["default_skin"];
    setPlayerModel( playerid, players[playerid]["default_skin"]);
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
    if(fuelcars[vehicleid][0]) {
        return msg( playerid, "The truck is ready already.");
    }

    fuelcars[vehicleid][0] = true;

    if(fuelcars[vehicleid][1] >= 4000) {
        msg( playerid, "The truck is ready. Truck is loaded to " + fuelcars[vehicleid][1] + " / 16000");
    } else {
        msg( playerid, "The truck is ready. Go to the warehouse of fuel in South Millville to load fuel truck." );
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
    if (!fuelcars[vehicleid][0]) {
        return msg( playerid, "The truck isn't ready." );
    }

    if(!isVehicleInValidPoint(playerid, 788.288, -78.0801, 5.0)) {
        return msg( playerid, "Go to the warehouse of fuel in South Millville to load fuel truck." );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "You're driving. Please stop the fuel truck.");
    }

    if(fuelcars[vehicleid][1] < 16000) {
        fuelcars[vehicleid][1] = 16000;
        msg( playerid, "Fuel truck is loaded to 16000 / 16000. Deliver fuel to gas stations." );
    } else {
        msg( playerid, "Fuel truck already loaded." );
    }
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
    if (!fuelcars[vehicleid][0]) {
        return msg( playerid, "The truck isn't ready." );
    }

    if(fuelcars[vehicleid][1] < 4000) {
        return msg( playerid, "Fuel is not enough. Go to the warehouse to load fuel truck." );
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

    if (job_fuel[playerid]["fuelcomplete"] == 8) {
        msg( playerid, "Nice job! Return the fuel truck to Trago Oil headquartered in Oyster Bay, park truck and take your money." );
    } else {
        if (fuelcars[vehicleid][1] >= 4000) {
            msg( playerid, "Unloading completed. Fuel truck is loaded to " + fuelcars[vehicleid][1] + " / 16000. Go to next gas station." );
        } else {
            msg( playerid, "Unloading completed. Fuel is not enough. Go to the warehouse to load fuel truck." );
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
    if (!fuelcars[vehicleid][0]) {
        return msg( playerid, "The truck isn't ready." );
    }

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
    fuelcars[vehicleid][0] = false;
    msg( playerid, "Nice job! You earned $40." );
    addMoneyToPlayer(playerid, 40);
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
    if (!fuelcars[vehicleid][0]) {
        return msg( playerid, "The truck isn't ready." );
    }

    msg( playerid, "Fuel truck is loaded to " + fuelcars[vehicleid][1] + " / 16000" );
}
