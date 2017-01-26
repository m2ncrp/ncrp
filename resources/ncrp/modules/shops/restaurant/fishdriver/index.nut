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

include("modules/shops/restaurant/fishdriver/commands.nut");

local job_fish = {};
local job_fish_blocked = {};
local fishcars = {};
local fish_limit_in_hour_current = 3;
local fish_limit_in_hour_default = 3;

local RADIUS_FISH = 2.0;
local RADIUS_FISH_SMALL = 1.0;
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

local FISH_TRUNK1 = [365.924, 121.5, -20.1988];
local FISH_TRUNK2 = [375.173, 121.5, -20.2118];



local fishcoords = {};
fishcoords["PortChinese"] <- [-217.298, -724.771, -21.423]; // PortPlace P3 06 Chinese


event("onServerStarted", function() {
    log("[jobs] loading fishdriver job...");
    //                                                                                      [ doors, gruz, skolko ]
    fishcars[createVehicle(38, 396.5, 101.977, -20.9432, -89.836, 0.40721, 0.0879066 )]  <- [ false, null, null ];// SeagiftTruck0
    fishcars[createVehicle(38, 396.5, 98.0385, -20.9359, -88.4165, 0.479715, -0.0220962)]  <- [ false, null, null ];  //SeagiftTruck1

    fishcars[createVehicle(38, 354.304, 85.7359, -20.9367, 0.794026, -0.0040194, 0.580053 )]  <- [ false, null, null ]; // SeagiftTruck0
    fishcars[createVehicle(38, 350.304, 85.7359, -20.9367, 0.794026, -0.0040194, 0.580053 )]  <- [ false, null, null ];  //SeagiftTruck1
    fishcars[createVehicle(38, 365.881, 110.01, -20.9320, 179.810, -0.0470277, -0.456284)]  <- [ false, null, null ];  //SeagiftTruck3
    fishcars[createVehicle(38, 374.868, 117.029, -20.9333, -178.932, -0.0996764, -0.5405)]  <- [ false, null, null ];  //SeagiftTruck3


    //creating 3dtext for bus depot
    create3DText ( FISH_JOB_X, FISH_JOB_Y, FISH_JOB_Z+0.35, "SEAGIFT's OFFICE", CL_ROYALBLUE );
    create3DText ( FISH_JOB_X, FISH_JOB_Y, FISH_JOB_Z+0.20, "Press E to action", CL_WHITE.applyAlpha(150), RADIUS_FISH );

    create3DText ( 375.005, 132.174, -20.2027+0.20, "RazlozhitRibu", CL_WHITE.applyAlpha(150), 10 );

    createPlace("SeaGiftParking1", 363.0, 119.839, 369.0, 115.5);
    createPlace("SeaGiftParking2", 371.0, 119.857, 378.0, 115.5);


    registerPersonalJobBlip("fishdriver", FISH_JOB_X, FISH_JOB_Y);
});

event("onPlayerConnect", function(playerid) {
    if ( ! (getPlayerName(playerid) in job_fish) ) {
    job_fish[getPlayerName(playerid)] <- {};
    job_fish[getPlayerName(playerid)]["hand"] <- null;
    job_fish[getPlayerName(playerid)]["userstatus"] <- null;
    job_fish[getPlayerName(playerid)]["blip3dtext"] <- [null, null, null];
    }
});

event("onServerPlayerStarted", function( playerid ){

    if(!isFishDriver(playerid)) {
        return;
    }

    if (job_fish[getPlayerName(playerid)]["userstatus"] == "working") {
        msg( playerid, "Continue job", FISH_JOB_COLOR );
        fishJobSync3DText(playerid);
    } else {
        msg( playerid, "job.fishdriver.sitintotruck", FISH_JOB_COLOR );
    }
    createText (playerid, "leavejob3dtext", FISH_JOB_X, FISH_JOB_Y, FISH_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_FISH_SMALL );
});

