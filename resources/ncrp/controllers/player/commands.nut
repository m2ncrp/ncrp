cmd(["spawn"], function(playerid) {
    setPlayerPosition( playerid, -1551.560181, -169.915466, -19.672523 );
    setPlayerHealth( playerid, 720.0 );
});

cmd(["weapons"], function(playerid) {
    givePlayerWeapon( playerid, 2, 2500 );
    givePlayerWeapon( playerid, 3, 2500 );
    givePlayerWeapon( playerid, 4, 2500 );
    givePlayerWeapon( playerid, 5, 2500 );
    givePlayerWeapon( playerid, 6, 2500 );
    givePlayerWeapon( playerid, 8, 2500 );
    givePlayerWeapon( playerid, 9, 2500 );
    givePlayerWeapon( playerid, 10, 2500 );
    givePlayerWeapon( playerid, 11, 2500 );
    givePlayerWeapon( playerid, 13, 2500 );
    givePlayerWeapon( playerid, 15, 2500 );
    givePlayerWeapon( playerid, 17, 2500 );
    //player:InventoryAddItem(36) -- отмычки
});

cmd(["heal"], function( playerid ) {
    setPlayerHealth( playerid, 720.0 );
});

cmd(["die"], function( playerid ) {
    setPlayerHealth( playerid, 0.0 );
});

cmd(["skin"], function( playerid, id ) {
    setPlayerModel( playerid, id.tointeger() );
    players[playerid]["skin"] = id.tointeger();
    players[playerid]["default_skin"] = id.tointeger();
});


cmd(["skininc"], function ( playerid ) {
    local skin = players[playerid]["skin"];
    if ( skin < 171) {
        skin += 1;
        setPlayerModel( playerid, skin );
        players[playerid]["skin"] = skin;
        players[playerid]["default_skin"] = skin;
        msg( playerid,  "Skin model changed on " + skin );
    } else {
        msg( playerid,  "Skin top limit" );
    }
});

cmd(["skindec"], function ( playerid ) {
    local skin = players[playerid]["skin"];
    if ( skin > 0) {
        skin -= 1;
        setPlayerModel( playerid, skin );
        players[playerid]["skin"] = skin;
        players[playerid]["default_skin"] = skin;
        msg( playerid,  "Skin model changed on " + skin );
    } else {
        msg( playerid,  "Skin lower limit" );
    }
});

cmd("checkmyjob", function ( playerid ) {
    local job = getPlayerJob(playerid);
    if(job) {
        msg( playerid, "job.checkmyjob", getLocalizedPlayerJob(playerid) );
    } else {
        msg( playerid, "job.unemployed" );
    }
});
