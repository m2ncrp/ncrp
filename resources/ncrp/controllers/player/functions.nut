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
 * Check is player have a valid job
 * @param  {int}  playerid
 * @param  {string}  jobname  - name of job
 * @return {Boolean} true/false
 */
function isPlayerHaveValidJob(playerid, jobname) {
    return (players[playerid]["job"] == jobname);
}

/**
 * Check is player have a any job
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerHaveJob(playerid) {
    return (players[playerid]["job"]) ? true : false;
}

/**
 * Get player position and return to OBJECT
 * @param  {int} playerid
 * @return {object}
 */
function getPlayerPositionObj ( playerid ) {
    local plaPos = getPlayerPosition(playerid);
    return { x = plaPos[0], y = plaPos[1], z = plaPos[2] };
}

/**
 * Set player position to coordinates from objpos.x, objpos.y, objpos.z
 * @param {int} playerid
 * @param {object} objpos
 */
function setPlayerPositionObj ( playerid, objpos ) {
    setPlayerPosition( playerid, objpos.x, objpos.y, objpos.z);
}


/**
 * Check if PLAYER in radius of given point
 * @param  {int} playerid
 * @param  {float} X
 * @param  {float} Y
 * @param  {float} radius
 * @return {bool} true/false
 */
function isPlayerInValidPoint(playerid, X, Y, radius) {
    local plaPos = getPlayerPosition( playerid );
    return isPointInCircle2D( plaPos[0], plaPos[1], X, Y, radius );
}

/**
 * Check if PLAYER in radius of given point 3D
 * @param  {int} playerid
 * @param  {float} X
 * @param  {float} Y
 * @param  {float} Z
 * @param  {float} radius
 * @return {bool} true/false
 */
function isPlayerInValidPoint3D(playerid, X, Y, Z, radius) {
    local plaPos = getPlayerPosition( playerid );
    return isPointInCircle3D( plaPos[0], plaPos[1], plaPos[2], X, Y, Z, radius );
}

/**
 * Return current player locale
 *
 * @param  {Integer} playerid
 * @return {String}
 */
function getPlayerLocale(playerid) {
    if (playerid in players && "locale" in players[playerid]) {
        return players[playerid]["locale"];
    }

    return "en";
}

/**
 * Set current player locale
 *
 * @param  {Integer} playerid
 * @return {String}
 */
function setPlayerLocale(playerid, locale = "en") {
    if (playerid in players) {
        players[playerid]["locale"] <- locale;
        return true;
    }

    return false;
}

function checkLevel(exp) {
    local q = 2.45;
    local a1 = 140;

    local lvl = log10( 1.25109855*(a1 - exp*(1-q)) / 343 ) / log10(q);
    return floor( abs(lvl) );
}

/**
 * Get player level
 *
 * @param  {Integer} playerid
 * @return {Integer}
 */
function getPlayerLevel(playerid) {
    if (!(playerid in players)) {
        return null;
    }

    // return floor(0.1 * sqrt(players[playerid].xp * 0.25));
    return checkLevel(players[playerid].xp);
}

/**
 * Is player level is passes validation
 * (same or bigger as the one provided)
 *
 * @param  {Integer} playerid
 * @param  {Number}  level
 * @return {Boolean}
 */
function isPlayerLevelValid(playerid, level = 1) {
    // return (getPlayerLevel(playerid) >= level);
    return true;
}

/**
 * Set player job
 * @param {Integer} playerid
 * @param {String} jobname
 * @return {Boolean}
 */
function setPlayerJob(playerid, jobname) {
    if (!(playerid in players)) {
        return false;
    }
    players[playerid].job = jobname;
    trigger(playerid, "onServerIntefaceCharacterJob", getLocalizedPlayerJob(playerid, "en"));
    trigger("onPlayerJobChanged", playerid);
    return true;
}

/**
 * Get player job by playerid
 * @param  {Integer} playerid
 * @return {String}
 */
function getPlayerJob(playerid) {
    return (playerid in players && players[playerid].job) ? players[playerid].job : false;
}

/**
 * Return current money balance
 * or 0.0 if player was not found
 * @param {Integer} playerid
 * @return {Float}
 */
function getPlayerMoney(playerid) {
    return (playerid in players) ? players[playerid].money : 0.0;
}

/**
 * Set player money by playerid
 * @param {Integer} playerid
 * @param {Float} money
 * @return {Boolean}
 */
function setPlayerMoney(playerid, money) {
    if (!(playerid in players)) {
        return false;
    }

    trigger(playerid, "onServerInterfaceMoney", money);
    trigger("onPlayerMoneyChanged", playerid);

    players[playerid].money = money;
    return true;
}

/**
 * Return short name of player
 * or fullname if invalid format name (without _)
 * or false if player was not found
 * @param {Integer} playerid
 */
function getPlayerNameShort(playerid) {
    if(playerid in players) {
        local playerName = getPlayerName(playerid);
        local index = playerName.find("_");
        if (index != null) {
            local playerNameShort = playerName.slice(0, index) + " " + playerName.slice(index+1, index+2)+".";
            return playerNameShort;
        }
        return playerName;
    }
    return false;
}

/**
 * Check if player is logined (right after login he is not)
 * @param  {Integer}  playerid
 * @return {Boolean}
 */
function isPlayerLogined(playerid) {
    return (playerid in players);
}

local lastDeaths = {};

/**
 * Check if player was dead in last 1 second
 * @param  {Integer}  playerid
 * @return {Boolean}
 */
function isPlayerBeenDead(playerid) {
    return (playerid in lastDeaths && ((getTimestamp() - lastDeaths[playerid]) <= 10));
}

/**
 * Set last player death to current timestamp
 * @param {Integer} playerid
 */
function setPlayerBeenDead(playerid) {
    lastDeaths[playerid] <- getTimestamp();
}

function sendPlayerNotification(playerid, type, message) {
    return trigger(playeridm "onServerAddedNofitication", type, message);
}
