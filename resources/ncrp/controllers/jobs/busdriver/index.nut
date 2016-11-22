include("controllers/jobs/busdriver/commands.nut");

local job_bus = {};
jobtext <- {};
jobtext["letsgo"] <- "asdasdasdad";


const RADIUS_BUS = 1.0;
const BUS_JOB_X = -421.738;
const BUS_JOB_Y = 479.321;
const BUS_JOB_Z = 0.0500296;
const BUS_JOB_SKIN = 171;
const BUS_JOB_BUSSTOP = "STOP HERE (middle of the bus)";
const BUS_JOB_DISTANCE = 100;

local busstops = [
    ["Go to first bus station in Uptown near platform #3", -423.116, 440.924, 0.132165],
    ["Go to bus stop in West Side", -471.471, 10.2396, -1.4627],
    ["Go to bus stop in Midtown", -431.421, -299.824, -11.8258],
    ["Go to bus stop in SouthPort", -140.946, -472.49, -15.4755],
    ["Go to bus stop in Oyster Bay", 296.348, -315.252, -20.3024],
    ["Go to bus stop in Chinatown", 274.361, 355.601, -21.6772],
    ["Go to bus stop in Little Italy (East)", 475.215, 736.735, -21.3909],
    ["Go to bus station in Millville North (west platform)", 688.59, 873.993, -12.2225],
    ["Go to bus stop in Little Italy (Central)", 164.963, 832.472, -19.7743],
    ["Go to bus stop in Little Italy (Diamond Motors)", -170.596, 727.372, -20.6562],
    ["Go to bus stop in East Side", -101.08, 374.001, -14.1311],
    ["Go to bus station in Uptown near platform #3", -423.116, 440.924, 0.132165]
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

addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading bus driver job...");
    createVehicle(20, -436.205, 417.33, 0.908799, 45.8896, -0.100647, 0.237746);
    createVehicle(20, -436.652, 427.656, 0.907598, 44.6088, -0.0841779, 0.205202);
    createVehicle(20, -437.04, 438.027, 0.907163, 45.1754, -0.100916, 0.242581);
    createVehicle(20, -410.198, 493.193, -0.21792, -179.657, -3.80509, -0.228946);

    create3DText ( BUS_JOB_X, BUS_JOB_Y, 0.35, "ROADKING BUS DEPOT", CL_ROYALBLUE );
    create3DText ( BUS_JOB_X, BUS_JOB_Y, -0.15, "/help job bus", CL_WHITE.applyAlpha(75) );

    foreach (idx, value in userbusstop) {
        create3DText ( value[0], value[1], value[2]+0.35, "BUS STOP", CL_ROYALBLUE );
        create3DText ( value[0], value[1], value[2]-0.15, value[3], CL_WHITE.applyAlpha(150) );
    }
});

addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial ){
     job_bus[playerid] <- {};
     job_bus[playerid]["nextbusstop"] <- null;
     job_bus[playerid]["busready"] <- false;
     job_bus[playerid]["bus3dtext1"] <- false;
     job_bus[playerid]["bus3dtext2"] <- false;
});




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
        return msg( playerid, "Let's go to bus station in Uptown (central door of the building)." );
    }
    if(isBusDriver(playerid)) {
        return msg( playerid, "You're busdriver already.");
    }

    if(isPlayerHaveJob(playerid)) {
        return msg(playerid, "You already have a job: " + getPlayerJob(playerid) + ".");
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "You're a bus driver now! Congratulations!" );
        msg( playerid, "Sit into bus." );

        players[playerid]["job"] = "busdriver";

        players[playerid]["skin"] = BUS_JOB_SKIN;
        setPlayerModel( playerid, BUS_JOB_SKIN );
    });
}

// working good, check
function busJobLeave( playerid ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return msg( playerid, "Let's go to bus station in Uptown (central door of the building)." );
    }
    if(!isBusDriver(playerid)) {
        return msg( playerid, "You're not a bus driver");
    } else {
         msg( playerid, "You leave this job." );

         players[playerid]["job"] = null;

         players[playerid]["skin"] = players[playerid]["default_skin"];
         setPlayerModel( playerid, players[playerid]["default_skin"]);
    }
}


function busJobRoutes( playerid ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return msg( playerid, "Let's go to bus station in Uptown (central door of the building)." );
    }
    if(!isBusDriver(playerid)) {
        return msg( playerid, "You're not a bus driver");
    }

    local title = "List of available routes:";
    local commands = [
        { name = "#3",        desc = "Central Circle Route" }
    ];
    msg_help(playerid, title, commands);
}


// working good, check
function busJobReady( playerid ) {
    if(!isBusDriver(playerid)) {
        return msg( playerid, "You're not a bus driver");
    }

    if (!isPlayerVehicleBus(playerid)) {
        return msg(playerid, "You need a bus.");
    }

    if (isBusReady(playerid)) {
        return msg(playerid, "You're ready already.");
    }

    job_bus[playerid]["busready"] = true;
    msg( playerid, busstops[0][0] );
    job_bus[playerid]["nextbusstop"] = 0;
    job_bus[playerid]["bus3dtext1"] = createPrivate3DText (playerid, busstops[0][1], busstops[0][2], busstops[0][3]+0.35, BUS_JOB_BUSSTOP, CL_RIPELEMON, BUS_JOB_DISTANCE );
    job_bus[playerid]["bus3dtext2"] = createPrivate3DText (playerid, busstops[0][1], busstops[0][2], busstops[0][3]-0.15, "/bus stop", CL_RIPELEMON );
}

// working good, check
// coords bus at bus station in Sand Island    -1597.05, -193.64, -19.9622,-89.79, 0.235025, 3.47667
// coords bus at bus station in Hunters Point    -1562.5, 105.709, -13.0123, 0.966663, -0.00153991, 0.182542
function busJobStop( playerid ) {
    if(!isBusDriver(playerid)) {
        return msg( playerid, "You're not a bus driver");
    }

    if (!isPlayerVehicleBus(playerid)) {
        return msg(playerid, "You need a bus.");
    }

    if (!isBusReady(playerid)) {
        return msg( playerid, "You aren't ready." );
    }

    local i = job_bus[playerid]["nextbusstop"];

    if(!isVehicleInValidPoint(playerid, busstops[i][1], busstops[i][2], 5.0 )) {
        return msg( playerid, busstops[i][0]);
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "You're driving. Please stop the bus.");
    }

    remove3DText ( job_bus[playerid]["bus3dtext1"] );
    remove3DText ( job_bus[playerid]["bus3dtext2"] );
    job_bus[playerid]["nextbusstop"] += 1;
    job_bus[playerid]["bus3dtext1"] = createPrivate3DText (playerid, busstops[i+1][1], busstops[i+1][2], busstops[i+1][3]+0.35, BUS_JOB_BUSSTOP, CL_RIPELEMON, BUS_JOB_DISTANCE );
    job_bus[playerid]["bus3dtext2"] = createPrivate3DText (playerid, busstops[i+1][1], busstops[i+1][2], busstops[i+1][3]+1.15, "/bus stop", CL_RIPELEMON );

        if (busstops.len() == job_bus[playerid]["nextbusstop"]) {
            sendPlayerMessage( playerid, "Nice job! You earned $10." );
            job_bus[playerid]["busready"] = false;
            addMoneyToPlayer(playerid, 10);
            return;
        }

    sendPlayerMessage( playerid, "Good! " + busstops[i+1][0] );
}
