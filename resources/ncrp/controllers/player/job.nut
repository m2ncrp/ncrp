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
