local count = 0;

cmd("snow", function(playerid) {
    if(!isPlayerInValidVehicle(playerid, 39)) { return msg(playerid, "You need Shubert SnowPlow."); }
    local vehicleid = getPlayerVehicle(playerid);
    local vehPos = getVehiclePosition(vehicleid);
    local vehRot = getVehicleRotation(vehicleid);

    local xR = vehRot[0];
    local x = vehPos[0];
    local y = vehPos[1];
    local x1 = 0;
    local x2 = 0;
    local y1 = 0;
    local y2 = 0;

    // when near 0
    if(xR > -5 && xR < 5) {
        dbg("0");
        x1 = x - 1.6;
        y1 = y + 1;
        x2 = x + 2;
        y2 = y - 1;
    }

    // when near 90
    else if(xR > 85 && xR < 95) {
        dbg("90");
        x1 = x + 1;
        y1 = y + 1.6;
        x2 = x - 1;
        y2 = y - 2;
    }

    // when near 180
    else if( (xR > 175 && xR < 180) || (xR < -175 && xR > -179.99) ) {
        dbg("180");
        x1 = x - 2;
        y1 = y + 1;
        x2 = x + 1.6;
        y2 = y - 1;
    }

    // when near -90
    else if(xR > -95 && xR < -85) {
        dbg("-90");
        x1 = x - 1;
        y1 = y + 2;
        x2 = x + 1;
        y2 = y - 1.6;
    }

    dbg(vehPos[0], vehPos[1], vehPos[2], x1, y1, x2, y2);
    msg(playerid, "Place has been created.", CL_SUCCESS );
    createPlace("snowPlace"+count, x1, y1, x2, y2);
    count += 1;
});


//include("modules/jobs/snowplow/commands.nut");

local job_snowplow = {};
local job_snowplow_blocked = {};
local snowplowStops = {};
local routes = {};

local RADIUS_SNOWPLOW = 2.0;
local RADIUS_SNOWPLOW_SMALL = 1.0;
local SNOWPLOW_JOB_X = -388.442;
local SNOWPLOW_JOB_Y = 585.829;
local SNOWPLOW_JOB_Z = -10.2939;


local SNOWPLOW_JOB_TIMEOUT = 1800; // 30 minutes
local SNOWPLOW_JOB_SKIN = 132;
local SNOWPLOW_JOB_SNOWPLOWSTOP = "CHECKPOINT";
local SNOWPLOW_JOB_DISTANCE = 100;
local SNOWPLOW_JOB_LEVEL = 1;
      SNOWPLOW_JOB_COLOR <- CL_CRUSTA;
local SNOWPLOW_JOB_GET_HOUR_START        = 0  ;   // 6;
local SNOWPLOW_JOB_GET_HOUR_END          = 23 ;   // 9;
local SNOWPLOW_JOB_LEAVE_HOUR_START      = 0  ;   // 20;
local SNOWPLOW_JOB_LEAVE_HOUR_END        = 23 ;   // 22;
local SNOWPLOW_JOB_WORKING_HOUR_START    = 0  ;   // 6;
local SNOWPLOW_JOB_WORKING_HOUR_END      = 23 ;   // 21;
local SNOWPLOW_ROUTE_IN_HOUR = 4;
local SNOWPLOW_ROUTE_NOW = 4;