event("onPlayerPlaceEnter", function(playerid, name) {
    if (name != "SeaGiftParking1" && name != "SeaGiftParking2") {;
        return;
    }
    if (!isFishDriver(playerid) || !isPlayerInVehicle(playerid)) {
        return;
    }
    local vehicleid = getPlayerVehicle(playerid);
    local modelid = getVehicleModel(vehicleid);

    if (modelid != 38) {
        return msg(playerid, "You need fish truck.");
    }

    local vehRot = getVehicleRotation(vehicleid);

    if (vehRot[0] < 175 && vehRot[0] > -175 ) {
        return msg(playerid, "Need to park truck correctly");
    }
    msg(playerid, "Good parking!");
    dbg("body");

    fishJobIsPlayerWorkingForeach(function(targetid) {
        if(name == "SeaGiftParking1") {
            createText( targetid, "fish_door1_3dtext", FISH_TRUNK1[0], FISH_TRUNK1[1], FISH_TRUNK1[2]+0.20, "Press E to control doors", CL_WHITE.applyAlpha(150), 10 );
            removeText( targetid, "fish_parking1_3dtext");
        }
        if(name == "SeaGiftParking2") {
            createText( targetid, "fish_door2_3dtext", FISH_TRUNK2[0], FISH_TRUNK2[1], FISH_TRUNK2[2]+0.20, "Press E to control doors", CL_WHITE.applyAlpha(150), 10 );
            removeText( targetid, "fish_parking2_3dtext");
        }
    });

});


event("onPlayerPlaceExit", function(playerid, name) {
    if (name != "SeaGiftParking1" && name != "SeaGiftParking2") {;
        return;
    }
    if (!isFishDriver(playerid) || !isPlayerInVehicle(playerid)) {
        return;
    }
    local vehicleid = getPlayerVehicle(playerid);
    local modelid = getVehicleModel(vehicleid);

    if (modelid != 38) {
        return;
    }

    fishJobIsPlayerWorkingForeach(function(targetid) {
        if(name == "SeaGiftParking1") {
            createText( targetid, "fish_parking1_3dtext", 365.915, 118.305, -20.054+0.20, "Parking Place 1", CL_ROYALBLUE.applyAlpha(150), 35 );
            removeText( targetid, "fish_door1_3dtext");
        }
        if(name == "SeaGiftParking2") {
            createText( targetid, "fish_parking2_3dtext", 375.059, 118.343, -20.0307+0.20, "Parking Place 2", CL_ROYALBLUE.applyAlpha(150), 35 );
            removeText( targetid, "fish_door2_3dtext");
        }
    });


});

event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
    if (!isPlayerVehicleFish(playerid)) {
        return;
    }


    if(isFishDriver(playerid) && job_fish[getPlayerName(playerid)]["userstatus"] == "working") {
        unblockVehicle(vehicleid);
        if (fishcars[vehicleid][0] != false) {
            blockVehicle(vehicleid);
            msg(playerid, "Need to close doors.");
        }
    } else {
        blockVehicle(vehicleid);
    }
});



key("e", function(playerid) {
    fishJobGet( playerid );
    fishOpenCloseDoors ( playerid ); // arg = playerid
}, KEY_UP);

key("q", function(playerid) {
    fishJobRefuseLeave( playerid );
}, KEY_UP);

key("5", function(playerid) {

    dbg(job_fish[getPlayerName(playerid)]["hand"]               );
    dbg(job_fish[getPlayerName(playerid)]["userstatus"]         );
    dbg(job_fish[getPlayerName(playerid)]["blip3dtext"]         );
}, KEY_UP);

key("6", function(playerid) {
    if(job_fish[getPlayerName(playerid)]["userstatus"] == "working") {
        job_fish[getPlayerName(playerid)]["userstatus"] = null;
    } else {
        job_fish[getPlayerName(playerid)]["userstatus"] = "working";
    }
}, KEY_UP);

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
    if(job_fish[getPlayerName(playerid)]["blip3dtext"][0] != null) {
        remove3DText ( job_fish[getPlayerName(playerid)]["blip3dtext"][0] );
        remove3DText ( job_fish[getPlayerName(playerid)]["blip3dtext"][1] );
        removeBlip   ( job_fish[getPlayerName(playerid)]["blip3dtext"][2] );
        job_fish[getPlayerName(playerid)]["blip3dtext"][0] = null;
    }
}


