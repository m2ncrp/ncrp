include("controllers/handshakes/models/Handshake.nut");
include("controllers/handshakes/commands.nut");

event("onServerStarted", function() {
    logger.log("starting handshakes...");
});

local handshakes_cache <- {};

/**
 * Try to load player handshakes
 * on player connected
 */
event("onServerPlayerStarted", function(playerid) {
    local character = players[playerid];

    if (!(character.id in handshakes_cache)) {
        handshakes_cache = handshakesLoadData(character.id)
    }

    character.handshakes = handshakes_cache[character.id];
});


function handshakesLoadData(charId) {
    handshakes_cache[charId] <- {};
    Handshake.findBy({char = charId}, function(err, handshakes) {
        foreach (idx, hs in handshakes) {
            handshakes_cache[charId][hs.target] <- hs;
        }
    })
}