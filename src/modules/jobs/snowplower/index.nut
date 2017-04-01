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
local SNOWPLOW_JOB_NAME = "snowplowdriver";
local SNOWPLOW_JOB_SNOWPLOWSTOP = "CHECKPOINT";
local SNOWPLOW_JOB_DISTANCE = 100;
local SNOWPLOW_JOB_LEVEL = 1;
      SNOWPLOW_JOB_COLOR <- CL_ROYALBLUE;
local SNOWPLOW_JOB_GET_HOUR_START        = 0  ;   // 6;
local SNOWPLOW_JOB_GET_HOUR_END          = 23 ;   // 9;
local SNOWPLOW_JOB_LEAVE_HOUR_START      = 0  ;   // 20;
local SNOWPLOW_JOB_LEAVE_HOUR_END        = 23 ;   // 22;
local SNOWPLOW_JOB_WORKING_HOUR_START    = 0  ;   // 6;
local SNOWPLOW_JOB_WORKING_HOUR_END      = 23 ;   // 21;
local SNOWPLOW_ROUTE_IN_HOUR = 4;
local SNOWPLOW_ROUTE_NOW = 4;

alternativeTranslate({
    "en|job.snowplowdriver"                     :   "snowplow driver"
    "ru|job.snowplowdriver"                     :   "водитель автобуса"

    "en|job.snowplow.letsgo"                    :   "[SNOWPLOW] Let's go to central door at snowplow depot in Uptown."
    "ru|job.snowplow.letsgo"                    :   "[SNOWPLOW] Подойди к центральной двери здания автобусного депо в Аптауне."

    "en|job.snowplow.needlevel"                 :   "[SNOWPLOW] You need level %d to become snowplow driver."
    "ru|job.snowplow.needlevel"                 :   "[SNOWPLOW] Стать водителем автобуса можно, начиная с %d уровня."

    "en|job.snowplow.badworker"                 :   "[SNOWPLOW] You are a bad worker. We haven't job for you."
    "ru|job.snowplow.badworker"                 :   "[SNOWPLOW] Увы, но нам нужны только ответственные водители."

    "en|job.snowplow.badworker.onleave"         :   "[SNOWPLOW] You are a bad worker. Get out of here."
    "ru|job.snowplow.badworker.onleave"         :   "[SNOWPLOW] Плохой из тебя работник."

    "en|job.snowplow.goodluck"                  :   "[SNOWPLOW] Good luck, guy! Come if you need a job."
    "ru|job.snowplow.goodluck"                  :   "[SNOWPLOW] Удачи тебе! Приходи, если нужна работа."

    "en|job.snowplow.driver.not"                :   "[SNOWPLOW] You're not a snowplow driver."
    "ru|job.snowplow.driver.not"                :   "[SNOWPLOW] Ты не работаешь водителем автобуса."

    "en|job.snowplow.driver.now"                :   "[SNOWPLOW] You're a snowplow driver now! Congratulations!"
    "ru|job.snowplow.driver.now"                :   "[SNOWPLOW] Ты стал водителем автобуса! Поздравляем!"

    "en|job.snowplow.driver.togetroute"         :   "Press E to get route."
    "ru|job.snowplow.driver.togetroute"         :   "Нажми клавишу E (латинская), чтобы получить маршрут."

    "en|job.snowplow.ifyouwantstart"            :   "[SNOWPLOW] You're snowplow driver. If you want to start route - take route at snowplow depot in Uptown."
    "ru|job.snowplow.ifyouwantstart"            :   "[SNOWPLOW] Ты работаешь водителем автобуса. Если хочешь выйти в рейс - возьми маршрут в автобусном депо."

    "en|job.snowplow.route.your"                :   "[SNOWPLOW] Your route:"
    "ru|job.snowplow.route.your"                :   "[SNOWPLOW] Твой текущий маршрут:"

    "en|job.snowplow.startroute"                :   "Sit into snowplow and go to snowplow stop in %s."
    "ru|job.snowplow.startroute"                :   "[SNOWPLOW] Подъезжай на автобусе к остановке %s."

    "en|job.snowplow.route.needcomplete"        :   "[SNOWPLOW] Complete current route."
    "ru|job.snowplow.route.needcomplete"        :   "[SNOWPLOW] Заверши маршрут."

    "en|job.snowplow.needCompleteToLeave"       :   "[SNOWPLOW] You need to complete current route to leave job."
    "ru|job.snowplow.needCompleteToLeave"       :   "[SNOWPLOW] Чтобы уволиться, тебе надо завершить текущий маршрут."

    "en|job.snowplow.needsnowplow"                   :   "[SNOWPLOW] You need a snowplow."
    "ru|job.snowplow.needsnowplow"                   :   "[SNOWPLOW] Тебе нужен автобус."

    "en|job.snowplow.gotonextsnowplowstop"           :   "[SNOWPLOW] Good! Go to next snowplow stop in %s."
    "ru|job.snowplow.gotonextsnowplowstop"           :   "[SNOWPLOW] Отлично! Следующая остановка: %s."

    "en|job.snowplow.continuesnowplowstop"           :   "[SNOWPLOW] Continue the route."
    "ru|job.snowplow.continuesnowplowstop"           :   "[SNOWPLOW] Продолжай движение по маршруту."

    "en|job.snowplow.nextsnowplowstop"               :   "Next snowplow stop: %s."
    "ru|job.snowplow.nextsnowplowstop"               :   "Следующая остановка: %s."

    "en|job.snowplow.nextsnowplowstop2"              :   "Driver: Route #%d. %s."
    "ru|job.snowplow.nextsnowplowstop2"              :   "Водитель: Маршрут #%d. %s."

    "en|job.snowplow.nextsnowplowstop3"              :   "Next snowplow stop: %s. Last snowplow stop"
    "ru|job.snowplow.nextsnowplowstop3"              :   "Следующая остановка: %s. Конечная."

    "en|job.snowplow.lastsnowplowstop"               :   "Driver: Route #%d. %s. Last snowplow stop."
    "ru|job.snowplow.lastsnowplowstop"               :   "Водитель: Маршрут #%d. %s. Конечная."

    "en|job.snowplow.waitpasses"                :   "[SNOWPLOW] Wait passengers some time..."
    "ru|job.snowplow.waitpasses"                :   "[SNOWPLOW] Идёт посадка..."

    "en|job.snowplow.driving"                   :   "[SNOWPLOW] You're driving. Please stop the snowplow."
    "ru|job.snowplow.driving"                   :   "[SNOWPLOW] Останови автобус."

    "en|job.snowplow.gototakemoney"             :   "[SNOWPLOW] Leave the snowplow and take your money near central entrance."
    "ru|job.snowplow.gototakemoney"             :   "[SNOWPLOW] Оставляй автобус тут. Заработанные деньги получишь у центрального входа в здание депо."

    "en|job.snowplow.nicejob"                   :   "[SNOWPLOW] Nice job! You earned $%.2f"
    "ru|job.snowplow.nicejob"                   :   "[SNOWPLOW] Отличная работа! Ты заработал $%.2f."

    "en|job.snowplow.needcorrectpark"           :   "[SNOWPLOW] Park the snowplow correctly."
    "ru|job.snowplow.needcorrectpark"           :   "[SNOWPLOW] Подъедь к остановке правильно."



    "en|job.snowplow.help.title"            :   "Controls for snowplow driver:"
    "ru|job.snowplow.help.title"            :   "Управление для водителя снегоуборочной машины:"

    "en|job.snowplow.help.job"              :   "E button"
    "ru|job.snowplow.help.job"              :   "кнопка E"

    "en|job.snowplow.help.jobtext"          :   "Get snowplow driver job at snowplow station in Uptown"
    "ru|job.snowplow.help.jobtext"          :   "Устроиться на работу водителем снегоуборочной машины (напротив Полицейского Департамента)"

    "en|job.snowplow.help.jobleave"         :   "Q button"
    "ru|job.snowplow.help.jobleave"         :   "кнопка Q"

    "en|job.snowplow.help.jobleavetext"     :   "Leave snowplow driver job at snowplow station in Uptown"
    "ru|job.snowplow.help.jobleavetext"     :   "Уволиться с работы (напротив Полицейского Департамента)"

});

