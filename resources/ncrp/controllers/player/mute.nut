// storage for mutes
local mutes = [];

/**
 * Set particular player mute
 * @param {Integer} playerid
 * @param {Boolean} state
 */
function setPlayerMuted(playerid, state) {
    if (state && mutes.find(playerid) == null) {
        return mutes.push(playerid);
    }

    if (!state && mutes.find(playerid) != null) {
        return mutes.remove(mutes.find(playerid));
    }

    return false;
}

/**
 * Check is player muted
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function isPlayerMuted(playerid) {
    return mutes.find(playerid) != null;
}