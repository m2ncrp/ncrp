local charsAnims = {};

function addPlayerAnim (playerid, anim, model, endless) {
    charsAnims[getCharacterIdFromPlayerId(playerid)] <- [anim, model, endless];
};

function removePlayerAnim (playerid) {
    delete charsAnims[getCharacterIdFromPlayerId(playerid)];
}

function getCharsAnims () {
    return charsAnims;
}

function getCharAnim (charid) {
    return charsAnims[charid];
}

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
        addPlayerAnim(playerid, data["animation"], data["model"], data["endless"]);
        createPlace(format("animation_%d", charId), position[0] - 100, position[1] - 100, position[0] + 100, position[1] + 100);
        sendAnimation(playerid, data);
        if (animLen == 0) return;
        delayedFunction(animLen, function() {
            removePlace(format("animation_%d", charId));
            removePlayerAnim(playerid);
        });
    }

function clearAnimPlace(playerid) {
    local charid = getCharacterIdFromPlayerId(playerid);
    removePlace(format("animation_%d", charid));
    removePlayerAnim(playerid);
}


event("onPlayerPlaceEnter", function(playerid, name) {
    local data = split(name, "_");
    if (data[0] == "animation") {
        local charId = data[1].tointeger();
        local playerAnim = getCharAnim(charId);
        sendAnimation(playerid, {"animation": playerAnim[0], "model": playerAnim[1], "endless": playerAnim[2]}, getPlayerIdFromCharacterId(charId))
    }
})
