include("modules/jobs/busdriver/commands.nut");

local job_bus = {};
local job_bus_blocked = {};
local busStops = {};
local routes = {};

local RADIUS_BUS = 2.0;
local RADIUS_BUS_SMALL = 1.0;
local BUS_JOB_X = -422.731;
local BUS_JOB_Y = 479.372;
local BUS_JOB_Z = 0.10922;

local BUS_JOB_TIMEOUT = 1800; // 30 minutes
local BUS_JOB_SKIN = 171;
local BUS_JOB_BUSSTOP = "STOP HERE";
local BUS_JOB_DISTANCE = 100;
local BUS_JOB_LEVEL = 1;
      BUS_JOB_COLOR <- CL_CRUSTA;
local BUS_JOB_GET_HOUR_START = 6;
local BUS_JOB_GET_HOUR_END   = 9;
local BUS_JOB_LEAVE_HOUR_START = 20;
local BUS_JOB_LEAVE_HOUR_END   = 22;
local BUS_JOB_WORKING_HOUR_START = 6;
local BUS_JOB_WORKING_HOUR_END   = 21;
local BUS_ROUTE_IN_HOUR = 4;
local BUS_ROUTE_NOW = 4;

translation("en", {
    "job.busdriver"                     :   "bus driver"
    "job.bus.letsgo"                    :   "[BUS] Let's go to central door at bus depot in Uptown."
    "job.bus.needlevel"                 :   "[BUS] You need level %d to become bus driver."
    "job.bus.badworker"                 :   "[BUS] You are a bad worker. We haven't job for you."
    "job.bus.badworker.onleave"         :   "[BUS] You are a bad worker. Get out of here."
    "job.bus.goodluck"                  :   "[BUS] Good luck, guy! Come if you need a job."
    "job.bus.driver.not"                :   "[BUS] You're not a bus driver."
    "job.bus.driver.now"                :   "[BUS] You're a bus driver now! Congratulations!"
    "job.bus.ifyouwantstart"            :   "[BUS] You're bus driver. If you want to start route - take route at bus depot in Uptown."
    "job.bus.route.your"                :   "[BUS] Your route is #%d - %s."
    "job.bus.startroute"                :   "Sit into bus and go to bus stop in %s."
    "job.bus.route.needcomplete"        :   "[BUS] Complete current route."
    "job.bus.needbus"                   :   "[BUS] You need a bus."
    "job.bus.gotonextbusstop"           :   "[BUS] Good! Go to next bus stop in %s."
    "job.bus.continuebusstop"           :   "[BUS] Continue the route. Go to next bus stop in %s."
    "job.bus.waitpasses"                :   "[BUS] Wait passengers some time..."
    "job.bus.gotobusstop"               :   "[BUS] Go to bus stop in %s."
    "job.bus.driving"                   :   "[BUS] You're driving. Please stop the bus."
    "job.bus.gototakemoney"             :   "[BUS] Leave the bus and take your money near central entrance."
    "job.bus.nicejob"                   :   "[BUS] Nice job! You earned $%.2f"
    "job.bus.needcorrectpark"           :   "[BUS] Park the bus correctly."

    "job.bus.help.title"            :   "Controls for bus driver:"
    "job.bus.help.job"              :   "E button"
    "job.bus.help.jobtext"          :   "Get bus driver job at bus depot in Uptown"
    "job.bus.help.jobleave"         :   "Q button"
    "job.bus.help.jobleavetext"     :   "Leave bus driver job at bus depot in Uptown"
    "job.bus.help.busstop"          :   "E button"
    "job.bus.help.busstoptext"      :   "Bus stop"

    "job.bus.route.1"                   :   "Uptown - Sand Island Route (7 station)"
    "job.bus.route.2"                   :   "Uptown - Kingston Route  (7 station)"
    "job.bus.route.3"                   :   "Right bank of Culver River Route (9 station)"
    "job.bus.route.4"                   :   "Central Circle Route (12 station)"
    "job.bus.route.5"                   :   "Big Empire Bay Route (21 station)"
});

