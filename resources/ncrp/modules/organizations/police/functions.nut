/**
 * Call police officers from <place>
 * @param  {int} playerid
 * @param  {string} place   - address place of call
 */
function policeCall(playerid, place) {
    if (!place || place.len() < 1) {
        return msg(playerid, "organizations.police.call.withoutaddress");
    }

    msg(playerid, "organizations.police.call.foruser", [place], CL_ROYALBLUE);

    foreach(player in playerList.getPlayers()) {
        if ( isOfficer(player) && isOnPoliceDuty(player) ) {
            msg(player, "organizations.police.call.new", [getAuthor(playerid), place], CL_ROYALBLUE);
        }
    }
}

/**
 * Become police officer
 * @param  {int} playerid
 */
function getPoliceJob(playerid) {
/*
    if( isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.alreadyofficer");
    }

    if (isPlayerHaveJob(playerid)) {
        return msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid));
    }
*/
    // set first rank
    setPlayerJob( playerid, setPoliceRank(playerid, 0) );
    //policeSetOnDuty(playerid, false);
    msg(playerid, "organizations.police.onbecame");
}


/**
 * Leave from police
 * @param  {int} playerid
 */
function leavePoliceJob(playerid) {
    if(!isOfficer(playerid)) {
        return msg(playerid, "organizations.police.notanofficer");
    }

    if (isPlayerHaveJob(playerid) && !isOfficer(playerid)) {
        return msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid));
    }

    if (isOnPoliceDuty(playerid)) {
        policeSetOnDuty(playerid, false);
    }
    setPlayerJob( playerid, null );
    msg(playerid, "organizations.police.onleave");
}

/**
 * Check is player's vehicle is a police car
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerInPoliceVehicle(playerid) {
    return (isPlayerInValidVehicle(playerid, 42) || isPlayerInValidVehicle(playerid, 51) || isPlayerInValidVehicle(playerid, 21));
}


/**
 * Check if player is a police officer
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isOfficer(playerid) {
    if (!(playerid in players)) {
        return false;
    }

    // return if playerjob (might be job.police.officer)
    return (POLICE_RANK.find(players[playerid].job) != null);
}

/**
 * Check if player is a police officer and on duty now
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isOnPoliceDuty(playerid) {
    return (isOfficer(playerid) && playerid in police && police[playerid].onduty);
}

function policeSetOnDuty(playerid, bool) {
    if (!(playerid in police)) {
        police[playerid] <- {};
        police[playerid]["ondutyminutes"] <- 0;
    }

    police[playerid].onduty <- bool;

    if (bool) {
        return screenFadeinFadeout(playerid, 100, function() {
            // onPoliceDutyGiveWeapon( playerid );
            trigger("onPoliceDutyOn", playerid);
            setPlayerModel(playerid, POLICE_MODEL);
            msg(playerid, "organizations.police.duty.on");
        });
    } else {
        // onPoliceDutyRemoveWeapon( playerid );
        trigger("onPoliceDutyOff", playerid);
        return screenFadeinFadeout(playerid, 100, function() {
            setPlayerModel(playerid, players[playerid]["default_skin"]);
            msg(playerid, "organizations.police.duty.off");

            policeJobPaySalary( playerid );
        });
    }
}

/**
 * Return integer with player rank
 * @param  {integer} playerid
 * @return {Integer} player rank
 */
function getPoliceRank(playerid) {
    return POLICE_RANK.find(players[playerid].job);
}

/**
 * Set player rank to given ID
 * @param  {integer} playerid
 * @param  {integer} rank number
 * @return {string}  player rank
 */
function setPoliceRank(playerid, rankID) {
    if (rankID >= 0 && rankID < POLICE_RANK.len()) {
        players[playerid].job = POLICE_RANK[rankID];
        return POLICE_RANK[rankID];
    }
    return players[playerid].job;
}

/**
 * Retrun true if player didn't reach MAX_RANK
 * @param  {[type]}  playerid [description]
 * @return {Boolean}          [description]
 */
function isPoliceRankUpPossible(playerid) {
    return (getPoliceRank(playerid) != null && getPoliceRank(playerid) < MAX_RANK);
}

/**
 * Increment rank if it's not MAX_RANK
 * @param  {[type]} playerid [description]
 * @return {[type]}          [description]
 */
function rankUpPolice(playerid) {
    if (isPoliceRankUpPossible(playerid)) {
        // increase rank
        setPoliceRank(playerid, getPoliceRank(playerid) + 1);

        // send message
        msg( playerid, "organizations.police.onrankup", [ getLocalizedPlayerJob(playerid) ] );
    } else {
        msg( playerid, "organizations.police.job.getmaxrank", [ localize( "job." + POLICE_RANK[MAX_RANK], [], getPlayerLocale(playerid)) ] );
    }
}

/**
 * Show police 
 * @param  {[type]} playerid [description]
 * @param  {[type]} targetid [description]
 * @return {[type]}          [description]
 */
function showBadge(playerid, targetid = null) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.notanofficer");
    }

    if ( !isOnPoliceDuty(playerid) ) {
        return msg(playerid, "organizations.police.offduty.nobadge");
    }

    if (targetid != null) {
        targetid = targetid.tointeger();
    } else {
        targetid = playerList.nearestPlayer( playerid );
    }

    if ( targetid == null) {
        return msg(playerid, "general.noonearound");
    }

    msg(playerid, "organizations.police.beenshown.badge", [getAuthor(targetid)]);
    msg(targetid, "organizations.police.show.badge", [getPoliceRank(playerid), getAuthor(targetid)]);
}


// function onPoliceDutyGiveWeapon(playerid, rank = null) {
//     if (rank == null) {
//         rank = getPlayerJob(playerid);
//     }

//     if (rank == POLICE_RANK[0]) {
//         givePlayerWeapon( playerid, 2, 42 ); // Model 12 Revolver
//     }
//     if (rank == POLICE_RANK[1]) {
//         givePlayerWeapon( playerid, 4, 56 ); // Colt M1911A1
//         //givePlayerWeapon( playerid, 8, 48 ); // Remington Model 870 Field gun // on RED level
//     }
//     if (rank == POLICE_RANK[2]) {
//         givePlayerWeapon( playerid, 6, 42 ); // Model 19 Revolver
//         //givePlayerWeapon( playerid, 8, 48 ); // Remington Model 870 Field gun // on RED level
//         givePlayerWeapon( playerid, 12, 120 ); // M1A1 Thompson
//     }
// }


// function onPoliceDutyRemoveWeapon(playerid, rank = null) {
//     if (rank == null) {
//         rank = getPlayerJob(playerid);
//     }

//     if (rank == POLICE_RANK[0]) {
//         removePlayerWeapon( playerid, 2 ); // Model 12 Revolver

//         // thompon on RED level
//     }
//     if (rank == POLICE_RANK[1]) {
//         removePlayerWeapon( playerid, 4 ); // Colt M1911A1
//         //removePlayerWeapon( playerid, 8 ); // Remington Model 870 Field gun // on RED level
//     }
//     if (rank == POLICE_RANK[2]) {
//         removePlayerWeapon( playerid, 6 ); // Model 19 Revolver
//         //removePlayerWeapon( playerid, 8 ); // Remington Model 870 Field gun // on RED level
//         removePlayerWeapon( playerid, 12 ); // M1A1 Thompson
//     }
// }
