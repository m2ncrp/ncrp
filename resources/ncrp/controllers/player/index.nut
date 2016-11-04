include("controllers/player/commands.nut");

players <- {};

addEventHandler("onPlayerConnect", function(playerid, name, ip, serial ) {
     players[playerid] <- {};
     players[playerid]["job"] <- null;
     players[playerid]["money"] <- 13.37;
     players[playerid]["skin"] <- 10;
     players[playerid]["request"] <- {}; // need for invoice to transfer money

     players[playerid]["taxi"] <- {};
     players[playerid]["taxi"]["call_address"] <- false; // Address from which was caused by a taxi
     players[playerid]["taxi"]["call_state"] <- false; // Address from which was caused by a taxi
});