event("onServerStarted", function() {
    log("[jobs] loading busdriver job...");

    createPlace("LittleItalyWaypoint",  -215.876, 625.305, -221.062, 650.786);
    createPlace("WestSideWaypoint",  -536.377, -126.749, -561.389, -142.504);
    createPlace("SandIslandWaypoint",  -1552.11, -238.172, -1537.36, -215.447);

    createVehicle(20, -436.205, 417.33, 0.908799, 45.8896, -0.100647, 0.237746);
    createVehicle(20, -436.652, 427.656, 0.907598, 44.6088, -0.0841779, 0.205202);
    createVehicle(20, -437.04, 438.027, 0.907163, 45.1754, -0.100916, 0.242581);
    //createVehicle(20, -410.198, 493.193, -0.21792, 180.0, -3.80509, -0.228946);

    //createVehicle(20, -426.371, 410.698, 0.742629, 90.2978, -3.42313, 0.371656);
    //createVehicle(20, -412.107, 410.674, -0.0407671, 89.4833, -3.28604, 1.37194);

  //busStops[0]   <-  busStop("NAME",                                              public ST                                   private
    busStops[1]   <-  busStop("Uptown (path #1)",                 busv3( -400.996,   476.106,  -1.01301 ),   busv3( -404.360,   488.435,   -0.568764 ), 0);
    busStops[2]   <-  busStop("Uptown (path #2)",                 busv3( -400.996,   444.081,  -1.05144 ),   busv3( -404.360,   441.001,   -0.566925 ), 0);
    busStops[3]   <-  busStop("Uptown (path #3)",                 busv3( -419.423,   444.183, 0.0254459 ),   busv3( -423.116,   441.001,    0.132165 ), 0);
    busStops[4]   <-  busStop("Uptown (path #4)",                 busv3( -373.499,   468.245, - 1.27469 ),   busv3(  -376.67,   471.245,   -0.944843 ), 0);
    busStops[5]   <-  busStop("West Side",                        busv3( -474.538,   7.72202,  -1.33022 ),   busv3( -471.471,   10.2396,     -1.4627 ), 180);
    busStops[6]   <-  busStop("Midtown",                          busv3( -428.483,  -303.189,  -11.7407 ),   busv3( -431.421,  -299.824,    -11.8258 ), 90);
    busStops[7]   <-  busStop("SouthPort",                        busv3( -137.196,  -475.182,  -15.2725 ),   busv3( -140.946,   -472.49,    -15.4755 ), 90);
    busStops[8]   <-  busStop("Oyster Bay",                       busv3(  299.087,  -311.669,  -20.162  ),   busv3(  296.348,  -315.252,    -20.3024 ), 0);
    busStops[9]   <-  busStop("Chinatown",                        busv3(  277.134,   359.335,  -21.535  ),   busv3(  274.361,   355.601,    -21.6772 ), 0);
    busStops[10]  <-  busStop("Little Italy (East)",              busv3(   477.92,   733.942,  -21.2513 ),   busv3(  475.215,   736.735,    -21.3909 ), 90);
    busStops[11]  <-  busStop("Millville North (west platform)",  busv3(  691.839,   873.923,  -11.9926 ),   busv3(   688.59,   873.993,    -12.2225 ), 0);
    busStops[12]  <-  busStop("Millville North (east platform)",  busv3(  697.743,   873.697,  -11.9925 ),   busv3(  701.126,   873.666,    -11.8061 ), 180);
    busStops[13]  <-  busStop("Little Italy (East-West)",         busv3(  162.136,   835.064,  -19.6378 ),   busv3(  164.963,   832.472,    -19.7743 ), -90);
    busStops[14]  <-  busStop("Little Italy (Diamond Motors)",    busv3( -173.266,   724.155,  -20.4991 ),   busv3( -170.596,   727.372,    -20.6562 ), 180);
    busStops[15]  <-  busStop("East Side",                        busv3( -104.387,   377.106,  -13.9932 ),   busv3( -101.08,    374.001,    -14.1311 ), -90);
    busStops[16]  <-  busStop("Dipton",                           busv3( -582.427,   1604.64,  -16.4354 ),   busv3( -579.006,   1601.32,    -16.1774 ), -90); // Dipton1
    busStops[17]  <-  busStop("Dipton",                           busv3( -568.004,   1580.03,  -16.7092 ),   busv3( -571.569,   1582.89,    -16.1666 ), 90); // Dipton2
    busStops[18]  <-  busStop("Kingston",                         busv3( -1151.38,   1486.28,  -3.42484 ),   busv3( -1147.42,   1483.27,    -3.03844 ), -90); // Kingston1
    busStops[19]  <-  busStop("Kingston",                         busv3( -1063.9,    1457.63,  -3.97645 ),   busv3( -1067.98,    1460.7,    -3.57558 ), 90); // Kingston2
    busStops[20]  <-  busStop("Greenfield",                       busv3( -1669.57,   1089.86,  -6.95323 ),   busv3( -1667.56,   1094.36,    -6.71022 ), 163); // Greenfield1
    busStops[21]  <-  busStop("Greenfield",                       busv3( -1612.92,    996.92,  -5.90228 ),   busv3( -1615.41,   992.857,    -5.58949 ), -10); // Greenfield2
    busStops[22]  <-  busStop("Sand Island",                      busv3( -1601.16,   -190.15,  -20.3354 ),   busv3( -1597.43,  -193.281,    -19.9776 ), -90);
    busStops[23]  <-  busStop("Sand Island (North)",              busv3( -1559.15,   109.576,  -13.2876 ),   busv3(  -1562.2,    105.64,    -13.0085 ), 0);
    busStops[24]  <-  busStop("Hunters Point",                    busv3( -1344.5,    421.815,  -23.7303 ),   busv3( -1347.92,    418.11,    -23.4532 ), 0);
    busStops[25]  <-  busStop("Little Italy (South-North)",       busv3( 131.681,    789.366,  -19.3316 ),   busv3(  128.864,   787.641,    -19.0034 ), 0);
    busStops[26]  <-  busStop("Uptown (path #1)",                 busv3( 131.681,    789.366,  -19.3316 ),   busv3(  -397.527,    469.4,   -0.919742 ), 180);


    busStops[97]  <-  busStop("Sand Island",                      busv3( 0.0, 0.0, 0.0 ),                    busv3(  -1541.81, -231.531, -20.3354   ), null); // waypoint
    busStops[98]  <-  busStop("Little Italy (South-North)",       busv3( 0.0, 0.0, 0.0 ),                    busv3(  -70.9254, 638.342, -20.237     ), null); // waypoint
    busStops[99]  <-  busStop("Midtown",                          busv3( 0.0, 0.0, 0.0 ),                    busv3(  -530.473, -292.407, -10.0177   ), null); // waypoint


  //routes[0] <- [zarplata, [stop1, stop2, stop3, ..., stop562]];
    routes[1] <- [9.5, [1, 5, 99, 6, 97, 22, 23, 24, 26]]; //sand island
    routes[2] <- [9.5, [2, 21, 19, 17, 14, 15, 2]]; //
    routes[3] <- [14, [4, 98, 25, 16, 18, 20, 22, 23, 24, 21, 19, 17, 14, 15, 4]];
    routes[4] <- [19, [3, 5, 99, 6, 7, 8, 9, 10, 11, 13, 14, 15, 3]];
    routes[5] <- [26, [4, 5, 99, 6, 7, 8, 9, 10, 12, 13, 16, 18, 20, 22, 23, 24, 21, 19, 17, 14, 15, 4]];

    //creating 3dtext for bus depot
    create3DText ( BUS_JOB_X, BUS_JOB_Y, BUS_JOB_Z+0.35, "ROADKING BUS DEPOT", CL_ROYALBLUE );
    create3DText ( BUS_JOB_X, BUS_JOB_Y, BUS_JOB_Z+0.20, "Press E to action", CL_WHITE.applyAlpha(150), RADIUS_BUS );

    //creating public 3dtext
    foreach (idx, value in busStops) {
        if (idx < 90 && idx != 26) {
            create3DText ( value.public.x, value.public.y, value.public.z+0.35, "=== BUS STOP ===", CL_ROYALBLUE );
            create3DText ( value.public.x, value.public.y, value.public.z-0.15, value.name, CL_WHITE.applyAlpha(150) );
        }
    }

    registerPersonalJobBlip("busdriver", BUS_JOB_X, BUS_JOB_Y);

});


