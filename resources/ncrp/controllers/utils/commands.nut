//================================================================================================================================================
//                                                          ADDITIONAL COMMAND
//================================================================================================================================================

addCommandHandler("getGPS", function ( playerid, name ) {
    if( isPlayerInVehicle( playerid ) ) {
        local vehicleid = getPlayerVehicle( playerid ) ;
        local vehicleModel = getVehicleModel ( vehicleid );
        local vehPos = getVehiclePosition( vehicleid );
        local vehRot = getVehicleRotation( vehicleid );
        log( "Vehicle iD: " + vehicleid + " is at "+ vehicleModel + ", " + vehPos[0] + ", " + vehPos[1] + ", " + vehPos[2] + ", " + vehRot[0] + ", " + vehRot[1] + ", " + vehRot[2] + " // " + name );
    } else {
        local plaPos = getPlayerPosition( playerid ) ;
        log( "Player " + playerid + " is at " + plaPos[0] + ", " + plaPos[1] + ", " + plaPos[2] + " // " + name );
    }
}
);


addCommandHandler("getspeed", function ( playerid ) {
    if( isPlayerInVehicle( playerid ) ) {
        local vehicleid = getPlayerVehicle( playerid ) ;
        local velocity = getVehicleSpeed( vehicleid );
        sendPlayerMessage( playerid,  " Current velocity on points is X = " + velocity[0] + ", Y = " + velocity[1] + ", Z = " + velocity[2] + "." );
    }
});


//================================================================================================================================================
//                                                              TELEPORT
//================================================================================================================================================

addCommandHandler("pos", function(playerid, x, y, z) {
    local myPos = getPlayerPosition( playerid );
    setPlayerPosition( playerid, myPos[0]+x.tofloat(), myPos[1]+y.tofloat(), myPos[2]+z.tofloat() );
});

addCommandHandler("gotovinchi", function(playerid) {
    setPlayerPosition( playerid, -1680.47, 955.375, 0.48104 );
});

addCommandHandler("gotobus", function(playerid) {
    setPlayerPosition( playerid, -422.731, 479.462, 0.109218 );
});

//================================================================================================================================================
//                                                          TEST COMMANDS BEGIN
//================================================================================================================================================

// not working
addCommandHandler("getarmoured", function ( playerid ) {
    local myPos = getPlayerPosition( playerid );
    local vehicleid = createVehicle( 27, myPos[0]+5, myPos[1], myPos[2]+0.5, 0.0, 0.0, 0.0 );
    sendPlayerMessage( playerid, "playerid: " + playerid + "; vehicleid: " + vehicleid);
/* --> */    putPlayerInVehicle( playerid, vehicleid, 0 );
    return 1;
});

// not working
addCommandHandler("putto", function ( playerid, vehicleid ) {
/* --> */    putPlayerInVehicle( playerid, vehicleid.tointeger(), 0 );
    return 1;
});

//================================================================================================================================================
//                                                          TEST COMMANDS END
//================================================================================================================================================

//================================================================================================================================================
//                                                          TEST COLORS BEGIN
//================================================================================================================================================

// working
addCommandHandler("colors1", function ( playerid ) {
   msg(playerid, "============== COLOR Page 1 ===============", CL_WHITE);
   msg(playerid, "This is Test color  CL_FLAMINGO", CL_FLAMINGO);
   msg(playerid, "This is Test color  CL_CHESTNUT", CL_CHESTNUT);
   msg(playerid, "This is Test color  CL_THUNDERBIRD", CL_THUNDERBIRD);
   msg(playerid, "This is Test color  CL_OLDBREAK", CL_OLDBREAK);
   msg(playerid, "This is Test color  CL_WAXFLOWER", CL_WAXFLOWER);
   msg(playerid, "This is Test color  CL_SNUFF", CL_SNUFF);
   msg(playerid, "This is Test color  CL_REBECCAPURPLE", CL_REBECCAPURPLE);
   msg(playerid, "This is Test color  CL_WISTFUL", CL_WISTFUL);
   msg(playerid, "This is Test color  CL_MEDIUMPURPLE", CL_MEDIUMPURPLE);
   msg(playerid, "This is Test color  CL_LIGHTWISTERIA", CL_LIGHTWISTERIA);
   msg(playerid, "This is Test color  CL_ROYALBLUE", CL_ROYALBLUE);
});


addCommandHandler("colors2", function ( playerid ) {
   msg(playerid, "============== COLOR Page 2 ===============", CL_WHITE);
   msg(playerid, "This is Test color  CL_PICTONBLUE", CL_PICTONBLUE);
   msg(playerid, "This is Test color  CL_PICTONBLUEDARK", CL_PICTONBLUEDARK);
   msg(playerid, "This is Test color  CL_MING", CL_MING);
   msg(playerid, "This is Test color  CL_MALIBU", CL_MALIBU);
   msg(playerid, "This is Test color  CL_HOKI", CL_HOKI);
   msg(playerid, "This is Test color  CL_JORDYBLUE", CL_JORDYBLUE);
   msg(playerid, "This is Test color  CL_GOSSIP", CL_GOSSIP);
   msg(playerid, "This is Test color  CL_EUCALYPTUS", CL_EUCALYPTUS);
   msg(playerid, "This is Test color  CL_CARIBBEANGREEN", CL_CARIBBEANGREEN);
   msg(playerid, "This is Test color  CL_NIAGARA", CL_NIAGARA);
   msg(playerid, "This is Test color  CL_OCEANGREEN", CL_OCEANGREEN);
}); 


addCommandHandler("colors3", function ( playerid ) {
   msg(playerid, "============== COLOR Page 3 ===============", CL_WHITE);
   msg(playerid, "This is Test color  CL_JADE", CL_JADE);
   msg(playerid, "This is Test color  CL_SALEM", CL_SALEM);
   msg(playerid, "This is Test color  CL_CREAMCAN", CL_CREAMCAN);
   msg(playerid, "This is Test color  CL_RIPELEMON", CL_RIPELEMON);
   msg(playerid, "This is Test color  CL_FIREBUSH", CL_FIREBUSH);
   msg(playerid, "This is Test color  CL_CRUSTA", CL_CRUSTA);
   msg(playerid, "This is Test color  CL_BURNTORANGE", CL_BURNTORANGE);
   msg(playerid, "This is Test color  CL_ECSTASY", CL_ECSTASY);
   msg(playerid, "This is Test color  CL_LYNCH", CL_LYNCH);
   msg(playerid, "This is Test color  CL_SILVERSAND", CL_SILVERSAND);
   msg(playerid, "This is Test color  CL_CASCADE", CL_CASCADE);
});   
//================================================================================================================================================
//                                                          TEST COLORS END
//================================================================================================================================================
