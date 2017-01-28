translation("en", {
"job.fishdriver"               : "fish truck driver"

"job.fishdriver.needlevel"     : "[FISH] You need level %d to become fish truck driver."
"job.fishdriver.already"       : "[FISH] You're fish truck driver already."
"job.fishdriver.now"           : "[FISH] You're a fish truck driver now. Welcome!"

"job.fishdriver.not"           : "[FISH] You're not a fish truck driver."
"job.fishdriver.needfishtruck" : "[FISH] You need a fish truck."
"job.fishdriver.sitintotruck"  : "[FISH] Sit into fish truck and go to warehouse P3 06 at Port."
"job.fishdriver.toload"        : "[FISH] Go to warehouse P3 06 at Port to load fish truck."
"job.fishdriver.driving"       : "[FISH] You're driving. Please stop the truck."
"job.fishdriver.loading"       : "[FISH] Loading truck. Wait..."
"job.fishdriver.alreadyloaded" : "[FISH] Truck already loaded."
"job.fishdriver.loaded"        : "[FISH] The truck loaded. Go back to Seagift to unload."

"job.fishdriver.nicejob"       : "[FISH] Nice job, %s! Keep $%.2f."

"job.fishdriver.notpassenger"  : "[FISH] Delivery can be performed only by driver, but not by passenger."


"job.fishdriver.help.title"            :   "List of available commands for FISH TRUCK DRIVER:"
"job.fishdriver.help.job"              :   "Get fish truck driver job"
"job.fishdriver.help.jobleave"         :   "Leave fish truck driver job"
"job.fishdriver.help.load"             :   "Load fish into truck"
"job.fishdriver.help.unload"           :   "Unload fish"
"job.fishdriver.help.finish"           :   "Report about delivery and get money"

"job.fishdriver.help.all"              :   "Read help messages and press E in process work."

//"job.fishdriver.wantagain"     : "[FISH] If you want to go to route again - sit into fish truck and go to warehouse P3 06 at Port."
//"job.fishdriver.empty"         : "[FISH] Truck is empty. Go to Port to load."
//"job.fishdriver.needcomplete"  : "[FISH] You must complete delivery before."
//"job.fishdriver.takemoney"     : "[FISH] Go to Seagift's office and take your money."
//"job.fishdriver.fishtoomuch"   : "[FISH] There is enough fish in warehouse. No longer necessary now."
});

include("modules/jobs/fishdriver/commands.nut");

local job_fish = {};
local job_fish_blocked = {};
local fishcars = {};
local fish_limit_in_hour_current = 3;
local fish_limit_in_hour_default = 3;

local RADIUS_FISH = 2.0;
local RADIUS_FISH_SMALL = 1.0;

local FISH_PARK_PUT_TEXT = "Truck freezer";
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
const FISH_JOB_SALARY = 0.6;
const FISH_JOB_LEVEL = 1;
      FISH_JOB_COLOR <- CL_CRUSTA;

local FISH_TRUCK_CAPACITY = 20;

local FISH_TRUNK1 = [365.924, 121.5, -20.1988];
local FISH_TRUNK2 = [375.173, 121.5, -20.2118];

local FISH_PARK_PUT_1 = [365.915, 118.305, -20.054];
local FISH_PARK_PUT_2 = [375.059, 118.343, -20.0307];
local FISH_TAKEBOX = [382.043, 134.532, -20.2027];
local FISH_PUTBOX = [375.963, 126.703, -20.2027];

local FISH_PORT =  [-217.298, -724.771, -21.423]; // PortPlace P3 06 Chinese


