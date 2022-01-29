local charsAnims = {};

function addPlayerAnim (charId, anim, model, endless) {
    charsAnims[charId] <- [anim, model, endless];
};

function removePlayerAnim (charId) {
    if(charId in charsAnims) {
        delete charsAnims[charId];
        return true;
    }
    return false;
};

function getCharsAnims () {
    return charsAnims;
};

function getCharAnim (charid) {
    return charsAnims[charid];
};

function isPlayingAnim (playerid) {
    local charId = getCharacterIdFromPlayerId(playerid);
    if (charId in charsAnims) {
        if (charsAnims[charId][2]) {
            return "idling";
        } else {
            return "playing";
        }
    } else {
        return null;
    }
};


function sendAnimation(playerid, data, id=-1) {
    local defaultArgs = {
     "model": 1,
     "endless": false,
     "block": true,
     "unblock": true
    }
    foreach (key, value in defaultArgs) {
        if (key in data){
            defaultArgs[key] = data[key];
        }
    }
    triggerClientEvent(playerid, "animate", id, data["animation"], defaultArgs["model"], defaultArgs["endless"], defaultArgs["block"], defaultArgs["unblock"]);
};


function animateGlobal(playerid, data, animLen=0) {
    if(isPlayerInVehicle(playerid) || getPlayerState(playerid) == "cuffed" || isDockerHaveBox(playerid)) return; // TODO: Подумать как избавиться от isDockerHaveBox

    local position = getPlayerPosition(playerid);
    local charId = getCharacterIdFromPlayerId(playerid);
    if (charId in getCharsAnims()) return;
    if (!("endless" in data)) {
        data["endless"] <- false;
    }
    addPlayerAnim(charId, data["animation"], data["model"], data["endless"]);
    createPlace(format("animation_%d", charId), position[0] - 100, position[1] - 100, position[0] + 100, position[1] + 100);
    sendAnimation(playerid, data);
    if (animLen == 0) return;
    delayedFunction(animLen, function() {
        removeArea(format("animation_%d", charId));
        removePlayerAnim(charId);
    });
}

function clearAnimPlace(playerid) {
    local charId = getCharacterIdFromPlayerId(playerid);
    removeArea(format("animation_%d", charId));
    removePlayerAnim(charId);
}


event("onPlayerAreaEnter", function(playerid, name) {
    local data = split(name, "_");
    if (data[0] == "animation") {
        local charId = data[1].tointeger();
        local playerAnim = getCharAnim(charId);
        sendAnimation(playerid, {"animation": playerAnim[0], "model": playerAnim[1], "endless": playerAnim[2]}, getPlayerIdFromCharacterId(charId));
    }
});

event("onServerPlayerStarted", function(playerid) {
    triggerClientEvent(playerid, "setModel", 1);
});
