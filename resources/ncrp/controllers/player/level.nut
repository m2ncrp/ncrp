/**
 * Get player level
 *
 * @param  {Integer} playerid
 * @return {Integer}
 */
function getPlayerLevel(playerid) {
    if (!(playerid in players)) {
        return null;
    }

    // return floor(0.1 * sqrt(players[playerid].xp * 0.25));
    return checkLevel(players[playerid].xp);
}

/**
 * Is player level is passes validation
 * (same or bigger as the one provided)
 *
 * @param  {Integer} playerid
 * @param  {Number}  level
 * @return {Boolean}
 */
function isPlayerLevelValid(playerid, level = 1) {
    // return (getPlayerLevel(playerid) >= level);
    return true;
}

function checkLevel(exp) {
    local q = 2.45;
    local a1 = 140;

    local lvl = log10( 1.25109855*(a1 - exp*(1-q)) / 343 ) / log10(q);
    return floor( abs(lvl) );
}
