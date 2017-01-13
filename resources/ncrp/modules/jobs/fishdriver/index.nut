translation("en", {
"job.fishdriver"               : "fish truck driver"
"job.fishdriver.letsgo"        : "[FISH] Let's go to office at City Port."
"job.fishdriver.needlevel"     : "[FISH] You need level %d to become fish truck driver."
"job.fishdriver.already"       : "[FISH] You're fish truck driver already."
"job.fishdriver.now"           : "[FISH] You're a fish truck driver now. Welcome!"
"job.fishdriver.sitintotruck"  : "[FISH] Sit into fish truck and go to warehouse P3 06 at Port."
"job.fishdriver.not"           : "[FISH] You're not a fish truck driver."
"job.fishdriver.needfishtruck" : "[FISH] You need a fish truck."
"job.fishdriver.fishtoomuch"   : "[FISH] There is enough fish in warehouse. No longer necessary now."
"job.fishdriver.toload"        : "[FISH] Go to warehouse P3 06 at Port to load fish truck."
"job.fishdriver.driving"       : "[FISH] You're driving. Please stop the truck."
"job.fishdriver.loading"       : "[FISH] Loading truck. Wait..."
"job.fishdriver.unloading"     : "[FISH] Unloading truck. Wait..."
"job.fishdriver.alreadyloaded" : "[FISH] Truck already loaded."
"job.fishdriver.loaded"        : "[FISH] The truck loaded. Go back to Seagift to unload."
"job.fishdriver.empty"         : "[FISH] Truck is empty. Go to Port to load."
"job.fishdriver.tounload"      : "[FISH] Go to Seagift to unload."
"job.fishdriver.takemoney"     : "[FISH] Go to Seagift's office and take your money."
"job.fishdriver.needcomplete"  : "[FISH] You must complete delivery before."
"job.fishdriver.nicejob"       : "[FISH] Nice job, %s! Keep $%.2f."
"job.fishdriver.wantagain"     : "[FISH] If you want to go to route again - sit into fish truck and go to warehouse P3 06 at Port."
"job.fishdriver.notpassenger"  : "[FISH] Delivery can be performed only by driver, but not by passenger."


"job.fishdriver.help.title"            :   "List of available commands for FISH TRUCK DRIVER:"
"job.fishdriver.help.job"              :   "Get fish truck driver job"
"job.fishdriver.help.jobleave"         :   "Leave fish truck driver job"
"job.fishdriver.help.load"             :   "Load fish into truck"
"job.fishdriver.help.unload"           :   "Unload fish"
"job.fishdriver.help.finish"           :   "Report about delivery and get money"
});

include("modules/jobs/fishdriver/commands.nut");

local job_fish = {};
local fishcars = {};
local fish_limit_in_hour_current = 3;
local fish_limit_in_hour_default = 3;

const RADIUS_FISH = 1.0;
//const FISH_JOB_X = -348.071; //Derek Cabinet
//const FISH_JOB_Y = -731.48;  //Derek Cabinet
//const FISH_JOB_X = -348.205; //Derek Door
//const FISH_JOB_Y = -731.48; //Derek Door
//const FISH_JOB_Z = -15.4205;

const FISH_JOB_X = 389.032; //Seagift
const FISH_JOB_Y = 128.104; //Seagift
const FISH_JOB_Z = -20.2027; //Seagift

const FISH_JOB_LOAD_X = -217.702; // Port P3 06
const FISH_JOB_LOAD_Y = -725.118;  // Port P3 06
const FISH_JOB_LOAD_Z = -21.7457; // Port P3 06

const FISH_JOB_UNLOAD_X = 396.5;
const FISH_JOB_UNLOAD_Y = 98.0385;
const FISH_JOB_UNLOAD_Z = -21.2582;

const FISH_JOB_SKIN = 130;
const FISH_JOB_SALARY = 11.0;
const FISH_JOB_LEVEL = 1;
      FISH_JOB_COLOR <- CL_CRUSTA;



local fishcoords = {};
fishcoords["PortChinese"] <- [-217.298, -724.771, -21.423]; // PortPlace P3 06 Chinese


event("onServerStarted", function() {
    log("[jobs] loading fishdriver job...");
    fishcars[createVehicle(38, 396.5, 101.977, -20.9432, -89.836, 0.40721, 0.0879066 )]  <- [ false ]; // SeagiftTruck0
    fishcars[createVehicle(38, 396.5, 98.0385, -20.9359, -88.4165, 0.479715, -0.0220962)]  <- [ false ];  //SeagiftTruck1
    fishcars[createVehicle(38, 365.481, 116.910, -20.9320, 179.810, -0.0470277, -0.456284)]  <- [ false ];  //SeagiftTruck3
    fishcars[createVehicle(38, 375.196, 116.910, -20.9320, 179.810, -0.081981, -0.55936)]  <- [ false ];  //SeagiftTruck3


    //creating 3dtext for bus depot
    create3DText ( FISH_JOB_X, FISH_JOB_Y, FISH_JOB_Z+0.35, "SEAGIFT's OFFICE", CL_ROYALBLUE );
    create3DText ( FISH_JOB_X, FISH_JOB_Y, FISH_JOB_Z+0.20, "/help job fish", CL_WHITE.applyAlpha(100), 3 );

    registerPersonalJobBlip("fishdriver", FISH_JOB_X, FISH_JOB_Y);
});