event("onServerStarted", function() {
    log("[jobs] loading fishdriver job...");
    //                                                                                             [ doors, gruz, skolko ]
    fishcars[createVehicle(38, 396.5, 101.977, -20.9432, -89.836, 0.40721, 0.0879066 )]         <- [ false, "emptybox", 0 ];  //SeagiftTruck0
    fishcars[createVehicle(38, 396.5, 98.0385, -20.9359, -88.4165, 0.479715, -0.0220962)]       <- [ false, "emptybox", 0 ];  //SeagiftTruck1
    fishcars[createVehicle(38, 354.304, 85.7359, -20.9367, 0.794026, -0.0040194, 0.580053 )]    <- [ false, "emptybox", 0 ];  //SeagiftTruck0
    fishcars[createVehicle(38, 350.304, 85.7359, -20.9367, 0.794026, -0.0040194, 0.580053 )]    <- [ false, "emptybox", 0 ];  //SeagiftTruck1
    fishcars[createVehicle(38, 365.881, 105.01, -20.9320, 179.810, -0.0470277, -0.456284)]      <- [ false, "emptybox", 0 ];  //SeagiftTruck3
    fishcars[createVehicle(38, 374.868, 105.029, -20.9333, -178.932, -0.0996764, -0.5405)]      <- [ false, "emptybox", 0 ];  //SeagiftTruck3


    //creating 3dtext for bus depot
    create3DText ( FISH_JOB_X, FISH_JOB_Y, FISH_JOB_Z+0.35, "SEAGIFT's OFFICE", CL_ROYALBLUE );
    create3DText ( FISH_JOB_X, FISH_JOB_Y, FISH_JOB_Z+0.20, "Press E to action", CL_WHITE.applyAlpha(150), RADIUS_FISH );

    //create3DText ( 375.005, 132.174, -20.2027+0.20, "RazlozhitRibu", CL_WHITE.applyAlpha(150), 10 );

    createPlace("SeaGiftParking1", 363.0, 119.839, 369.0, 115.5);
    createPlace("SeaGiftParking2", 372.0, 119.857, 379.0, 115.5);

    registerPersonalJobBlip("fishdriver", FISH_JOB_X, FISH_JOB_Y);
});

event("onPlayerConnect", function(playerid) {
    if ( ! (getPlayerName(playerid) in job_fish) ) {
    job_fish[getPlayerName(playerid)] <- {};
    job_fish[getPlayerName(playerid)]["hand"] <- null;
    job_fish[getPlayerName(playerid)]["userstatus"] <- null;
    job_fish[getPlayerName(playerid)]["sitting"] <- false;
    job_fish[getPlayerName(playerid)]["blip3dtext"] <- [null, null, null];
    }
});

