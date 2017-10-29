POLICE_EBPD_GARAGE <- [-313.822, 697.219, -18.8391];

event("onServerStarted", function() {
    create3DText( POLICE_EBPD_GARAGE[0], POLICE_EBPD_GARAGE[1], POLICE_EBPD_GARAGE[2]+0.35, "=== EMPIRE BAY POLICE DEPARTMENT GARAGE ===", CL_ROYALBLUE, EBPD_TITLE_DRAW_DISTANCE );
    create3DText( POLICE_EBPD_GARAGE[0], POLICE_EBPD_GARAGE[1], POLICE_EBPD_GARAGE[2]+0.20, "/police repair", CL_WHITE.applyAlpha(150), EBPD_ENTER_RADIUS );
    create3DText( POLICE_EBPD_GARAGE[0], POLICE_EBPD_GARAGE[1], POLICE_EBPD_GARAGE[2]+0.05, "/police wash", CL_WHITE.applyAlpha(150), EBPD_ENTER_RADIUS );
});

function isNearPoliceGarage(playerid) {
    if (isPlayerVehicleInValidPoint(playerid, POLICE_EBPD_GARAGE[0], POLICE_EBPD_GARAGE[1], EBPD_ENTER_RADIUS )) {
        return true;
    }
    return false;
}

/**
 * Repair player car
 * @param  {integer}    playerid
 * @return {void}
 */
function repairPoliceDutyVehicle(playerid) {
    if ( !isNearPoliceGarage(playerid) ) {
       return msg(playerid, "organizations.police.toofarfromgarage", CL_ROYALBLUE);
    }

    if(!isOfficer(playerid)) {
        return msg(playerid, "organizations.police.notanofficer", CL_ROYALBLUE);
    }

    if ( !isOnPoliceDuty(playerid) ) {
        return msg( playerid, "organizations.police.duty.not", CL_ROYALBLUE);
    }

    if ( !isPlayerInPoliceVehicle(playerid) ) {
        return msg( playerid, "organizations.police.notpolicevehicle", CL_ROYALBLUE);
    }

    msg(playerid, "organizations.police.wait");
    delayedFunction(1000, function() {
        screenFadeinFadeoutEx(playerid, 250, 3000, null, function() {
            local vehicleid = getPlayerVehicle(playerid);
            repairVehicle( vehicleid );
            return msg(playerid, "organizations.police.completed", CL_ROYALBLUE);
        });
    });
}

/**
 * Wash player car
 * @param  {integer}    playerid
 * @return {void}
 */
function washPoliceDutyVehicle(playerid) {
    if ( !isNearPoliceGarage(playerid) ) {
       return msg(playerid, "organizations.police.toofarfromgarage", CL_ROYALBLUE);
    }

    if(!isOfficer(playerid)) {
        return msg(playerid, "organizations.police.notanofficer", CL_ROYALBLUE);
    }

    if ( !isOnPoliceDuty(playerid) ) {
        return msg( playerid, "organizations.police.duty.not", CL_ROYALBLUE);
    }

    if ( !isPlayerInPoliceVehicle(playerid) ) {
        return msg( playerid, "organizations.police.notpolicevehicle", CL_ROYALBLUE);
    }

    msg(playerid, "organizations.police.wait");
    delayedFunction(1000, function() {
        screenFadeinFadeoutEx(playerid, 250, 3000, null, function() {
            local vehicleid = getPlayerVehicle(playerid);
            setVehicleDirtLevel (vehicleid, 0.0);
            return msg(playerid, "organizations.police.completed", CL_ROYALBLUE);
        });
    });
}


cmd("police", ["repair"], function(playerid) {
    repairPoliceDutyVehicle(playerid);
});

cmd("police", ["wash"], function(playerid) {
    washPoliceDutyVehicle(playerid);
});
