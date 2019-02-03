// storage for mutes
local mutes = {};

/**
 * Set particular player mute
 * @param {Integer} playerid
 * @param {Boolean} state
 */
function setPlayerMuted(playerid, params = null) {
    local key = getAccountName(playerid);

    if (key in mutes == false) {
        mutes[key] <- {};
    }

    if (params && key in mutes) {
        return mutes[key] = { amount = params.amount, until = params.until, created = params.created, reason = params.reason };
    }

    if (!params && key in mutes == true) {
        return delete mutes[key];
    }

    return false;
}

/**
 * Check is player muted
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function isPlayerMuted(playerid) {
    local key = getAccountName(playerid);
    return key in mutes == true && mutes[key].until > getTimestamp();
}

