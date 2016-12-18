include("modules/jobs/truckdriver/commands.nut");

local job_truck = {};
local truckcars = {};
local truck_scens = {};

    // сценарий 1: Северный Миллвиль - Мидтаун (доставка материалов) All
     truck_scens[1] <- { LoadText = "job.truckdriver.scens1.load", UnloadText = "job.truckdriver.scens1.unload", LoadPointX = 826.769, LoadPointY = 517.451, LoadPointZ = -11.7677, UnloadPointX = -370.788, UnloadPointY = -347.463, UnloadPointZ =  -13.3999 };
    // сценарий 2: Хантерч Поинт - Северный Миллвиль (обломки здания) Only summer
     truck_scens[2] <- { LoadText = "job.truckdriver.scens2.load", UnloadText = "job.truckdriver.scens2.unload", LoadPointX = -1582.51, LoadPointY = 571.176, LoadPointZ = -19.8774, UnloadPointX = 628.368, UnloadPointY = 382.828, UnloadPointZ = -6.70368 };

// работы доступные в сезон
local truck_scens_winter = [ 1 ];
local truck_scens_summer = [ 1, 2 ];


translation("en", {
    "job.truckdriver"                   : "truck driver"

    "job.truckdriver.scens1.load"       : "Sit into truck and go to North Millville to load construction materials."
    "job.truckdriver.scens1.unload"     : "The truck loaded. Go to Midtown to unload construction materials."

    "job.truckdriver.scens2.load"       : "Sit into truck and go to Hunters Point to load debris of burnt building."
    "job.truckdriver.scens2.unload"     : "The truck loaded. Go to North Millville to unload debris of burnt building."

    "job.truckdriver.badworker"         : "Robert Casey: You are a bad worker. I'll not give you a job."
    "job.truckdriver.badworker.onleave" : "Robert Casey: You are a bad worker. Get out of here."
    "job.truckdriver.goodluck"          : "Robert Casey: Good luck, guy! Come if you need a job."
    "job.truckdriver.needcomplete"      : "Robert Casey: You must complete delivery before."
    "job.truckdriver.nicejob"           : "Robert Casey: Nice job, %s! Keep $%.2f."
    "job.truckdriver.now"               : "Robert Casey: You're a truck driver now. Welcome!"

    "job.truckdriver.needlevel"         : "[TRUCK] You need level %d to become truck driver."
    "job.truckdriver.wantwork"          : "[TRUCK] You're a truck driver. If you want to work - go to transport facilities near Highbrook Bridge."
    "job.truckdriver.already"           : "[TRUCK] You're truck driver already."
    "job.truckdriver.notpassenger"      : "[TRUCK] Delivery can be performed only by driver, but not by passenger."
    "job.truckdriver.loading"           : "[TRUCK] Loading truck. Wait..."
    "job.truckdriver.unloading"         : "[TRUCK] Unloading truck. Wait..."
    "job.truckdriver.alreadyloaded"     : "[TRUCK] Truck already loaded."
    "job.truckdriver.empty"             : "[TRUCK] Truck is empty."
    "job.truckdriver.takemoney"         : "[TRUCK] Go back to transport facilities near Highbrook Bridge to park truck and get money."

    "job.truckdriver.help.title"            :   "List of available commands for TRUCK DRIVER:"
    "job.truckdriver.help.job"              :   "E button"
    "job.truckdriver.help.jobtext"          :   "Get truck driver job near Robert Casey"
    "job.truckdriver.help.jobleave"         :   "Q button"
    "job.truckdriver.help.jobleavetext"     :   "Leave truck driver job near Robert Casey"
    "job.truckdriver.help.loadunload"       :   "E button"
    "job.truckdriver.help.loadunloadtext"   :   "Load/unload truck (need be in truck)"


});


/*
826.769, 517.451, -11.7677, 89.8741, -0.213281, 0.213751, NorthMillVilleLoadMaterials
-370.788, -347.463, -13.3999, -179.469, -0.0121328, -1.44906, MidtownUnloadMaterials
*/


const RADIUS_TRUCK = 2.0;

const TRUCK_JOB_X =  -704.88; //under Red Bridge
const TRUCK_JOB_Y =  1461.06; //
const TRUCK_JOB_Z = -6.86539; //

const TRUCK_JOB_SKIN = 130;
const TRUCK_JOB_SALARY = 12.0;
const TRUCK_JOB_LEVEL = 1;
      TRUCK_JOB_COLOR <- CL_CRUSTA;


