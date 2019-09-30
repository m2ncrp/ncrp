nativeGetPlayerName <- getPlayerName;

/**
 * Return logined player character name
 * or native network player name
 * @param  {Integer} playerid
 * @return {String}
 */
function getPlayerName(playerid) {
    if (isPlayerLoaded(playerid)) {
        return players[playerid].getName();
    }

    return nativeGetPlayerName(playerid);
}

/**
 * Return short name of player
 * or fullname if invalid format name (without _)
 * or false if player was not found
 * @param {Integer} playerid
 */
function getPlayerNameShort(playerid) {
    if(isPlayerLoaded(playerid)) {
        local playerName = getPlayerName(playerid);
        local index = playerName.find(" ");
        if (index != null) {
            local playerNameShort = playerName.slice(0, index) + " " + playerName.slice(index+1, index+2)+".";
            return playerNameShort;
        }
        return playerName;
    }
    return false;
}

/**
 * Return playerid by character first and last name in format: Mike Bruski
 * or false if player was not found
 * @param {Integer} characterName
 * @return {Integer} playerid
 */
function getPlayerIdFromCharacterName(characterName) {
    foreach(playerid, value in players) {
        if(value.firstname+" "+value.lastname == characterName) {
            return playerid;
        }
    }
    return -1;
}

/**
 * Return playerid by CharacterId
 * or false if player was not found
 * @param {Integer} CharacterId
 * @return {Integer} playerid
 */
function getPlayerIdFromCharacterId(CharacterId) {
    foreach(playerid, value in players) {
        if(value.id == CharacterId) {
            return playerid;
        }
    }
    return -1;
}

/**
 * Return CharacterId by playerid
 * or false if player was not found
 * @param {Integer} PlayerId
 * @return {Integer} CharacterId
 */
function getCharacterIdFromPlayerId(playerid) {
    if(players.has(playerid)) {
        return players[playerid].id;
    }
    return false;
}

/**
 * Return known character name by playerid and targetid
 * or false
 * @param  {int}    playerid
 * @param  {int}    targetid
 * @return {string}
 */
function getKnownCharacterName(playerid, targetid) {
    local idStr = " [" + targetid.tostring() + "]";
    local unknown = "Незнакомец" + idStr;

    if(!isPlayerConnected(targetid)) {
        return unknown;
    }

    // Раскомментировать для прода
    // if(playerid == targetid) {
    //     return getPlayerName(playerid) + idStr;
    // }

    local targetCharId = getCharacterIdFromPlayerId(targetid);

    if(!(targetCharId in players[playerid].handshakes)) {
      return unknown;
    }


    return players[playerid].handshakes[targetCharId].text + idStr;
}

event("onServerPlayerStarted", function(playerid) {

    local isVerified = ("verified" in players[playerid].data) ? players[playerid].data.verified : false;

    // for local player
    trigger(playerid, "onServerPlayerAdded", playerid, getPlayerName(playerid), isVerified);

    // for all players
    foreach (targetid, player in players) {
        trigger(targetid, "onServerPlayerAdded", playerid, getPlayerName(playerid), isVerified ); // create name of current player for remote players
        trigger(playerid, "onServerPlayerAdded", targetid, getPlayerName(targetid), ("verified" in players[targetid].data) ? players[targetid].data.verified : false ); // create name of remote player for current player
    }
});

