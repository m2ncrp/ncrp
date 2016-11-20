cmd(["dig"], function(playerid) {
    if ( isHobos(playerid) && !isTimeToDig(playerid) ) {
        return msg( playerid, "You get tired. Take a nap" );
    }
    if ( isHobos(playerid) && isNearTrash(playerid) ) {
        local found = randomf(minCouldFind, maxCouldFind);
        found = round( found, 2);
        addMoneyToPlayer(playerid, found );
        msg( playerid, "You found $" + found + ". Now you can buy yourself cookies with $"+ getPlayerBalance(playerid) +". Cookies! Om-nom-nom!");
        players[playerid]["digtime"] <- getTimestamp();
    }
});