local carp = false;
local carp2 = false;


event("onServerStarted", function() {
    log("[jobs] loading truckdriver job...");

     truckcars[createVehicle(35, -705.155, 1456, -6.48204, -43.0174, -0.252974, -0.64192)]  <- [ false, false ]; //      Truck1
     truckcars[createVehicle(35, -708.151, 1453.25, -6.50832, -43.1396, -0.445434, -1.12674)]  <- [ false, false ]; //   Truck2
     truckcars[createVehicle(35, -711.119, 1450.54, -6.52765, -41.8644, -0.613728, -1.6044)]  <- [ false, false ]; //    Truck3

     carp = createVehicle(42, -364.809, -348.672, -13.5259, -0.540874, -0.0051816, -1.09775); // police Midtown

     createVehicle(27, -368.761, -330.329, -13.1167, 113.28, -0.503684, -1.39627); //Bron1
     createVehicle(27, -368.435, -366.052, -13.8605, 63.8406, -0.365066, -1.26762); //Bron2

    if (isSummer()) {
        carp2 = createVehicle(42, -1604.3, 569.969, -19.9775, -54.2438, 0.27688, -0.144837); // police Most
    }

    create3DText ( TRUCK_JOB_X, TRUCK_JOB_Y, TRUCK_JOB_Z+0.20, "Press E to talk", CL_WHITE.applyAlpha(150), RADIUS_TRUCK );

    registerPersonalJobBlip("truckdriver", TRUCK_JOB_X, TRUCK_JOB_Y);
});

/*
        truckcars[createVehicle(39, -714.917, 1448.12, -6.50445, -40.4398, -1.22047, 0.221121)]  <- [ false, false ]; //    SnowTruck1
        truckcars[createVehicle(39, -718.038, 1445.28, -6.35813, -39.2938, -1.00603, 3.70481)]  <- [ false, false ]; //     SnowTruck2
        truckcars[createVehicle(39, -721.274, 1442.58, -6.09918, -38.2308, -0.808422, 5.6408)]  <- [ false, false ]; //     SnowTruck3

-1582.32, 572.606, -19.7032, 179.534, 0.265915, 0.166093, TruckFireLoad
-1582.55, 571.041, -19.8709, -177.697, -0.325503, -0.0581149, TruckNewFireLoad
627.969, 382.268, -6.70534, -88.2257, 0.220177, -0.0782472, TruckNewFireUNLoad


-1603.78, 568.653, -19.9782, -50.4648, 0.293502, -0.120968, PoliceFireLoad


826.237, 519.311, -11.7672, 92.6744, -0.229025, 0.218576, TruckNewMidtownLoad


    //creating 3dtext for bus depot
    //create3DText ( TRUCK_JOB_X, TRUCK_JOB_Y, TRUCK_JOB_Z+0.35, "SEAGIFT's OFFICE", CL_ROYALBLUE );



job_truck[playerid]["userstatus"] == null;         -  если есть работа для игрока
job_truck[playerid]["userstatus"] == "nojob";      -  если нет работы для игрока
job_truck[playerid]["userstatus"] == "working";    -  если игрок работает
job_truck[playerid]["userstatus"] == "complete";    -  если игрок выполнил работу
*/


key(["e"], function(playerid) {
    truckJobTalk( playerid );
    truckJobLoadUnload( playerid )
}, KEY_UP);

key(["q"], function(playerid) {
    truckJobRefuseLeave( playerid );
}, KEY_UP);

event("onPlayerConnect", function(playerid, name, ip, serial) {
     job_truck[playerid] <- {};
     job_truck[playerid]["userjob"] <- null;
     job_truck[playerid]["userstatus"] <- null;
     job_truck[playerid]["leavejob3dtext"] <- null;
     job_truck[playerid]["truckblip3dtext"] <- [null, null, null];
});

event("onPlayerSpawn", function(playerid) {
    setVehicleBeaconLightState(carp, true);
    if (isSummer()) { setVehicleBeaconLightState(carp2, true); }
});

