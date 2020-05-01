cmd("find", "subway", function( playerid, stationID = null ) {
    //travelToStation( playerid, stationID );

    showNearestMetroBlip(playerid);
    msg(playerid, "metro.station.nearest.showblip", [ plocalize(playerid, getNearestStation(playerid)[10]) ] );
});

/*
cmd( ["sub", "subway", "metro"], "list", function( playerid) {
    return metroShowListStations( playerid );
});
*/

key("e", function(playerid) {
    showMetroGUI( playerid );
}, KEY_UP);


// Close station by its ID runtime
acmd( ["sub", "subway", "metro"], ["station", "close"], function( playerid, stationID ) {
    local stationID = stationID.tointeger() - 1;
    return setMetroStationStatus(stationID, true);
});

// Close station by its ID runtime
acmd( ["sub", "subway", "metro"], ["station", "open"], function( playerid, stationID ) {
    local stationID = stationID.tointeger() - 1;
    return setMetroStationStatus(stationID, false);
});
