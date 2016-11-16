include("controllers/jobs/milkdriver/commands.nut");

local job_milk = {};
local milktrucks = {};

const RADIUS_JOB_MILK = 2.0;
const MILK_JOB_X =  176.8;
const MILK_JOB_Y = 439.305;

local milkname = [
    "Hill Of Tara Black Exit",                  // Hill Of Tara Black Exit
    "Empire Diner Kingston",                    // Empire Diner Kingston
    "Empire Diner Greenfield",                  // Empire Diner Greenfield
    "Empire Diner Highbrook"                    // Empire Diner Highbrook
];

// 788.288, -78.0801, -20.132   // coords of place to load milk truck
// 551.762, -266.866, -20.1644  // coords of place to get job milkdriver

local milkcoords = [
    [-1162.5, 1599.26, 6.46012],    // Hill Of Tara Black Exit
    [-1594.78, 1602.47, -5.90717],      // Empire Diner Kingston
    [-1418.26, 975.404, -13.577],       // Empire Diner Greenfield
    [-634.34, 1292.31, 3.26542]        // Empire Diner Highbrook
];


addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading milkdriver job...");
    // milktrucks[i][0] - Truck ready: true/false
    // milktrucks[i][1] - milk load: integer
    milktrucks[createVehicle(19, 172.868, 436, -20.04, -178.634, 0.392045, -0.829271)]  <- [false, 0 ];
    milktrucks[createVehicle(19, 168.812, 436, -20.04, 179.681, 0.427494, -0.637235)]  <- [false, 0 ];
});

addEventHandler("onPlayerConnect", function(playerid, name, ip, serial) {
     job_milk[playerid] <- {};
     job_milk[playerid]["milkstatus"] <- [false, false, false, false, false, false, false, false]; // see sequence of gas stations in variable milkname
     job_milk[playerid]["milkcomplete"] <- 0;  // number of completed milk stations. Default is 0
});


