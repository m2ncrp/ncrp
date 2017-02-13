cmd( ["sub", "subway", "metro"], function( playerid, stationID = null ) {
    //travelToStation( playerid, stationID );

    showNearestMetroBlip(playerid);
    msg(playerid, "metro.station.nearest.showblip", [ plocalize(playerid, getNearestStation(playerid)[10]) ] );
});


cmd( ["sub", "subway", "metro"], "list", function( playerid) {
    return metroShowListStations( playerid );
});

key("e", function(playerid) {
    showMetroGUI( playerid );
}, KEY_UP);


function metroHelp ( playerid ) {
    local title = "metro.help.title";
    local commands = [
        { name = "/subway ID",      desc = "metro.help.subway" },
        { name = "/subway list",    desc = "metro.help.subwayList" },
        { name = "/sub ID",         desc = "metro.help.sub" },
        { name = "/metro ID",       desc = "metro.help.metro" }
    ];
    msg_help(playerid, title, commands);
}

cmd(["help", "h", "halp", "info"], "subway", metroHelp);
cmd(["help", "h", "halp", "info"], "metro", metroHelp);
cmd(["help", "h", "halp", "info"], "sub", metroHelp);



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