event("onServerStarted", function() {
    log("[jobs] loading snowplow job...");

    createVehicle(39, -372.233, 593.342, -9.96686, -89.1468, 1.52338, 0.0686706);
    createVehicle(39, -374.524, 589.011, -9.96381, -56.7532, 1.17279, 0.934235);
    createVehicle(39, -380.797, 588.42, -9.95933, -56.3861, 1.20405, 0.900966);

  //snowplowStops[0]   <-                                     vehPos                  x1       y1          x2        y2
    snowplowStops[1]   <-  snowplowStop( snowplowv3(-435.672, 587.141,  -9.6025),  -436.672,  589.141,  -434.672,  585.541);
    snowplowStops[2]   <-  snowplowStop( snowplowv3(-567.725, 586.777,  -2.8422),  -568.725,  588.777,  -566.725,  585.177);
    snowplowStops[3]   <-  snowplowStop( snowplowv3(-641.673, 582.995,  1.15959),  -640.673,  584.595,  -642.673,  580.995);
    snowplowStops[4]   <-  snowplowStop( snowplowv3(-415.356, 582.949, -9.97182),  -414.356,  584.549,  -416.356,  580.949);



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


event("onPlayerConnect", function(playerid) {
    if ( ! (getPlayerName(playerid) in job_snowplow) ) {
     job_snowplow[getPlayerName(playerid)] <- {};
     job_snowplow[getPlayerName(playerid)]["route"] <- false;
     job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] <- [ null, null ];
     job_snowplow[getPlayerName(playerid)]["snowplowBlip"] <- null;
    }
});


event("onServerPlayerStarted", function( playerid ){

    if(isSnowplowDriver(playerid)) {
        if (getPlayerJobState(playerid) == "working") {
            local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][2][0];
            job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] = createPrivateSnowplowCheckpoint3DText(playerid, snowplowStops[snowplowID].coords);
            trigger(playerid, "setGPS", snowplowStops[snowplowID].coords.x, snowplowStops[snowplowID].coords.y);
            trigger(playerid, "hudDestroyTimer");
            msg( playerid, "job.snowplow.continuesnowplowstop", SNOWPLOW_JOB_COLOR );
        } else {
            msg( playerid, "job.snowplow.ifyouwantstart", SNOWPLOW_JOB_COLOR );
        }
        createText (playerid, "leavejob3dtext", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_SNOWPLOW_SMALL );
    }
});

