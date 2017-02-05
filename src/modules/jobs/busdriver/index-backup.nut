include("modules/jobs/busdriver/commands.nut");

local job_bus = {};
local busStops = {};
local routes = {};
local carp = false;

const RADIUS_BUS = 2.0;
const BUS_JOB_X = -422.731;
const BUS_JOB_Y = 479.372;
const BUS_JOB_Z = 0.10922;
const BUS_JOB_SKIN = 171;
const BUS_JOB_BUSSTOP = "STOP HERE (middle of the bus)";
const BUS_JOB_DISTANCE = 100;
const BUS_JOB_LEVEL = 1;
      BUS_JOB_COLOR <- CL_CRUSTA;

/*
local busstops = [
    ["Go to first bus station in Uptown near platform #3",          -423.116, 440.924, 0.132165],
    ["Go to bus stop in West Side",                                 -471.471, 10.2396, -1.4627],
    ["Go to bus stop in Midtown",                                   -431.421, -299.824, -11.8258],
    ["Go to bus stop in SouthPort",                                 -140.946, -472.49, -15.4755],
    ["Go to bus stop in Oyster Bay",                                296.348, -315.252, -20.3024],
    ["Go to bus stop in Chinatown",                                 274.361, 355.601, -21.6772],
    ["Go to bus stop in Little Italy (East)",                       475.215, 736.735, -21.3909],
    ["Go to bus station in Millville North (west platform)",        688.59, 873.993, -12.2225],
    ["Go to bus stop in Little Italy (Central)",                    164.963, 832.472, -19.7743],
    ["Go to bus stop in Little Italy (Diamond Motors)",             -170.596, 727.372, -20.6562],
    ["Go to bus stop in East Side",                                 -101.08, 374.001, -14.1311],
    ["Go to bus station in Uptown near platform #3",                -423.116, 440.924, 0.132165]
];

local userbusstop = [
    [-419.707, 444.016, 0.0456606, "Uptown. Platform #3"             ],  // busst0
    [-474.538, 7.72202,  -1.33022, "West Side"                       ],  // busst1
    [-428.483, -303.189, -11.7407, "Midtown"                         ],  // busst2
    [-137.196, -475.182, -15.2725, "SouthPort"                       ],  // busst3
    [299.087, -311.669,   -20.162, "Oyster Bay"                      ],  // busst4
    [277.134, 359.335,    -21.535, "Chinatown"                       ],  // busst5
    [477.92, 733.942,    -21.2513, "Little Italy (East)"             ],  // busst6
    [691.839, 873.923,   -11.9926, "Millville North (west platform)" ],  // busst7
    [162.136, 835.064,   -19.6378, "Little Italy (Central)"          ],  // busst8
    [-173.266, 724.155,  -20.4991, "Little Italy (Diamond Motors)"   ],  // busst9
    [-104.387, 377.106,  -13.9932, "East Side"                       ]   // busst10
];
*/

