cmd(["spawn"], function(playerid) {
    setPlayerPosition( playerid, -1551.560181, -169.915466, -19.672523 );
    setPlayerHealth( playerid, 720.0 );
});

cmd(["weapons"], function(playerid) {
    givePlayerWeapon( playerid, 10, 2500 );
    givePlayerWeapon( playerid, 11, 2500 );
    givePlayerWeapon( playerid, 12, 2500 );
});

cmd(["heal"], function( playerid ) {
    setPlayerHealth( playerid, 720.0 );
});

cmd(["die"], function( playerid ) {
    setPlayerHealth( playerid, 0.0 );
});

cmd(["skin"], function( playerid, id ) {
    setPlayerModel( playerid, id.tointeger() );
});