key("e", function(playerid) {
    busJobGet( playerid );
    busJobStop( playerid );
}, KEY_UP);

key("q", function(playerid) {
    busJobRefuseLeave( playerid );
}, KEY_UP);


event("onPlayerConnect", function(playerid) {
    if ( ! (getPlayerName(playerid) in job_bus) ) {
     job_bus[getPlayerName(playerid)] <- {};
     job_bus[getPlayerName(playerid)]["route"] <- false;
     job_bus[getPlayerName(playerid)]["userstatus"] <- null;
     job_bus[getPlayerName(playerid)]["bus3dtext"] <- [ null, null ];
     job_bus[getPlayerName(playerid)]["busBlip"] <- null;
    }
});


event("onServerPlayerStarted", function( playerid ){

    if(isBusDriver(playerid)) {
        if (job_bus[getPlayerName(playerid)]["userstatus"] == "working") {
            local busID = job_bus[getPlayerName(playerid)]["route"][1][0];
            if (busID < 90 ) job_bus[getPlayerName(playerid)]["bus3dtext"] = createPrivateBusStop3DText(playerid, busStops[busID].private);
            trigger(playerid, "setGPS", busStops[busID].private.x, busStops[busID].private.y);
            trigger(playerid, "hudDestroyTimer");
            msg( playerid, "job.bus.continuebusstop", busStops[busID].name, BUS_JOB_COLOR );
        } else {
            msg( playerid, "job.bus.ifyouwantstart", BUS_JOB_COLOR );
        }
        createText (playerid, "leavejob3dtext", BUS_JOB_X, BUS_JOB_Y, BUS_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_BUS_SMALL );
    }
});