event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
    if (!isPlayerVehicleSnowplow(playerid)) {
        return;
    }

    if(isSnowplowDriver(playerid) && getPlayerJobState(playerid) == "working") {
        unblockVehicle(vehicleid);
        //delayedFunction(4500, function() {
            //snowplowJobReady(playerid);
        //});
    } else {
        blockVehicle(vehicleid);
    }
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (!isPlayerVehicleSnowplow(playerid)) {
        return;
    }

    blockVehicle(vehicleid);
});

event("onServerHourChange", function() {
    SNOWPLOW_ROUTE_NOW = SNOWPLOW_ROUTE_IN_HOUR + random(-2, 1);
});

function snowplowStop(a, b, c, d, e) {
    return {coords = a, x1 = b, y1 = c, x2 = d, y2 = e};
}

function snowplowv3(a, b, c) {
    return {x = a.tofloat(), y = b.tofloat(), z = c.tofloat() };
}


/**
 * Create private 3DTEXT for current snowplow stop
 * @param  {int}  playerid
 * @return {array} [idtext1, id3dtext2]
 */
function createPrivateSnowplowCheckpoint3DText(playerid, snowplowstop) {
    return [
        createText( playerid, "snowplow_3dtext", snowplowstop.x, snowplowstop.y, snowplowstop.z+0.20, SNOWPLOW_JOB_SNOWPLOWSTOP, CL_RIPELEMON, SNOWPLOW_JOB_DISTANCE )
    ];
}

