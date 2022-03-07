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
        trigger("onPlayerPhonePut", playerid);
        return msg(playerid, "organizations.police.call.no", [], CL_ROYALBLUE);
    }

    msg(playerid, "organizations.police.call.foruser", [ plocalize(playerid, place) ], CL_ROYALBLUE);
    // dbg("chat", "police", getAuthor(playerid), localize( place, [], "ru") );

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
    trigger("onPlayerPhonePut", playerid);
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
function setPoliceJob(playerid, targetid, rankId) {
    if( isOfficer(targetid) ) {
        return msg(targetid, "organizations.police.alreadyofficer");
    }

    // set first rank
    setPlayerJob(targetid, POLICE_RANK[rankId]);

    nano({
        "path": "discord",
        "server": "police",
        "channel": "news",
        "action": "join",
        "author": getPlayerName(playerid),
        "title": getPlayerName(targetid),
        "description": "Принят на службу",
        "color": "green",
        "datetime": getVirtualDate(),
        "fields": [
            ["Должность",  getLocalizedPlayerJob(targetid)]
        ]
    })
}


/**
 * Leave from police
 * @param  {int} playerid
 */
function leavePoliceJob(playerid, targetid, reason) {

    if(!isOfficer(targetid)) {
        return msg(targetid, "organizations.police.notanofficer");
    }

    if (isOnPoliceDuty(targetid)) {
        policeSetOnDuty(targetid, false);
    }

    msg(targetid, "organizations.police.onleave");
    nano({
        "path": "discord",
        "server": "police",
        "channel": "news",
        "action": "leave",
        "author": getPlayerName(playerid),
        "title": getPlayerName(targetid),
        "description": "Уволен со службы",
        "color": "red",
        "datetime": getVirtualDate(),
        "fields": [
            ["Должность", getLocalizedPlayerJob(targetid)],
            ["Причина", reason]
        ]
    });
    setPlayerJob(targetid, null);
}

/**
 * Check is player's vehicle is a police car
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerInPoliceVehicle(playerid) {
    if(!isPlayerInVehicle(playerid)) return false;
    local vehicleid = getPlayerVehicle(playerid);
    return isVehicleidPoliceVehicle(vehicleid)
}

function isVehicleidPoliceVehicle(vehicleid) {
    local model = getVehicleModel( vehicleid );
    return ( model == 42 ) || ( model == 51 ) || ( model == 21 ) || ( model == 50 && getVehiclePlateText(vehicleid) == "PD-191");
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

/**
 * Check if officer on duty now
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isOfficerOnDuty(playerid) {
    return (playerid in police && police[playerid].onduty);
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
function showPoliceBadge(playerid, targetid = null) {
    if (targetid != null) {
        targetid = targetid.tointeger();
    } else {
        targetid = playerList.nearestPlayer( playerid );
    }

    if (targetid == null) {
        return msg(playerid, "general.noonearound");
    }

    msg(playerid, "organizations.police.beenshown.badge", [getAuthor(targetid)]);
    msg(targetid, "organizations.police.show.badge", [getLocalizedPlayerJob(playerid), getAuthor(playerid)]);
}

function putInJail(playerid, targetid, reason) {
    if ( isOnPoliceDuty(playerid) && getPlayerState(targetid) == "cuffed" ) {
        setPlayerState(targetid, "jail");
        screenFadeinFadeoutEx(targetid, 250, 200, function() {
        //  output "Wasted" and set player position
            setPlayerPosition( targetid, POLICE_JAIL_COORDS.jail[0], POLICE_JAIL_COORDS.jail[1], POLICE_JAIL_COORDS.jail[2] );
            freezePlayer(targetid, false);
        });
        msg(targetid, "organizations.police.jail", [], CL_THUNDERBIRD);
        msg(playerid, format("Вы посадили в тюрьму %s по причине: %s", getKnownCharacterNameWithId(playerid, targetid), reason), [], CL_THUNDERBIRD);
        nano({
            "path": "discord",
            "server": "police",
            "channel": "jail",
            "action": "put",
            "author": getPlayerName(playerid),
            "title": getKnownCharacterName(playerid, targetid),
            "description": "Отправлен в тюрьму",
            "color": "red",
            "datetime": getVirtualDate(),
            "fields": [
                ["Причина", reason]
            ]
        });
    }
}


function takeOutOfJail(playerid, targetid) {
    if ( isOnPoliceDuty(playerid) ) {
        setPlayerPosition(targetid, POLICE_JAIL_COORDS.exit[0], POLICE_JAIL_COORDS.exit[1], POLICE_JAIL_COORDS.exit[2]);
        //setPlayerRotation(targetid, -137.53, 0.00309768, -0.00414733);

        screenFadeinFadeoutEx(targetid, 250, 200, function() {
            setPlayerState(targetid, "free");
        });
        msg(targetid, "organizations.police.unjail", [], CL_SUCCESS);
        msg(playerid, format("Вы выпустиили из тюрьмы %s", getKnownCharacterName(playerid, targetid)), [], CL_SUCCESS);
        nano({
            "path": "discord",
            "server": "police",
            "channel": "jail",
            "action": "out",
            "author": getPlayerName(playerid),
            "title": getKnownCharacterName(playerid, targetid),
            "description": "Выпущен из тюрьмы",
            "color": "green",
            "datetime": getVirtualDate(),
        });
    }
}


function getVehicleWantedForTax() {
    local vehiclesWanted = [];

    foreach (vehicleid, value in __vehicles) {
        if (!value || !value.entity || isVehicleInParking(vehicleid) || value.ownership.ownerid == 4 || value.ownership.owner == "city" || isGovVehicle(value.entity.plate)) continue;

        local carInfo = getCarInfoModelById( value.entity.model );

        if(("tax" in value.entity.data) && value.entity.data.tax >= carInfo.price * 0.02) {
            vehiclesWanted.push( value.entity.plate );
        }
    }

    return vehiclesWanted;
}


function getHashToPoliceBadge(fullname) {
    local alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];

    local hash = md5(fullname);
    local s = hash.slice(0, 8);

    foreach (idy, letter in alphabet) {
        s = str_replace_ex(letter, "", s)
    }

    if (s.len() > 4) {
        s = s.slice(0, 4);
    } else {
        while(s.len() < 4) {
            s = "0"+s;
        }
    }

    return s;
}

function isCopInPoliceCarOnDuty(playerid) {
    if ( !isOfficer(playerid) ) {
        return false;
    }
    if ( isOfficer(playerid) && !isOnPoliceDuty(playerid) ) {
        return false;
    }

    if ( !isPlayerInPoliceVehicle(playerid) ) {
        return false;
    }
    return true;
}
