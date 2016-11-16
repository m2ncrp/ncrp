include("controllers/player/commands.nut");
include("controllers/player/PlayerList.nut");
include("controllers/player/functions.nut");

players <- {};
playerList <- null;

default_spawns <- [
    [-555.251,  1702.31, -22.2408], // railway
    [ 100.421,  1776.41, -24.0068], // bomj style
    [-402.282, -828.907, -21.7456]  // port
];

addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial) {
    // probably should be at player registration once, not on every spawn
    local res = random(0,3);

    players[playerid] <- {};
    players[playerid]["job"] <- null;
    players[playerid]["money"] <- 1.75;
    players[playerid]["default_skin"] <- 10;
    players[playerid]["skin"] <- 10;
    players[playerid]["request"] <- {}; // need for invoice to transfer money

    playerList.addPlayer(playerid, name, ip, serial);
});

addEventHandler("onPlayerDisconnect", function(playerid, reason) {
    playerList.delPlayer(playerid);
});

addEventHandler("onPlayerSpawn", function(playerid) {
    setPlayerPosition(playerid, -567.499, 1531.58, -15.8716);
    setPlayerHealth(playerid, 730.0);
});

addEventHandler("onPlayerDeath", function(playerid, killerid) {
    if (killerid != INVALID_ENTITY_ID) {
        sendPlayerMessageToAll("~ " + getPlayerName(playerid) + " has been killed by " + getPlayerName(killerid) + ".", 255, 204, 0);
    } else {
        sendPlayerMessageToAll("~ " + getPlayerName(playerid) + " has died.", 255, 204, 0 );
    }
});
