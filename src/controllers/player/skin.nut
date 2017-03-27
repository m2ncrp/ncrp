nativeSetPlayerModel <- setPlayerModel;
nativeGetPlayerModel <- getPlayerModel;

/**
 * Set temp (visual) player model
 * also, if pass false as 3rd parameter
 * it will set this skin as default (after job exiting or whatever)
 *
 * @param {Integer}  playerid
 * @param {Integer}  skin
 * @param {Boolean}  forced
 */
function setPlayerModel(playerid, skin, forced = false) {
    nativeSetPlayerModel(playerid, skin.tointeger());

    if (isPlayerLoaded(playerid)) {
        // save temp skin
        players[playerid].cskin = skin.tointeger();

        // if not temp, set also main skin
        if (forced) players[playerid].dskin = skin.tointeger();
    }

    return true;
}

/**
 * Reload player model forcing player to appear
 * @param  {Integer} playerid
 */
function reloadPlayerModel(playerid) {
    setPlayerModel(playerid, 10);
    local oldmodel = getPlayerModel(playerid);

    delayedFunction(250, function() {
        setPlayerModel(playerid, oldmodel);
    });
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
 * Get current player model
 * @param  {Integer} playerid
 * @return {Integer}
 */
function getPlayerModel(playerid) {
    return isPlayerLoaded(playerid) ? players[playerid].cskin : 0;
}

/**
 * Register aliases
 */
setPlayerSkin <- setPlayerModel;
getPlayerSkin <- getPlayerModel;
getDefaultPlayerSkin <- getDefaultPlayerModel;
