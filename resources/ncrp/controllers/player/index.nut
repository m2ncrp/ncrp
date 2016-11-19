include("controllers/player/commands.nut");
include("controllers/player/PlayerList.nut");
include("controllers/player/functions.nut");

players <- {};
xPlayers <- {};
playerList <- null;

default_spawns <- [
    [-555.251,  1702.31, -22.2408], // railway
    [-11.2921,  1631.85, -20.0296], // tmp bomj spawn
    // [ 100.421,  1776.41, -24.0068], // bomj style
    [-402.282, -828.907, -21.7456]  // port
];
local spawns = 2; // number-1

addEventHandlerEx("onPlayerInit", function(playerid, name, ip, serial) {
    Character.findOneBy({ name = getPlayerName(playerid) }, function(err, char) {
        if (err || !char) {
            // create entity
            char = Character();

            // setup deafults
            char.name    = getPlayerName(playerid);
            char.spawnid = random(0, spawns);
            char.money   = 1.75;
            char.dskin   = 10;
            char.cskin   = 10;

            // save first-time created entity
            char.save();
        }

        xPlayers[playerid] <- char;

        // legacy data binding
        // @deprecated
        playerList.addPlayer(playerid, name, ip, serial);
        players[playerid]                 <- {};
        players[playerid]["request"]      <- {}; // need for invoice to transfer money
        players[playerid]["job"]          <- (char.job.len() > 0) ? char.job : null;
        players[playerid]["money"]        <- char.money;
        players[playerid]["default_skin"] <- char.dskin;
        players[playerid]["skin"]         <- char.cskin;
        players[playerid]["spawn"]        <- char.spawnid;
        players[playerid]["xp"]           <- char.xp;
        players[playerid]["housex"]       <- char.housex;
        players[playerid]["housey"]       <- char.housey;
        players[playerid]["housez"]       <- char.housez;

        triggerServerEventEx("onPlayerConnect", playerid, name, ip, serial);
    });
});

function trySavePlayer(playerid) {
    if (!(playerid in players) || !(playerid in xPlayers)) {
        return null;
    }

    // get instance
    local char   = xPlayers[playerid];

    // proxy data back to the model
    char.money   = players[playerid]["money"];
    char.dskin   = players[playerid]["default_skin"];
    char.cskin   = players[playerid]["skin"];
    char.spawnid = players[playerid]["spawn"];
    char.xp      = players[playerid]["xp"];
    char.housex  = players[playerid]["housex"];
    char.housey  = players[playerid]["housey"];
    char.housez  = players[playerid]["housez"];
    char.job     = (players[playerid]["job"]) ? players[playerid]["job"] : "";

    // save it
    char.save();
}

addEventHandler("onPlayerDisconnect", function(playerid, reason) {
    // save player after disconnect
    trySavePlayer(playerid);
    playerList.delPlayer(playerid);
});

addEventHandlerEx("onServerAutosave", function() {
    foreach (playerid, char in players) {
        trySavePlayer(playerid);
    }
});

addEventHandler("onPlayerSpawn", function(playerid) {
    local spawnID = players[playerid]["spawn"];
    local x = default_spawns[spawnID][0];
    local y = default_spawns[spawnID][1];
    local z = default_spawns[spawnID][2];
    setPlayerPosition(playerid, x, y, z);
    // setPlayerPosition(playerid, -567.499, 1531.58, -15.8716);
    setPlayerHealth(playerid, 730.0);
});

addEventHandler("onPlayerDeath", function(playerid, killerid) {
    if (killerid != INVALID_ENTITY_ID) {
        sendPlayerMessageToAll("~ " + getPlayerName(playerid) + " has been killed by " + getPlayerName(killerid) + ".", 255, 204, 0);
    } else {
        sendPlayerMessageToAll("~ " + getPlayerName(playerid) + " has died.", 255, 204, 0 );
    }
});
