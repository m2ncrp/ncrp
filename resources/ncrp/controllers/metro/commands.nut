cmd( ["sub"], function( playerid, id ) { 
	id = id.tointeger();
	if (id < 1)	id = 1;
	if (id > 6)	id = 6;

    log( "Chosen " + metroInfos[id][3] );
    local playerPos = getPlayerPosition( playerid );
    local foundone = false;

    foreach (index, station in metroInfos) {
    	local dist = getDistanceBetweenPoints3D( station[0], station[1], station[2], playerPos[0], playerPos[1], playerPos[2] );
    	foundone = dist < RADIUS;
    	if (foundone) {
        	setPlayerPosition(playerid, metroInfos[id][0], metroInfos[id][1], metroInfos[id][2]);
        	// and don't forget took all his money bitch!
        	break;
    	}
    }

    if (!foundone)
    	sendPlayerMessage(playerid, "You are too far from any station!");
});