event("onServerPlayerStarted", function( playerid ){

    if(!isFishDriver(playerid)) {
        return;
    }

    if (job_fish[getPlayerName(playerid)]["userstatus"] == "working") {
        msg( playerid, "job.fishdriver.continue", FISH_JOB_COLOR );
        fishJobSync3DText(playerid);
    } else {
        msg( playerid, "job.fishdriver.ifyouwantstart", FISH_JOB_COLOR );
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

    if(job_fish[getPlayerName(playerid)]["sitting"] == true) {
        return;
    }
    local vehicleid = getPlayerVehicle(playerid);
    local modelid = getVehicleModel(vehicleid);

    if (modelid != 38) {
        return msg(playerid, "job.fishdriver.needfishtruck", FISH_JOB_COLOR );
    }

    local vehRot = getVehicleRotation(vehicleid);

    if (vehRot[0] < 175 && vehRot[0] > -175 ) {
        return msg(playerid, "job.fishdriver.needcorrectpark", FISH_JOB_COLOR );
    }

    if(fishcars[vehicleid][1] == "emptybox") {
        msg(playerid, "job.fishdriver.goodparkingempty", FISH_JOB_COLOR );
         msg(playerid, "job.fishdriver.sitintotruck", FISH_JOB_COLOR );
    } else {
        msg(playerid, "job.fishdriver.goodparkingfish", FISH_JOB_COLOR );
    }

    trigger(playerid, "removeGPS");
    setVehicleRespawnEx(vehicleid, false);
    fishJobIsPlayerWorkingForeach(function(targetid) {
        if(name == "SeaGiftParking1") {
            createText( targetid, "fish_door1_3dtext", FISH_TRUNK1[0], FISH_TRUNK1[1], FISH_TRUNK1[2]+0.20, "Press E to control doors", CL_WHITE.applyAlpha(150), 3.0 );
            removeText( targetid, "fish_parking1_3dtext");
        }
        if(name == "SeaGiftParking2") {
            createText( targetid, "fish_door2_3dtext", FISH_TRUNK2[0], FISH_TRUNK2[1], FISH_TRUNK2[2]+0.20, "Press E to control doors", CL_WHITE.applyAlpha(150), 3.0 );
            removeText( targetid, "fish_parking2_3dtext");
        }
    });
});


event("onPlayerPlaceExit", function(playerid, name) {
    if (name != "SeaGiftParking1" && name != "SeaGiftParking2") {;
        return;
    }
    if (!isFishDriver(playerid) || !isPlayerInVehicle(playerid) || !isPlayerVehicleDriver(playerid)) {
        return;
    }
    local vehicleid = getPlayerVehicle(playerid);
    local modelid = getVehicleModel(vehicleid);

    if (modelid != 38) {
        return;
    }
    setVehicleRespawnEx(vehicleid, true);

    if(fishcars[vehicleid][1] == "emptybox" && fishcars[vehicleid][2] > 0) {
        job_fish[getPlayerName(playerid)]["blip3dtext"] = fishJobCreatePrivateBlipText(playerid, FISH_JOB_LOAD_X, FISH_JOB_LOAD_Y, FISH_JOB_LOAD_Z, "LOAD FISH", "Press E");
        trigger(playerid, "setGPS", FISH_JOB_LOAD_X, FISH_JOB_LOAD_Y);
        msg(playerid, "job.fishdriver.toload", FISH_JOB_COLOR );
    }

    fishJobIsPlayerWorkingForeach(function(targetid) {
        if(name == "SeaGiftParking1") {
            createText( targetid, "fish_parking1_3dtext", FISH_PARK_PUT_1[0], FISH_PARK_PUT_1[1], FISH_PARK_PUT_1[2]+0.20, "Parking Place 1", CL_ROYALBLUE.applyAlpha(150), 35 );
            removeText( targetid, "fish_door1_3dtext");
        }
        if(name == "SeaGiftParking2") {
            createText( targetid, "fish_parking2_3dtext", FISH_PARK_PUT_2[0], FISH_PARK_PUT_2[1], FISH_PARK_PUT_2[2]+0.20, "Parking Place 2", CL_ROYALBLUE.applyAlpha(150), 35 );
            removeText( targetid, "fish_door2_3dtext");
        }
    });



});

event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
    if (!isPlayerVehicleFish(playerid)) {
        return;
    }

    if(isFishDriver(playerid) && job_fish[getPlayerName(playerid)]["userstatus"] == "working") {
        job_fish[getPlayerName(playerid)]["hand"] = null;
        job_fish[getPlayerName(playerid)]["sitting"] = true;
        delayedFunction(3000, function() {
            job_fish[getPlayerName(playerid)]["sitting"] = false;
        });
        unblockVehicle(vehicleid);
        if (fishcars[vehicleid][0] != false) {
            blockVehicle(vehicleid);
            msg(playerid, "job.fishdriver.needclosedoors", FISH_JOB_COLOR );
        }
    } else {
        blockVehicle(vehicleid);
    }
});



key("e", function(playerid) {
    fishJobGet( playerid );

    if(!isFishDriver(playerid)) {
        return;
    }
    if (job_fish[getPlayerName(playerid)]["userstatus"] != "working") {
        return;
    }

    fishOpenCloseDoors ( playerid ); // arg = playerid
    fishJobTakePutBox( playerid );
    fishJobLoad( playerid );
}, KEY_UP);

