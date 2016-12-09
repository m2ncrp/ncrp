translation("en", {
"job.cargodriver"               : "cargo truck driver"
"job.cargodriver.letsgo"        : "[CARGO] Let's go to office at City Port."
"job.cargodriver.needlevel"     : "[CARGO] You need level %d to become cargo truck driver."
"job.cargodriver.already"       : "[CARGO] You're cargo truck driver already."
"job.cargodriver.now"           : "[CARGO] You're a cargo truck driver now. Welcome!"
"job.cargodriver.sitintotruck"  : "[CARGO] Sit into fish truck and go to warehouse P3 06 at Port."
"job.cargodriver.not"           : "[CARGO] You're not a cargo truck driver."
"job.cargodriver.needfishtruck" : "[CARGO] You need a fish truck."
"job.cargodriver.fishtoomuch"   : "[CARGO] There is enough fish in warehouse. No longer necessary now."
"job.cargodriver.toload"        : "[CARGO] Go to warehouse P3 06 at Port to load fish truck."
"job.cargodriver.driving"       : "[CARGO] You're driving. Please stop the truck."
"job.cargodriver.loading"       : "[CARGO] Loading truck. Wait..."
"job.cargodriver.unloading"     : "[CARGO] Unloading truck. Wait..."
"job.cargodriver.alreadyloaded" : "[CARGO] Truck already loaded."
"job.cargodriver.loaded"        : "[CARGO] The truck loaded. Go back to Seagift to unload."
"job.cargodriver.empty"         : "[CARGO] Truck is empty. Go to Port to load."
"job.cargodriver.tounload"      : "[CARGO] Go to Seagift to unload."
"job.cargodriver.takemoney"     : "[CARGO] Go to Seagift's office and take your money."
"job.cargodriver.needcomplete"  : "[CARGO] You must complete delivery before."
"job.cargodriver.nicejob"       : "[CARGO] Nice job, %s! Keep $%.2f."
"job.cargodriver.wantagain"     : "[CARGO] If you want to go to route again - sit into cargo truck and go to warehouse P3 06 at Port."
"job.cargodriver.notpassenger"  : "[CARGO] Delivery can be performed only by driver, but not by passenger."


"job.cargodriver.help.title"            :   "List of available commands for CARGO TRUCK DRIVER:"
"job.cargodriver.help.job"              :   "Get cargo truck driver job"
"job.cargodriver.help.jobleave"         :   "Leave cargo truck driver job"
"job.cargodriver.help.load"             :   "Load cargo into truck"
"job.cargodriver.help.unload"           :   "Unload cargo"
"job.cargodriver.help.finish"           :   "Report about delivery and get money"
});

include("modules/jobs/cargodriver/commands.nut");

local job_cargo = {};
local cargocars = {};
local cargo_limit_in_day = 30;


const RADIUS_CARGO = 1.0;
//const CARGO_JOB_X = -348.071; //Derek Cabinet
//const CARGO_JOB_Y = -731.48;  //Derek Cabinet
//const CARGO_JOB_X = -348.205; //Derek Door
//const CARGO_JOB_Y = -731.48; //Derek Door
//const CARGO_JOB_Z = -15.4205;

const CARGO_JOB_X = 389.032; //Seagift
const CARGO_JOB_Y = 128.104; //Seagift
const CARGO_JOB_Z = -20.2027; //Seagift

const CARGO_JOB_LOAD_X = -217.702; // Port P3 06
const CARGO_JOB_LOAD_Y = -725.118;  // Port P3 06
const CARGO_JOB_LOAD_Z = -21.7457; // Port P3 06

const CARGO_JOB_UNLOAD_X = 396.5;
const CARGO_JOB_UNLOAD_Y = 98.0385;
const CARGO_JOB_UNLOAD_Z = -21.2582;

const CARGO_JOB_SKIN = 130;
const CARGO_JOB_SALARY = 15.0;
const CARGO_JOB_LEVEL = 1;
      CARGO_JOB_COLOR <- CL_CRUSTA;



local cargocoords = {};
cargocoords["PortChinese"] <- [-217.298, -724.771, -21.423]; // PortPlace P3 06 Chinese


event("onServerStarted", function() {
    log("[jobs] loading cargodriver job...");
    cargocars[createVehicle(38, 396.5, 101.977, -20.9432, -89.836, 0.40721, 0.0879066 )]  <- [ false ]; // SeagiftTruck0
    cargocars[createVehicle(38, 396.5, 98.0385, -20.9359, -88.4165, 0.479715, -0.0220962)]  <- [ false ];  //SeagiftTruck1
    cargocars[createVehicle(38, 365.481, 116.910, -20.9320, 179.810, -0.0470277, -0.456284)]  <- [ false ];  //SeagiftTruck3
    cargocars[createVehicle(38, 375.196, 116.910, -20.9320, 179.810, -0.081981, -0.55936)]  <- [ false ];  //SeagiftTruck3


    //creating 3dtext for bus depot
    create3DText ( CARGO_JOB_X, CARGO_JOB_Y, CARGO_JOB_Z+0.35, "SEAGIFT's OFFICE", CL_ROYALBLUE );
    create3DText ( CARGO_JOB_X, CARGO_JOB_Y, CARGO_JOB_Z+0.20, "/help job cargo", CL_WHITE.applyAlpha(100), 3 );

    registerPersonalJobBlip("cargodriver", CARGO_JOB_X, CARGO_JOB_Y);
});