translation("en", {
    "job.busdriver"                     :   "bus driver"
    "job.bus.letsgo"                    :   "[BUS] Let's go to bus station in Uptown."
    "job.bus.needlevel"                 :   "[BUS] You need level %d to become bus driver."
    "job.bus.driver.not"                :   "[BUS] You're not a bus driver."
    "job.bus.driver.already"            :   "[BUS] You're bus driver already."
    "job.bus.driver.now"                :   "[BUS] You're a bus driver now! Congratulations!"
    "job.bus.ifyouwantstart"            :   "[BUS] You're bus driver. If you want to start route - select route at bus station."
    "job.bus.route.needselect"          :   "[BUS] You need to select route."
    "job.bus.route.tochange"            :   "[BUS] To select route use /bus route id"
    "job.bus.route.noexist"             :   "[BUS] Selected route doesn't exist. Select available route."
    "job.bus.route.selected"            :   "[BUS] You selected route #%d. Sit into bus."
    "job.bus.route.needcontinue"        :   "[BUS] Continue current route."
    "job.bus.route.needcomplete"        :   "[BUS] Complete current route."
    "job.bus.needbus"                   :   "[BUS] You need a bus."
    "job.bus.notready"                  :   "[BUS] You aren't ready. Please, report that you are ready via /bus ready."
    "job.bus.readyalready"              :   "[BUS] You're ready already."
    "job.bus.gotonextbusstop"           :   "[BUS] Good! Go to next bus stop in %s."
    "job.bus.gotobusstop"               :   "[BUS] Go to bus stop in %s."
    "job.bus.driving"                   :   "[BUS] You're driving. Please stop the bus."
    "job.bus.nicejob"                   :   "[BUS] Nice job! You earned $%.2f"

    "job.bus.help.title"                :   "List of available commands for BUS DRIVER JOB:"
    "job.bus.help.job"                  :   "Get bus driver job"
    "job.bus.help.jobleave"             :   "Leave bus driver job"
    "job.bus.help.routelist"            :   "Show list of available routes"
    "job.bus.help.route"                :   "Select route. Example: /bus route 3"
    "job.bus.help.ready"                :   "Go to the route (make the bus ready)"
    "job.bus.help.busstop"              :   "Check in at the bus stop"

    "job.bus.route.select"              :   "Select one route from available routes:"
    "job.bus.route.1"                   :   "Uptown - Sand Island Route (7 station)."
    "job.bus.route.2"                   :   "Uptown - Kingston Route  (7 station)."
    "job.bus.route.3"                   :   "Right bank of Culver River Route (9 station)."
    "job.bus.route.4"                   :   "Central Circle Route (12 station)."
    "job.bus.route.5"                   :   "Big Empire Bay Route (21 station)."
});

