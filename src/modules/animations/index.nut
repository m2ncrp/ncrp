local CharsAnims = {};


function addPlayerAnim (playerid, anim, model) {
    CharsAnims[getCharacterIdFromPlayerId(playerid)] <- [anim, model];
};

function removePlayerAnim (playerid) {
    delete CharsAnims[getCharacterIdFromPlayerId(playerid)];
}

function getCharsAnims () {
    return CharsAnims;
}

function getCharAnim (charid) {
    return CharsAnims[charid];
}