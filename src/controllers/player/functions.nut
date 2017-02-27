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
    dbg("player", "disconnect", getIdentity(playerid));
    setPlayerAuthBlocked(playerid, false);

    if (!isPlayerAuthed(playerid)) {
        return dbg(format("player %s exited without login", getIdentity(playerid)));
    }

    if (!isPlayerLoaded(playerid)) {
        return dbg(format("player %s exited without character loading", getIdentity(playerid)));
    }

    // call events
    trigger("onPlayerDisconnect", playerid, reason);

    // save player after disconnect
    players.remove(playerid).save();
}

/**
 * Get player description for admins
 * in format:
 *     id: 5, character: John Smith, account: Holly18, serial: ASADAS11D123A3S23DA42A1165SDSDASD
 * @param  {Integer} playerid
 * @return {String}
 */
function getIdentity(playerid) {
    try {
        local charactername = getPlayerName(playerid).tostring();

        if (!isPlayerLoaded(playerid)) {
            charactername = "unloaded";
        }

        return playerid >= 0 ? format("id: %d, account: %s, character: %s", playerid.tointeger(), getAccountName(playerid).tostring(), charactername) : "unloaded";
    }
    catch (e) {
        return "cannot format identity for playerid: " + playerid;
    }
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
    return playerid in players ? players[playerid].state : "free";
}

function setPlayerState(playerid, to) {
    players[playerid].state = to;
    trigger("onPlayerStateChange", playerid);
}