event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
    if (!isPlayerVehicleBus(playerid)) {
        return;
    }

    if(isBusDriver(playerid) && job_bus[getPlayerName(playerid)]["userstatus"] == "working") {
        unblockVehicle(vehicleid);
        //delayedFunction(4500, function() {
            //busJobReady(playerid);
        //});
    } else {
        blockVehicle(vehicleid);
    }
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (!isPlayerVehicleBus(playerid)) {
        return;
    }

    blockVehicle(vehicleid);
});

event("onServerHourChange", function() {
    BUS_ROUTE_NOW = BUS_ROUTE_IN_HOUR + random(-2, 1);
});

function busStop(a, b, c, d) {
    return {name = a, public = b, private = c, rotation = d };
}

function busv3(a, b, c) {
    return {x = a.tofloat(), y = b.tofloat(), z = c.tofloat() };
}


/**
 * Create private 3DTEXT for current bus stop
 * @param  {int}  playerid
 * @return {array} [idtext1, id3dtext2]
 */
function createPrivateBusStop3DText(playerid, busstop) {
    return [
        createPrivate3DText (playerid, busstop.x, busstop.y, busstop.z+0.35, BUS_JOB_BUSSTOP, CL_RIPELEMON, BUS_JOB_DISTANCE ),
        createPrivate3DText (playerid, busstop.x, busstop.y, busstop.z-0.15, "Press E", CL_WHITE.applyAlpha(150), 5 )
    ];
}

/**
 * Remove private 3DTEXT AND BLIP for current bus stop
 * @param  {int}  playerid
 */
function busJobRemovePrivateBlipText ( playerid ) {
    if(job_bus[getPlayerName(playerid)]["bus3dtext"][0] != null) {
        remove3DText ( job_bus[getPlayerName(playerid)]["bus3dtext"][0] );
        remove3DText ( job_bus[getPlayerName(playerid)]["bus3dtext"][1] );
    }
    if (job_bus[getPlayerName(playerid)]["busBlip"] != null) {
        removeBlip ( job_bus[getPlayerName(playerid)]["busBlip"] );
    }
}