key("q", function(playerid) {
    fishJobRefuseLeave( playerid );
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
            createText (playerid, "fish_load_title", x, y, z+0.35, text, CL_RIPELEMON, 40 ),
            createText (playerid, "fish_load_desc", x, y, z+0.10, cmd, CL_WHITE.applyAlpha(150), 4.0 ),
            //createPrivateBlip (playerid, x, y, ICON_YELLOW, 4000.0)
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
        //removeBlip   ( job_fish[getPlayerName(playerid)]["blip3dtext"][2] );
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
    if (job_fish[getPlayerName(playerid)]["userstatus"] == "working" || job_fish[getPlayerName(playerid)]["userstatus"] == "wait") {
        job_fish[getPlayerName(playerid)]["userstatus"] = "working";
        return msg( playerid, "job.fishdriver.continue", FISH_JOB_COLOR );
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

        msg( playerid, "job.fishdriver.goodluck", FISH_JOB_COLOR);
        job_fish[getPlayerName(playerid)]["userstatus"] = null;
        job_fish[getPlayerName(playerid)]["hand"] = null;

        removeText ( playerid, "leavejob3dtext" );
        removeText ( playerid, "fish_putbox1_3dtext" );
        removeText ( playerid, "fish_putbox2_3dtext" );
        removeText ( playerid, "fish_parking1_3dtext" );
        removeText ( playerid, "fish_parking2_3dtext" );
        removeText ( playerid, "fish_door1_3dtext" );
        removeText ( playerid, "fish_door2_3dtext" );

        msg( playerid, "job.leave", FISH_JOB_COLOR );

        setPlayerJob( playerid, null );
        //restorePlayerModel(playerid);

        // remove private blip job
        removePersonalJobBlip ( playerid );

        fishJobRemovePrivateBlipText ( playerid );
}


function fishJobStartRoute( playerid ) {
    //job_fish[getPlayerName(playerid)]["blip3dtext"] = fishJobCreatePrivateBlipText(playerid, 396.5, 98.0385, -21.2582, "UNLOAD HERE", "/fish unload");
    job_fish[getPlayerName(playerid)]["userstatus"] = "working";
    fishJobSync3DText(playerid);
    msg(playerid, "job.fishdriver.toparking", FISH_JOB_COLOR );
}

// working good, check
function fishJobLoad( playerid ) {

    if (!isPlayerVehicleFish(playerid)) {
        return;
    }

    local valid = false;
    if(isVehicleInValidPoint(playerid, FISH_PORT[0], FISH_PORT[1], 4.0 )) {
        valid = true;
    }

    local vehicleid = getPlayerVehicle(playerid);

    if(!valid && fishcars[vehicleid][1] == "emptybox" && fishcars[vehicleid][2] > 0) {
        return; // msg( playerid, "job.fishdriver.toload", FISH_JOB_COLOR );
    }

    if(!valid && fishcars[vehicleid][1] == "emptybox" && fishcars[vehicleid][2] == 0) {
        return; // msg( playerid, "job.fishdriver.truck.empty", FISH_JOB_COLOR );
    }

    if(!valid && fishcars[vehicleid][1] == "fishbox") {
        return;// msg( playerid, "job.fishdriver.tounload", FISH_JOB_COLOR );
    }

    if(valid && fishcars[vehicleid][1] == "fishbox") {
        return msg( playerid, "job.fishdriver.alreadyloaded", FISH_JOB_COLOR );
    }

    local vehRot = getVehicleRotation(vehicleid);
    if (vehRot[0] < 172 && vehRot[0] > -172 ) {
        return msg(playerid, "job.fishdriver.needcorrectpark", CL_RED );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.fishdriver.driving", CL_RED );
    }

    if(!isPlayerInVehicleSeat(playerid, 0)) {
        return msg( playerid, "job.fishdriver.notpassenger", FISH_JOB_COLOR );
    }

    fishJobRemovePrivateBlipText ( playerid );

    freezePlayer( playerid, true);
    job_fish[getPlayerName(playerid)]["userstatus"] = "wait";
    setVehiclePartOpen(vehicleid, 1, true);
    msg( playerid, "job.fishdriver.loading", FISH_JOB_COLOR );
    trigger(playerid, "removeGPS");
    trigger(playerid, "hudCreateTimer", 25.0, true, true);
    delayedFunction(25000, function () {
        setVehiclePartOpen(vehicleid, 1, false);
        freezePlayer( playerid, false);
        delayedFunction(1000, function () { freezePlayer( playerid, false); });
        job_fish[getPlayerName(playerid)]["userstatus"] = "working";
        fishcars[vehicleid][1] = "fishbox";
        trigger(playerid, "setGPS", 370.0, 118.0);
        msg( playerid, "job.fishdriver.loaded", FISH_JOB_COLOR );
    });


}


// working good, check
function fishGetSalary( playerid ) {
    local amount = FISH_JOB_SALARY;
    msg( playerid, "job.fishdriver.nicejob", [getPlayerName( playerid ), amount], FISH_JOB_COLOR );
    addMoneyToPlayer(playerid, amount);
}


function fishOpenCloseDoors(playerid) {
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

                    delayedFunction(1000, function() {
                        ppos = players[playerid].getPosition();
                        vpos = getVehiclePosition(vehicleid);
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
                        if (place == "place1") { createText (targetid, "fish_putbox1_3dtext", FISH_PARK_PUT_1[0], FISH_PARK_PUT_1[1], FISH_PARK_PUT_1[2]+0.20, FISH_PARK_PUT_TEXT, CL_ROYALBLUE.applyAlpha(150), 35 ); }
                        if (place == "place2") { createText (targetid, "fish_putbox2_3dtext", FISH_PARK_PUT_2[0], FISH_PARK_PUT_2[1], FISH_PARK_PUT_2[2]+0.20, FISH_PARK_PUT_TEXT, CL_ROYALBLUE.applyAlpha(150), 35 ); }
                    });
                }
                return;
            }
        }
    }
    if (!found) { msg(playerid, "job.fishdriver.nofishtrucknear", FISH_JOB_COLOR ); }
}


