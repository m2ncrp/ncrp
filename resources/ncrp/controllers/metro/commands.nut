cmd( ["sub", "subway", "metro"], function( playerid, id = null ) {
    if (id == null) {
        return showAllStations(playerid);
    }

    local id = id.tointeger();
    if (id < HEAD) {  id = HEAD;  }
    if (id > TAIL) {  id = TAIL;  }

    local ticketCost = 0.25;

    if ( isNearStation(playerid) ) {
        if ( !canMoneyBeSubstracted(playerid, ticketCost) ) {
            return msg(playerid, "Not enough money!", CL_RED);
        }
        togglePlayerControls( playerid, true );
        screenFadeinFadeout(playerid, 2000, function() {
            subMoneyToPlayer(playerid, ticketCost); // don't forget took money for ticket ~ 25 cents
            msg(playerid, "You pay $" + ticketCost + " for ticket. Now you have $" + getPlayerBalance(playerid) );
            msg(playerid, "You arrived to " + metroInfos[id][3] + " station.");
            setPlayerPosition(playerid, metroInfos[id][0], metroInfos[id][1], metroInfos[id][2]);
        }, function() {
            togglePlayerControls( playerid, false );
        });
    }
});

cmd( ["sub", "subway", "metro"], "all", function( playerid, id = null ) {
    return showAllStations(playerid);
});

cmd(["help", "h", "halp", "info"], "subway", function(playerid) {
    local title = "List of available commands for SUBWAY:";
    local commands = [
        { name = "/subway all",     desc = "Show all stations" },
        { name = "/subway <id>",    desc = "Move to station by id" },
        { name = "/sub <id>",       desc = "Analog /subway <id>" },
        { name = "/metro <id>",     desc = "Analog /subway <id>" }
    ];
    msg_help(playerid, title, commands);
});