/**
 * Remove private 3DTEXT AND BLIP for current snowplow stop
 * @param  {int}  playerid
 */
function snowplowJobRemovePrivateBlipText ( playerid ) {

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
// function isSnowplowRouteSelected(playerid) {
//     return (job_snowplow[getPlayerName(playerid)]["route"] != false) ? true : false;
// }
// 
// /**
//  * Check is SnowplowReady
//  * @param  {int}  playerid
//  * @return {Boolean} true/false
//  */
// function isSnowplowReady(playerid) {
//     return job_snowplow[getPlayerName(playerid)]["snowplowready"];
// }
// 
// 


/**
Event: JOB - Snowplow driver - Already have job
*/
key("e", function(playerid) {

    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    if (getPlayerJob(playerid) && getPlayerJob(playerid) != SNOWPLOW_JOB_NAME) {
        msg(playerid, "job.alreadyhavejob", [getPlayerJob(playerid)]);
    }
})



function snowplowJobGet( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    // если у игрока недостаточный уровень
    if(!isPlayerLevelValid ( playerid, SNOWPLOW_JOB_LEVEL )) {
        return msg(playerid, "job.snowplow.needlevel", SNOWPLOW_JOB_LEVEL, SNOWPLOW_JOB_COLOR );
    }


    if(isPlayerHaveJob(playerid) && !isSnowplowDriver(playerid)) {
        return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), SNOWPLOW_JOB_COLOR );
    }

    local hour = getHour();
    if(hour < SNOWPLOW_JOB_GET_HOUR_START || hour >= SNOWPLOW_JOB_GET_HOUR_END) {
        return msg( playerid, "job.closed", [ SNOWPLOW_JOB_GET_HOUR_START.tostring(), SNOWPLOW_JOB_GET_HOUR_END.tostring()], SNOWPLOW_JOB_COLOR );
    }

    if (getPlayerName(playerid) in job_snowplow_blocked) {
        if (getTimestamp() - job_snowplow_blocked[getPlayerName(playerid)] < SNOWPLOW_JOB_TIMEOUT) {
            return msg( playerid, "job.snowplow.badworker", SNOWPLOW_JOB_COLOR);
        }
    }
    msg( playerid, "job.snowplow.driver.now", SNOWPLOW_JOB_COLOR );
    msg( playerid, "job.snowplow.driver.togetroute", CL_LYNCH );
    setPlayerJob( playerid, "snowplowdriver");
    setPlayerJobState( playerid, null);

    //snowplowJobStartRoute( playerid );
    createText (playerid, "leavejob3dtext", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_SNOWPLOW_SMALL );
}
addJobEvent("e", null,    null, snowplowJobGet);
addJobEvent("e", null, "nojob", snowplowJobGet);


/**
Event: JOB - Snowplow driver - Need complete
*/
function snowplowJobNeedComplete( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    msg( playerid, "job.snowplow.route.needcomplete", SNOWPLOW_JOB_COLOR );
}
addJobEvent("e", SNOWPLOW_JOB_NAME,  "working", snowplowJobNeedComplete);


/**
Event: JOB - Snowplow driver - Completed
*/
function snowplowJobCompleted( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    setPlayerJobState(playerid, null);
    snowplowGetSalary( playerid );
    job_snowplow[getPlayerName(playerid)]["route"] = false;
    jobRestorePlayerModel(playerid);
    return;
}
addJobEvent("e", SNOWPLOW_JOB_NAME,  "complete", snowplowJobCompleted);


