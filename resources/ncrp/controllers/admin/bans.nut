/**
 * Kick player with 5 sec delay
 * Usage:
 *     /kick 0 shitposting
 *     /kick 0
 */
acmd("kick", function(playerid, targetid, ...) {
    local targetid = toInteger(targetid);
    local reason   = concat(vargv);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "You should provide playerid of connected player you want to kick", CL_ERROR);
    }

    freezePlayer( targetid, true );

    if (isPlayerInVehicle(targetid)) {
        stopPlayerVehicle( targetid );
        removePlayerFromVehicle( playerid );
    }

    // move player to sky
    movePlayer(targetid, 0.0, 0.0, 150.0);

    // remove player from players array (disabling chats and stuff)
    removePlayer(targetid, reason);

    // clear chat
    for (local i = 0; i < 12; i++) {
        msg(targetid, "");
    }

    msg(targetid, format("You has been kicked for: %s", reason), CL_RED);

    delayedFunction(5000, function () {
        kickPlayer( targetid );
    });
});

// acmd("ban")
// acmd("mute")
