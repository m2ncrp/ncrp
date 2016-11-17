cmd(["dig"], function(playerid) {
    if ( isHobos(playerid) && isNearTrash(playerid) ) {
        local found = round( randomf(minCouldFind, maxCouldFind), 2);
        addMoneyToPlayer(playerid, found);
        msg( playerid, "You found $" + found + ". Now you can buy yourself cookies with $"+ getPlayerBalance(playerid) +". Cookies! Om-nom-nom!");
    }
});
