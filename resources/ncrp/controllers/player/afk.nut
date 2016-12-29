local afkPlayers = {};

event("onServerPlayerStarted", function(playerid) {
    afkPlayers[playerid] <- false;
});

function setPlayerAfk(playerid, state) {
    afkPlayers[playerid] <- state;
}

function isPlayerAfk(playerid) {
    return (playerid in afkPlayers && afkPlayers[playerid]);
}