event("onServerPlayerStarted", function( playerid ){


    if(players[playerid]["job"] == "truckdriver") {
        msg( playerid, "job.truckdriver.wantwork", TRUCK_JOB_COLOR );
        job_truck[playerid]["leavejob3dtext"] = createPrivate3DText (playerid, TRUCK_JOB_X, TRUCK_JOB_Y, TRUCK_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_TRUCK );
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
function truckJobCreatePrivateBlipText(playerid, x, y, z, text, cmd) {
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
function truckJobRemovePrivateBlipText ( playerid ) {
    if(job_truck[playerid]["truckblip3dtext"][0] != null) {
        remove3DText ( job_truck[playerid]["truckblip3dtext"][0] );
        remove3DText ( job_truck[playerid]["truckblip3dtext"][1] );
        removeBlip   ( job_truck[playerid]["truckblip3dtext"][2] );
        job_truck[playerid]["truckblip3dtext"][0] = null;
    }
}


/**
 * Check is player is a truck truck driver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isTruckDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "truckdriver"));
}

/**
 * Check is player's vehicle is a truck
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleTruck(playerid) {
    return (isPlayerInValidVehicle(playerid, 35));
}


function truckJobTalk( playerid ) {
    // если игрок не в нужной точке
    if(!isPlayerInValidPoint(playerid, TRUCK_JOB_X, TRUCK_JOB_Y, RADIUS_TRUCK)) {
        return;
    }
    // если у игрока недостаточный уровень
    if(!isPlayerLevelValid ( playerid, TRUCK_JOB_LEVEL )) {
        return msg(playerid, "job.truckdriver.needlevel", TRUCK_JOB_LEVEL, TRUCK_JOB_COLOR );
    }

    // если у игрока статус работы == null
    if(job_truck[playerid]["userstatus"] == null) {
/*
        // если игрок уже работает водителем грузовика
        if(!isTruckDriver( playerid )) {
            return msg( playerid, "job.truckdriver.already", TRUCK_JOB_COLOR );
        }
*/
        // если игрок уже есть другая работа
        if(isPlayerHaveJob(playerid) && getPlayerJob(playerid) != "truckdriver") {
            return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), TRUCK_JOB_COLOR );
        }

        // create private blip job
        //createPersonalJobBlip( playerid, TRUCK_JOB_X, TRUCK_JOB_Y);
        //

        if(!isPlayerHaveJob(playerid)) {
            msg( playerid, "job.truckdriver.now" );
            screenFadeinFadeoutEx(playerid, 250, 200, function() {

                setPlayerJob( playerid, "truckdriver");

                players[playerid]["skin"] = TRUCK_JOB_SKIN;
                setPlayerModel( playerid, TRUCK_JOB_SKIN );
            });
        }

        local userjob = null;
        if(isSummer()) {
            userjob = truck_scens[truck_scens_summer[random(0, truck_scens_summer.len()-1)]];
        } else {
            userjob = truck_scens[truck_scens_winter[random(0, truck_scens_winter.len()-1)]];
        }

        job_truck[playerid]["userjob"] = userjob;
        msg( playerid, userjob.LoadText, TRUCK_JOB_COLOR );
        job_truck[playerid]["userstatus"] = "working";



        job_truck[playerid]["truckblip3dtext"] = truckJobCreatePrivateBlipText(playerid, userjob.LoadPointX, userjob.LoadPointY, userjob.LoadPointZ, "LOAD HERE", "Press E to load");
        job_truck[playerid]["leavejob3dtext"] = createPrivate3DText (playerid, TRUCK_JOB_X, TRUCK_JOB_Y, TRUCK_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_TRUCK );
        return;
    }

    // если у игрока статус работы == для тебя нет работы
    if (job_truck[playerid]["userstatus"] == "nojob") {
        return msg( playerid, "job.truckdriver.badworker");
    }
    // если у игрока статус работы == выполняет работу
    if (job_truck[playerid]["userstatus"] == "working") {
        return msg( playerid, "job.truckdriver.needcomplete" );
    }
    // если у игрока статус работы == завершил работу
    if (job_truck[playerid]["userstatus"] == "complete") {
        job_truck[playerid]["userstatus"] = null;
        local amount = TRUCK_JOB_SALARY + (random(-2, 2)).tofloat();
        msg( playerid, "job.truckdriver.nicejob", [getPlayerName( playerid ), amount] );
        addMoneyToPlayer(playerid, amount);
        return;
    }
}