/**
Event: JOB - Snowplow driver - Leave job
*/
function snowplowJobLeave( playerid ) {
    if(!isSnowplowDriver(playerid)) {
        return;
    }

    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW_SMALL)) {
        return;
    }

    local hour = getHour();
    if(hour < SNOWPLOW_JOB_LEAVE_HOUR_START || hour >= SNOWPLOW_JOB_LEAVE_HOUR_END) {
        return msg( playerid, "job.closed", [ SNOWPLOW_JOB_LEAVE_HOUR_START.tostring(), SNOWPLOW_JOB_LEAVE_HOUR_END.tostring()], SNOWPLOW_JOB_COLOR );
    }

    if(getPlayerJobState(playerid) == null) {
        msg( playerid, "job.snowplow.goodluck", SNOWPLOW_JOB_COLOR);
    }

    if(getPlayerJobState(playerid) == "working") {
        return msg( playerid, "job.snowplow.needCompleteToLeave", SNOWPLOW_JOB_COLOR );
    }

    if(getPlayerJobState(playerid) == "complete") {
        setPlayerJobState(playerid, null);
        snowplowGetSalary( playerid );
        job_snowplow[getPlayerName(playerid)]["route"] = false;
        msg( playerid, "job.snowplow.goodluck", SNOWPLOW_JOB_COLOR);
    }

    removeText(playerid, "leavejob3dtext");
    trigger(playerid, "removeGPS");

    setPlayerJob( playerid, null );

    msg( playerid, "job.leave", SNOWPLOW_JOB_COLOR );

    // remove private blip job
    removePersonalJobBlip ( playerid );

}
addJobEvent("q", SNOWPLOW_JOB_NAME,       null, snowplowJobLeave);
addJobEvent("q", SNOWPLOW_JOB_NAME,  "working", snowplowJobLeave);
addJobEvent("q", SNOWPLOW_JOB_NAME, "complete", snowplowJobLeave);


/**
Event: JOB - Snowplow driver - Get salary
*/
function snowplowGetSalary( playerid ) {
    local amount = job_snowplow[getPlayerName(playerid)]["route"][1];
    addMoneyToPlayer(playerid, amount);
    msg( playerid, "job.snowplow.nicejob", amount, SNOWPLOW_JOB_COLOR );
}

/**
Event: JOB - SNOWPLOW driver - Start route
*/
function snowplowJobStartRoute( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    local hour = getHour();
    if(hour < SNOWPLOW_JOB_WORKING_HOUR_START || hour >= SNOWPLOW_JOB_WORKING_HOUR_END) {
        return msg( playerid, "job.closed", [ SNOWPLOW_JOB_WORKING_HOUR_START.tostring(), SNOWPLOW_JOB_WORKING_HOUR_END.tostring()], TRUCK_JOB_COLOR );
    }

    if(SNOWPLOW_ROUTE_NOW < 1) {
        return msg( playerid, "job.nojob", SNOWPLOW_JOB_COLOR );
    }

    setPlayerJobState( playerid, "working");
    jobSetPlayerModel( playerid, SNOWPLOW_JOB_SKIN );

    local route = random(1, 1);

    job_snowplow[getPlayerName(playerid)]["route"] <- [route, routes[route][0], clone routes[route][1]]; //create clone of route

    msg(playerid, "job.snowplow.route.your", SNOWPLOW_JOB_COLOR);
    msg(playerid, "#"+route+" - "+plocalize(playerid, "job.snowplow.route."+route), SNOWPLOW_JOB_COLOR);

    local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][2][0];

    msg( playerid, "job.snowplow.startroute", [], SNOWPLOW_JOB_COLOR );
    job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] = createPrivateSnowplowCheckpoint3DText(playerid, snowplowStops[snowplowID].coords);

    createPrivatePlace(playerid, "snowplowZone", snowplowStops[snowplowID].x1, snowplowStops[snowplowID].y1, snowplowStops[snowplowID].x2, snowplowStops[snowplowID].y2);

    trigger(playerid, "setGPS", snowplowStops[snowplowID].coords.x, snowplowStops[snowplowID].coords.y);
}
addJobEvent("e", SNOWPLOW_JOB_NAME, null, snowplowJobStartRoute);



