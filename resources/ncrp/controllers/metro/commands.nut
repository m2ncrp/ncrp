cmd( ["sub"], function( playerid, id ) { 
	id = id.tointeger();
	if (id < 1)	id = 1;
	if (id > 6)	id = 6;

    log( "Chosen " + metroInfos[id][3] );

    // foreach (index, value in metroInfos) {
        setPlayerPosition(playerid, metroInfos[id][0], metroInfos[id][1], metroInfos[id][2]);
    // }   
});
