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
    players[playerid]["skin"] = id.tointeger();
});


cmd(["skininc"], function ( playerid ) {
    local skin = players[playerid]["skin"];
    if ( skin < 171) {
        skin += 1;
        setPlayerModel( playerid, skin );
        players[playerid]["skin"] = skin;
        sendPlayerMessage( playerid,  "Skin model changed on " + skin );
    } else {
        sendPlayerMessage( playerid,  "Skin top limit" );
    }
});

cmd(["skindec"], function ( playerid ) {
    local skin = players[playerid]["skin"];
    if ( skin > 0) {
        skin -= 1;
        setPlayerModel( playerid, skin );
        players[playerid]["skin"] = skin;
        sendPlayerMessage( playerid,  "Skin model changed on " + skin );
    } else {
        sendPlayerMessage( playerid,  "Skin lower limit" );
    }
});

addCommandHandler("checkmyjob", function ( playerid ) {
    if(players[playerid]["job"] != null) {
        sendPlayerMessage( playerid, "You're a " + players[playerid]["job"] );
    } else {
        sendPlayerMessage( playerid, "You're unemployed" );
    }
});