/**
 * Check is player is a busdriver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isBusDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "busdriver"));
}

/**
 * Check is player's vehicle is a bus
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleBus(playerid) {
    return (isPlayerInValidVehicle(playerid, 20));
}

/**
 * Check is route selected
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isBusRouteSelected(playerid) {
    return (job_bus[getPlayerName(playerid)]["route"] != false) ? true : false;
}

/**
 * Check is BusReady
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isBusReady(playerid) {
    return job_bus[getPlayerName(playerid)]["busready"];
}


// working good, check
function busJobGet( playerid ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return;
    }

/*
    if(isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.already", BUS_JOB_COLOR );
    }

    // если у игрока недостаточный уровень
    if(!isPlayerLevelValid ( playerid, BUS_JOB_LEVEL )) {
        return msg(playerid, "job.bus.needlevel", BUS_JOB_LEVEL, BUS_JOB_COLOR );
    }
*/
    // если у игрока статус работы == null
    if(job_bus[getPlayerName(playerid)]["userstatus"] == null) {

        if(!isPlayerHaveJob(playerid)) {

            local hour = getHour();
            if(hour < BUS_JOB_GET_HOUR_START || hour >= BUS_JOB_GET_HOUR_END) {
                return msg( playerid, "job.closed", [ BUS_JOB_GET_HOUR_START.tostring(), BUS_JOB_GET_HOUR_END.tostring()], BUS_JOB_COLOR );
            }

            if(isPlayerHaveJob(playerid) && !isBusDriver(playerid)) {
                return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), BUS_JOB_COLOR );
            }

            if (getPlayerName(playerid) in job_bus_blocked) {
                if (getTimestamp() - job_bus_blocked[getPlayerName(playerid)] < BUS_JOB_TIMEOUT) {
                    return msg( playerid, "job.bus.badworker", BUS_JOB_COLOR);
                }
            }

            msg( playerid, "job.bus.driver.now", BUS_JOB_COLOR );
            setPlayerJob( playerid, "busdriver");
            screenFadeinFadeoutEx(playerid, 250, 200, function() {
                setPlayerModel( playerid, BUS_JOB_SKIN );
            });
        }

        busJobStartRoute( playerid );
        createText (playerid, "leavejob3dtext", BUS_JOB_X, BUS_JOB_Y, BUS_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_BUS_SMALL );

        return;
    }

    // если у игрока статус работы == выполняет работу
    if (job_bus[getPlayerName(playerid)]["userstatus"] == "working") {
        return msg( playerid, "job.bus.route.needcomplete", BUS_JOB_COLOR );
    }
    // если у игрока статус работы == завершил работу
    if (job_bus[getPlayerName(playerid)]["userstatus"] == "complete") {
        job_bus[getPlayerName(playerid)]["userstatus"] = null;
        busGetSalary( playerid );
        job_bus[getPlayerName(playerid)]["route"] = false;
        return;
    }

}


function busJobRefuseLeave( playerid ) {
    if(!isBusDriver(playerid)) {
        return;
    }

    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS_SMALL)) {
        return;
    }

    local hour = getHour();
    if(hour < BUS_JOB_LEAVE_HOUR_START || hour >= BUS_JOB_LEAVE_HOUR_END) {
        return msg( playerid, "job.closed", [ BUS_JOB_LEAVE_HOUR_START.tostring(), BUS_JOB_LEAVE_HOUR_END.tostring()], BUS_JOB_COLOR );
    }

    if(job_bus[getPlayerName(playerid)]["userstatus"] == null) {
        msg( playerid, "job.bus.goodluck", BUS_JOB_COLOR);
    }

    if (job_bus[getPlayerName(playerid)]["userstatus"] == "working") {
        msg( playerid, "job.bus.badworker.onleave", BUS_JOB_COLOR);
        job_bus_blocked[getPlayerName(playerid)] <- getTimestamp();
        job_bus[getPlayerName(playerid)]["userstatus"] = null;
        busJobRemovePrivateBlipText( playerid );
    }

    if (job_bus[getPlayerName(playerid)]["userstatus"] == "complete") {
        job_bus[getPlayerName(playerid)]["userstatus"] = null;
        busGetSalary( playerid );
        job_bus[getPlayerName(playerid)]["route"] = false;
        msg( playerid, "job.bus.goodluck", BUS_JOB_COLOR);
    }

    removeText ( playerid, "leavejob3dtext" );
    trigger(playerid, "removeGPS");

    screenFadeinFadeoutEx(playerid, 250, 200, function() {

        msg( playerid, "job.leave", BUS_JOB_COLOR );

        setPlayerJob( playerid, null );
        restorePlayerModel(playerid);

        // remove private blip job
        removePersonalJobBlip ( playerid );
    });

}


