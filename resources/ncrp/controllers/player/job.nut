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
    if (!(isPlayerLoaded(playerid))) {
        return false;
    }

    trigger(playerid, "onServerIntefaceCharacterJob", getLocalizedPlayerJob(playerid, "en"));
    trigger("onPlayerJobChanged", playerid);

    if (!jobname) {
        jobname = "";
    }

    players[playerid].job = jobname;

    return true;
}

/**
 * Get player job by playerid
 * @param  {Integer} playerid
 * @return {String}
 */
function getPlayerJob(playerid) {
    return (isPlayerLoaded(playerid) && players[playerid].job && players[playerid].job != "") ? players[playerid].job : false;
}