/**
 * Check is player is a milk driver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isMilkDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "milkdriver"));
}

/**
 * Check is player's vehicle is a milk truck
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleMilk(playerid) {
    return (isPlayerInValidVehicle(playerid, 19));
}


/**
 * Check is milkReady
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isMilkReady(playerid) {
    return milktrucks[vehicleid][0];
}


// working good, check
function milkJob ( playerid ) {

    if(!isPlayerInValidPoint(playerid, MILK_JOB_X, MILK_JOB_Y, RADIUS_JOB_MILK)) {
        return msg( playerid, "Let's go to Empire Bay Milk Co." );
    }

    if(isMilkDriver(playerid)) {
        return msg( playerid, "You're milkdriver already.");
    }

    if(isPlayerHaveJob(playerid)) {
        return msg(playerid, "You already have a job: " + getPlayerJob(playerid) + ".");
    }

    msg( playerid, "You're a milk truck driver now! Congratulations!" );
    msg( playerid, "Sit into milk truck." );
    setPlayerModel( playerid, 144 );
    players[playerid]["job"] = "milkdriver";
}


// working good, check
function milkJobLeave ( playerid ) {

    if(!isPlayerInValidPoint(playerid, MILK_JOB_X, MILK_JOB_Y, RADIUS_JOB_MILK)) {
        return msg( playerid, "Let's go to farm" );
    }

    if(!isMilkDriver(playerid)) {
        return msg( playerid, "You're not a milk truck driver.");
    }

    msg( playerid, "You leave this job." );
    setPlayerModel( playerid, 10 );
    players[playerid]["job"] = null;

}


// working good, check
function milkJobReady ( playerid ) {

    if(!isMilkDriver(playerid)) {
        return msg( playerid, "You're not a milk truck driver.");
    }

    if (!isPlayerVehicleMilk(playerid)) {
        return msg(playerid, "You need a milk truck.");
    }

    local vehicleid = getPlayerVehicle(playerid);
    if(milktrucks[vehicleid][0]) {
        return msg( playerid, "The truck is ready already.");
    }

    milktrucks[vehicleid][0] = true;

    if(milktrucks[vehicleid][1] >= 12) {
        msg( playerid, "The truck is ready. Truck is loaded to " + milktrucks[vehicleid][1] + " / 120");
    } else {
        msg( playerid, "The truck is ready, but empty. Load milk to truck." );
    }
}

// working good, check
function milkJobLoad ( playerid ) {

    if(!isMilkDriver(playerid)) {
        return msg( playerid, "You're not a milk truck driver.");
    }

    if (!isPlayerVehicleMilk(playerid)) {
        return msg(playerid, "You need a milk truck.");
    }

    local vehicleid = getPlayerVehicle(playerid);
    if (!milktrucks[vehicleid][0]) {
        return msg( playerid, "The truck isn't ready." );
    }

    if(!isVehicleInValidPoint(playerid, 170.737, 436.886, 4.0)) {
        return msg( playerid, "Go to the milk filling station in Chinatown to load milk truck." );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "You're driving. Please stop the milk truck.");
    }
// load in 1 pint = 0.5 litres
    if(milktrucks[vehicleid][1] < 120) {
        milktrucks[vehicleid][1] = 120;
        msg( playerid, "Milk truck is loaded to 120 / 120. Carry milk to addresses." );
    } else {
        msg( playerid, "Milk truck already loaded." );
    }
}

// working good, check
function milkJobUnload ( playerid ) {

    if(!isMilkDriver(playerid)) {
        return msg( playerid, "You're not a milk truck driver.");
    }

    if (!isPlayerVehicleMilk(playerid)) {
        return msg(playerid, "You need a milk truck.");
    }

    local vehicleid = getPlayerVehicle(playerid);
    if (!milktrucks[vehicleid][0]) {
        return msg( playerid, "The truck isn't ready." );
    }

    if(milktrucks[vehicleid][1] < 12) {
        return msg( playerid, "Milk is not enough. Go to the milk filling station in Chinatown to load milk truck." );
    }

    local check = false;
    local i = -1;
    foreach (key, value in milkcoords) {
        if (isVehicleInValidPoint(playerid, value[0], value[1], 5.0 )) {
            check = true;
            i = key;
            break;
        }
    }

    if (!check) {
       return  msg( playerid, "Carry milk to addresses." );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "You're driving. Please stop the milk truck.");
    }

    if(job_milk[playerid]["milkstatus"][i]) {
        return msg( playerid, "You've already been here. Go to other address." );
    }

    milktrucks[vehicleid][1] -= 12;
    job_milk[playerid]["milkstatus"][i] = true;
    job_milk[playerid]["milkcomplete"] += 1;

    if (job_milk[playerid]["milkcomplete"] == 8) {
        msg( playerid, "Nice job! Return the milk truck to milk filling station in Chinatown, park truck and take your money." );
    } else {
        if (milktrucks[vehicleid][1] >= 12) {
            msg( playerid, "Unloading completed. Milk truck is loaded to " + milktrucks[vehicleid][1] + " / 120. Go to next address." );
        } else {
            msg( playerid, "Unloading completed. Milk is not enough. Go to the milk filling station to load milk truck." );
        }
    }
}


// working good, check
function milkJobPark ( playerid ) {

    if(!isMilkDriver(playerid)) {
        return msg( playerid, "You're not a milk truck driver.");
    }

    if (!isPlayerVehicleMilk(playerid)) {
        return msg(playerid, "You need a milk truck.");
    }

    local vehicleid = getPlayerVehicle(playerid);
    if (!milktrucks[vehicleid][0]) {
        return msg( playerid, "The truck isn't ready." );
    }

    if(!isVehicleInValidPoint(playerid, 170.737, 436.886, 4.0)) {
        return msg( playerid, "Go to the milk filling station to park the milk truck." );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "You're driving. Please stop the milk truck.");
    }

    if (job_milk[playerid]["milkcomplete"] < 8) {
        return msg( playerid, "Complete milk delivery to all addresses." );
    }

    job_milk[playerid]["milkcomplete"] = 0;
    milktrucks[vehicleid][0] = false;
    msg( playerid, "Nice job! You earned $20." );
    addMoneyToPlayer(playerid, 20);
}


// working good, check
function milkJobList ( playerid ) {
    if(players[playerid]["job"] == "milkdriver")    {
        msg( playerid, "========== List of route ==========", CL_JOB_LIST);
        foreach (key, value in job_milk[playerid]["milkstatus"]) {
            local i = key+1;
            if (value == true) {
                msg( playerid, i + ". Gas station in " + milkname[key] + " - completed", CL_JOB_LIST_GR);
            } else {
                msg( playerid, i + ". Gas station in " + milkname[key] + " - waiting", CL_JOB_LIST_R);
            }
        }
    } else { msg( playerid, "You're not a milk truck driver"); }
}

// working good, check
function milkJobCheck ( playerid ) {

    if(!isMilkDriver(playerid)) {
        return msg( playerid, "You're not a milk truck driver.");
    }

    if (!isPlayerVehicleMilk(playerid)) {
        return msg(playerid, "You need a milk truck.");
    }

    local vehicleid = getPlayerVehicle(playerid);
    if (!milktrucks[vehicleid][0]) {
        return msg( playerid, "The truck isn't ready." );
    }

    msg( playerid, "Milk truck is loaded to " + milktrucks[vehicleid][1] + " / 120" );
}
