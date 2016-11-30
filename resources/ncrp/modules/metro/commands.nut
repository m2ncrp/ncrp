cmd( ["sub", "subway", "metro"], function( playerid, id = null ) {
    metroGo( playerid, id );
});

cmd( ["sub", "subway", "metro"], "list", function( playerid) {
    return metroShowListStations( playerid );
});

function metroHelp ( playerid ) {
    local title = "metro.help.title";
    local commands = [
        { name = "/subway id",      desc = "metro.help.subway" },
        { name = "/subway list",    desc = "metro.help.subwayList" },
        { name = "/sub id",         desc = "metro.help.sub" },
        { name = "/metro id",       desc = "metro.help.metro" }
    ];
    msg_help(playerid, title, commands);
}

cmd(["help", "h", "halp", "info"], "subway", metroHelp);
cmd(["help", "h", "halp", "info"], "metro", metroHelp);
cmd(["help", "h", "halp", "info"], "sub", metroHelp);
