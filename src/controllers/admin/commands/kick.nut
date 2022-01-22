/**
 * Kick player with 5 sec delay
 * Usage:
 *     /kick 0 shitposting
 *     /kick 0
 */
function kick(playerid, targetid, ...) {

    local targetid = getPlayerIdByPlayerSessionId(targetid.tointeger());
    local reason   = concat(vargv);

    if (!isPlayerConnected(targetid)) {
        return msg(playerid, "admin.error", CL_ERROR);
    }

    freezePlayer( targetid, true );

    if (isPlayerInVehicle(targetid)) {
        stopPlayerVehicle( targetid );
        removePlayerFromVehicle( targetid );
    }

    if (!reason) {
        reason = plocalize(targetid, "inappropriatebehavior");
    }

    // clear chat
    for (local i = 0; i < 12; i++) {
        msg(targetid, "");
    }

    msg(targetid, "admin.kick.hasbeenkicked", [ reason ], CL_RED);
    msg(playerid, "admin.kick.kicked"        , [ getPlayerName(targetid), reason ], CL_SUCCESS);

    // remove player from players array (disabling chats and stuff)
    removePlayer(targetid, reason);

    // move player to sky
    movePlayer(targetid, 0.0, 0.0, 150.0);

    delayedFunction(5000, function () {
        kickPlayer( targetid );
        dbg("admin", "kicked", getAuthor(targetid));
    });
};
acmd("kick", kick);
event("onPlayerKicked", kick);

/**
 * Kick all players on server stopping
 */
function kickAll() {
    foreach (playerid, character in players) kick( -1, playerid, "restart" );
}
