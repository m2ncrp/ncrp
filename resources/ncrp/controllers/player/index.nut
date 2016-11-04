include("controllers/player/commands.nut");
include("controllers/player/PlayerList.nut");

players <- {};
playerList <- null;

addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial) {
    players[playerid] <- {};
    players[playerid]["job"] <- null;
    players[playerid]["money"] <- 13.37;
    players[playerid]["skin"] <- 10;
    players[playerid]["request"] <- {}; // need for invoice to transfer money

    players[playerid]["taxi"] <- {};
    players[playerid]["taxi"]["call_address"] <- false; // Address from which was caused by a taxi
    players[playerid]["taxi"]["call_state"] <- false; // Address from which was caused by a taxi

    playerList.addPlayer(playerid, name, ip, serial);
});

addEventHandler("onPlayerDisconnect", function(playerid, reason) {
    playerList.delPlayer(playerid);
});

addEventHandler("onPlayerSpawn", function(playerid) {
    setPlayerPosition(playerid, -567.499, 1531.58, -15.8716);
    setPlayerHealth(playerid, 720.0);
});

addEventHandler("onPlayerDeath", function(playerid, killerid) {
    if (killerid != INVALID_ENTITY_ID) {
        sendPlayerMessageToAll("~ " + getPlayerName(playerid) + " has been killed by " + getPlayerName(killerid) + ".", 255, 204, 0);
    } else {
        sendPlayerMessageToAll("~ " + getPlayerName(playerid) + " has died.", 255, 204, 0 );
    }
});
