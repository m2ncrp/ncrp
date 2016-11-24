include("controllers/jobs/cargodriver/commands.nut");

local job_cargo = {};
local cargocars = {};


const RADIUS_CARGO = 1.0;
//const CARGO_JOB_X = -348.071; //Derek Cabinet
//const CARGO_JOB_Y = -731.48;  //Derek Cabinet
const CARGO_JOB_X = -348.205; //Derek Door
const CARGO_JOB_Y = -731.48; //Derek Door
const CARGO_JOB_Z = -15.4205;
const CARGO_JOB_SKIN = 130;

local cargocoords = {};
cargocoords["PortChinese"] <- [-217.298, -724.771, -21.423]; // PortPlace P3 06 Chinese


addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading cargo job...");
    cargocars[createVehicle(38, 396.5, 101.977, -20.9432, -89.836, 0.40721, 0.0879066 )]  <- [ false ]; // SeagiftTruck0
    cargocars[createVehicle(38, 396.5, 98.0385, -20.9359, -88.4165, 0.479715, -0.0220962)]  <- [ false ];  //SeagiftTruck1

    //creating 3dtext for bus depot
    //create3DText ( DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z+0.35, "CITY PORT", CL_ROYALBLUE );
    create3DText ( CARGO_JOB_X, CARGO_JOB_Y, CARGO_JOB_Z-0.25, "/help job cargo", CL_WHITE.applyAlpha(75), 5 );

    registerPersonalJobBlip("docker", CARGO_JOB_X, CARGO_JOB_Y);
});

addEventHandler("onPlayerConnect", function(playerid, name, ip, serial) {
     job_cargo[playerid] <- {};
     job_cargo[playerid]["cargostatus"] <- false;
});


/**
 * Check is player is a cargo delivery driver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isCargoDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "cargodriver"));
}

/**
 * Check is player's vehicle is a fish truck
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleCargo(playerid) {
    return (isPlayerInValidVehicle(playerid, 38));
}

// working good, check
function cargoJob( playerid ) {

    if(!isPlayerInValidPoint(playerid, CARGO_JOB_X, CARGO_JOB_Y, RADIUS_CARGO)) {
        return msg( playerid, "Let's go to Derek office at City Port." );
    }

    if(isCargoDriver( playerid )) {
        return msg( playerid, "You're cargo delivery driver already." );
    }

    if(isPlayerHaveJob(playerid)) {
        return msg( playerid, "You already have a job: " + getPlayerJob(playerid) + ".");
    }

    msg( playerid, "You're a cargo delivery driver now. Welcome! Ha-ha..." );
    msg( playerid, "Go to Seagift Co. at Chinatown, get behind wheel of truck of fish and get your ass to warehouse P3 06 at Port." );

    players[playerid]["job"] = "cargodriver";

    players[playerid]["skin"] = CARGO_JOB_SKIN;
    setPlayerModel( playerid, CARGO_JOB_SKIN );
}

// working good, check
function cargoJobLeave( playerid ) {

    if(!isPlayerInValidPoint(playerid, CARGO_JOB_X, CARGO_JOB_Y, RADIUS_CARGO)) {
        return msg( playerid, "Let's go to Derek office at City Port." );
    }

    if(!isCargoDriver(playerid)) {
        return msg( playerid, "You're not a cargo delivery driver.");
    } else {
        msg( playerid, "You leave this job." );

        players[playerid]["job"] = null;

        players[playerid]["skin"] = players[playerid]["default_skin"];
        setPlayerModel( playerid, players[playerid]["default_skin"]);

        job_cargo[playerid]["cargostatus"] = false;
    }
}

// working good, check
function cargoJobLoad( playerid ) {
    if(!isCargoDriver(playerid)) {
        return msg( playerid, "You're not a cargo delivery driver.");
    }

    if (!isPlayerVehicleCargo(playerid)) {
        return msg( playerid, "You need a fish truck.");
    }

    if(!isVehicleInValidPoint(playerid, cargocoords["PortChinese"][0], cargocoords["PortChinese"][1], 4.0 )) {
        return msg( playerid, "Go to warehouse P3 06 at Port to load fish truck.");
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "You're driving. Please stop the truck.");
    }

    local vehicleid = getPlayerVehicle(playerid);
    if(cargocars[vehicleid][0]) {
        return msg( playerid, "Truck already loaded.");
    }

    cargocars[vehicleid][0] = true;
    msg( playerid, "The truck loaded. Go back to Seagift to unload.")
}

// working good, check
function cargoJobUnload( playerid ) {
    if(!isCargoDriver(playerid)) {
        return msg( playerid, "You're not a cargo delivery driver.");
    }

    if (!isPlayerVehicleCargo(playerid)) {
        return msg( playerid, "You need a fish truck.");
    }

    local vehicleid = getPlayerVehicle(playerid);
    if(!cargocars[vehicleid][0]) {
        return msg( playerid, "Truck is empty. Go to Port to load." );
    }

    if(!isVehicleInValidPoint(playerid, 396.5, 98.0385, 4.0 )) {
        return msg( playerid, "Go to Seagift to unload.");
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "You're driving. Please stop the truck.");
    }

    job_cargo[playerid]["cargostatus"] = true;
    cargocars[vehicleid][0] = false;
    msg( playerid, "Go to Derek office at City Port and take your money." );
    removePlayerFromVehicle( playerid );
}


// working good, check
function cargoJobFinish( playerid ) {

    if(!isCargoDriver(playerid)) {
        return msg( playerid, "You're not a cargo delivery driver.");
    }

    if(!job_cargo[playerid]["cargostatus"]) {
        return msg( playerid, "You must complete delivery before.");
    }

    if(!isPlayerInValidPoint(playerid, CARGO_JOB_X, CARGO_JOB_Y, RADIUS_CARGO)) {
        return msg( playerid, "Let's go to Derek office at City Port." );
    }

    job_cargo[playerid]["cargostatus"] = false;
    msg( playerid, "Nice job, " + getPlayerName( playerid ) + "! Keep your $30." );
    addMoneyToPlayer(playerid, 30);
}
