cmd( ["sub"], function( playerid, id ) { 
	id = id.tointeger();
	if (id < HEAD)	id = HEAD;
	if (id > TAIL)	id = TAIL;

    log( "Chosen " + metroInfos[id][3] );

    if ( isNearStation(playerid) ) {
        if ( getPlayerBalance(playerid) >= 0.25 ) {
            screenFadeinFadeout(playerid, 2000, function() {
                subMoneyToPlayer(playerid, 0.25); // don't forget took money for ticket ~ 25 cents
                sendPlayerMessage(playerid, "You pay $0.25 for ticket. Now you have $" + getPlayerBalance(playerid) );
                setPlayerPosition(playerid, metroInfos[id][0], metroInfos[id][1], metroInfos[id][2]);
            });
        } else {
            msg(playerid, "You can't afford youself to spend $0.25!");
        }
    } else {
        sendPlayerMessage(playerid, "You are too far from any station!");
    }
    	
});
