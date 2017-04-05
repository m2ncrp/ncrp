local distanceCounter = {};

event("onServerStarted", function() {
    log("[module] distance counter...");
});


event("onPlayerConnect", function(playerid) {
    if ( ! (getPlayerName(playerid) in distanceCounter) ) {
        distanceCounter[getPlayerName(playerid)] <- {};
        distanceCounter[getPlayerName(playerid)]["status"] <- "stop";
        distanceCounter[getPlayerName(playerid)]["counter"] <- null;
    }
});


function countDistance (playerid, vx = null, vy = null, vz = null) {
    if (!isPlayerConnected(playerid) || distanceCounter[getPlayerName(playerid)]["status"] != "play") {
        return;
    }

    local vehicleid = getPlayerVehicle(playerid);

    local posOld = null;
    if (vx != null) {
        posOld = [vx, vy, vz];
    } else {
        if(vehicleid > 1) {
            posOld = getVehiclePosition(vehicleid);
        } else {
            posOld = getPlayerPosition(playerid);
        }
    }

    local posNew = null;
    if(vehicleid > 1) {
        posNew = getVehiclePosition(vehicleid);
    } else {
        posNew = getPlayerPosition(playerid);
    }



    local dis = getDistanceBetweenPoints3D( posOld[0], posOld[1], posOld[2], posNew[0], posNew[1], posNew[2] );
    distanceCounter[getPlayerName(playerid)]["counter"] += dis;


    delayedFunction(3500, function(){
        countDistance (playerid, posNew[0], posNew[1], posNew[2]);
    });
}


function distanceStartCounter(playerid) {
    if(distanceCounter[getPlayerName(playerid)]["status"] == "stop" ) {
        distanceCounter[getPlayerName(playerid)]["counter"] = 0;
    }
    distanceCounter[getPlayerName(playerid)]["status"] = "play";
    countDistance(playerid);
}

function distanceStopCounter(playerid) {
    distanceCounter[getPlayerName(playerid)]["status"] = "stop";
    distanceCounter[getPlayerName(playerid)]["counter"] = null;
    countDistance(playerid);
}

function distancePauseCounter(playerid) {
    distanceCounter[getPlayerName(playerid)]["status"] = "pause";
    countDistance(playerid);
}

function isDistanceCounterStarted(playerid) {
    return (distanceCounter[getPlayerName(playerid)]["status"] != "stop") ? true : false;
}


acmd("ta", function(playerid) {
    msg(playerid, "Distance Counter has been started.")
    distanceStartCounter(playerid);
});

acmd("tb", function(playerid) {
    msg(playerid, "Distance: "+distanceCounter[getPlayerName(playerid)]["counter"]);
    distanceStopCounter(playerid);

});