event("onPlayerConnect", function(playerid, name, ip, serial) {
     job_cargo[playerid] <- {};
     job_cargo[playerid]["cargostatus"] <- false;
     job_cargo[playerid]["blip3dtext"] <- [null, null, null];
});

event("onServerPlayerStarted", function( playerid ){
    if(players[playerid]["job"] == "cargodriver") {
        msg( playerid, "job.cargodriver.sitintotruck", CARGO_JOB_COLOR );
        job_cargo[playerid]["blip3dtext"] = cargoJobCreatePrivateBlipText(playerid, CARGO_JOB_LOAD_X, CARGO_JOB_LOAD_Y, CARGO_JOB_LOAD_Z, "LOAD HERE", "/cargo load");
    }
});


/**
 * Create private 3DTEXT AND BLIP
 * @param  {int}  playerid
 * @param  {float} x
 * @param  {float} y
 * @param  {float} z
 * @param  {string} text
 * @param  {string} cmd
 * @return {array} [idtext1, id3dtext2, idblip]
 */
function cargoJobCreatePrivateBlipText(playerid, x, y, z, text, cmd) {
    return [
            createPrivate3DText (playerid, x, y, z+0.35, text, CL_RIPELEMON, 40 ),
            createPrivate3DText (playerid, x, y, z+0.20, cmd, CL_WHITE.applyAlpha(150), 4.0 ),
            createPrivateBlip (playerid, x, y, ICON_YELLOW, 4000.0)
    ];
}

/**
 * Remove private 3DTEXT AND BLIP
 * @param  {int}  playerid
 */
function cargoJobRemovePrivateBlipText ( playerid ) {
    if(job_cargo[playerid]["blip3dtext"][0] != null) {
        remove3DText ( job_cargo[playerid]["blip3dtext"][0] );
        remove3DText ( job_cargo[playerid]["blip3dtext"][1] );
        removeBlip   ( job_cargo[playerid]["blip3dtext"][2] );
        job_cargo[playerid]["blip3dtext"][0] = null;
    }
}


