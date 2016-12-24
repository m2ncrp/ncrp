local hoboses = {};


function hobosDig(playerid) {
    if ( !isTimeToDig(playerid) ) { // isHobos(playerid) && 
        return msg( playerid, "organizations.hobos.tired" );
    }
    if ( isNearTrash(playerid) ) { // isHobos(playerid) &&
        local found = randomf(minCouldFind, maxCouldFind);
        found = round( found, 2);
        addMoneyToPlayer(playerid, found );
        msg( playerid, "organizations.hobos.trash.found", [found, getPlayerBalance(playerid)] );

        if (!(playerid in hoboses)) {
            hoboses[playerid] <- {};
        }
        hoboses[playerid].digtime <- getTimestamp();
    }
}

cmd(["dig"], hobosDig);
key("e", function(playerid) {
    if (!isNearTrash()) {
        return;
    }

    hobosDig(playerid);
});

function isHobos(playerid) {
    return players[playerid]["spawn"] == hobos_spawnID;
}

function isNearTrash(playerid) {
    foreach (point in hobos_points) {
        if ( isInRadius(playerid, point[0], point[1], point[2], DIG_RADIUS) ) {
            return true;
        }
    }
    msg(playerid, "organizations.hobos.trash.toofar", [], CL_YELLOW);
    return false;
}


function isTimeToDig(playerid) {
    if (!(playerid in hoboses)) {
        return true;
    }

    if (getTimestamp() > (hoboses[playerid].digtime + DIG_TIME_DELAY)) {
        return true;
    }

    return false;
}