function fishJobIsPlayerWorkingForeach(func_callback) {
    foreach (targetid, player in players) {
        if (!isFishDriver(targetid)) continue;
        if (job_fish[getPlayerName(targetid)]["userstatus"] != "working") continue;

        func_callback(targetid);
    }
}

function fishJobSync3DText(playerid) {
    createText ( playerid, "fish_takebox", FISH_TAKEBOX[0], FISH_TAKEBOX[1], FISH_TAKEBOX[2]+0.20, "Press E to take empty box", CL_WHITE.applyAlpha(150), 7.5 );
    createText ( playerid, "fish_putbox",  FISH_PUTBOX[0],  FISH_PUTBOX[1],  FISH_PUTBOX[2]+0.20, "Press E to put box with fish", CL_WHITE.applyAlpha(150), 7.5 );

    local place1busy = false;
    local place2busy = false;
    foreach (vehicleid, value in __vehicles) {
        local vehModel = getVehicleModel(vehicleid);
        if (vehModel == 38) {
            local vehRot = getVehicleRotation(vehicleid);
            if (vehRot[0] < 175 && vehRot[0] > -175 ) {
                continue;
            }

            local inplace1 = isVehicleInPlace(vehicleid, "SeaGiftParking1");
            if (inplace1) {
                place1busy = true;
                createText( playerid, "fish_door1_3dtext", FISH_TRUNK1[0], FISH_TRUNK1[1], FISH_TRUNK1[2]+0.20, "Press E to control doors", CL_WHITE.applyAlpha(150), 3.0 );
                if ([vehicleid][0]) {
                    createText( playerid, "fish_putbox1_3dtext", FISH_PARK_PUT_1[0], FISH_PARK_PUT_1[1], FISH_PARK_PUT_1[2]+0.20, FISH_PARK_PUT_TEXT, CL_ROYALBLUE.applyAlpha(150), 35 );
                    setVehiclePartOpen(vehicleid, 1, true);
                }
                continue;
            }

            local inplace2 = isVehicleInPlace(vehicleid, "SeaGiftParking2");
            if (inplace2) {
                place2busy = true;
                createText( playerid, "fish_door2_3dtext", FISH_TRUNK2[0], FISH_TRUNK2[1], FISH_TRUNK2[2]+0.20, "Press E to control doors", CL_WHITE.applyAlpha(150), 3.0 );
                if(fishcars[vehicleid][0]) {
                    createText( playerid, "fish_putbox2_3dtext", FISH_PARK_PUT_2[0], FISH_PARK_PUT_2[1], FISH_PARK_PUT_2[2]+0.20, FISH_PARK_PUT_TEXT, CL_ROYALBLUE.applyAlpha(150), 35 );
                    setVehiclePartOpen(vehicleid, 1, true);
                }
                continue;
            }
        }
    }
    if(!place1busy) createText (playerid, "fish_parking1_3dtext", FISH_PARK_PUT_1[0], FISH_PARK_PUT_1[1], FISH_PARK_PUT_1[2]+0.20, "Parking Place 1", CL_ROYALBLUE.applyAlpha(150), 35 );
    if(!place2busy) createText (playerid, "fish_parking2_3dtext", FISH_PARK_PUT_2[0], FISH_PARK_PUT_2[1], FISH_PARK_PUT_2[2]+0.20, "Parking Place 2", CL_ROYALBLUE.applyAlpha(150), 35 );
}

/* -------------------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------------- */

