/**
 * Call police officers from <place>
 * @param  {int} playerid
 * @param  {string} place   - address place of call
 */
function policeCall(playerid, place) {
    if (!place || place.len() < 1) {
        return msg(playerid, "organizations.police.call.withoutaddress");
    }

    local policeOfficersOnline = false;

    if(police.len() > 0) {
        foreach (player in police) {
            if(player.onduty == true) {
                policeOfficersOnline = true;
            }
        }
    }

    if(!policeOfficersOnline) {
        return msg(playerid, "organizations.police.call.no", [], CL_ROYALBLUE);
    }

    msg(playerid, "organizations.police.call.foruser", [ plocalize(playerid, place) ], CL_ROYALBLUE);
    dbg("chat", "police", getAuthor(playerid), localize( place, [], "ru") );

    local pos = getPlayerPositionObj(playerid);

    foreach (player in players) {
        local id = player.playerid;
        if ( isOfficer(id) && isOnPoliceDuty(id) ) {
            local crime_hash = createPrivateBlip(id, pos.x, pos.y, ICON_YELLOW, 4000.0);

            delayedFunction(60000, function() { // <----------------------------------------- need check for more than 2 people
                removeBlip( crime_hash );
            });

            msg(id, "organizations.police.call.new", plocalize(id, place), CL_ROYALBLUE);
        }
    }
}

function setDangerLevel(playerid, to) {
    DENGER_LEVEL = to;
    foreach(player in police) {
        trigger("onPoliceDutyOff", player.playerid);
        trigger("onPoliceDutyOn", player.playerid);
    }
}

/**
 * Become police officer
 * @param  {int} playerid
 */
function getPoliceJob(playerid) {

    if( isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.alreadyofficer");
    }

    if (isPlayerHaveJob(playerid)) {
        return msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid));
    }

    // set first rank
    setPlayerJob( playerid, setPoliceRank(playerid, 0) );
    // msg(playerid, "organizations.police.onbecame");
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

