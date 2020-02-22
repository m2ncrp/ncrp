/**
 * Check player section data exist
 * @param {Integer} PlayerId
 * @param {String} Section
 * @return {boolean}
 */
function checkPlayerSectionData(playerid, section) {
    return section in players[playerid].data;
}

/**
 * Set player section data with value
 * @param {Integer} PlayerId
 * @param {String} Section
 * @param {any} Value
 */
function setPlayerSectionData(playerid, section, value = {}) {
    players[playerid].data[section] <- value;
}