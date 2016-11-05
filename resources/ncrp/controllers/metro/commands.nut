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
                setPlayerPosition(playerid, metroInfos[id][0], metroInfos[id][1], metroInfos[id][2]);
            });
    }
});