function isVehicleidPoliceVehicle(vehicleid) {
    local model = getVehicleModel( vehicleid );
    return ( model == 42 ) || ( model == 51 ) || ( model == 21 );
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
    if (!(isPlayerLoaded(playerid))) {
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

    local rank = getPoliceRank(playerid);
    police[playerid].onduty <- bool;

    if (bool) {
        return screenFadeinFadeout(playerid, 100, function() {
            trigger("onPoliceDutyOn", playerid);
            local modelNUM = random( 0, POLICE_RANK_SALLARY_PERMISSION_SKIN[rank][2].len()-1 );
            local model = POLICE_RANK_SALLARY_PERMISSION_SKIN[rank][2][modelNUM];
            setPlayerModel(playerid, model);
            msg(playerid, "organizations.police.duty.on");
        });
    } else {
        trigger("onPoliceDutyOff", playerid);
        //policeJobPaySalary( playerid );
        policeJobDuteMinute( playerid );
        return screenFadeinFadeout(playerid, 100, function() {
            restorePlayerModel(playerid);
            msg(playerid, "organizations.police.duty.off");
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
function setPoliceRank(targetid, rankID) {
    // if (rankID >= 0 && rankID < POLICE_RANK.len()) {
        local oldRankID = getPoliceRank(targetid);

        players[targetid].job = POLICE_RANK[rankID];
        setPlayerJob(targetid, POLICE_RANK[rankID]);
        if (rankID == oldRankID) {
            return POLICE_RANK[rankID];
        } else if (rankID > oldRankID) {
            // msg( playerid, "organizations.police.onrankupsmbd", [getPlayerName(targetid), POLICE_RANK[rankID]]);
            msg( targetid, "organizations.police.onrankup", [ getLocalizedPlayerJob(targetid) ] );
        } else {
            // msg( playerid, "organizations.police.onrankdownsmbd", [getPlayerName(targetid), POLICE_RANK[rankID]]);
            msg( targetid, "organizations.police.onrankdown", [ getLocalizedPlayerJob(targetid) ] );
        }
        return POLICE_RANK[rankID];
    // }
    // return players[targetid].job;
}

/**
 * Retrun true if player didn't reach MAX_RANK
 * @param  {[type]}  playerid [description]
 * @return {Boolean}          [description]
 */
function isPoliceRankUpPossible(playerid) {
    local rank = getPoliceRank(playerid);
    return (getPoliceRank(playerid) != null &&  rank < MAX_RANK);
}

/**
 * Retrun true if player didn't reach MAX_RANK
 * @param  {[type]}  playerid [description]
 * @return {Boolean}          [description]
 */
function isPoliceRankDownPossible(playerid) {
    local rank = getPoliceRank(playerid);
    return (getPoliceRank(playerid) != null && rank > 0);
}

/**
 * Increment rank if it's not MAX_RANK
 * @param  {[type]} playerid [description]
 * @return {[type]}          [description]
 */
function rankUpPolice(playerid) {
    if (isPoliceRankUpPossible(playerid)) {
        // increase rank
        setPlayerJob( playerid,
            setPoliceRank(playerid, getPoliceRank(playerid) + 1)
        );
        // send message
        msg( playerid, "organizations.police.onrankup", [ getLocalizedPlayerJob(playerid) ] );
    } else {
        msg( playerid, "organizations.police.job.getmaxrank", [ localize( "job." + POLICE_RANK[MAX_RANK], [], getPlayerLocale(playerid)) ] );
    }
}

/**
 * Increment rank if it's not MAX_RANK
 * @param  {[type]} playerid [description]
 * @return {[type]}          [description]
 */
function rankDownPolice(playerid) {
    if (isPoliceRankDownPossible(playerid)) {
        // decrease rank
        setPlayerJob( playerid,
            setPoliceRank(playerid, getPoliceRank(playerid) - 1)
        );

        // send message
        msg( playerid, "organizations.police.onrankdown", [ getLocalizedPlayerJob(playerid) ] );
    } else {
        msg( playerid, "organizations.police.job.getminrank", [ localize( "job." + POLICE_RANK[0], [], getPlayerLocale(playerid)) ] );
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
    msg(targetid, "organizations.police.show.badge", [getLocalizedPlayerJob(playerid), getAuthor(playerid)]);
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
            if ( players[targetid].state == "free" || players[targetid].state == "" ) {
                setPlayerToggle( targetid, true );
                setPlayerState(targetid, "tased");
                local health_dmg = random(1,10);
                local health = getPlayerHealth(targetid);
                setPlayerHealth(targetid, health - health_dmg);
            }
            screenFadeinFadeout(targetid, 1500, function() {
                msg( playerid, "organizations.police.bitsomeone.bybaton", [getAuthor(targetid)] );
                msg( targetid, "organizations.police.beenbit.bybaton" );
            }, function() {
                if ( players[targetid].state == "tased" ) {
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
            if ( players[targetid].state == "tased" ) {
                setPlayerToggle( targetid, true ); // cuff dat bitch
                setPlayerState(targetid, "cuffed");
                msg(targetid, "organizations.police.beencuffed", [getAuthor( playerid )]);
                msg(playerid, "organizations.police.cuff.someone", [getAuthor( targetid )]);
                return;
            }
            if ( players[targetid].state == "cuffed" ) {
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
    if ( isOnPoliceDuty(playerid) && players[targetid].state == "cuffed" ) {
        setPlayerState(targetid, "jail");
        setPlayerToggle(targetid, false);
        screenFadeinFadeoutEx(targetid, 250, 200, function() {
        //  output "Wasted" and set player position
            setPlayerState(targetid, "jail");
            setPlayerPosition( targetid, POLICE_JAIL_COORDS.jail[0], POLICE_JAIL_COORDS.jail[1], POLICE_JAIL_COORDS.jail[2] );
        });
        msg(targetid, "organizations.police.jail", [], CL_THUNDERBIRD);
        dbg( "[JAIL] " + getAuthor(playerid) + " put " + getAuthor(targetid) + "in jail." );
    }
}


function takeOutOfJail(playerid, targetid) {
    if ( isOnPoliceDuty(playerid) ) {
        setPlayerPosition(targetid, POLICE_JAIL_COORDS.exit[0], POLICE_JAIL_COORDS.exit[1], POLICE_JAIL_COORDS.exit[2]);
        //setPlayerRotation(targetid, -137.53, 0.00309768, -0.00414733);

        screenFadeinFadeoutEx(targetid, 250, 200, function() {
            // setPlayerToggle(targetid, false);
            setPlayerState(targetid, "free");
        });
        msg(targetid, "organizations.police.unjail", [], CL_THUNDERBIRD);
    }
}


function getVehicleWantedForTax() {
    local vehiclesWanted = [];

    foreach (vehicleid, value in __vehicles) {
        if(value.entity && !isVehicleInParking(vehicleid) && value.ownership.ownerid != 4 && value.entity.plate.find("GOV-") == null ) {
            vehiclesWanted.push( value.entity.plate );
        }
    }

    Item.VehicleTax.findAll(function(err, result){
        local curdateStamp = getDay() + getMonth()*30 + getYear()*360;
        foreach (idx, value in result) {
            local dateStamp = convertDateToTimestamp(value.data["expires"]);
            if(curdateStamp <= dateStamp) {
                if (vehiclesWanted.find(value.data["plate"]) != null) {
                    vehiclesWanted.remove(vehiclesWanted.find(value.data["plate"]));
                }
            }
        }
    });
    return vehiclesWanted;
}