function busGetSalary( playerid ) {
    local amount = job_bus[getPlayerName(playerid)]["route"][0];
    addMoneyToPlayer(playerid, amount);
    msg( playerid, "job.bus.nicejob", amount, BUS_JOB_COLOR );
}

// working good, check
function busJobStartRoute( playerid ) {

    local hour = getHour();
    if(hour < BUS_JOB_WORKING_HOUR_START || hour >= BUS_JOB_WORKING_HOUR_END) {
        return msg( playerid, "job.closed", [ BUS_JOB_WORKING_HOUR_START.tostring(), BUS_JOB_WORKING_HOUR_END.tostring()], TRUCK_JOB_COLOR );
    }

    if(BUS_ROUTE_NOW < 1) {
        return msg( playerid, "job.nojob", BUS_JOB_COLOR );
    }

    local route = random(1, 5);

    job_bus[getPlayerName(playerid)]["route"] <- [routes[route][0], clone routes[route][1]]; //create clone of route
    msg( playerid, "job.bus.route.your", [route, plocalize(playerid, "job.bus.route."+route) ], BUS_JOB_COLOR  );


// Your route is #2 - . Sit into bus.
// plocalize(playerid, "job.bus.route."+route)

    job_bus[getPlayerName(playerid)]["userstatus"] = "working";

    local busID = job_bus[getPlayerName(playerid)]["route"][1][0];

    msg( playerid, "job.bus.startroute", busStops[busID].name, BUS_JOB_COLOR );
    if (busID < 90 ) job_bus[getPlayerName(playerid)]["bus3dtext"] = createPrivateBusStop3DText(playerid, busStops[busID].private);
    trigger(playerid, "setGPS", busStops[busID].private.x, busStops[busID].private.y);
    //job_bus[getPlayerName(playerid)]["busBlip"]   = createPrivateBlip(playerid, busStops[busID].private.x, busStops[busID].private.y, ICON_YELLOW, 4000.0);   надо вырезать
    //local gpsPos = busStops[busID].private;
    //trigger(playerid, "setGPS", gpsPos.x, gpsPos.y);
}

