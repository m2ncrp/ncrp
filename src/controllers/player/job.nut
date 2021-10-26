/**
 * Check is player have a valid job
 * @param  {int}  playerid
 * @param  {string}  jobname  - name of job
 * @return {Boolean} true/false
 */
function isPlayerHaveValidJob(playerid, jobname) {
    return (getPlayerJob(playerid) == jobname);
}

/**
 * Check is player have a any job
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerHaveJob(playerid) {
    return (getPlayerJob(playerid)) ? true : false;
}


/**
 * Set player job
 * @param {Integer} playerid
 * @param {String} jobname
 * @return {Boolean}
 */
function setPlayerJob(playerid, jobname) {
    if (!isPlayerLoaded(playerid)) {
        return false;
    }

    players[playerid].job = (!jobname) ? "" : jobname;

    trigger(playerid, "onServerIntefaceCharacterJob", getLocalizedPlayerJob(playerid));
    delayedFunction(500, function() { renderPlayerJobBlips(playerid) });

    return true;
}

/**
 * Toggle Player Job Blips
 * @param  {[type]} playerid [description]
 */
function renderPlayerJobBlips(playerid) {
    trigger("onPlayerJobChanged", playerid);
}

/**
 * Get player job by playerid
 * @param  {Integer} playerid
 * @return {String}
 */
function getPlayerJob(playerid) {
    return (isPlayerLoaded(playerid) && players[playerid].job && players[playerid].job != "") ? players[playerid].job : false;
}
