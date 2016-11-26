cmd(["dig"], function(playerid) {
    if ( isHobos(playerid) && !isTimeToDig(playerid) ) {
        return msg( playerid, "organizations.hobos.tired" );
    }
    if ( isHobos(playerid) && isNearTrash(playerid) ) {
        local found = randomf(minCouldFind, maxCouldFind);
        found = round( found, 2);
        addMoneyToPlayer(playerid, found );
        msg( playerid, "organizations.hobos.trash.found", [found, getPlayerBalance(playerid)] );
        players[playerid]["digtime"] <- getTimestamp();
    }
});
