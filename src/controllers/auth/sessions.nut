/**
 * Storage for sessions
 * no direct acess
 */
local sessions = {};

/**
 * Get last active session for the player
 * @param  {Integer} playerid
 * @return {Boolean}
 */
function getLastActiveSession(playerid) {
    local key = md5(getAccountName(playerid) + "@" + getPlayerSerial(playerid));

    if (key in sessions) {
        return sessions[key];
    }

    return 0;
}

/**
 * Set last active session to current timestamp
 * @param {Integer} playerid
 * @return {Boolean}
 */
function setLastActiveSession(playerid) {
    return sessions[md5(getAccountName(playerid) + "@" + getPlayerSerial(playerid))] <- getTimestamp();
}