/**
 * LoOnyBiker (c) via GitHub: https://github.com/LoOnyBiker
 * Creation date: 17.01.2017
 *
 * Dat manager bring full controll on police officer players in game. Allows:
 * - get some one unemployeed a job
 * - retire any officer
 * - set any officer rank
 * - get info about total officers in EBPD or how many of them online now (last one for admins probably)
 *
 * Note: there's no need in constructor couse table will be shared between all objects of dat class.
 * Couse there's now it should be skeleton its better to be a table, but for the future it's been created as a class.
 */
class OfficerManager {
    police <- {}; // all police officers on duty now

    /**
     * Check if player is a police officer
     * @param  {int}  playerid
     * @return {Boolean} true/false
     */
    function isOfficer(playerid) {
        if (!(isPlayerLoaded(playerid))) {
            return false;
        }

        // return if playerjob (might be job.police.officer)
        return (POLICE_RANK.find(players[playerid].job) != null);
    }

    /**
     * Function add player to EBPD organization as cadet and return feedback msg to player who send invite
     * @param {int} Who call this function and will get feedback msg
     * @param {int} Player id who's join EBPD
     */
    function add(playerid, cadet_id) {
        // Code
    }

    /**
     * 
     */
    function add_withrankup() {
        if( isOfficer(playerid) ) {
            return msg(playerid, "organizations.police.alreadyofficer");
        }

        if (isPlayerHaveJob(playerid)) {
            return msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid));
        }

        // set first rank
        setPlayerJob( playerid, setPoliceRank(playerid, 0) );
        //policeSetOnDuty(playerid, false);
        msg(playerid, "organizations.police.onbecame");
    }

    /**
     * Function add player to EBPD and don't return any msg to player who send invite
     * @param {int} Player id who's join EBPD
     */
    function add_silent(cadet_id) {
        // Code
    }

    /**
     * Function remove player from EBPD organization and send feedback msg to player who call it
     * @param  {int} Who call this function
     * @param  {int} Player id who'll be removed from EBPD
     * @return {bool} is operation failed or not
     */
    function remove(playerid, officer_id) {
        // Code
    }

    /**
     * @param  {int} Player id who'll be removed from EBPD
     * @return {[type]}
     */
    function remove_silent(officer_id) {
        // Code
    }

    /**
     * @param  {int} Int number from 0 to inf
     * @return {void}
     */
    function info(decade_number = 0) {
        // Code
    }

    /**
     * @param  {int} Player id who call it
     * @return {void}
     */
    function online(playerid) {
        // Code
    }
}