// working good, check
// coords bus at bus station in Sand Island    -1597.05, -193.64, -19.9622, -89.79, 0.235025, 3.47667
// coords bus at bus station in Hunters Point    -1562.5, 105.709, -13.0123, 0.966663, -0.00153991, 0.182542
function busJobStop( playerid ) {

    if(job_bus[getPlayerName(playerid)]["userstatus"] != "working" || !isPlayerInVehicle(playerid) || !isPlayerVehicleBus(playerid) ) {
        return;
    }

    if(!isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.not", BUS_JOB_COLOR );
    }

    if (!isPlayerVehicleBus(playerid)) {
        return msg(playerid, "job.bus.needbus", BUS_JOB_COLOR );
    }

    local busID = job_bus[getPlayerName(playerid)]["route"][1][0];

    if(!isPlayerVehicleInValidPoint(playerid, busStops[busID].private.x, busStops[busID].private.y, 5.0 )) {
        return/* msg( playerid, "job.bus.gotobusstop", busStops[busID].name, BUS_JOB_COLOR )*/;
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.bus.driving", CL_RED );
    }

    local vehicleid = getPlayerVehicle(playerid);
    if(busStops[busID].rotation != null) {
        local vehRot = getVehicleRotation(vehicleid);
        local offset = fabs(vehRot[0] - busStops[busID].rotation);
        if (offset > 3) {
            return msg(playerid, "job.bus.needcorrectpark", CL_RED );
        }
    }

    setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);

    busJobRemovePrivateBlipText( playerid );
    trigger(playerid, "removeGPS");
    trigger(playerid, "hudDestroyTimer");

    job_bus[getPlayerName(playerid)]["route"][1].remove(0);

    freezePlayer( playerid, true);
    local vehFuel = getVehicleFuel( vehicleid );
    setVehicleFuel( vehicleid, 0.0 );
    msg( playerid, "job.bus.waitpasses", BUS_JOB_COLOR );

    trigger(playerid, "hudCreateTimer", 14.0, true, true);
    delayedFunction(14000, function () {
        freezePlayer( playerid, false);
        delayedFunction(1000, function () { freezePlayer( playerid, false); });
        setVehicleFuel( vehicleid, vehFuel );
        if (job_bus[getPlayerName(playerid)]["route"][1].len() == 0) {
            msg( playerid, "job.bus.gototakemoney", BUS_JOB_COLOR );
            blockVehicle(vehicleid);
            job_bus[getPlayerName(playerid)]["userstatus"] = "complete";
            return;
        }

        local busID = job_bus[getPlayerName(playerid)]["route"][1][0];

        if (busID < 90 ) job_bus[getPlayerName(playerid)]["bus3dtext"] = createPrivateBusStop3DText(playerid, busStops[busID].private);
        //job_bus[getPlayerName(playerid)]["busBlip"]   = createPrivateBlip(playerid, busStops[busID].private.x, busStops[busID].private.y, ICON_YELLOW, 2000.0);
        //job_bus[getPlayerName(playerid)]["busBlip"]   = playerid+"blip"; //надо вырезать

        trigger(playerid, "setGPS", busStops[busID].private.x, busStops[busID].private.y);
        msg( playerid, "job.bus.gotonextbusstop", busStops[busID].name, BUS_JOB_COLOR );
        //local gpsPos = busStops[busID].private;
        //trigger(playerid, "setGPS", gpsPos.x, gpsPos.y);
    });

}

event("onPlayerPlaceEnter", function(playerid, name) {
    if (isBusDriver(playerid) && isPlayerVehicleBus(playerid) && job_bus[getPlayerName(playerid)]["userstatus"] == "working") {
        if((name == "LittleItalyWaypoint" && job_bus[getPlayerName(playerid)]["route"][1][0] == 98) || (name == "WestSideWaypoint" && job_bus[getPlayerName(playerid)]["route"][1][0] == 99) || (name == "SandIslandWaypoint" && job_bus[getPlayerName(playerid)]["route"][1][0] == 97)) {
            trigger(playerid, "removeGPS");
            job_bus[getPlayerName(playerid)]["route"][1].remove(0);
            local busID = job_bus[getPlayerName(playerid)]["route"][1][0];
            trigger(playerid, "setGPS", busStops[busID].private.x, busStops[busID].private.y);
            job_bus[getPlayerName(playerid)]["bus3dtext"] = createPrivateBusStop3DText(playerid, busStops[busID].private);
        }
    }
});


event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (isBusDriver(playerid) && getVehicleModel(vehicleid) == 20 && job_bus[getPlayerName(playerid)]["userstatus"] == "complete") {
        delayedFunction(14000, function () {
            tryRespawnVehicleById(vehicleid, true);
        });
    }
});



// don't touch and don't replace. Service command for fast test!
acmd("gotobusstop", function(playerid) {
    local busid = job_bus[getPlayerName(playerid)]["route"][1][0];
    local poss = busStops[busid].private;
    setVehiclePosition( getPlayerVehicle(playerid), poss.x, poss.y, poss.z );
    busJobStop( playerid );
});

acmd("buscomplete", function(playerid) {
    job_bus[getPlayerName(playerid)]["userstatus"] = "complete";
});

