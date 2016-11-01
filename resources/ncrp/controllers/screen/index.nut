function screenFadein(playerid, time, callback = null) {
    triggerClientEvent(playerid, "onServerFadeScreen", time, true);
    return callback ? delayedFunction(time, callback) : true;
}

function screenFadeout(playerid, time, callback = null) {
    triggerClientEvent(playerid, "onServerFadeScreen", time, false);
    return callback ? delayedFunction(time, callback) : true;
}

function screenFadeoutFadein(playerid, time, callback = null) {
    return screenFadeout(playerid, time, function() {
        screenFadein(playerid, time, function() {
            return callback ? callback(playerid) : null;
        });
    });
}
