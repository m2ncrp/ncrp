const PLAYER_HUNGER_MODIFIER = 0.16;
const PLAYER_THIRST_MODIFIER = 0.20;

const PLAYER_HUNGER_MAX = 100.0;
const PLAYER_THIRST_MAX = 100.0;

const PLAYER_HUNGER_REGEN_MINIMAL = 75.0;
const PLAYER_THIRST_REGEN_MINIMAL = 75.0;

event("onServerPlayerStarted", function(playerid) {
    trigger(playerid, "onPlayerHungerUpdate", players[playerid].hunger, players[playerid].thirst);
});

event("onServerMinuteChange", function() {
    foreach (playerid, player in players) {
        if (player.hunger > 0.0) player.hunger -= PLAYER_HUNGER_MODIFIER;
        if (player.thirst > 0.0) player.thirst -= PLAYER_THIRST_MODIFIER;

        if (player.hunger < 5.0 || player.thirst < 5.0) {
            setPlayerHealth(playerid, getPlayerHealth(playerid) - 72.0);
        }

        if (player.hunger > PLAYER_HUNGER_REGEN_MINIMAL && player.thirst > PLAYER_THIRST_REGEN_MINIMAL && getPlayerHealth(playerid) < 720.0) {
            setPlayerHealth(playerid, getPlayerHealth(playerid) + 36.0);
        }

        trigger(playerid, "onPlayerHungerUpdate", player.hunger, player.thirst);
    }
});

event("onPlayerDeath", function(playerid) {
    if (!isPlayerLoaded(playerid)) return;
    players[playerid].hunger = 25.0;
    players[playerid].thirst = 25.0;
    trigger(playerid, "onPlayerHungerUpdate", players[playerid].hunger, players[playerid].thirst);
});

mcmd(["admin.eat"], "aeat", function(playerid, playerSessionId = null) {
    local targetid = playerSessionId ? getPlayerIdByPlayerSessionId(playerSessionId.tointeger()) : playerid;
    players[targetid].hunger = 100.0;
    players[targetid].thirst = 100.0;
    trigger(targetid, "onPlayerHungerUpdate", players[targetid].hunger, players[targetid].thirst);
});

/**
 * Add hunger to player
 * @param {Integer} playerid
 * @param {Float} level
 */
function addPlayerHunger(playerid, level = 0.0) {
    if (!players.has(playerid)) return false;
    local newlevel = players[playerid].hunger + level.tofloat();
    players[playerid].hunger = newlevel > PLAYER_HUNGER_MAX ? PLAYER_HUNGER_MAX : newlevel;
    trigger(playerid, "onPlayerHungerUpdate", players[playerid].hunger, players[playerid].thirst);
    return true;
}

/**
 * Add thirst to player
 * @param {Integer} playerid
 * @param {Float} level
 */
function addPlayerThirst(playerid, level = 0.0) {
    if (!players.has(playerid)) return false;
    local newlevel = players[playerid].thirst + level.tofloat();
    players[playerid].thirst = newlevel > PLAYER_THIRST_MAX ? PLAYER_THIRST_MAX : newlevel;
    trigger(playerid, "onPlayerHungerUpdate", players[playerid].hunger, players[playerid].thirst);
    return true;
}

/**
 * Add hunger to player
 * @param {Integer} playerid
 * @param {Float} level
 */
function subPlayerHunger(playerid, level = 0.0) {
    if (!players.has(playerid)) return false;
    local newlevel = players[playerid].hunger - level.tofloat();
    players[playerid].hunger = newlevel < 0.0 ? 0.0 : newlevel;
    trigger(playerid, "onPlayerHungerUpdate", players[playerid].hunger, players[playerid].thirst);
    return true;
}

/**
 * Add thirst to player
 * @param {Integer} playerid
 * @param {Float} level
 */
function subPlayerThirst(playerid, level = 0.0) {
    if (!players.has(playerid)) return false;
    local newlevel = players[playerid].thirst - level.tofloat();
    players[playerid].thirst = newlevel < 0.0 ? 0.0 : newlevel;
    trigger(playerid, "onPlayerHungerUpdate", players[playerid].hunger, players[playerid].thirst);
    return true;
}