translation("en", {
    "job.snowplowdriver"                     :   "snowplow driver"
    "job.snowplow.letsgo"                    :   "[BUS] Let's go to central door at snowplow depot in Uptown."
    "job.snowplow.needlevel"                 :   "[BUS] You need level %d to become snowplow driver."
    "job.snowplow.badworker"                 :   "[BUS] You are a bad worker. We haven't job for you."
    "job.snowplow.badworker.onleave"         :   "[BUS] You are a bad worker. Get out of here."
    "job.snowplow.goodluck"                  :   "[BUS] Good luck, guy! Come if you need a job."
    "job.snowplow.driver.not"                :   "[BUS] You're not a snowplow driver."
    "job.snowplow.driver.now"                :   "[BUS] You're a snowplow driver now! Congratulations!"
    "job.snowplow.ifyouwantstart"            :   "[BUS] You're snowplow driver. If you want to start route - take route at snowplow depot in Uptown."
    "job.snowplow.route.your"                :   "[BUS] Your route is #%d - %s."
    "job.snowplow.startroute"                :   "Sit into snowplow and go to snowplow stop in %s."
    "job.snowplow.route.needcomplete"        :   "[BUS] Complete current route."
    "job.snowplow.needsnowplow"                   :   "[BUS] You need a snowplow."
    "job.snowplow.gotonextsnowplowstop"           :   "[BUS] Good! Go to next snowplow stop in %s."
    "job.snowplow.continuesnowplowstop"           :   "[BUS] Continue the route. Go to next snowplow stop in %s."
    "job.snowplow.waitpasses"                :   "[BUS] Wait passengers some time..."
    "job.snowplow.gotosnowplowstop"               :   "[BUS] Go to snowplow stop in %s."
    "job.snowplow.driving"                   :   "[BUS] You're driving. Please stop the snowplow."
    "job.snowplow.gototakemoney"             :   "[BUS] Leave the snowplow and take your money near central entrance."
    "job.snowplow.nicejob"                   :   "[BUS] Nice job! You earned $%.2f"
    "job.snowplow.needcorrectpark"           :   "[BUS] Park the snowplow correctly."

    "job.snowplow.help.title"                 :   "Controls for snowplow driver:"
    "job.snowplow.help.job"                   :   "E button"
    "job.snowplow.help.jobtext"               :   "Get snowplow driver job at snowplow depot in Uptown"
    "job.snowplow.help.jobleave"              :   "Q button"
    "job.snowplow.help.jobleavetext"          :   "Leave snowplow driver job at snowplow depot in Uptown"
    "job.snowplow.help.snowplowstop"          :   "E button"
    "job.snowplow.help.snowplowstoptext"      :   "Bus stop"

});

event("onServerStarted", function() {
    log("[jobs] loading snowplow job...");

    createVehicle(39, -372.233, 593.342, -9.96686, -89.1468, 1.52338, 0.0686706);
    createVehicle(39, -374.524, 589.011, -9.96381, -56.7532, 1.17279, 0.934235);
    createVehicle(39, -380.797, 588.42, -9.95933, -56.3861, 1.20405, 0.900966);

  //snowplowStops[0]   <-               vehPos               x1       y1          x2        y2
    snowplowStops[1]   <-  [-435.672, 587.141, -9.6025,  -436.672,  589.141,  -434.672,  585.541];
    snowplowStops[2]   <-  [-567.725, 586.777, -2.8422,  -568.725,  588.777,  -566.725,  585.177];
    snowplowStops[3]   <-  [-641.673, 582.995, 1.15959,  -640.673,  584.595,  -642.673,  580.995];
    snowplowStops[4]   <-  [-415.356, 582.949, -9.97182, -414.356,  584.549,  -416.356,  580.949];



  //routes[0] <- [zarplata, [stop1, stop2, stop3, ..., stop562]];
    routes[1] <- [9, [1, 2, 3, 4]]; //sand island
    //routes[2] <- [9, [2, 21, 19, 17, 14, 15, 2]]; //
    //routes[3] <- [15, [4, 98, 25, 16, 18, 20, 22, 23, 24, 21, 19, 17, 14, 15, 4]];
    //routes[4] <- [12, [3, 5, 99, 6, 7, 8, 9, 10, 11, 13, 14, 15, 3]];
    //routes[5] <- [23, [4, 5, 99, 6, 7, 8, 9, 10, 12, 13, 16, 18, 20, 22, 23, 24, 21, 19, 17, 14, 15, 4]];

    //creating 3dtext for snowplow depot
    create3DText ( SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.35, "SNOW PLOWING COMPANY", CL_ROYALBLUE );
    create3DText ( SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.20, "Press E to action", CL_WHITE.applyAlpha(150), RADIUS_SNOWPLOW );

    registerPersonalJobBlip("snowplow", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y);

});


key("e", function(playerid) {
    snowplowJobGet( playerid );
    snowplowJobStop( playerid );
}, KEY_UP);

key("q", function(playerid) {
    snowplowJobRefuseLeave( playerid );
}, KEY_UP);

