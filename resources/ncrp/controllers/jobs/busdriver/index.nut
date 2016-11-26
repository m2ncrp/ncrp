include("controllers/jobs/busdriver/commands.nut");

local job_bus = {};
local busStops = {};
local routes = {};

const RADIUS_BUS = 2.0;
const BUS_JOB_X = -422.731;
const BUS_JOB_Y = 479.372;
const BUS_JOB_Z = 0.10922;
const BUS_JOB_SKIN = 171;
const BUS_JOB_BUSSTOP = "STOP HERE (middle of the bus)";
const BUS_JOB_DISTANCE = 100;

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
addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading bus driver job...");
    createVehicle(20, -436.205, 417.33, 0.908799, 45.8896, -0.100647, 0.237746);
    createVehicle(20, -436.652, 427.656, 0.907598, 44.6088, -0.0841779, 0.205202);
    createVehicle(20, -437.04, 438.027, 0.907163, 45.1754, -0.100916, 0.242581);
    createVehicle(20, -410.198, 493.193, -0.21792, -179.657, -3.80509, -0.228946);

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
    busStops[16]  <-  busStop("Dipton1",                          busv3( -582.427,   1604.64,  -16.4354 ),   busv3( -579.006,   1601.32,    -16.1774 ));
    busStops[17]  <-  busStop("Dipton2",                          busv3( -568.004,   1580.03,  -16.7092 ),   busv3( -571.569,   1582.89,    -16.1666 ));
    busStops[18]  <-  busStop("Kingston1",                        busv3( -1151.38,   1486.28,  -3.42484 ),   busv3( -1147.42,   1483.27,    -3.03844 ));
    busStops[19]  <-  busStop("Kingston2",                        busv3( -1063.9,    1457.63,  -3.97645 ),   busv3( -1067.98,    1460.7,    -3.57558 ));
    busStops[20]  <-  busStop("Greenfield1",                      busv3( -1669.57,   1089.86,  -6.95323 ),   busv3( -1667.56,   1094.36,    -6.71022 ));
    busStops[21]  <-  busStop("Greenfield2",                      busv3( -1612.92,    996.92,  -5.90228 ),   busv3( -1615.41,   992.857,    -5.58949 ));
    busStops[22]  <-  busStop("Sand Island",                      busv3( -1601.16,   -190.15,  -20.3354 ),   busv3( -1597.43,  -193.281,    -19.9776 ));
    busStops[23]  <-  busStop("Sand Island (North)",              busv3( -1559.15,   109.576,  -13.2876 ),   busv3(  -1562.2,    105.64,    -13.0085 ));
    busStops[24]  <-  busStop("Hunters Point",                    busv3( -1344.5,    421.815,  -23.7303 ),   busv3( -1347.92,    418.11,    -23.4532 ));

  //routes[0] <- [zarplata, [stop1, stop2, stop3, ..., stop562]];
    routes[1] <- [10, [1, 5, 6, 22, 23, 24, 1]]; //sand island
    routes[2] <- [10, [2, 21, 19, 17, 14, 15, 2]]; //
    routes[3] <- [15, [16, 18, 20, 22, 23, 24, 21, 19, 17]];
    routes[4] <- [20, [3, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 3]];
    routes[5] <- [30, [4, 5, 6, 7, 8, 9, 10, 12, 13, 16, 18, 20, 22, 23, 24, 21, 19, 17, 14, 15, 4]];

    //creating 3dtext for bus depot
    create3DText ( BUS_JOB_X, BUS_JOB_Y, BUS_JOB_Z+0.35, "ROADKING BUS DEPOT", CL_ROYALBLUE );
    create3DText ( BUS_JOB_X, BUS_JOB_Y, BUS_JOB_Z+0.20, "/help job bus", CL_WHITE.applyAlpha(75), 3 );

    //creating public 3dtext
    foreach (idx, value in busStops) {
        create3DText ( value.public.x, value.public.y, value.public.z+0.35, "=== BUS STOP ===", CL_ROYALBLUE );
        create3DText ( value.public.x, value.public.y, value.public.z-0.15, value.name, CL_WHITE.applyAlpha(150) );
    }

    registerPersonalJobBlip("busdriver", BUS_JOB_X, BUS_JOB_Y);

});

addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial ){
     job_bus[playerid] <- {};
     job_bus[playerid]["busready"] <- false;
     job_bus[playerid]["route"] <- false;
     job_bus[playerid]["bus3dtext"] <- [ null, null ];
     job_bus[playerid]["busBlip"] <- null;
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
        return msg( playerid, "job.bus.letsgo" );
    }
    if(isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.already");
    }

    if(isPlayerHaveJob(playerid)) {
        return msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid) );
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.bus.driver.now" );

        players[playerid]["job"] = "busdriver";

        players[playerid]["skin"] = BUS_JOB_SKIN;
        setPlayerModel( playerid, BUS_JOB_SKIN );

        // create private blip job
        createPersonalJobBlip( playerid, BUS_JOB_X, BUS_JOB_Y);

        busJobRoutes( playerid );
    });
}

