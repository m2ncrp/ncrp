cmd( ["sub", "subway", "metro"], function( playerid, id = null ) {
    metroGo (playerid, id);
});

cmd( ["sub", "subway", "metro"], "list", function( playerid, id = null ) {
    return metroShowListStations(playerid);
});

cmd(["help", "h", "halp", "info"], "subway", function(playerid) {
    local title = "List of available commands for SUBWAY:";
    local commands = [
        { name = "/subway <id>",    desc = "Move to station by id" },
        { name = "/subway list",    desc = "Show list of all stations" },
        { name = "/sub <id>",       desc = "Analog /subway <id>" },
        { name = "/metro <id>",     desc = "Analog /subway <id>" }
    ];
    msg_help(playerid, title, commands);
});