event("onPlayerConnect", function(playerid) {
    if ( ! (getPlayerName(playerid) in job_snowplow) ) {
     job_snowplow[getPlayerName(playerid)] <- {};
     job_snowplow[getPlayerName(playerid)]["route"] <- false;
     job_snowplow[getPlayerName(playerid)]["userstatus"] <- null;
     job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] <- [ null, null ];
     job_snowplow[getPlayerName(playerid)]["snowplowBlip"] <- null;
    }
});


event("onServerPlayerStarted", function( playerid ){

    if(isBusDriver(playerid)) {
        if (job_snowplow[getPlayerName(playerid)]["userstatus"] == "working") {
            local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][1][0];
            if (snowplowID < 90 ) job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] = createPrivateBusStop3DText(playerid, snowplowStops[snowplowID].private);
            trigger(playerid, "setGPS", snowplowStops[snowplowID].private.x, snowplowStops[snowplowID].private.y);
            trigger(playerid, "hudDestroyTimer");
            msg( playerid, "job.snowplow.continuesnowplowstop", snowplowStops[snowplowID].name, SNOWPLOW_JOB_COLOR );
        } else {
            msg( playerid, "job.snowplow.ifyouwantstart", SNOWPLOW_JOB_COLOR );
        }
        createText (playerid, "leavejob3dtext", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_SNOWPLOW_SMALL );
    }
});

// event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
//     if (!isPlayerVehicleBus(playerid)) {
//         return;
//     }
// 
//     if(isBusDriver(playerid) && job_snowplow[getPlayerName(playerid)]["userstatus"] == "working") {
//         unblockVehicle(vehicleid);
//         //delayedFunction(4500, function() {
//             //snowplowJobReady(playerid);
//         //});
//     } else {
//         blockVehicle(vehicleid);
//     }
// });
// 
// event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
//     if (!isPlayerVehicleBus(playerid)) {
//         return;
//     }
// 
//     blockVehicle(vehicleid);
// });
// 
// event("onServerHourChange", function() {
//     SNOWPLOW_ROUTE_NOW = SNOWPLOW_ROUTE_IN_HOUR + random(-2, 1);
// });

 function snowplowStop(a, b, c, d) {
     return {name = a, public = b, private = c, rotation = d };
 }

 function snowplowv3(a, b, c) {
     return {x = a.tofloat(), y = b.tofloat(), z = c.tofloat() };
 }


/**
 * Create private 3DTEXT for current snowplow stop
 * @param  {int}  playerid
 * @return {array} [idtext1, id3dtext2]
 */
function createPrivateBusStop3DText(playerid, snowplowstop) {
    return [
        createText( playerid, "snowplow_3dtext", snowplowstop[0], snowplowstop[1], snowplowstop[2]+0.20, SNOWPLOW_JOB_SNOWPLOWSTOP, CL_RIPELEMON, SNOWPLOW_JOB_DISTANCE );
    ];
}

/**
 * Remove private 3DTEXT AND BLIP for current snowplow stop
 * @param  {int}  playerid
 */
function snowplowJobRemovePrivateBlipText ( playerid ) {
    if(job_snowplow[getPlayerName(playerid)]["snowplow3dtext"][0] != null) {
        removeText( playerid, "snowplow_3dtext");
    }
    if (job_snowplow[getPlayerName(playerid)]["snowplowBlip"] != null) {
        removeText( playerid, "snowplow_3dtext");
    }
}