// working good, check
// coords snowplow at snowplow station in Sand Island    -1597.05, -193.64, -19.9622, -89.79, 0.235025, 3.47667
// coords snowplow at snowplow station in Hunters Point    -1562.5, 105.709, -13.0123, 0.966663, -0.00153991, 0.182542
function snowplowJobStop( playerid ) {

    if(!isPlayerInVehicle(playerid) || !isPlayerVehicleSnowplow(playerid) ) {
        return;
    }

    if (!isPlayerVehicleSnowplow(playerid)) {
        return msg(playerid, "job.snowplow.needsnowplow", SNOWPLOW_JOB_COLOR );
    }

    local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][2][0];

    if(!isPlayerVehicleInValidPoint(playerid, snowplowStops[snowplowID].coords.x, snowplowStops[snowplowID].coords.y, 5.0 )) {
        return/* msg( playerid, "job.snowplow.gotosnowplowstop", snowplowStops[snowplowID].name, SNOWPLOW_JOB_COLOR )*/;
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.snowplow.driving", CL_RED );
    }

    local vehicleid = getPlayerVehicle(playerid);
    if(snowplowStops[snowplowID].rotation != null) {
        local vehRot = getVehicleRotation(vehicleid);
        local offset = fabs(fabs(vehRot[0]) - fabs(snowplowStops[snowplowID].rotation));
        if (offset > 3.5) {
            return msg(playerid, "job.snowplow.needcorrectpark", CL_RED );
        }
    }

    setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);

    removeText( playerid, "snowplow_3dtext");
    trigger(playerid, "removeGPS");
    trigger(playerid, "hudDestroyTimer");

    msg( playerid, "job.snowplow.waitpasses", SNOWPLOW_JOB_COLOR );

    local routenumber = job_snowplow[getPlayerName(playerid)]["route"][0];
    local snowplowStopLeft = job_snowplow[getPlayerName(playerid)]["route"][2].len();
    if(snowplowStopLeft > 1) {
        local nextSnowplowID = job_snowplow[getPlayerName(playerid)]["route"][2][1];
        //sendLocalizedMsgToAll(playerid, "chat.player.shout", [getPlayerName(playerid), message], SHOUT_RADIUS, CL_WHITE);
        sendLocalizedMsgToAll(playerid, "job.snowplow.nextsnowplowstop2", [ routenumber, plocalize(playerid, snowplowStops[snowplowID].name)], SHOUT_RADIUS, CL_WHITE);
        if (snowplowStopLeft > 2) {
            sendLocalizedMsgToAll(playerid, "job.snowplow.nextsnowplowstop", [ plocalize(playerid, snowplowStops[nextSnowplowID].name)], SHOUT_RADIUS, CL_WHITE);
        } else {
            sendLocalizedMsgToAll(playerid, "job.snowplow.nextsnowplowstop3", [ plocalize(playerid, snowplowStops[nextSnowplowID].name)], SHOUT_RADIUS, CL_WHITE);
        }
    } else {
        sendLocalizedMsgToAll(playerid, "job.snowplow.lastsnowplowstop", [ routenumber, plocalize(playerid, snowplowStops[snowplowID].name)], SHOUT_RADIUS, CL_WHITE);
    }

    job_snowplow[getPlayerName(playerid)]["route"][2].remove(0);

    freezePlayer( playerid, true);
    setPlayerJobState(playerid, "wait");
    job_snowplow[getPlayerName(playerid)]["idSnowplowStop"] = snowplowID;
    local vehFuel = getVehicleFuel( vehicleid );
    setVehicleFuel( vehicleid, 0.0 );

    trigger(playerid, "hudCreateTimer", 20.0, true, true);
    delayedFunction(20000, function () {
        freezePlayer( playerid, false);
        delayedFunction(1000, function () { freezePlayer( playerid, false); });
        setVehicleFuel( vehicleid, vehFuel );
        if (job_snowplow[getPlayerName(playerid)]["route"][2].len() == 0) {
            msg( playerid, "job.snowplow.gototakemoney", SNOWPLOW_JOB_COLOR );
            blockVehicle(vehicleid);
            setPlayerJobState(playerid, "complete");

            local passengers = getAllSnowplowPassengers(vehicleid);
            foreach (idx, passid in passengers) {
                removePlayerFromSnowplow(passid);
                setPlayerPosition(passid, snowplowStops[snowplowID].public.x, snowplowStops[snowplowID].public.y, snowplowStops[snowplowID].public.z);
                reloadPlayerModel(passid);
            }

            return;
        }

        local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][2][0];

        job_snowplow[getPlayerName(playerid)]["idSnowplowStop"] = null;

        if (snowplowID < 90 ) job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] = createPrivateSnowplowCheckpoint3DText(playerid, snowplowStops[snowplowID].coords);
        //job_snowplow[getPlayerName(playerid)]["snowplowBlip"]   = createPrivateBlip(playerid, snowplowStops[snowplowID].coords.x, snowplowStops[snowplowID].coords.y, ICON_YELLOW, 2000.0);
        //job_snowplow[getPlayerName(playerid)]["snowplowBlip"]   = playerid+"blip"; //надо вырезать
        setPlayerJobState(playerid, "working");
        trigger(playerid, "setGPS", snowplowStops[snowplowID].coords.x, snowplowStops[snowplowID].coords.y);
        msg( playerid, "job.snowplow.gotonextsnowplowstop", plocalize(playerid, snowplowStops[snowplowID].name), SNOWPLOW_JOB_COLOR );
        //local gpsPos = snowplowStops[snowplowID].coords;
        //trigger(playerid, "setGPS", gpsPos.x, gpsPos.y);
    });

}
addJobEvent("e", SNOWPLOW_JOB_NAME, "working", snowplowJobStop);