/**
 * Check is player is a cargo truck driver
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
        return msg( playerid, "job.cargodriver.letsgo", CARGO_JOB_COLOR );
    }

    if(isCargoDriver( playerid )) {
        return msg( playerid, "job.cargodriver.already", CARGO_JOB_COLOR );
    }

    if(isPlayerHaveJob(playerid)) {
        return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), CARGO_JOB_COLOR );
    }

    if(!isPlayerLevelValid ( playerid, CARGO_JOB_LEVEL )) {
        return msg(playerid, "job.cargodriver.needlevel", CARGO_JOB_LEVEL, CARGO_JOB_COLOR );
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.cargodriver.now", CARGO_JOB_COLOR );
        msg( playerid, "job.cargodriver.sitintotruck", CARGO_JOB_COLOR );

        setPlayerJob( playerid, "cargodriver");

        players[playerid]["skin"] = CARGO_JOB_SKIN;
        setPlayerModel( playerid, CARGO_JOB_SKIN );

        // create private blip job
        //createPersonalJobBlip( playerid, CARGO_JOB_X, CARGO_JOB_Y);
        job_cargo[playerid]["blip3dtext"] = cargoJobCreatePrivateBlipText(playerid, CARGO_JOB_LOAD_X, CARGO_JOB_LOAD_Y, CARGO_JOB_LOAD_Z, "LOAD HERE", "/cargo load");
    });
}

// working good, check
function cargoJobLeave( playerid ) {

    if(!isPlayerInValidPoint(playerid, CARGO_JOB_X, CARGO_JOB_Y, RADIUS_CARGO)) {
        return msg( playerid, "job.cargodriver.letsgo", CARGO_JOB_COLOR );
    }

    if(!isCargoDriver(playerid)) {
        return msg( playerid, "job.cargodriver.not", CARGO_JOB_COLOR );
    } else {
        screenFadeinFadeoutEx(playerid, 250, 200, function() {
            msg( playerid, "job.leave", CARGO_JOB_COLOR );

            setPlayerJob( playerid, null );

            players[playerid]["skin"] = players[playerid]["default_skin"];
            setPlayerModel( playerid, players[playerid]["default_skin"]);

            job_cargo[playerid]["cargostatus"] = false;

            // remove private blip job
            removePersonalJobBlip ( playerid );

            cargoJobRemovePrivateBlipText ( playerid );
        });
    }
}

// working good, check
function cargoJobLoad( playerid ) {
    if(!isCargoDriver(playerid)) {
        return msg( playerid, "job.cargodriver.not", CARGO_JOB_COLOR );
    }

    if (!isPlayerVehicleCargo(playerid)) {
        return msg( playerid, "job.cargodriver.needfishtruck", CARGO_JOB_COLOR );
    }

    local vehicleid = getPlayerVehicle(playerid);
    if(cargocars[vehicleid][0]) {
        return msg( playerid, "job.cargodriver.alreadyloaded", CARGO_JOB_COLOR );
    }

    if(!isVehicleInValidPoint(playerid, cargocoords["PortChinese"][0], cargocoords["PortChinese"][1], 4.0 )) {
        return msg( playerid, "job.cargodriver.toload", CARGO_JOB_COLOR );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.cargodriver.driving", CL_RED );
    }

    if(!isPlayerInVehicleSeat(playerid, 0)) {
        return msg( playerid, "job.cargodriver.notpassenger", CARGO_JOB_COLOR );
    }

    cargoJobRemovePrivateBlipText ( playerid );

    msg( playerid, "job.cargodriver.loading", CARGO_JOB_COLOR );
    screenFadeinFadeoutEx(playerid, 1000, 3000, null, function() {
        cargocars[vehicleid][0] = true;
        job_cargo[playerid]["blip3dtext"] = cargoJobCreatePrivateBlipText(playerid, 396.5, 98.0385, -21.2582, "UNLOAD HERE", "/cargo unload");
        msg( playerid, "job.cargodriver.loaded", CARGO_JOB_COLOR );
    });

}

// working good, check
function cargoJobUnload( playerid ) {
    if(!isCargoDriver(playerid)) {
        return msg( playerid, "job.cargodriver.not", CARGO_JOB_COLOR );
    }

    if (!isPlayerVehicleCargo(playerid)) {
        return msg( playerid, "job.cargodriver.needfishtruck", CARGO_JOB_COLOR );
    }

    if (cargo_limit_in_day == 0) {
        return msg( playerid, "job.cargodriver.fishtoomuch", CARGO_JOB_COLOR );
    }


    local vehicleid = getPlayerVehicle(playerid);
    if(!cargocars[vehicleid][0]) {
        return msg( playerid, "job.cargodriver.empty", CARGO_JOB_COLOR );
    }

    if(!isVehicleInValidPoint(playerid, 396.5, 98.0385, 4.0 )) {
        return msg( playerid, "job.cargodriver.tounload", CARGO_JOB_COLOR );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.cargodriver.driving", CL_RED );
    }

    if(!isPlayerInVehicleSeat(playerid, 0)) {
        return msg( playerid, "job.cargodriver.notpassenger", CARGO_JOB_COLOR );
    }

    cargoJobRemovePrivateBlipText ( playerid );
    cargo_limit_in_day -= 1;

    msg( playerid, "job.cargodriver.unloading", CARGO_JOB_COLOR );

    screenFadeinFadeoutEx(playerid, 1000, 3000, null, function() {
        job_cargo[playerid]["cargostatus"] = true;
        cargocars[vehicleid][0] = false;
        msg( playerid, "job.cargodriver.takemoney", CARGO_JOB_COLOR );
        removePlayerFromVehicle( playerid );
    });



}


// working good, check
function cargoJobFinish( playerid ) {

    if(!isCargoDriver(playerid)) {
        return msg( playerid, "job.cargodriver.not", CARGO_JOB_COLOR );
    }

    if(!job_cargo[playerid]["cargostatus"]) {
        return msg( playerid, "job.cargodriver.needcomplete", CARGO_JOB_COLOR );
    }

    if(!isPlayerInValidPoint(playerid, CARGO_JOB_X, CARGO_JOB_Y, RADIUS_CARGO)) {
        return msg( playerid, "job.cargodriver.letsgo", CARGO_JOB_COLOR );
    }

    job_cargo[playerid]["cargostatus"] = false;
    msg( playerid, "job.cargodriver.nicejob", [getPlayerName( playerid ), CARGO_JOB_SALARY], CARGO_JOB_COLOR );
    addMoneyToPlayer(playerid, CARGO_JOB_SALARY);

    delayedFunction(2000, function() {
        msg( playerid, "job.cargodriver.wantagain", CARGO_JOB_COLOR );
        job_cargo[playerid]["blip3dtext"] = cargoJobCreatePrivateBlipText(playerid, CARGO_JOB_LOAD_X, CARGO_JOB_LOAD_Y, CARGO_JOB_LOAD_Z, "LOAD HERE", "/cargo load");
    });

}



addEventHandlerEx("onServerDayChange", function() {
    cargo_limit_in_day = 30;
});


function cargoJobSetFishLimit( playerid, limit ) {
    cargo_limit_in_day = limit.tointeger();
    msg( playerid, "[CARGO] New fish limit in day: "+limit, CARGO_JOB_COLOR );
}

function cargoJobGetFishLimit( playerid ) {
    msg( playerid, "[CARGO] Fish limit: "+cargo_limit_in_day, CARGO_JOB_COLOR );
}

