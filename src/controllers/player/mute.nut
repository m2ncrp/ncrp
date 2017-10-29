// storage for mutes
local mutes = [];

/**
 * Set particular player mute
 * @param {Integer} playerid
 * @param {Boolean} state
 */
function setPlayerMuted(playerid, state) {
    local key = getPlayerName(playerid);

    if (state && mutes.find(key) == null) {
        return mutes.push(key);
    }

    if (!state && mutes.find(key) != null) {
        return mutes.remove(mutes.find(key));
    }

    return false;
}

/**
 * Check is player muted
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function isPlayerMuted(playerid) {
    return mutes.find(getPlayerName(playerid)) != null;
}
