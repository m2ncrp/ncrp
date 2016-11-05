cmd( ["sub", "subway", "metro"], function( playerid, id ) {
    local id = id.tointeger();
    if (id < HEAD) {  id = HEAD;  }
    if (id > TAIL) {  id = TAIL;  }

    local ticketCost = 0.25;

    if ( isNearStation(playerid) ) {
        if ( !canMoneyBeSubstracted(playerid, ticketCost) ) {
            return msg(playerid, "Not enough money!", CL_RED);
        }
        screenFadeinFadeout(playerid, 2000, function() {
            subMoneyToPlayer(playerid, ticketCost); // don't forget took money for ticket ~ 25 cents
            msg(playerid, "You pay $" + ticketCost + " for ticket. Now you have $" + getPlayerBalance(playerid) );
            msg(playerid, "You arrived to " + metroInfos[id][4]);
            setPlayerPosition(playerid, metroInfos[id][0], metroInfos[id][1], metroInfos[id][2]);
        });
    }
});

cmd(["help", "h", "halp", "info"], ["subway", "metro", "sub"], function(playerid) {
    local title = "List of available commands for SUBWAY:";
    local commands = [
        { name = "/subway <id>",    desc = "Analog /subway <id>" },
        { name = "/subway 0",       desc = "Dipton station" },
        { name = "/subway 1",       desc = "Uptown station" },
        { name = "/subway 2",       desc = "Chinatown station" },
        { name = "/subway 3",       desc = "Southport station" },
        { name = "/subway 4",       desc = "West Side station" },
        { name = "/subway 5",       desc = "Sand Island station" },
        { name = "/subway 6",       desc = "Kingston station" },
        { name = "/sub <id>",       desc = "Analog /subway <id>" },
        { name = "/metro <id>",     desc = "Analog /subway <id>" }
    ];
    msg_help(playerid, title, commands);
});