/**
 * Check is player is a fish truck driver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isFishDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "fishdriver"));
}

/**
 * Check is player's vehicle is a fish truck
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleFish(playerid) {
    return (isPlayerInValidVehicle(playerid, 38));
}



// working good, check
function fishJobGet( playerid ) {

    if(!isPlayerInValidPoint(playerid, FISH_JOB_X, FISH_JOB_Y, RADIUS_FISH)) {
        return;
    }
/*
    if(isFishDriver( playerid )) {
        return msg( playerid, "job.fishdriver.already", FISH_JOB_COLOR );
    }
*/
    if(!isPlayerLevelValid ( playerid, FISH_JOB_LEVEL )) {
        return msg(playerid, "job.fishdriver.needlevel", FISH_JOB_LEVEL, FISH_JOB_COLOR );
    }

    if (getPlayerName(playerid) in job_fish_blocked) {
        if (getTimestamp() - job_fish_blocked[getPlayerName(playerid)] < BUS_JOB_TIMEOUT) {
            return msg( playerid, "job.bus.badworker", BUS_JOB_COLOR);
        }
    }

    // если у игрока статус работы == null
    if(job_fish[getPlayerName(playerid)]["userstatus"] == null) {

        // если у игрока уже есть другая работа
        if(isPlayerHaveJob(playerid) && !isFishDriver(playerid)) {
            return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), FISH_JOB_COLOR );
        }

        if(!isPlayerHaveJob(playerid)) {
            msg( playerid, "job.fishdriver.now", FISH_JOB_COLOR );
            setPlayerJob( playerid, "fishdriver");
            //screenFadeinFadeoutEx(playerid, 250, 200, function() {
            //    setPlayerModel( playerid, FISH_JOB_SKIN );
            //});
        }

        // busJobStartRoute( playerid );
        fishJobStartRoute( playerid );
        createText (playerid, "leavejob3dtext", FISH_JOB_X, FISH_JOB_Y, FISH_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_FISH_SMALL );
        return;
    }

    // если у игрока статус работы == выполняет работу
    if (job_fish[getPlayerName(playerid)]["userstatus"] == "working") {
        return msg( playerid, "job.bus.route.needcomplete", FISH_JOB_COLOR );
    }
    // если у игрока статус работы == завершил работу
    if (job_fish[getPlayerName(playerid)]["userstatus"] == "complete") {
        fishGetSalary( playerid )
        //job_fish[getPlayerName(playerid)]["route"] = false;
        job_fish[getPlayerName(playerid)]["userstatus"] = null;
        return;
    }

}





// working good, check
function fishJobRefuseLeave( playerid ) {
    if(!isFishDriver(playerid)) {
        return;
    }

    if(!isPlayerInValidPoint(playerid, FISH_JOB_X, FISH_JOB_Y, RADIUS_FISH_SMALL)) {
        return;
    }



    if(job_fish[getPlayerName(playerid)]["userstatus"] == null) {
        msg( playerid, "job.bus.goodluck", FISH_JOB_COLOR);
    }

    if (job_fish[getPlayerName(playerid)]["userstatus"] == "working") {
        msg( playerid, "job.bus.badworker.onleave", FISH_JOB_COLOR);
        job_fish[getPlayerName(playerid)]["userstatus"] = "nojob";
        //////////////////////////////////////job_fish_blocked[getPlayerName(playerid)] <- getTimestamp();
        //busJobRemovePrivateBlipText( playerid );
    }

    if (job_fish[getPlayerName(playerid)]["userstatus"] == "complete") {
        fishGetSalary( playerid )
        //job_fish[getPlayerName(playerid)]["route"] = false;
        job_fish[getPlayerName(playerid)]["userstatus"] = null;
        msg( playerid, "job.bus.goodluck", FISH_JOB_COLOR);
    }

        removeText ( playerid, "leavejob3dtext" );
        removeText ( playerid, "fish_putbox1_3dtext" );
        removeText ( playerid, "fish_putbox2_3dtext" );
        removeText ( playerid, "fish_parking1_3dtext" );
        removeText ( playerid, "fish_parking2_3dtext" );
        removeText ( playerid, "fish_door1_3dtext" );
        removeText ( playerid, "fish_door2_3dtext" );

        msg( playerid, "job.leave", FISH_JOB_COLOR );
        job_fish[getPlayerName(playerid)]["hand"] = null;

        setPlayerJob( playerid, null );
        //restorePlayerModel(playerid);

        // remove private blip job
        removePersonalJobBlip ( playerid );

        fishJobRemovePrivateBlipText ( playerid );
}




