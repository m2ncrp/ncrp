include("controllers/player/commands.nut");

players <- {};

addEventHandler("onPlayerConnect", function(playerid, name, ip, serial ) {
     players[playerid] <- {};
     players[playerid]["job"] <- null;
     players[playerid]["money"] <- 0;
});
