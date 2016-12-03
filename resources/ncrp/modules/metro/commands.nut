cmd( ["sub", "subway", "metro"], function( playerid, stationID = null ) {
    if (stationID == null) {
        return metroShowListStations(playerid);
    }

    local stationID = stationID.tointeger() - 1;
    if (stationID < METRO_HEAD || stationID > METRO_TAIL) {
        return msg(playerid, "metro.notexist", CL_RED);
    }

    if ( !isStationAvaliable( getNearStationIndex(playerid) ) ) {
        return msg(playerid, "metro.station.closed.maintaince");
    }
    travelToStation( playerid, stationID );
});


cmd( ["sub", "subway", "metro"], "list", function( playerid) {
    return metroShowListStations( playerid );
});


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
    return setMetroStationStatus(stationID, true);
});

// Close station by its ID runtime
acmd( ["sub", "subway", "metro"], ["station", "open"], function( playerid, stationID ) {
    return setMetroStationStatus(stationID, false);
});
