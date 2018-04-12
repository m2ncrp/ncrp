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
    return false;
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
    return false;
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

event("onServerPlayerStarted", function(playerid) {
    // for local player
    trigger(playerid, "onServerPlayerAdded", playerid, getPlayerName(playerid), players[playerid].data.verified );

    // for all players
    foreach (targetid, player in players) {
        trigger(targetid, "onServerPlayerAdded", playerid, getPlayerName(playerid), players[playerid].data.verified ); // create name of current player for remote players
        trigger(playerid, "onServerPlayerAdded", targetid, getPlayerName(targetid), players[targetid].data.verified ); // create name of remote player for current player
    }
});