/*
"job.fishdriver.alreadyhand" : "You already have something in hands."
Truck is full. Sit into truck and go to Port.
*/

/*
    delayedFunction(2000, function() {
        msg( playerid, "job.fishdriver.wantagain", FISH_JOB_COLOR );
        job_fish[playerid]["blip3dtext"] = fishJobCreatePrivateBlipText(playerid, FISH_JOB_LOAD_X, FISH_JOB_LOAD_Y, FISH_JOB_LOAD_Z, "LOAD HERE", "/fish load");
    });
 */


/*
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

*/

/* -------------------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------------------------------------- */

function fishJobTakePutBox( playerid ) {
    if(isPlayerInVehicle(playerid)) return;

    local hand = job_fish[getPlayerName(playerid)]["hand"];
    local place = null;
    local places = [
        [  FISH_TAKEBOX[0]     ,  FISH_TAKEBOX[1]     , "takeemptybox" ],
        [  FISH_PARK_PUT_1[0]  ,  FISH_PARK_PUT_1[1]  , "parking1"     ],
        [  FISH_PARK_PUT_2[0]  ,  FISH_PARK_PUT_2[1]  , "parking2"     ],
        [  FISH_PUTBOX[0]      ,  FISH_PUTBOX[1]      , "putfishbox"   ]
    ];

    foreach (idx, placex in places) {
        if(isPlayerInValidPoint(playerid, placex[0], placex[1], 2.0)) {
            place = placex[2];
        }
    }
            if(place == null) return;

            if(place == "takeemptybox") {

                if(hand == null) {
                    hand = "emptybox";
                    msg(playerid, "job.fishdriver.takenEmptybox", FISH_JOB_COLOR );
                }
                else if(hand == "emptybox") {
                    hand = null;
                    msg(playerid, "job.fishdriver.putEmptybox", FISH_JOB_COLOR );
                }
                else if(hand != null) {
                    msg(playerid, "job.fishdriver.alreadyHand", FISH_JOB_COLOR );
                }
            }

            if(place == "putfishbox") {

                if(hand == null) {
                    msg(playerid, "job.fishdriver.goTakeFishbox" , FISH_JOB_COLOR );
                }
                else if(hand == "fishbox") {
                    hand = null;
                    fishGetSalary( playerid );
                    msg(playerid, "job.fishdriver.putFishbox", FISH_JOB_COLOR );
                }
                else if(hand != null) {
                    msg(playerid, "job.fishdriver.onlyFishbox", FISH_JOB_COLOR );
                }
            }

            if(place == "parking1" || place == "parking2") {
                local vehicleid = getNearestCarForPlayer(playerid, 6.0);
                if(vehicleid <= 0) return;
                local modelid = getVehicleModel(vehicleid);
                if(modelid != 38) return;
                local gruz = fishcars[vehicleid][1];
                local kolvo = fishcars[vehicleid][2];

                if(hand == null) {
                    if(gruz == "emptybox") return msg(playerid, "job.fishdriver.goTakeEmptybox", FISH_JOB_COLOR );
                    if(gruz == "fishbox" && kolvo > 0) {
                        hand = "fishbox";
                        kolvo -= 1;
                        msg(playerid, "job.fishdriver.takenFishbox", [kolvo], FISH_JOB_COLOR );
                        } else {
                            gruz = "emptybox";
                            msg(playerid, "job.fishdriver.truck.empty", FISH_JOB_COLOR );
                        }
                }
                else
                if(hand == "emptybox") {
                    if(gruz == "fishbox") return msg(playerid, "job.fishdriver.truck.onlyFishbox", FISH_JOB_COLOR );
                    if(gruz == "emptybox" && kolvo < FISH_TRUCK_CAPACITY) {
                        hand = null;
                        kolvo += 1;
                        msg(playerid, "job.fishdriver.truck.putEmptybox", [ kolvo, FISH_TRUCK_CAPACITY], FISH_JOB_COLOR );
                        }
                    if(kolvo == FISH_TRUCK_CAPACITY) msg(playerid, "job.fishdriver.truck.full", FISH_JOB_COLOR );
                }
                else
                if(hand == "fishbox") {
                    if(gruz == "emptybox") return msg(playerid, "job.fishdriver.truck.onlyEmptybox", FISH_JOB_COLOR );
                    if(gruz == "fishbox") msg(playerid, "job.fishdriver.truck.goPutFishbox", FISH_JOB_COLOR );
                }

                fishcars[vehicleid][1] = gruz;
                fishcars[vehicleid][2] = kolvo;
            }
    job_fish[getPlayerName(playerid)]["hand"] = hand;
}

