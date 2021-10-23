local charsAnims = {};


function addPlayerAnim (playerid, anim, model) {
    charsAnims[getCharacterIdFromPlayerId(playerid)] <- [anim, model];
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