event("onServerStarted", function() {
    log("[jobs] loading busdriver job...");
    createVehicle(20, -436.205, 417.33, 0.908799, 45.8896, -0.100647, 0.237746);
    createVehicle(20, -436.652, 427.656, 0.907598, 44.6088, -0.0841779, 0.205202);
    createVehicle(20, -437.04, 438.027, 0.907163, 45.1754, -0.100916, 0.242581);
    createVehicle(20, -410.198, 493.193, -0.21792, -179.657, -3.80509, -0.228946);
    createVehicle(20, -426.371, 410.698, 0.742629, 90.2978, -3.42313, 0.371656);
    createVehicle(20, -412.107, 410.674, -0.0407671, 89.4833, -3.28604, 1.37194);

    createVehicle(27, -1559.61, -297.071, -20.0909, -0.0439384, 0.275704, 0.537192); //Bronevik Sand Island

    carp = createVehicle(42, -1559.61, -296.908, -20.0912, -0.0724972, 0.000332189, 0.525066); // police Sand Island


  //busStops[0]   <-  busStop("NAME",                                              public ST                                   private
    busStops[1]   <-  busStop("Uptown. Platform #1",              busv3( -400.996,   490.847,  -1.01301 ),   busv3( -404.360,   488.435,   -0.568764 ));
    busStops[2]   <-  busStop("Uptown. Platform #2",              busv3( -400.996,   444.081,  -1.05144 ),   busv3( -404.360,   441.001,   -0.566925 ));
    busStops[3]   <-  busStop("Uptown. Platform #3",              busv3( -419.423,   444.183, 0.0254459 ),   busv3( -423.116,   441.001,    0.132165 ));
    busStops[4]   <-  busStop("Uptown. Platform #4",              busv3( -373.499,   468.245, - 1.27469 ),   busv3(  -376.67,   471.245,   -0.944843 ));
    busStops[5]   <-  busStop("West Side",                        busv3( -474.538,   7.72202,  -1.33022 ),   busv3( -471.471,   10.2396,     -1.4627 ));
    busStops[6]   <-  busStop("Midtown",                          busv3( -428.483,  -303.189,  -11.7407 ),   busv3( -431.421,  -299.824,    -11.8258 ));
    busStops[7]   <-  busStop("SouthPort",                        busv3( -137.196,  -475.182,  -15.2725 ),   busv3( -140.946,   -472.49,    -15.4755 ));
    busStops[8]   <-  busStop("Oyster Bay",                       busv3(  299.087,  -311.669,  -20.162  ),   busv3(  296.348,  -315.252,    -20.3024 ));
    busStops[9]   <-  busStop("Chinatown",                        busv3(  277.134,   359.335,  -21.535  ),   busv3(  274.361,   355.601,    -21.6772 ));
    busStops[10]  <-  busStop("Little Italy (East)",              busv3(   477.92,   733.942,  -21.2513 ),   busv3(  475.215,   736.735,    -21.3909 ));
    busStops[11]  <-  busStop("Millville North (west platform)",  busv3(  691.839,   873.923,  -11.9926 ),   busv3(   688.59,   873.993,    -12.2225 ));
    busStops[12]  <-  busStop("Millville North (east platform)",  busv3(  697.743,   873.697,  -11.9925 ),   busv3(  701.126,   873.666,    -11.8061 ));
    busStops[13]  <-  busStop("Little Italy (Central)",           busv3(  162.136,   835.064,  -19.6378 ),   busv3(  164.963,   832.472,    -19.7743 ));
    busStops[14]  <-  busStop("Little Italy (Diamond Motors)",    busv3( -173.266,   724.155,  -20.4991 ),   busv3( -170.596,   727.372,    -20.6562 ));
    busStops[15]  <-  busStop("East Side",                        busv3( -104.387,   377.106,  -13.9932 ),   busv3( -101.08,    374.001,    -14.1311 ));
    busStops[16]  <-  busStop("Dipton",                           busv3( -582.427,   1604.64,  -16.4354 ),   busv3( -579.006,   1601.32,    -16.1774 )); // Dipton1
    busStops[17]  <-  busStop("Dipton",                           busv3( -568.004,   1580.03,  -16.7092 ),   busv3( -571.569,   1582.89,    -16.1666 )); // Dipton2
    busStops[18]  <-  busStop("Kingston",                         busv3( -1151.38,   1486.28,  -3.42484 ),   busv3( -1147.42,   1483.27,    -3.03844 )); // Kingston1
    busStops[19]  <-  busStop("Kingston",                         busv3( -1063.9,    1457.63,  -3.97645 ),   busv3( -1067.98,    1460.7,    -3.57558 )); // Kingston2
    busStops[20]  <-  busStop("Greenfield",                       busv3( -1669.57,   1089.86,  -6.95323 ),   busv3( -1667.56,   1094.36,    -6.71022 )); // Greenfield1
    busStops[21]  <-  busStop("Greenfield",                       busv3( -1612.92,    996.92,  -5.90228 ),   busv3( -1615.41,   992.857,    -5.58949 )); // Greenfield2
    busStops[22]  <-  busStop("Sand Island",                      busv3( -1601.16,   -190.15,  -20.3354 ),   busv3( -1597.43,  -193.281,    -19.9776 ));
    busStops[23]  <-  busStop("Sand Island (North)",              busv3( -1559.15,   109.576,  -13.2876 ),   busv3(  -1562.2,    105.64,    -13.0085 ));
    busStops[24]  <-  busStop("Hunters Point",                    busv3( -1344.5,    421.815,  -23.7303 ),   busv3( -1347.92,    418.11,    -23.4532 ));

  //routes[0] <- [zarplata, [stop1, stop2, stop3, ..., stop562]];
    routes[1] <- [12, [1, 5, 6, 22, 23, 24, 1]]; //sand island
    routes[2] <- [12, [2, 21, 19, 17, 14, 15, 2]]; //
    routes[3] <- [17, [16, 18, 20, 22, 23, 24, 21, 19, 17]];
    routes[4] <- [24, [3, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 3]];
    routes[5] <- [38, [4, 5, 6, 7, 8, 9, 10, 12, 13, 16, 18, 20, 22, 23, 24, 21, 19, 17, 14, 15, 4]];

    //creating 3dtext for bus depot
    create3DText ( BUS_JOB_X, BUS_JOB_Y, BUS_JOB_Z+0.35, "ROADKING BUS DEPOT", CL_ROYALBLUE );
    create3DText ( BUS_JOB_X, BUS_JOB_Y, BUS_JOB_Z+0.20, "/help job bus", CL_WHITE.applyAlpha(75), 3.0 );

    //creating public 3dtext
    foreach (idx, value in busStops) {
        create3DText ( value.public.x, value.public.y, value.public.z+0.35, "=== BUS STOP ===", CL_ROYALBLUE );
        create3DText ( value.public.x, value.public.y, value.public.z-0.15, value.name, CL_WHITE.applyAlpha(150) );
    }

    registerPersonalJobBlip("busdriver", BUS_JOB_X, BUS_JOB_Y);

});


