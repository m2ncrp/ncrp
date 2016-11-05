cmd( ["subway", "metro", "sub", "met"], function( playerid, id ) {
    local id = id.tointeger();
    if (id < HEAD) {  id = HEAD;  }
    if (id > TAIL) {  id = TAIL;  }

    log( "Chosen " + metroInfos[id][3] );

    local ticketCost = 1500.25;

    if ( isNearStation(playerid) ) {
        if ( canMoneyBeSubstracted(playerid, ticketCost) ) {
            screenFadeinFadeout(playerid, 2000, function() {
                subMoneyToPlayer(playerid, ticketCost); // don't forget took money for ticket ~ 25 cents
                msg(playerid, "You pay $" + ticketCost + " for ticket. Now you have $" + getPlayerBalance(playerid) );
                setPlayerPosition(playerid, metroInfos[id][0], metroInfos[id][1], metroInfos[id][2]);
            });
        } else {
            msg(playerid, "Not enough money bitch!", CL_RED);
        }
    }
});