event("onPlayerPlaceEnter", function(playerid, name) {
    if (isSnowplowDriver(playerid) && isPlayerVehicleSnowplow(playerid) && getPlayerJobState(playerid) == "working") {
        if(name == "snowplowZone") {
            local vehicleid = getPlayerVehicle(playerid);
            local speed = getVehicleSpeed(vehicleid);
            local maxsp = max(fabs(speed[0]), fabs(speed[1]));
            if(maxsp > 18.5) return msg(playerid, "Speed is very high");
            removePrivatePlace(playerid, "snowplowZone");
            removeText( playerid, "snowplow_3dtext");
            trigger(playerid, "removeGPS");
            job_snowplow[getPlayerName(playerid)]["route"][2].remove(0);
            if (job_snowplow[getPlayerName(playerid)]["route"][2].len() == 0) {
                
                blockVehicle(vehicleid);
                msg( playerid, "job.snowplow.gototakemoney", SNOWPLOW_JOB_COLOR );
                setPlayerJobState(playerid, "complete");
                return;
            }
            local snowplowID = job_snowplow[getPlayerName(playerid)]["route"][2][0];
            trigger(playerid, "setGPS", snowplowStops[snowplowID].coords.x, snowplowStops[snowplowID].coords.y);
            job_snowplow[getPlayerName(playerid)]["snowplow3dtext"] = createPrivateSnowplowCheckpoint3DText(playerid, snowplowStops[snowplowID].coords);
            createPrivatePlace(playerid, "snowplowZone", snowplowStops[snowplowID].x1, snowplowStops[snowplowID].y1, snowplowStops[snowplowID].x2, snowplowStops[snowplowID].y2);
        }
    }
});


event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (isSnowplowDriver(playerid) && getVehicleModel(vehicleid) == 39 && getPlayerJobState(playerid) == "complete") {
        delayedFunction(10000, function () {
            tryRespawnVehicleById(vehicleid, true);
        });
    }
});


function getNearestSnowplowStationForPlayer(playerid) {
    local pos = getPlayerPositionObj( playerid );
    local dis = 5;
    local snowplowStopid = null;
    foreach (key, value in snowplowStops) {
        local distance = getDistanceBetweenPoints3D( pos.x, pos.y, pos.z, value.public.x, value.public.y, value.public.z );
        if (distance < dis) {
           dis = distance;
           snowplowStopid = key;
        }
    }
    return snowplowStopid;
}
