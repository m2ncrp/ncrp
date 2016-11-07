include("controllers/jobs/busdriver/commands.nut");

local job_bus = {};

const RADIUS_BUS = 1.0;
const BUS_JOB_X = -422.731;
const BUS_JOB_Y = 479.462;

addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading bus driver job...");
    createVehicle(20, -436.205, 417.33, 0.908799, 45.8896, -0.100647, 0.237746);
    createVehicle(20, -436.652, 427.656, 0.907598, 44.6088, -0.0841779, 0.205202);
    createVehicle(20, -437.04, 438.027, 0.907163, 45.1754, -0.100916, 0.242581);
    createVehicle(20, -410.198, 493.193, -0.21792, -179.657, -3.80509, -0.228946);
});

addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial ){
     job_bus[playerid] <- {};
     job_bus[playerid]["nextbusstop"] <- null;
     job_bus[playerid]["busready"] <- false;
});

local busstops = [
    ["Go to first bus station in Uptown near platform #3", -423.116, 440.924],
    ["Go to bus stop in West Side", -471.471, 10.2396],
    ["Go to bus stop in Midtown", -431.421, -299.824],
    ["Go to bus stop in SouthPort", -140.946, -472.49],
    ["Go to bus stop in Oyster Bay", 296.348, -315.252],
    ["Go to bus stop in Chinatown", 274.361, 355.601],
    ["Go to bus stop in East Little Italy", 475.215, 736.735],
    ["Go to bus station in Millville North (west platform)", 688.59, 873.993],
    ["Go to bus stop in Central Little Italy", 164.963, 832.472],
    ["Go to bus stop in Little Italy (Diamond Motors)", -170.596, 727.372],
    ["Go to bus stop in East Side", -101.08, 374.001],
    ["Go to bus station in Uptown near platform #3", -423.116, 440.924]
];


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
        return msg( playerid, jobphrases["letsgo"] );
    }
    if(isBusDriver(playerid)) {
        return msg( playerid, "You're busdriver already.");
    }

    if(isPlayerHaveJob(playerid)) {
        return msg(playerid, "You already have a job: " + getPlayerJob(playerid) + ".");
    }

    msg( playerid, "You're a bus driver now! Congratulations!" );
    //msg( playerid, "Sit into bus." );
    setPlayerModel( playerid, 171 );
    players[playerid]["job"] = "busdriver";
    msg( playerid, "Sit into bus." );
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
         setPlayerModel( playerid, 10 );
         players[playerid]["job"] = null;
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

        job_bus[playerid]["nextbusstop"] += 1;
        if (busstops.len() == job_bus[playerid]["nextbusstop"]) {
            sendPlayerMessage( playerid, "Nice job! You earned $10." );
            job_bus[playerid]["busready"] = false;
            addMoneyToPlayer(playerid, 10);
            return;
        }
    sendPlayerMessage( playerid, "Good! " + busstops[i+1][0] );
}