event("onPlayerSpawn", function(playerid) {
    setVehicleBeaconLightState(carp, true);
});


event("onPlayerConnect", function(playerid) {
     job_bus[playerid] <- {};
     job_bus[playerid]["busready"] <- false;
     job_bus[playerid]["route"] <- false;
     job_bus[playerid]["bus3dtext"] <- [ null, null ];
     job_bus[playerid]["busBlip"] <- null;
});

event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
    if (!isPlayerVehicleBus(playerid)) {
        return;
    }

    if(isBusDriver(playerid)) {
        unblockVehicle(vehicleid);
        delayedFunction(4500, function() {
            busJobReady(playerid);
        });
    } else {
        blockVehicle(vehicleid);
    }
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    blockVehicle(vehicleid);
});

function busStop(a, b, c) {
    return {name = a, public = b, private = c };
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
        createPrivate3DText (playerid, busstop.x, busstop.y, busstop.z-0.15, "/bus stop", CL_WHITE.applyAlpha(150), 5 )
    ];
}

/**
 * Remove private 3DTEXT AND BLIP for current bus stop
 * @param  {int}  playerid
 */
function busJobRemovePrivateBlipText ( playerid ) {
    if(job_bus[playerid]["bus3dtext"][0] != null) {
        remove3DText ( job_bus[playerid]["bus3dtext"][0] );
        remove3DText ( job_bus[playerid]["bus3dtext"][1] );
    }
    if (job_bus[playerid]["busBlip"] != null) {
        removeBlip ( job_bus[playerid]["busBlip"] );
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
    return (job_bus[playerid]["route"] != false) ? true : false;
}

/**
 * Check is BusReady
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isBusReady(playerid) {
    return job_bus[playerid]["busready"];
}

// working good, check
function busJob( playerid ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return msg( playerid, "job.bus.letsgo", BUS_JOB_COLOR );
    }
    if(isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.already", BUS_JOB_COLOR );
    }

    if(isPlayerHaveJob(playerid)) {
        return msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), BUS_JOB_COLOR );
    }

    if(!isPlayerLevelValid ( playerid, BUS_JOB_LEVEL )) {
        return msg(playerid, "job.bus.needlevel", BUS_JOB_LEVEL, BUS_JOB_COLOR );
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.bus.driver.now", BUS_JOB_COLOR );

        setPlayerJob( playerid, "busdriver" );
        setPlayerModel( playerid, BUS_JOB_SKIN );

        // create private blip job
        //createPersonalJobBlip( playerid, BUS_JOB_X, BUS_JOB_Y);

        busJobRoutes( playerid );
    });
}

// working good, check
function busJobLeave( playerid ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return msg( playerid, "job.bus.letsgo", BUS_JOB_COLOR );
    }
    if(!isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.not", BUS_JOB_COLOR );
    } else {
        screenFadeinFadeoutEx(playerid, 250, 200, function() {
            msg( playerid, "job.leave", BUS_JOB_COLOR );

            setPlayerJob( playerid, null );

            job_bus[playerid]["busready"] = false;
            restorePlayerModel(playerid);

            busJobRemovePrivateBlipText( playerid );

            // remove private blip job
            removePersonalJobBlip ( playerid );
        });
    }
}


function busJobRoutes( playerid ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return msg( playerid, "job.bus.letsgo", BUS_JOB_COLOR );
    }
    if(!isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.not", BUS_JOB_COLOR );
    }

    local title = "job.bus.route.select";
    local commands = [
        { name = "#1",  desc = "job.bus.route.1" },
        { name = "#2",  desc = "job.bus.route.2" },
        { name = "#3",  desc = "job.bus.route.3" },
        { name = "#4",  desc = "job.bus.route.4" },
        { name = "#5",  desc = "job.bus.route.5" }
    ];
    msg_help(playerid, title, commands);
    msg( playerid, "job.bus.route.tochange", BUS_JOB_COLOR );
}

function busJobSelectRoute( playerid, route = null) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return msg( playerid, "job.bus.letsgo", BUS_JOB_COLOR );
    }
    if(!isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.not", BUS_JOB_COLOR );
    }

    if (isBusReady(playerid)) {
        return msg(playerid, "job.bus.route.needcomplete", BUS_JOB_COLOR );
    }

    if (route == null) {
        return msg(playerid, "job.bus.route.needselect", BUS_JOB_COLOR );
    }

    local route = route.tointeger();
    if (route < 1 || route > 5) {
        return msg(playerid, "job.bus.route.noexist", BUS_JOB_COLOR );
    }

    job_bus[playerid]["route"] <- [routes[route][0], clone routes[route][1]]; //create clone of route
    msg( playerid, "job.bus.route.selected", route, BUS_JOB_COLOR  );
}


// working good, check
function busJobReady( playerid ) {
    if(!isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.not", BUS_JOB_COLOR );
    }

    if (!isPlayerVehicleBus(playerid) && !isBusRouteSelected(playerid)) {
        //return msg(playerid, "job.bus.ifyouwantstart", BUS_JOB_COLOR );
        return;
    }

    if (!isPlayerVehicleBus(playerid) && isBusRouteSelected(playerid)) {
        return msg(playerid, "job.bus.needbus", BUS_JOB_COLOR );
    }

    if (isPlayerVehicleBus(playerid) && !isBusRouteSelected(playerid)) {
        return msg(playerid, "job.bus.route.needselect", BUS_JOB_COLOR );
    }

    if (isBusReady(playerid)) {
        return msg(playerid, "job.bus.route.needcontinue", BUS_JOB_COLOR );
    }

    job_bus[playerid]["busready"] = true;
    local busID = job_bus[playerid]["route"][1][0];
    msg( playerid, "job.bus.gotobusstop", busStops[busID].name, BUS_JOB_COLOR );
    job_bus[playerid]["bus3dtext"] = createPrivateBusStop3DText(playerid, busStops[busID].private);
    job_bus[playerid]["busBlip"]   = createPrivateBlip(playerid, busStops[busID].private.x, busStops[busID].private.y, ICON_YELLOW, 4000.0);
}

// working good, check
// coords bus at bus station in Sand Island    -1597.05, -193.64, -19.9622, -89.79, 0.235025, 3.47667
// coords bus at bus station in Hunters Point    -1562.5, 105.709, -13.0123, 0.966663, -0.00153991, 0.182542
function busJobStop( playerid ) {
    if(!isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.not", BUS_JOB_COLOR );
    }

    if (!isPlayerVehicleBus(playerid)) {
        return msg(playerid, "job.bus.needbus", BUS_JOB_COLOR );
    }

    if (!isBusRouteSelected(playerid)) {
        return msg(playerid, "job.bus.route.needselect", BUS_JOB_COLOR );
    }

    if (!isBusReady(playerid)) {
        return msg( playerid, "job.bus.notready", BUS_JOB_COLOR );
    }

    local busID = job_bus[playerid]["route"][1][0];

    if(!isPlayerVehicleInValidPoint(playerid, busStops[busID].private.x, busStops[busID].private.y, 5.0 )) {
        return msg( playerid, "job.bus.gotobusstop", busStops[busID].name, BUS_JOB_COLOR );
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.bus.driving", CL_RED );
    }

    busJobRemovePrivateBlipText( playerid );

    job_bus[playerid]["route"][1].remove(0);

        if (job_bus[playerid]["route"][1].len() == 0) {
            local busZP = job_bus[playerid]["route"][0];
            msg( playerid, "job.bus.nicejob", busZP, BUS_JOB_COLOR );
            job_bus[playerid]["route"] = false;
            job_bus[playerid]["busready"] = false;
            local route = job_bus[playerid]["route"]
            addMoneyToPlayer(playerid, busZP);
            return;
        }

    local busID = job_bus[playerid]["route"][1][0];

    job_bus[playerid]["bus3dtext"] = createPrivateBusStop3DText(playerid, busStops[busID].private);
    job_bus[playerid]["busBlip"]   = createPrivateBlip(playerid, busStops[busID].private.x, busStops[busID].private.y, ICON_YELLOW, 2000.0);

    msg( playerid, "job.bus.gotonextbusstop", busStops[busID].name, BUS_JOB_COLOR );
}

// don't touch and don't replace. Service command for fast test!
acmd("gotobusstop", function(playerid) {
    local busid = job_bus[playerid]["route"][1][0];
    local poss = busStops[busid].private;
    setVehiclePosition( getPlayerVehicle(playerid), poss.x, poss.y, poss.z );
    busJobStop( playerid );
});