event("onPlayerConnect", function(playerid) {
     job_fish[playerid] <- {};
     job_fish[playerid]["fishstatus"] <- false;
     job_fish[playerid]["blip3dtext"] <- [null, null, null];
});

event("onServerPlayerStarted", function( playerid ){
    if(players[playerid]["job"] == "fishdriver") {
        msg( playerid, "job.fishdriver.sitintotruck", FISH_JOB_COLOR );
        job_fish[playerid]["blip3dtext"] = fishJobCreatePrivateBlipText(playerid, FISH_JOB_LOAD_X, FISH_JOB_LOAD_Y, FISH_JOB_LOAD_Z, "LOAD HERE", "/fish load");
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
function fishJobCreatePrivateBlipText(playerid, x, y, z, text, cmd) {
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
function fishJobRemovePrivateBlipText ( playerid ) {
    if(job_fish[playerid]["blip3dtext"][0] != null) {
        remove3DText ( job_fish[playerid]["blip3dtext"][0] );
        remove3DText ( job_fish[playerid]["blip3dtext"][1] );
        removeBlip   ( job_fish[playerid]["blip3dtext"][2] );
        job_fish[playerid]["blip3dtext"][0] = null;
    }
}


/**
 * Check is player is a fish truck driver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isCargoDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "fishdriver"));
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
function fishJob( playerid ) {

    if(!isPlayerInValidPoint(playerid, FISH_JOB_X, FISH_JOB_Y, RADIUS_FISH)) {
        return msg( playerid, "job.fishdriver.letsgo", FISH_JOB_COLOR );
    }

    if(isCargoDriver( playerid )) {
        return msg( playerid, "job.fishdriver.already", FISH_JOB_COLOR );
    }

    if(isPlayerHaveJob(playerid)) {
        return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), FISH_JOB_COLOR );
    }

    if(!isPlayerLevelValid ( playerid, FISH_JOB_LEVEL )) {
        return msg(playerid, "job.fishdriver.needlevel", FISH_JOB_LEVEL, FISH_JOB_COLOR );
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.fishdriver.now", FISH_JOB_COLOR );
        msg( playerid, "job.fishdriver.sitintotruck", FISH_JOB_COLOR );

        setPlayerJob( playerid, "fishdriver");
        setPlayerModel( playerid, FISH_JOB_SKIN );

        // create private blip job
        //createPersonalJobBlip( playerid, FISH_JOB_X, FISH_JOB_Y);
        job_fish[playerid]["blip3dtext"] = fishJobCreatePrivateBlipText(playerid, FISH_JOB_LOAD_X, FISH_JOB_LOAD_Y, FISH_JOB_LOAD_Z, "LOAD HERE", "/fish load");
    });
}

// working good, check
function fishJobLeave( playerid ) {

    if(!isPlayerInValidPoint(playerid, FISH_JOB_X, FISH_JOB_Y, RADIUS_FISH)) {
        return msg( playerid, "job.fishdriver.letsgo", FISH_JOB_COLOR );
    }

    if(!isCargoDriver(playerid)) {
        return msg( playerid, "job.fishdriver.not", FISH_JOB_COLOR );
    } else {
        screenFadeinFadeoutEx(playerid, 250, 200, function() {
            msg( playerid, "job.leave", FISH_JOB_COLOR );

            setPlayerJob( playerid, null );
            restorePlayerModel(playerid);

            job_fish[playerid]["fishstatus"] = false;

            // remove private blip job
            removePersonalJobBlip ( playerid );

            fishJobRemovePrivateBlipText ( playerid );
        });
    }
}

// working good, check
function fishJobLoad( playerid ) {
    if(!isCargoDriver(playerid)) {
        return msg( playerid, "job.fishdriver.not", FISH_JOB_COLOR );
    }

    if (!isPlayerVehicleCargo(playerid)) {
        return msg( playerid, "job.fishdriver.needfishtruck", FISH_JOB_COLOR );
    }

    local vehicleid = getPlayerVehicle(playerid);
    if(fishcars[vehicleid][0]) {
        return msg( playerid, "job.fishdriver.alreadyloaded", FISH_JOB_COLOR );
    }

    if(!isVehicleInValidPoint(playerid, fishcoords["PortChinese"][0], fishcoords["PortChinese"][1], 4.0 )) {
        return msg( playerid, "job.fishdriver.toload", FISH_JOB_COLOR );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.fishdriver.driving", CL_RED );
    }

    if(!isPlayerInVehicleSeat(playerid, 0)) {
        return msg( playerid, "job.fishdriver.notpassenger", FISH_JOB_COLOR );
    }

    fishJobRemovePrivateBlipText ( playerid );

    msg( playerid, "job.fishdriver.loading", FISH_JOB_COLOR );
    screenFadeinFadeoutEx(playerid, 1000, 3000, null, function() {
        fishcars[vehicleid][0] = true;
        job_fish[playerid]["blip3dtext"] = fishJobCreatePrivateBlipText(playerid, 396.5, 98.0385, -21.2582, "UNLOAD HERE", "/fish unload");
        msg( playerid, "job.fishdriver.loaded", FISH_JOB_COLOR );
    });

}

// working good, check
function fishJobUnload( playerid ) {
    if(!isCargoDriver(playerid)) {
        return msg( playerid, "job.fishdriver.not", FISH_JOB_COLOR );
    }

    if (!isPlayerVehicleCargo(playerid)) {
        return msg( playerid, "job.fishdriver.needfishtruck", FISH_JOB_COLOR );
    }

    if (fish_limit_in_hour_current == 0) {
        return msg( playerid, "job.fishdriver.fishtoomuch", FISH_JOB_COLOR );
    }

    local vehicleid = getPlayerVehicle(playerid);
    if(!fishcars[vehicleid][0]) {
        return msg( playerid, "job.fishdriver.empty", FISH_JOB_COLOR );
    }

    if(!isVehicleInValidPoint(playerid, 396.5, 98.0385, 4.0 )) {
        return msg( playerid, "job.fishdriver.tounload", FISH_JOB_COLOR );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.fishdriver.driving", CL_RED );
    }

    if(!isPlayerInVehicleSeat(playerid, 0)) {
        return msg( playerid, "job.fishdriver.notpassenger", FISH_JOB_COLOR );
    }

    fishJobRemovePrivateBlipText ( playerid );
    fish_limit_in_hour_current -= 1;

    msg( playerid, "job.fishdriver.unloading", FISH_JOB_COLOR );

    screenFadeinFadeoutEx(playerid, 1000, 3000, null, function() {
        job_fish[playerid]["fishstatus"] = true;
        fishcars[vehicleid][0] = false;
        msg( playerid, "job.fishdriver.takemoney", FISH_JOB_COLOR );
        removePlayerFromVehicle( playerid );
    });



}


// working good, check
function fishJobFinish( playerid ) {

    if(!isCargoDriver(playerid)) {
        return msg( playerid, "job.fishdriver.not", FISH_JOB_COLOR );
    }

    if(!job_fish[playerid]["fishstatus"]) {
        return msg( playerid, "job.fishdriver.needcomplete", FISH_JOB_COLOR );
    }

    if(!isPlayerInValidPoint(playerid, FISH_JOB_X, FISH_JOB_Y, RADIUS_FISH)) {
        return msg( playerid, "job.fishdriver.letsgo", FISH_JOB_COLOR );
    }

    job_fish[playerid]["fishstatus"] = false;
    local amount = FISH_JOB_SALARY + (random(-3, 1)).tofloat();
    msg( playerid, "job.fishdriver.nicejob", [getPlayerName( playerid ), amount], FISH_JOB_COLOR );
    addMoneyToPlayer(playerid, amount);

    delayedFunction(2000, function() {
        msg( playerid, "job.fishdriver.wantagain", FISH_JOB_COLOR );
        job_fish[playerid]["blip3dtext"] = fishJobCreatePrivateBlipText(playerid, FISH_JOB_LOAD_X, FISH_JOB_LOAD_Y, FISH_JOB_LOAD_Z, "LOAD HERE", "/fish load");
    });

}



addEventHandlerEx("onServerHourChange", function() {
       fish_limit_in_hour_current = fish_limit_in_hour_default;
});


function fishJobSetFishLimit( playerid, limit ) {
    fish_limit_in_hour_current = limit.tointeger();
    msg( playerid, "[FISH] New current fish limit in hour: "+limit, FISH_JOB_COLOR );
}

function fishJobGetFishLimit( playerid ) {
    msg( playerid, "[FISH] Fish limit: "+fish_limit_in_hour_current, FISH_JOB_COLOR );
}

function fishJobSetDefaultFishLimit( playerid, limit ) {
    fish_limit_in_hour_default = limit.tointeger();
    msg( playerid, "[FISH] New default fish limit in hour: "+limit, FISH_JOB_COLOR );
}
