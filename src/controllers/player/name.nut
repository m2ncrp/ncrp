nativeGetPlayerName <- getPlayerName;

/**
 * Return logined player character name
 * or native network player name
 * @param  {Integer} playerid
 * @return {String}
 */
function getPlayerName(playerid) {
    if (isPlayerLoaded(playerid)) {
        return players[playerid].getName();
    }

    return nativeGetPlayerName(playerid);
}

/**
 * Return short name of player
 * or fullname if invalid format name (without _)
 * or false if player was not found
 * @param {Integer} playerid
 */
function getPlayerNameShort(playerid) {
    if(isPlayerLoaded(playerid)) {
        local playerName = getPlayerName(playerid);
        local index = playerName.find(" ");
        if (index != null) {
            local playerNameShort = playerName.slice(0, index) + " " + playerName.slice(index+1, index+2)+".";
            return playerNameShort;
        }
        return playerName;
    }
    return false;
}

event("onServerPlayerStarted", function(playerid) {
    // for local player
    trigger(playerid, "onServerPlayerAdded", playerid, getPlayerName(playerid));

    // for all players
    foreach (targetid, player in players) {
        trigger(targetid, "onServerPlayerAdded", playerid, getPlayerName(playerid)); // create name of current player for remote players
        trigger(playerid, "onServerPlayerAdded", targetid, getPlayerName(targetid)); // create name of remote player for current player
    }
});