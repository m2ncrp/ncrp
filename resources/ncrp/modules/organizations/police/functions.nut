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
    local pos = getPlayerPositionObj(playerid); 

    foreach(player in playerList.getPlayers()) {
        if ( isOfficer(player) && isOnPoliceDuty(player) || isPlayerAdmin(player) ) {
            local crime_hash = createPrivateBlip(player, pos.x, pos.y, ICON_YELLOW, 4000.0);

            delayedFunction(60000, function() { // <----------------------------------------- need check for more than 2 people
                removeBlip( crime_hash );
            });

            msg(player, "organizations.police.call.new", [place], CL_ROYALBLUE);
        }
    }
}

function setDangerLevel(playerid, to) {
    DENGER_LEVEL = to;
    trigger("onPoliceDutyOff", playerid);
    trigger("onPoliceDutyOn", playerid);
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


function isPlayerNearPoliceDepartment(playerid) {
    return isInRadius(playerid, POLICE_EBPD_ENTERES[1][0], POLICE_EBPD_ENTERES[1][1], POLICE_EBPD_ENTERES[1][2], EBPD_ENTER_RADIUS);
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
    msg(targetid, "organizations.police.show.badge", [getLocalizedPlayerJob(playerid), getAuthor(targetid)]);
}


function baton( playerid ) {
    if ( !isOfficer(playerid) ) {
        return msg( playerid, "organizations.police.notanofficer" );
    }

    if ( isOnPoliceDuty(playerid) ) {
        local targetid = playerList.nearestPlayer( playerid );
        if ( targetid == null ) {
            return msg(playerid, "general.noonearound");
        }

        if ( isPlayerInVehicle(targetid) ) {
            return;
        }

        if ( isBothInRadius(playerid, targetid, BATON_RADIUS) ) {
            trigger("onBatonBitStart", playerid);
            screenFadeinFadeout(targetid, 1000, function() {
                msg( playerid, "organizations.police.bitsomeone.bybaton", [getAuthor(targetid)] );
                msg( targetid, "organizations.police.beenbit.bybaton" );
                if ( getPlayerState(targetid) == "free" ) {
                    setPlayerToggle( targetid, true );
                    setPlayerState(targetid, "tased");
                }
            }, function() {
                if ( getPlayerState(targetid) == "tased" ) {
                    setPlayerToggle( targetid, false );
                    setPlayerState(targetid, "free");
                }
            });

            // setPlayerAnimStyle(playerid, "common", "default");
            // setPlayerHandModel(playerid, 1, 0); // remove policedubinka right hand
        }        
    } else {
        return msg(playerid, "organizations.police.offduty.nobaton")
    }
}


function cuff(playerid) {
    if ( isOnPoliceDuty(playerid) ) {
        local targetid = playerList.nearestPlayer( playerid );

        if ( targetid == null ) {
            return msg(playerid, "general.noonearound");
        }

        if ( isBothInRadius(playerid, targetid, CUFF_RADIUS) ) {
            if ( getPlayerState(targetid) == "tased" ) {
                setPlayerToggle( targetid, true ); // cuff dat bitch
                setPlayerState(targetid, "cuffed");
                msg(targetid, "organizations.police.beencuffed", [getAuthor( playerid )]);
                msg(playerid, "organizations.police.cuff.someone", [getAuthor( targetid )]);
                return;
            }
            if ( getPlayerState(targetid) == "cuffed" ) {
                setPlayerToggle( targetid, false ); // uncuff him...
                setPlayerState(targetid, "free");
                msg(targetid, "organizations.police.cuff.beenuncuffed", [getAuthor( playerid )] );
                msg(playerid, "organizations.police.cuff.uncuffsomeone", [getAuthor( targetid )] );
                return;
            }
            // throw out cuffes and disable arrest any players till officer didn't take them from the ground 
        }
    }
}


function putInJail(playerid, targetid) {
    if ( isOnPoliceDuty(playerid) && getPlayerState(targetid) == "cuffed" ) {
        setPlayerState(targetid, "jail");
        setPlayerToggle(targetid, false);
        screenFadeinFadeoutEx(targetid, 250, 200, function() {
        //  output "Wasted" and set player position
            setPlayerState(targetid, "jail");
            setPlayerPosition( targetid, POLICE_JAIL_COORDS[0][0], POLICE_JAIL_COORDS[0][1], POLICE_JAIL_COORDS[0][2] );
        });
        msg(targetid, "organizations.police.jail", [], CL_THUNDERBIRD);
        dbg( "[JAIL] " + getAuthor(playerid) + " put " + getAuthor(targetid) + "in jail." );
    }
}


function takeOutOfJail(playerid, targetid) {
    if ( isOnPoliceDuty(playerid) ) {
        setPlayerPosition(targetid, POLICE_EBPD_ENTERES[1][0], POLICE_EBPD_ENTERES[1][1], POLICE_EBPD_ENTERES[1][2]); // police department
        //setPlayerRotation(targetid, -137.53, 0.00309768, -0.00414733);

        screenFadeinFadeoutEx(targetid, 250, 200, function() {
            // setPlayerToggle(targetid, false);
            setPlayerState(targetid, "free");
        });
        msg(targetid, "organizations.police.unjail", [], CL_THUNDERBIRD);
    }
}