/**
 * Check is player is a snowplow
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isSnowplowDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "snowplowdriver"));
}

/**
 * Check is player's vehicle is a snowplow truck
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleSnowplow(playerid) {
    return (isPlayerInValidVehicle(playerid, 39));
}

// /**
//  * Check is route selected
//  * @param  {int}  playerid
//  * @return {Boolean} true/false
//  */
// function isBusRouteSelected(playerid) {
//     return (job_snowplow[getPlayerName(playerid)]["route"] != false) ? true : false;
// }
// 
// /**
//  * Check is BusReady
//  * @param  {int}  playerid
//  * @return {Boolean} true/false
//  */
// function isBusReady(playerid) {
//     return job_snowplow[getPlayerName(playerid)]["snowplowready"];
// }
// 
// 
// working good, check
function snowplowJobGet( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

/*
    if(isBusDriver(playerid)) {
        return msg( playerid, "job.snowplow.driver.already", SNOWPLOW_JOB_COLOR );
    }

    // если у игрока недостаточный уровень
    if(!isPlayerLevelValid ( playerid, SNOWPLOW_JOB_LEVEL )) {
        return msg(playerid, "job.snowplow.needlevel", SNOWPLOW_JOB_LEVEL, SNOWPLOW_JOB_COLOR );
    }
*/
    // если у игрока статус работы == null
    if(job_snowplow[getPlayerName(playerid)]["userstatus"] == null) {

        if(!isPlayerHaveJob(playerid)) {

            local hour = getHour();
            if(hour < SNOWPLOW_JOB_GET_HOUR_START || hour >= SNOWPLOW_JOB_GET_HOUR_END) {
                return msg( playerid, "job.closed", [ SNOWPLOW_JOB_GET_HOUR_START.tostring(), SNOWPLOW_JOB_GET_HOUR_END.tostring()], SNOWPLOW_JOB_COLOR );
            }

            if(isPlayerHaveJob(playerid) && !isBusDriver(playerid)) {
                return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), SNOWPLOW_JOB_COLOR );
            }

            if (getPlayerName(playerid) in job_snowplow_blocked) {
                if (getTimestamp() - job_snowplow_blocked[getPlayerName(playerid)] < SNOWPLOW_JOB_TIMEOUT) {
                    return msg( playerid, "job.snowplow.badworker", SNOWPLOW_JOB_COLOR);
                }
            }

            msg( playerid, "job.snowplow.driver.now", SNOWPLOW_JOB_COLOR );
            setPlayerJob( playerid, "snowplowdriver");
            screenFadeinFadeoutEx(playerid, 250, 200, function() {
                setPlayerModel( playerid, SNOWPLOW_JOB_SKIN );
            });
        }

        //snowplowJobStartRoute( playerid );
        createText (playerid, "leavejob3dtext", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_SNOWPLOW_SMALL );

        return;
    }

    // если у игрока статус работы == выполняет работу
    if (job_snowplow[getPlayerName(playerid)]["userstatus"] == "working") {
        return msg( playerid, "job.snowplow.route.needcomplete", SNOWPLOW_JOB_COLOR );
    }
    // если у игрока статус работы == завершил работу
    if (job_snowplow[getPlayerName(playerid)]["userstatus"] == "complete") {
        job_snowplow[getPlayerName(playerid)]["userstatus"] = null;
        snowplowGetSalary( playerid );
        job_snowplow[getPlayerName(playerid)]["route"] = false;
        return;
    }

}


function snowplowJobRefuseLeave( playerid ) {
    if(!isBusDriver(playerid)) {
        return;
    }

    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW_SMALL)) {
        return;
    }

    local hour = getHour();
    if(hour < SNOWPLOW_JOB_LEAVE_HOUR_START || hour >= SNOWPLOW_JOB_LEAVE_HOUR_END) {
        return msg( playerid, "job.closed", [ SNOWPLOW_JOB_LEAVE_HOUR_START.tostring(), SNOWPLOW_JOB_LEAVE_HOUR_END.tostring()], SNOWPLOW_JOB_COLOR );
    }

    if(job_snowplow[getPlayerName(playerid)]["userstatus"] == null) {
        msg( playerid, "job.snowplow.goodluck", SNOWPLOW_JOB_COLOR);
    }

    if (job_snowplow[getPlayerName(playerid)]["userstatus"] == "working") {
        msg( playerid, "job.snowplow.badworker.onleave", SNOWPLOW_JOB_COLOR);
        job_snowplow_blocked[getPlayerName(playerid)] <- getTimestamp();
        job_snowplow[getPlayerName(playerid)]["userstatus"] = null;
        snowplowJobRemovePrivateBlipText( playerid );
    }

    if (job_snowplow[getPlayerName(playerid)]["userstatus"] == "complete") {
        job_snowplow[getPlayerName(playerid)]["userstatus"] = null;
        snowplowGetSalary( playerid );
        job_snowplow[getPlayerName(playerid)]["route"] = false;
        msg( playerid, "job.snowplow.goodluck", SNOWPLOW_JOB_COLOR);
    }

    removeText ( playerid, "leavejob3dtext" );
    trigger(playerid, "removeGPS");

    screenFadeinFadeoutEx(playerid, 250, 200, function() {

        msg( playerid, "job.leave", SNOWPLOW_JOB_COLOR );

        setPlayerJob( playerid, null );
        restorePlayerModel(playerid);

        // remove private blip job
        removePersonalJobBlip ( playerid );
    });

}


