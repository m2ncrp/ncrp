addCommandHandler("money", function(playerid) {
    sendPlayerMessage( playerid, "Your balance: $" + players[playerid]["money"]);
});
