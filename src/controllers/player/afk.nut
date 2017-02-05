const AFK_TIME = 300; // 5 minutes

local afkPlayers = {};
local afkLastPositions = {};

event("onServerPlayerStarted", function(playerid) {
    afkPlayers[playerid] <- getTimestamp();
});

event("onServerPlayerCommand", function(playerid, cmdlog) {
    setPlayerAfk(playerid, false);
});

event("onServerMinuteChange", function() {
    foreach (playerid, stuff in players) {
        if (!(playerid in afkLastPositions)) {
            afkLastPositions[playerid] <- [0, 0];
        }

        local pos1 = getPlayerPosition(playerid);
        local pos2 = afkLastPositions[playerid];

        if ((pos2[0] - pos1[0]) > 2.5 || (pos2[1] - pos1[1]) > 2.5) {
            afkLastPositions[playerid] = [ pos1[0], pos1[1] ];
            setPlayerAfk(playerid, false);
        }
    }
});

/**
 * Set player afk state
 * @param {Integer} playerid
 * @param {Boolean} state
 */
function setPlayerAfk(playerid, state) {
    afkPlayers[playerid] <- (state) ? 0 : getTimestamp();
}

/**
 * Return if current player is afk
 * @param  {Integer}  playerid
 * @return {Boolean}
 */
function isPlayerAfk(playerid) {
    return (playerid in afkPlayers && (getTimestamp() - afkPlayers[playerid] > AFK_TIME));
}
