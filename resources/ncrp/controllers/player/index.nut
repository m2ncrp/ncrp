include("controllers/player/commands.nut");

players <- {};

addEventHandler("onPlayerConnect", function(playerid, name, ip, serial ) {
     players[playerid] <- {};
     players[playerid]["job"] <- null;
     players[playerid]["money"] <- 13.37;
     players[playerid]["skin"] <- 10;
     players[playerid]["request"] <- {}; // need for invoice to transfer money
});
