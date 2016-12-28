class Officer {
    constructor (playerid) {
        setPlayerJob( playerid, setPoliceRank(playerid, 0) ); // set first rank
        //policeSetOnDuty(playerid, false);
        msg(playerid, "organizations.police.onbecame");
    }

    /**
     * Leave from police
     * @param  {int} playerid
     */
    function destructor(playerid) {
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

    function isInDutyVehicle(playerid) {
        return (isPlayerInValidVehicle(playerid, 42) || isPlayerInValidVehicle(playerid, 51) || isPlayerInValidVehicle(playerid, 21));
    }


    function isNearPoliceDepartment(playerid) {
        return isInRadius(playerid, POLICE_EBPD_ENTERES[1][0], POLICE_EBPD_ENTERES[1][1], POLICE_EBPD_ENTERES[1][2], EBPD_ENTER_RADIUS);
    }

    function isOnDuty(playerid) {
        return (isOfficer(playerid) && playerid in police && police[playerid].onduty);
    }

    function setOnDutyState(playerid, bool) {
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

    function getRank(playerid) {
        return POLICE_RANK.find(players[playerid].job);
    }

    function setRank(playerid, rankID) {
        if (rankID >= 0 && rankID < POLICE_RANK.len()) {
            players[playerid].job = POLICE_RANK[rankID];
            return POLICE_RANK[rankID];
        }
        return players[playerid].job;
    }

    function isRankChangePossible(playerid) {
        return (getRank(playerid) != null && (getRank(playerid) < MAX_RANK || getRank(playerid) >= 0));
    }

    function rankUp(playerid) {
        if (isRankChangePossible(playerid)) {
            setRank(playerid, getRank(playerid) + 1);
            msg( playerid, "organizations.police.onrankup", [ getLocalizedPlayerJob(playerid) ] );
        } else {
            msg( playerid, "organizations.police.job.getmaxrank", [ localize( "job." + POLICE_RANK[MAX_RANK], [], getPlayerLocale(playerid)) ] );
        }
    }
}