function fishJobStartRoute( playerid ) {
    create3DText ( 382.043, 134.532, -20.2027+0.20, "GetPoddon", CL_WHITE.applyAlpha(150), 10 );
    job_fish[getPlayerName(playerid)]["blip3dtext"] = fishJobCreatePrivateBlipText(playerid, 396.5, 98.0385, -21.2582, "UNLOAD HERE", "/fish unload");
    job_fish[getPlayerName(playerid)]["userstatus"] = "working";
    fishJobSync3DText(playerid);
    msg(playerid, "Go to fish truck and park it to warehouse at Parking Place 1 or 2");
}






// working good, check
function fishJobLoad( playerid ) {
    if(!isFishDriver(playerid)) {
        return msg( playerid, "job.fishdriver.not", FISH_JOB_COLOR );
    }

    if (!isPlayerVehicleFish(playerid)) {
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
function fishJobLoadUnload( playerid ) {
    if(!isFishDriver(playerid)) {
        return msg( playerid, "job.fishdriver.not", FISH_JOB_COLOR );
    }

    if (!isPlayerVehicleFish(playerid)) {
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
        job_fish[playerid]["userstatus"] = true;
        fishcars[vehicleid][0] = false;
        msg( playerid, "job.fishdriver.takemoney", FISH_JOB_COLOR );
    });



}


// working good, check
function fishGetSalary( playerid ) {
    local amount = FISH_JOB_SALARY + (random(-3, 1)).tofloat();
    msg( playerid, "job.fishdriver.nicejob", [getPlayerName( playerid ), amount], FISH_JOB_COLOR );
    addMoneyToPlayer(playerid, amount);
}

/*
    delayedFunction(2000, function() {
        msg( playerid, "job.fishdriver.wantagain", FISH_JOB_COLOR );
        job_fish[playerid]["blip3dtext"] = fishJobCreatePrivateBlipText(playerid, FISH_JOB_LOAD_X, FISH_JOB_LOAD_Y, FISH_JOB_LOAD_Z, "LOAD HERE", "/fish load");
    });
 */

addEventHandlerEx("onServerHourChange", function() {
       fish_limit_in_hour_current = fish_limit_in_hour_default;
});

/* ---------------------------------------------------------------------------------------------------------------------------- */

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


function fishOpenCloseDoors(playerid) {
    if(!isFishDriver(playerid)) {
        return;
    }
    if (job_fish[getPlayerName(playerid)]["userstatus"] != "working") {
        return;
    }
    local place = null;
    if(isPlayerInValidPoint(playerid, FISH_TRUNK1[0], FISH_TRUNK1[1], RADIUS_FISH)) {
        place = "place1";
    } else if (isPlayerInValidPoint(playerid, FISH_TRUNK2[0], FISH_TRUNK2[1], RADIUS_FISH)) {
        place = "place2";
    } else {
        return;
    }

    local ppos = players[playerid].getPosition();
    // special check for spawning inside closed truck
    local found = false;
    foreach (vehicleid, value in __vehicles) {
        local vehModel = getVehicleModel(vehicleid);
        if (vehModel == 38 || vehModel == 34) {
            local vpos = getVehiclePosition(vehicleid);
            // if inside vehicle, set offsetted position
            if (getDistanceBetweenPoints3D(ppos.x, ppos.y, ppos.z, vpos[0], vpos[1], vpos[2]) < 6.0) {
                found = true;
                if (fishcars[vehicleid][0]) {
                    setVehiclePartOpen(vehicleid, 1, false);
                    fishcars[vehicleid][0] = false;
                    unblockVehicle(vehicleid);
                    fishJobIsPlayerWorkingForeach(function(targetid) {
                        if (place == "place1") { removeText( targetid, "fish_putbox1_3dtext" ); }
                        if (place == "place2") { removeText( targetid, "fish_putbox2_3dtext" ); }
                    });

                    delayedFunction(2000, function() {
                        ppos = players[playerid].getPosition();
                        vpos = getVehiclePosition(vehicleid);
                        dbg((vpos[2]+0.5)+" "+ppos.z+" "+(vpos[2]+1.0));
                        if (isInRadius(playerid, vpos[0], vpos[1], vpos[2]+0.7, 2.75) && ppos.z > (vpos[2]+0.7) && ppos.z < (vpos[2]+1.0)) {
                            local health = getPlayerHealth(playerid) - 360.0;
                            setPlayerHealth( playerid, health);
                        }
                    });

                } else {
                    setVehiclePartOpen(vehicleid, 1, true);
                    fishcars[vehicleid][0] = true;
                    blockVehicle(vehicleid);
                    fishJobIsPlayerWorkingForeach(function(targetid) {
                        if (place == "place1") { createText (targetid, "fish_putbox1_3dtext", 365.915, 118.305, -20.054+0.20,  "Put box here", CL_ROYALBLUE.applyAlpha(150), 35 ); }
                        if (place == "place2") { createText (targetid, "fish_putbox2_3dtext", 375.059, 118.343, -20.0307+0.20, "Put box here", CL_ROYALBLUE.applyAlpha(150), 35 ); }
                    });
                }
                return;
            }
        }
    }
    if (!found) { msg(playerid, "No fish truck near"); }
}


key("1", function(playerid) {
    local vehicleid = getNearestCarForPlayer(playerid, 6.0);
    msg(playerid, "Ближайшее авто: "+vehicleid);
                    local ppos = players[playerid].getPosition();
                    local vpos = getVehiclePosition(vehicleid);
                        dbg((vpos[2]+0.5)+" "+ppos.z+" "+(vpos[2]+1.0));
                    if (isInRadius(playerid, vpos[0], vpos[1], vpos[2]+0.7, 2.75) && ppos.z > (vpos[2]+0.7) && ppos.z < (vpos[2]+1.0)) {
                        msg(playerid, "Тебе крышка");
                    }
}, KEY_UP);


function fishJobIsPlayerWorkingForeach(func_callback) {
    foreach (targetid, player in players) {
        if (!isFishDriver(targetid)) continue;
        if (job_fish[getPlayerName(targetid)]["userstatus"] != "working") continue;

        func_callback(targetid);
    }
}

function fishJobSync3DText(playerid) {
    local place1busy = false;
    local place2busy = false;
    foreach (vehicleid, value in __vehicles) {
        local vehModel = getVehicleModel(vehicleid);
        if (vehModel == 38) {
            local inplace1 = isVehicleInPlace(vehicleid, "SeaGiftParking1");
            if (inplace1) {
                place1busy = true;
                createText( playerid, "fish_door1_3dtext", FISH_TRUNK1[0], FISH_TRUNK1[1], FISH_TRUNK1[2]+0.20, "Press E to control doors", CL_WHITE.applyAlpha(150), 10 );
                if ([vehicleid][0]) {
                    createText( playerid, "fish_putbox1_3dtext", 365.915, 118.305, -20.054+0.20, "Put box here", CL_ROYALBLUE.applyAlpha(150), 35 );
                    setVehiclePartOpen(vehicleid, 1, true);
                }
                continue;
            }

            local inplace2 = isVehicleInPlace(vehicleid, "SeaGiftParking2");
            if (inplace2) {
                place2busy = true;
                createText( playerid, "fish_door2_3dtext", FISH_TRUNK2[0], FISH_TRUNK2[1], FISH_TRUNK2[2]+0.20, "Press E to control doors", CL_WHITE.applyAlpha(150), 10 );
                if(fishcars[vehicleid][0]) {
                    createText( playerid, "fish_putbox2_3dtext", 375.059, 118.343, -20.0307+0.20, "Put box here", CL_ROYALBLUE.applyAlpha(150), 35 );
                    setVehiclePartOpen(vehicleid, 1, true);
                }
                continue;
            }
        }
    }
    if(!place1busy) createText (playerid, "fish_parking1_3dtext", 365.915, 118.305, -20.054+0.20, "Parking Place 1", CL_ROYALBLUE.applyAlpha(150), 35 );
    if(!place2busy) createText (playerid, "fish_parking2_3dtext", 375.059, 118.343, -20.0307+0.20, "Parking Place 2", CL_ROYALBLUE.applyAlpha(150), 35 );
}
