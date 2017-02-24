const PLAYER_HUNGER_MODIFIER = 0.01;
const PLAYER_THIRST_MODIFIER = 0.02;

const PLAYER_HUNGER_MAX = 100.0;
const PLAYER_THIRST_MAX = 100.0;

event("onPlayerStarted", function(playerid) {
    trigger(playerid, "onPlayerHungerUpdate", players[playerid].hunger, players[playerid].thirst);
});

event("onServerMinuteChange", function() {
    foreach (playerid, player in players) {
        if (player.hunger > 0.0) player.hunger -= PLAYER_HUNGER_MODIFIER;
        if (player.thirst > 0.0) player.thirst -= PLAYER_THIRST_MODIFIER;

        if (player.hunger < 35.0 || player.thirst < 35.0) {
            setPlayerHealth(playerid, getPlayerHealth(playerid) - 1.0);
        }

        trigger(playerid, "onPlayerHungerUpdate", player.hunger, player.thirst);
    }
});

/**
 * Add hunger to player
 * @param {Integer} playerid
 * @param {Float} level
 */
function addPlayerHunger(playerid, level = 0.0) {
    if (!players.has(playerid)) return;
    local newlevel = players[playerid].hunger + level.tofloat();
    players[playerid].hunger = newlevel > players[playerid].hunger ? PLAYER_HUNGER_MAX : newlevel;
}

/**
 * Add thirst to player
 * @param {Integer} playerid
 * @param {Float} level
 */
function addPlayerThirst(playerid, level = 0.0) {
    if (!players.has(playerid)) return;
    local newlevel = players[playerid].thirst + level.tofloat();
    players[playerid].thirst = newlevel > players[playerid].thirst ? PLAYER_THIRST_MAX : newlevel;
}

/**
 * Add hunger to player
 * @param {Integer} playerid
 * @param {Float} level
 */
function subPlayerHunger(playerid, level = 0.0) {
    if (!players.has(playerid)) return;
    local newlevel = players[playerid].hunger - level.tofloat();
    players[playerid].hunger = newlevel < 0.0 ? 0.0 : newlevel;
}

/**
 * Add thirst to player
 * @param {Integer} playerid
 * @param {Float} level
 */
function subPlayerThirst(playerid, level = 0.0) {
    if (!players.has(playerid)) return;
    local newlevel = players[playerid].thirst - level.tofloat();
    players[playerid].thirst = newlevel < 0.0 ? 0.0 : newlevel;
}
