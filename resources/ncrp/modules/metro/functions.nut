/**
 * Check whitch station player near to.
 * @param  {uint}  playerid
 * @return {Boolean}
 */
function isNearStation(playerid) {
    foreach (key, station in metroInfos) {
        if ( isInRadius(playerid, station[0], station[1], station[2], METRO_RADIUS) ) {
            return (true) ? key : "faraway";
        }
    }
    return "faraway";
}

/**
 * Check if station with given ID currently avaliable on server
 * @param  {integer}  stationID
 * @return {Boolean}
 */
function isStationAvaliable(stationID) {
    foreach (index, station in metroInfos) {
        if ( index == stationID && station[9] == METRO_KEY_AVALIABLE ) {
            return true;
        }
    }
    return false;
}

/**
 * Calculate fade screen time to move player to given stations
 * @param  {byte} stationID
 * @return {uint} fade time duration
 */
function metroCalculateTravelTime( stationID ) {
    // Code
}


function travelToStation( playerid, id = null ) {
    if (id == null) {
        return metroShowListStations(playerid);
    }

    local id = id.tointeger();
    //if (id < METRO_HEAD) {  id = METRO_HEAD;  }
    //if (id > METRO_TAIL) {  id = METRO_TAIL;  }

    id -= 1; //for correct

    local isNear = isNearStation( playerid );

    if ( isNear == "faraway") {
        return msg(playerid, "metro.toofaraway", CL_RED);
    }

    if( isPlayerInVehicle( playerid ) ) {
        return msg(playerid, "metro.nocar", CL_RED);
    }

    if ( isNumeric(isNear) ) {

        if (id < METRO_HEAD || id > METRO_TAIL) {
            return msg(playerid, "metro.notexist", CL_RED);
        }

        if ( id == isNear ) {
            return msg(playerid, "metro.herealready", CL_RED);
        }

        if ( !canMoneyBeSubstracted(playerid, METRO_TICKET_COST) ) {
            return msg(playerid, "metro.notenoughmoney", CL_RED);
        }
        onTavelToStation(playerid, id);
    }
}


/**
 * What happens while player travel from one station to another.
 * @param  {uint} playerid
 * @param  {uint} id        station ID
 * @return {void}
 */
function onTavelToStation(playerid, id) {
    //local travelTime = metroCalculateTravelTime(stationID);

    togglePlayerControls( playerid, true );
    screenFadeinFadeout(playerid, 500, function() {
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
    msg(playerid, "==================================", CL_HELP_LINE);
    msg(playerid, "metro.listStations.title", CL_HELP_TITLE);
    foreach (index, station in metroInfos) {
        msg(playerid, "metro.listStations.station", [(index+1), station[3]], CL_WHITE);
    }
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
