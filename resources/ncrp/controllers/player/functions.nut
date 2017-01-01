/**
 * Check is player sit in a valid vehicle
 * @param  {int}  playerid
 * @param  {int}  modelid  - model vehicle
 * @return {Boolean} true/false
 */
function isPlayerInValidVehicle(playerid, modelid) {
    return (isPlayerInVehicle(playerid) && getVehicleModel( getPlayerVehicle(playerid) ) == modelid.tointeger());
}

/**
 * Forcefully remove player from server
 * @param  {Integer} playerid
 * @param  {String} reason
 */
function removePlayer(playerid, reason = "") {
    dbg("player", "disconnect", getPlayerName(playerid));
    setPlayerAuthBlocked(playerid, false);

    if (!players.exists(playerid)) {
        return dbg(format("player %s exited without login", getPlayerName(playerid)));
    }

    // call events
    trigger("onPlayerDisconnect", playerid, reason);

    // save player after disconnect
    players.remove(playerid).save();
}


/**
 * Check if player is logined (right after login he is not)
 * @param  {Integer}  playerid
 * @return {Boolean}
 */
function isPlayerLoaded(playerid) {
    return players.exists(playerid);
}

// @deprecated
isPlayerLogined <- isPlayerLoaded;

// TODO(inlife)
function sendPlayerNotification(playerid, type, message) {
    return trigger(playeridm "onServerAddedNofitication", type, message);
}


function getPlayerToggle(playerid) {
    return players[playerid]["toggle"];
}

function setPlayerToggle(playerid, to) {
    players[playerid]["toggle"] = to;
    // togglePlayerControls(playerid, to);
    freezePlayer(playerid, to);
}


function getPlayerState(playerid) {
    return players[playerid]["state"];
}

function setPlayerState(playerid, to) {
    players[playerid]["state"] = to;
    trigger("onPlayerStateChange", playerid);
}