// function snowplowGetSalary( playerid ) {
//     local amount = job_snowplow[getPlayerName(playerid)]["route"][0];
//     addMoneyToPlayer(playerid, amount);
//     msg( playerid, "job.snowplow.nicejob", amount, SNOWPLOW_JOB_COLOR );
// }
// 
// // working good, check
// function snowplowJobStartRoute( playerid ) {
// 
//     local hour = getHour();
//     if(hour < SNOWPLOW_JOB_WORKING_HOUR_START || hour >= SNOWPLOW_JOB_WORKING_HOUR_END) {
//         return msg( playerid, "job.closed", [ SNOWPLOW_JOB_WORKING_HOUR_START.tostring(), SNOWPLOW_JOB_WORKING_HOUR_END.tostring()], TRUCK_JOB_COLOR );
//     }
// 
//     if(SNOWPLOW_ROUTE_NOW < 1) {
//         return msg( playerid, "job.nojob", SNOWPLOW_JOB_COLOR );
//     }
// 
//     local route = random(1, 5);
// 
//     job_snowplow[getPlayerName(playerid)]["route"] <- [routes[route][0], clone routes[route][1]]; //create clone of route
//     msg( playerid, "job.snowplow.route.your", [route, plocalize(playerid, "job.snowplow.route."+route) ], SNOWPLOW_JOB_COLOR  );
// 
// 
// // Your route is #2 - . Sit into snowplow.
// // plocalize(playerid, "job.snowplow.route."+route)
// 
//     job_snowplow[getPlayerName(playerid)]["userstatus"] = "working";
// 
//     local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][1][0];
// 
//     msg( playerid, "job.snowplow.startroute", snowplowStops[snowplowID].name, SNOWPLOW_JOB_COLOR );
//     if (snowplowID < 90 ) job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] = createPrivateBusStop3DText(playerid, snowplowStops[snowplowID].private);
//     trigger(playerid, "setGPS", snowplowStops[snowplowID].private.x, snowplowStops[snowplowID].private.y);
//     //job_snowplow[getPlayerName(playerid)]["snowplowBlip"]   = createPrivateBlip(playerid, snowplowStops[snowplowID].private.x, snowplowStops[snowplowID].private.y, ICON_YELLOW, 4000.0);   надо вырезать
//     //local gpsPos = snowplowStops[snowplowID].private;
//     //trigger(playerid, "setGPS", gpsPos.x, gpsPos.y);
// }
// 
// // working good, check
// // coords snowplow at snowplow station in Sand Island    -1597.05, -193.64, -19.9622, -89.79, 0.235025, 3.47667
// // coords snowplow at snowplow station in Hunters Point    -1562.5, 105.709, -13.0123, 0.966663, -0.00153991, 0.182542
// function snowplowJobStop( playerid ) {
// 
//     if(job_snowplow[getPlayerName(playerid)]["userstatus"] != "working" || !isPlayerInVehicle(playerid) || !isPlayerVehicleBus(playerid) ) {
//         return;
//     }
// 
//     if(!isBusDriver(playerid)) {
//         return msg( playerid, "job.snowplow.driver.not", SNOWPLOW_JOB_COLOR );
//     }
// 
//     if (!isPlayerVehicleBus(playerid)) {
//         return msg(playerid, "job.snowplow.needsnowplow", SNOWPLOW_JOB_COLOR );
//     }
// 
//     local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][1][0];
// 
//     if(!isPlayerVehicleInValidPoint(playerid, snowplowStops[snowplowID].private.x, snowplowStops[snowplowID].private.y, 5.0 )) {
//         return/* msg( playerid, "job.snowplow.gotosnowplowstop", snowplowStops[snowplowID].name, SNOWPLOW_JOB_COLOR )*/;
//     }
// 
//     if(isPlayerVehicleMoving(playerid)){
//         return msg( playerid, "job.snowplow.driving", CL_RED );
//     }
// 
//     local vehicleid = getPlayerVehicle(playerid);
//     if(snowplowStops[snowplowID].rotation != null) {
//         local vehRot = getVehicleRotation(vehicleid);
//         local offset = fabs(vehRot[0] - snowplowStops[snowplowID].rotation);
//         if (offset > 3.5) {
//             return msg(playerid, "job.snowplow.needcorrectpark", CL_RED );
//         }
//     }
// 
//     setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
// 
//     snowplowJobRemovePrivateBlipText( playerid );
//     trigger(playerid, "removeGPS");
//     trigger(playerid, "hudDestroyTimer");
// 
//     job_snowplow[getPlayerName(playerid)]["route"][1].remove(0);
// 
//     freezePlayer( playerid, true);
//     local vehFuel = getVehicleFuel( vehicleid );
//     setVehicleFuel( vehicleid, 0.0 );
//     msg( playerid, "job.snowplow.waitpasses", SNOWPLOW_JOB_COLOR );
// 
//     trigger(playerid, "hudCreateTimer", 14.0, true, true);
//     delayedFunction(14000, function () {
//         freezePlayer( playerid, false);
//         delayedFunction(1000, function () { freezePlayer( playerid, false); });
//         setVehicleFuel( vehicleid, vehFuel );
//         if (job_snowplow[getPlayerName(playerid)]["route"][1].len() == 0) {
//             msg( playerid, "job.snowplow.gototakemoney", SNOWPLOW_JOB_COLOR );
//             blockVehicle(vehicleid);
//             job_snowplow[getPlayerName(playerid)]["userstatus"] = "complete";
//             return;
//         }
// 
//         local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][1][0];
// 
//         if (snowplowID < 90 ) job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] = createPrivateBusStop3DText(playerid, snowplowStops[snowplowID].private);
//         //job_snowplow[getPlayerName(playerid)]["snowplowBlip"]   = createPrivateBlip(playerid, snowplowStops[snowplowID].private.x, snowplowStops[snowplowID].private.y, ICON_YELLOW, 2000.0);
//         //job_snowplow[getPlayerName(playerid)]["snowplowBlip"]   = playerid+"blip"; //надо вырезать
// 
//         trigger(playerid, "setGPS", snowplowStops[snowplowID].private.x, snowplowStops[snowplowID].private.y);
//         msg( playerid, "job.snowplow.gotonextsnowplowstop", snowplowStops[snowplowID].name, SNOWPLOW_JOB_COLOR );
//         //local gpsPos = snowplowStops[snowplowID].private;
//         //trigger(playerid, "setGPS", gpsPos.x, gpsPos.y);
//     });
// 
// }
// 
// event("onPlayerPlaceEnter", function(playerid, name) {
//     if (isBusDriver(playerid) && isPlayerVehicleBus(playerid) && job_snowplow[getPlayerName(playerid)]["userstatus"] == "working") {
//         if((name == "LittleItalyWaypoint" && job_snowplow[getPlayerName(playerid)]["route"][1][0] == 98) || (name == "WestSideWaypoint" && job_snowplow[getPlayerName(playerid)]["route"][1][0] == 99) || (name == "SandIslandWaypoint" && job_snowplow[getPlayerName(playerid)]["route"][1][0] == 97)) {
//             trigger(playerid, "removeGPS");
//             job_snowplow[getPlayerName(playerid)]["route"][1].remove(0);
//             local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][1][0];
//             trigger(playerid, "setGPS", snowplowStops[snowplowID].private.x, snowplowStops[snowplowID].private.y);
//             job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] = createPrivateBusStop3DText(playerid, snowplowStops[snowplowID].private);
//         }
//     }
// });
// 
// 
// event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
//     if (isBusDriver(playerid) && getVehicleModel(vehicleid) == 20 && job_snowplow[getPlayerName(playerid)]["userstatus"] == "complete") {
//         delayedFunction(14000, function () {
//             tryRespawnVehicleById(vehicleid, true);
//         });
//     }
// });
// 
