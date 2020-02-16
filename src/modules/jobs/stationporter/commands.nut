key("e", function(playerid) {
    if ( isPlayerInVehicle(playerid) ) {
        return;
    }
    if ( !isPorter(playerid) ) {
        return porterJob( playerid );
    }
    if ( !isPorterHaveBox(playerid) ) {
        porterJobTakeBox( playerid );
    } else {
        porterJobPutBox( playerid );
    }
}, KEY_UP);

key("q", function(playerid) {
    if ( isPorter(playerid) ) {
        porterJobLeave( playerid );
    }
}, KEY_UP);