/**
 * Check which station player near to.
 * @param  {uint}   playerid
 * @return {uint}   station index if near to any stations. If not return string "faraway".
 */
function getNearStationIndex(playerid) {
    foreach (key, station in metroInfos) {
        if ( isInRadius(playerid, station[0], station[1], station[2], METRO_RADIUS) ) {
            return key;
        }
    }
    return "faraway";
}

/**
 * Return name of station by given ID
 * @param  {uint} stationID
 * @return {string}
 */
function getSubwayStationNameByID( stationID ) {
    return metroInfos[stationID][3];
}


/**
 * Check if station with given ID currently avaliable on server
 * @param  {uint}  stationID
 * @return {Boolean}
 */
function isStationAvaliable(stationID) {
    if ( metroInfos[stationID][9] == METRO_KEY_AVALIABLE ) {
        return true;
    }
    return false;
}


function setMetroStationStatus(stationID, close) {
    if (stationID < METRO_HEAD || stationID > METRO_TAIL) {
        return msg(playerid, "metro.notexist", CL_RED);
    }

    if (close) {
        metroInfos[stationID][9] = METRO_KEY_UNAVALIABLE;
    } else {
        metroInfos[stationID][9] = METRO_KEY_AVALIABLE;
    }
    
}

/**
 * Calculate fade screen time to move player to given stations
 * @param  {byte} stationID
 * @return {uint} fade time duration
 */
function metroCalculateTravelTime( stationID ) {
    return 500;
}


function travelToStation( playerid, stationID ) {
    if (stationID == null) {
        return metroShowListStations(playerid);
    }
    
    local stationID = toInteger(stationID).tointeger() - 1;

    if (stationID < METRO_HEAD || stationID > METRO_TAIL) {
        return msg(playerid, "metro.notexist", CL_RED);
    }

    local nearestStationID = getNearStationIndex(playerid);

    if ( nearestStationID == "faraway") {
        return msg(playerid, "metro.toofaraway", CL_RED);
    }

    if( isPlayerInVehicle( playerid ) ) {
        return msg(playerid, "metro.nocar", CL_RED);
    }

    if ( isNumeric(nearestStationID) ) {
        if ( !isStationAvaliable(nearestStationID) ) {
            return msg(playerid, "metro.station.closed.maintaince", [ getSubwayStationNameByID(nearestStationID) ]);
        }
        if ( !isStationAvaliable(stationID) ) {
            return msg(playerid, "metro.station.closed.maintaince", [ getSubwayStationNameByID(stationID) ]);
        }
        if ( stationID == nearestStationID ) {
            return msg(playerid, "metro.herealready", CL_RED);
        }

        if ( !canMoneyBeSubstracted(playerid, METRO_TICKET_COST) ) {
            return msg(playerid, "metro.notenoughmoney", CL_RED);
        }
        onTavelToStation(playerid, stationID);
    }
}


/**
 * What happens while player travel from one station to another.
 * @param  {uint} playerid
 * @param  {uint} id        station ID
 * @return {void}
 */
function onTavelToStation(playerid, id) {
    local travelTime = metroCalculateTravelTime(id);

    togglePlayerControls( playerid, true );
    screenFadeinFadeout(playerid, travelTime, function() {
        subMoneyToPlayer(playerid, METRO_TICKET_COST); // don't forget took money for ticket ~ 25 cents
        msg(playerid, "metro.pay", METRO_TICKET_COST );
        msg(playerid, "metro.arrived", metroInfos[id][3]);
        setPlayerPosition(playerid, metroInfos[id][0], metroInfos[id][1], metroInfos[id][2]);
    }, function() {
        afterTravelToStation(playerid);
    });
}


/**
 * What happens after player arrive to station
 * @param  {integer} playerid
 * @return {void}
 */
function afterTravelToStation(playerid) {
    togglePlayerControls( playerid, false );
}


/**
 * Show all stations on the server
 * @param  {integer} playerid
 * @return {void}
 */
function metroShowListStations( playerid ) {
    return metroShowListStationsIncludingUnavaliable( playerid );
}


/**
 * Show only all avaliable stations
 * @param  {uint} playerid
 * @return {void}
 */
function metroShowListAvaliableStations( playerid ) {
    msg(playerid, "==================================", CL_HELP_LINE);
    msg(playerid, "metro.listStations.title", CL_HELP_TITLE);
    foreach (index, station in metroInfos) {
        if ( isStationAvaliable(index) ) {
            msg(playerid, "metro.listStations.station", [(index+1), station[3]], CL_WHITE);
        }
    }
}


/**
 * Show all stations. Closed one marked "(closed)" and paint red
 * @param  {uint} playerid
 * @return {void}
 */
function metroShowListStationsIncludingUnavaliable( playerid ) {
    msg(playerid, "==================================", CL_HELP_LINE);
    msg(playerid, "metro.listStations.title", CL_HELP_TITLE);
    foreach (index, station in metroInfos) {
        if ( isStationAvaliable(index) ) {
            msg(playerid, "metro.listStations.station", [(index+1), station[3]], CL_WHITE);
        }
        if ( !isStationAvaliable(index) ) {
            msg(playerid, "metro.listStations.station.closed", [(index+1), station[3]], CL_THUNDERBIRD);
        }
    }
}
