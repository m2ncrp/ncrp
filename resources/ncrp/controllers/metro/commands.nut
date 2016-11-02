cmd( ["sub"], function( playerid, id ) { 
	id = id.tointeger();
	if (id < HEAD)	id = HEAD;
	if (id > TAIL)	id = TAIL;

    log( "Chosen " + metroInfos[id][3] );

    if ( isNearStation(playerid) ) {
        screenFadeinFadeout(playerid, 2000, function() {
            // and don't forget took all his money bitch!
            sendPlayerMessage(playerid, "You pay $0.25 for ticket.");
            setPlayerPosition(playerid, metroInfos[id][0], metroInfos[id][1], metroInfos[id][2]);
        });
    } else {
        sendPlayerMessage(playerid, "You are too far from any station!");
    }
    	
});