// working good, check
function busJobLeave( playerid ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return msg( playerid, "job.bus.letsgo" );
    }
    if(!isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.not");
    } else {
        screenFadeinFadeoutEx(playerid, 250, 200, function() {
            msg( playerid, "job.leave" );

            players[playerid]["job"] = null;

            players[playerid]["skin"] = players[playerid]["default_skin"];
            setPlayerModel( playerid, players[playerid]["default_skin"]);

            busJobRemovePrivateBlipText( playerid );

            // remove private blip job
            removePersonalJobBlip ( playerid );
        });
    }
}


function busJobRoutes( playerid ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return msg( playerid, "job.bus.letsgo" );
    }
    if(!isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.not");
    }

    local title = "job.bus.route.select";
    local commands = [
        { name = "#1",  desc = "Uptown - Sand Island Route (7 station)." },
        { name = "#2",  desc = "Uptown - Kingston Route  (7 station)" },
        { name = "#3",  desc = "Right bank of Culver River Route (9 station)" },
        { name = "#4",  desc = "Central Circle Route (12 station)" },
        { name = "#5",  desc = "Big Empire Bay Route (21 station)" }
    ];
    msg_help(playerid, title, commands);
}

function busJobSelectRoute( playerid, route ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return msg( playerid, "job.bus.letsgo" );
    }
    if(!isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.not");
    }

    if (isBusReady(playerid)) {
        return msg(playerid, "job.bus.route.needcomplete");
    }

    job_bus[playerid]["route"] <- [routes[route.tointeger()][0], clone routes[route.tointeger()][1]]; //create clone of route
    msg( playerid, "job.bus.route.selected", route );
}


// working good, check
function busJobReady( playerid ) {
    if(!isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.not");
    }

    if (!isPlayerVehicleBus(playerid)) {
        return msg(playerid, "job.bus.needbus");
    }

    if (!isBusRouteSelected(playerid)) {
        return msg(playerid, "job.bus.route.needselect");
    }

    if (isBusReady(playerid)) {
        return msg(playerid, "job.bus.readyalready");
    }

    job_bus[playerid]["busready"] = true;
    local busID = job_bus[playerid]["route"][1][0];
    msg( playerid, "job.bus.gotobusstop", busStops[busID].name);
    job_bus[playerid]["bus3dtext"] = createPrivateBusStop3DText(playerid, busStops[busID].private);
    job_bus[playerid]["busBlip"]   = createPrivateBlip(playerid, busStops[busID].private.x, busStops[busID].private.y, ICON_RED, 2000.0);
}

// working good, check
// coords bus at bus station in Sand Island    -1597.05, -193.64, -19.9622, -89.79, 0.235025, 3.47667
// coords bus at bus station in Hunters Point    -1562.5, 105.709, -13.0123, 0.966663, -0.00153991, 0.182542
function busJobStop( playerid ) {
    if(!isBusDriver(playerid)) {
        return msg( playerid, "job.bus.driver.not");
    }

    if (!isPlayerVehicleBus(playerid)) {
        return msg(playerid, "job.bus.needbus");
    }

    if (!isBusRouteSelected(playerid)) {
        return msg(playerid, "job.bus.route.needselect");
    }

    if (!isBusReady(playerid)) {
        return msg( playerid, "job.bus.notready" );
    }

    local busID = job_bus[playerid]["route"][1][0];

    if(!isPlayerVehicleInValidPoint(playerid, busStops[busID].private.x, busStops[busID].private.y, 5.0 )) {
        return msg( playerid, "job.bus.gotobusstop", busStops[busID].name);
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.bus.driving");
    }

    busJobRemovePrivateBlipText( playerid );

    job_bus[playerid]["route"][1].remove(0);

        if (job_bus[playerid]["route"][1].len() == 0) {
            local busZP = job_bus[playerid]["route"][0];
            msg( playerid, "job.bus.nicejob", busZP);
            job_bus[playerid]["route"] = false;
            job_bus[playerid]["busready"] = false;
            local route = job_bus[playerid]["route"]
            addMoneyToPlayer(playerid, busZP);
            return;
        }

    local busID = job_bus[playerid]["route"][1][0];

    job_bus[playerid]["bus3dtext"] = createPrivateBusStop3DText(playerid, busStops[busID].private);
    job_bus[playerid]["busBlip"]   = createPrivateBlip(playerid, busStops[busID].private.x, busStops[busID].private.y, ICON_RED, 2000.0);

    msg( playerid, "job.bus.gotonextbusstop", busStops[busID].name );
}

// don't touch and don't replace. Service command for fast test!
cmd("gotobusstop", function(playerid) {
    local busid = job_bus[playerid]["route"][1][0];
    local poss = busStops[busid].private;
    setVehiclePosition( getPlayerVehicle(playerid), poss.x, poss.y, poss.z );
    busJobStop( playerid );
});
