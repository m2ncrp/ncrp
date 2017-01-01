nativeSetPlayerModel <- setPlayerModel;
nativeGetPlayerModel <- getPlayerModel;

/**
 * Set temp (visual) player model
 * also, if pass false as 3rd parameter
 * it will set this skin as default (after job exiting or whatever)
 *
 * @param {Integer}  playerid
 * @param {Integer}  skin
 * @param {Boolean} temp
 */
function setPlayerModel(playerid, skin, temp = true) {
    nativeGetPlayerModel(playerid, skin.tointeger());

    if (isPlayerLoaded(playerid)) {
        // save temp skin
        players[playerid].cskin = skin.tointeger();

        // if not temp, set also main skin
        if (!temp) players[playerid].dskin = skin.tointeger();
    }

    return true;
}

/**
 * Restore player model to default skin
 * @param  {Integer} playerid
 * @return {Boolean} result of execution
 */
function restorePlayerModel(playerid) {
    return (isPlayerLoaded(playerid)) ? setPlayerModel(playerid, players[playerid].dskin) : false;
}

/**
 * Get default player model
 * @param  {Integer} playerid
 * @return {Integer}
 */
function getDefaultPlayerModel(playerid) {
    return isPlayerLoaded(playerid) ? players[playerid].dskin : 0;
}

/**
 * Register aliases
 */
setPlayerSkin <- setPlayerModel;
getPlayerSkin <- getPlayerModel;
getDefaultPlayerSkin <- getDefaultPlayerModel;
