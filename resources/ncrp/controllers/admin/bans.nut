const DEFAULT_PLAYER_MUTE_TIME = 300; // 5 minutes

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

    // remove player from players array (disabling chats and stuff)
    removePlayer(targetid, reason);

    // move player to sky
    movePlayer(targetid, 0.0, 0.0, 150.0);

    // clear chat
    for (local i = 0; i < 12; i++) {
        msg(targetid, "");
    }

    msg(targetid, format("[SERVER] You has been kicked for: %s.", reason), CL_RED);
    msg(playerid, format("You've kicked %s for: %s.", getPlayerName(targetid), reason), CL_SUCCESS);

    delayedFunction(5000, function () {
        kickPlayer( targetid );
    });
});

// acmd("ban")

/**
 * Mute player for a period of time
 * Usage:
 *     /mute 0
 *     /mute 0 150
 *     /mute 1 150 spam, flood
 */
acmd("mute", function(playerid, targetid, ...) {
    local targetid = toInteger(targetid);
    local amount   = vargv.len() ? toInteger(vargv.pop()) : null;
    local reason   = concat(vargv);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "You should provide playerid of connected player you want to mute", CL_ERROR);
    }

    if (amount == null || amount < 1) {
        amount = DEFAULT_PLAYER_MUTE_TIME;
    }

    if (!reason) {
        reason = "inappropriate behavior";
    }

    setPlayerMuted(targetid, true);
    msg(targetid, format("[SERVER] You has been muted on: %d seconds, for: %s.", amount, reason), CL_RED);
    msg(playerid, format("You've muted %s on: %d seconds, for: %s.", getPlayerName(targetid), amount, reason), CL_SUCCESS);

    // unmute
    return delayedFunction(amount * 1000, function() {
        if (isPlayerMuted(targetid)) {
            setPlayerMuted(targetid, false);
            msg(targetid, "[SERVER] You has been unmuted", CL_INFO);
        }
    });
});

/**
 * Unmute player
 * Usage:
 *     /unmute 0
 */
acmd("unmute", function(playerid, targetid) {
    local targetid = toInteger(targetid);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "You should provide playerid of connected player you want to mute", CL_ERROR);
    }

    if (!isPlayerMuted(targetid)) {
        return msg(playerid, format("Player %s is not muted.", getPlayerName(targetid)), CL_INFO);
    }

    setPlayerMuted(targetid, false);
    msg(playerid, format("Player %s is unmuted.", getPlayerName(targetid)), CL_SUCCESS);
    msg(targetid, "[SERVER] You has been unmuted", CL_INFO);
});
