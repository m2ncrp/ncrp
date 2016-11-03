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
addCommandHandler("chattest", function ( playerid ) {
   msg(playerid, "This is Test color CL_WHITESMOKE", CL_WHITESMOKE);
   msg(playerid, "This is Test color CL_LYNCH", CL_LYNCH);
   msg(playerid, "This is Test color CL_PUMICE", CL_PUMICE);
   msg(playerid, "This is Test color CL_GALLERY", CL_GALLERY);
   msg(playerid, "This is Test color CL_SILVERSAND", CL_SILVERSAND);
   msg(playerid, "This is Test color CL_PORCELAIN", CL_PORCELAIN);
   msg(playerid, "This is Test color CL_CASCADE", CL_CASCADE);
   msg(playerid, "This is Test color CL_IRON", CL_IRON);
   msg(playerid, "This is Test color CL_EDWARD", CL_EDWARD);
   msg(playerid, "This is Test color CL_CARARRA", CL_CARARRA);
});

//================================================================================================================================================
//                                                          TEST COLORS END
//================================================================================================================================================