translate("ru", {
"job.fishdriver.continue"        :   "[FISH] Отдохнул немного? Теперь продолжай работать!"
"job.fishdriver.nofishtrucknear" :   "[FISH] На парковке нет грузовика для рыбы."
"job.fishdriver.needcorrectpark" :   "[FISH] Припаркуй грузовик ровно, дверями к складу."
"job.fishdriver.needclosedoors"  :   "[FISH] Закрой двери грузового отделения."
"job.fishdriver.goodparkingempty":   "[FISH] Отлично! Теперь вылезай, открывай двери грузового отделения и тащи со склада пустые лотки для рыбы."
"job.fishdriver.goodparkingfish" :   "[FISH] Отлично! Теперь выгружай лотки с рыбой на склад."
"job.fishdriver.sitintotruck"    :   "Как загрузишь сколько сможешь - садись за руль и двигай в City Port к складу P3 06."
"job.fishdriver.goodluck"        :   "[FISH] Удачи тебе! Будет нужна работа - приходи!"
"job.fishdriver.toparking"       :   "[FISH] Садись в свободный грузовик и заезжай на парковочное место для загрузки!"
"job.fishdriver.ifyouwantstart"  :   "[FISH] Ты работаешь водителем грузовика на рыбном складе. Если хочешь потрудиться - иди в офис Seagift в Чайнатауне."
"job.fishdriver.toload"          :   "[FISH] Отправляйся в Порт к складу P3 06 для наполнения лотков рыбой."
"job.fishdriver.tounload"        :   "[FISH] Езжай к складу Seagift для разгрузки."
"job.fishdriver.loading"         :   "[FISH] Рабочие портового склада наполняют лотки рыбой. Жди..."
"job.fishdriver.alreadyloaded"   :   "[FISH] Лотки уже наполнены рыбой."
"job.fishdriver.loaded"          :   "[FISH] Лотки наполнены. Езжай к складу Seagift для разгрузки."


"job.fishdriver.takenEmptybox"      :  "[FISH] Взял пустой лоток."
"job.fishdriver.putEmptybox"        :  "[FISH] Положил пустой лоток обратно."
"job.fishdriver.alreadyHand"        :  "[FISH] Уже есть что-то в руках."
"job.fishdriver.goTakeFishbox"      :  "[FISH] Иди возьми лоток с рыбой и неси сюда."
"job.fishdriver.putFishbox"         :  "[FISH] Положил лоток с рыбой."
"job.fishdriver.onlyFishbox"        :  "[FISH] Не наводи беспорядок. Сюда только лотки с рыбой!"
"job.fishdriver.goTakeEmptybox"     :  "[FISH] Иди возьми пустой лоток."
"job.fishdriver.takenFishbox"       :  "[FISH] Взял лоток с рыбой из грузовика. Осталось %d."
"job.fishdriver.truck.empty"        :  "[FISH] Грузовик пуст."
"job.fishdriver.truck.onlyFishbox"  :  "[FISH] В грузовике лежат лотки с рыбой. Сначала разгрузи их."
"job.fishdriver.truck.putEmptybox"  :  "[FISH] Положил пустой лоток в грузовик (%d/%d)"
"job.fishdriver.truck.full"         :  "[FISH] Грузовик полон."
"job.fishdriver.truck.onlyEmptybox" :  "[FISH] Грузить лотки с рыбой не надо, отнеси их на склад."
"job.fishdriver.truck.goPutFishbox" :  "[FISH] Чё ты носишься с этим лотком с рыбой? Отнеси его на склад."

"job.fishdriver.help.all"           :  "Читайте задания и используйте клавишу E для действия в процессе выполнения работы."
});

/*
translate("en", {
"job.fishdriver.nofishtrucknear" : "На парковке нет грузовика для рыбы."
"job.fishdriver."                : "Need to park truck correctly."

Need to close doors.
Good parking!

"Go to fish truck and park it to warehouse at Parking Place 1 or 2"
});
*/
