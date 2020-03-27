include("controllers/handshakes/models/Handshake.nut");
include("controllers/handshakes/commands.nut");

event("onServerStarted", function() {
    logStr("starting handshakes...");
});

local handshakes_cache = {};

/**
 * Try to load player handshakes
 * on player connected
 */
event("onServerPlayerStarted", function(playerid) {

    local character = players[playerid];
    local charId = character.id;

    if (!(charId in handshakes_cache)) {
        handshakesLoadData(charId)
    }

    character.handshakes = handshakes_cache[charId];
});


function handshakesLoadData(charId) {
    handshakes_cache[charId] <- {};
    Handshake.findBy({char = charId}, function(err, handshakes) {
        foreach (idx, hs in handshakes) {
            handshakes_cache[charId][hs.target] <- hs;
        }
    })
}