function truckJobRefuseLeave( playerid ) {
    if(!isPlayerInValidPoint(playerid, TRUCK_JOB_X, TRUCK_JOB_Y, RADIUS_TRUCK)) {
        return;
    }

    if(!isTruckDriver(playerid)) {
        return;
    }

    if (job_truck[playerid]["userstatus"] == "working") {
        msg( playerid, "job.truckdriver.badworker.onleave");
        job_truck[playerid]["userstatus"] = "nojob";
    }

    if (job_truck[playerid]["userstatus"] == "complete") {
        msg( playerid, "job.truckdriver.nicejob", [getPlayerName( playerid ), TRUCK_JOB_SALARY] );
        msg( playerid, "job.truckdriver.goodluck");
        addMoneyToPlayer(playerid, TRUCK_JOB_SALARY);
        job_truck[playerid]["userstatus"] = null;
    }

    if(job_truck[playerid]["userstatus"] == null) {
        msg( playerid, "job.truckdriver.goodluck");
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.leave", TRUCK_JOB_COLOR );

        setPlayerJob( playerid, null );

        players[playerid]["skin"] = players[playerid]["default_skin"];
        setPlayerModel( playerid, players[playerid]["default_skin"]);

        remove3DText ( job_truck[playerid]["leavejob3dtext"] );
        // remove private blip job
        removePersonalJobBlip ( playerid );

        truckJobRemovePrivateBlipText ( playerid );
    });

}



// working good, check
function truckJobLoadUnload( playerid ) {

    local vehicleid = getPlayerVehicle( playerid );
    if(job_truck[playerid]["userjob"] == null || !isPlayerInVehicle(playerid) || !isPlayerVehicleDriver(playerid) || !(vehicleid in truckcars)) {
        return;
    }
    if (isPlayerVehicleMoving(playerid)) {
        return;
    }


/*
    if(!isTruckDriver(playerid)) {
        return msg( playerid, "job.truckdriver.not", TRUCK_JOB_COLOR );
    }
*/


    local userjob = job_truck[playerid]["userjob"];

    if(truckcars[vehicleid][0] && isVehicleInValidPoint(playerid, userjob.LoadPointX, userjob.LoadPointY, 4.0 )) {
        dbg(1);
        return msg( playerid, "job.truckdriver.alreadyloaded", TRUCK_JOB_COLOR );
    }

    if(!truckcars[vehicleid][0] && isVehicleInValidPoint(playerid, userjob.UnloadPointX, userjob.UnloadPointY, 4.0 )) {
        dbg(2);
        return msg( playerid, "job.truckdriver.empty", TRUCK_JOB_COLOR );
    }


/*
    if (!isPlayerVehicleTruck(playerid)) {
        return msg( playerid, "job.truckdriver.needtruck", TRUCK_JOB_COLOR );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.truckdriver.driving", CL_RED );
    }
*/
    if(!isPlayerInVehicleSeat(playerid, 0)) {
        return msg( playerid, "job.truckdriver.notpassenger", TRUCK_JOB_COLOR );
    }

    if(!truckcars[vehicleid][0] && isVehicleInValidPoint(playerid, userjob.LoadPointX, userjob.LoadPointY, 4.0 )) {
        //loading
        truckJobRemovePrivateBlipText ( playerid );
        setVehiclePartOpen(vehicleid, 1, true);

        msg( playerid, "job.truckdriver.loading", TRUCK_JOB_COLOR );
        delayedFunction(1500, function() {
            screenFadeinFadeoutEx(playerid, 1000, 3000, null, function() {
                truckcars[vehicleid][0] = true;
                job_truck[playerid]["truckblip3dtext"] = truckJobCreatePrivateBlipText(playerid, userjob.UnloadPointX, userjob.UnloadPointY, userjob.UnloadPointZ, "UNLOAD HERE", "Press E to unload");
                msg( playerid, userjob.UnloadText, TRUCK_JOB_COLOR );
                setVehiclePartOpen(vehicleid, 1, false);
            });
        });

    }


    if(truckcars[vehicleid][0] && isVehicleInValidPoint(playerid, userjob.UnloadPointX, userjob.UnloadPointY, 4.0 )) {
        // UNloading
        truckJobRemovePrivateBlipText ( playerid );
        //truck_limit_in_hour_current -= 1;

        setVehiclePartOpen(vehicleid, 1, true);

        msg( playerid, "job.truckdriver.unloading", TRUCK_JOB_COLOR );
        delayedFunction(1500, function() {
            screenFadeinFadeoutEx(playerid, 1000, 3000, null, function() {
                job_truck[playerid]["userstatus"] = "complete";
                truckcars[vehicleid][0] = false;
                msg( playerid, "job.truckdriver.takemoney", TRUCK_JOB_COLOR );
                setVehiclePartOpen(vehicleid, 1, false);
            });
        });
    }
}
