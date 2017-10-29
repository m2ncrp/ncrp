//================================================================================================================================================
//                                                          ADDITIONAL COMMAND
//================================================================================================================================================

acmd(["getGPS", "getpos"], function ( playerid, str ) {
    local vehicleModel = -1;
    if( isPlayerInVehicle( playerid ) ) {
        local vehicleid = getPlayerVehicle( playerid ) ;
        vehicleModel = getVehicleModel ( vehicleid );
        local vehPos = getVehiclePosition( vehicleid );
        local vehRot = getVehicleRotation( vehicleid );
        log( "Vehicle: " + vehicleid + ", "+ vehicleModel + ", " + vehPos[0] + ", " + vehPos[1] + ", " + vehPos[2] + ", " + vehRot[0] + ", " + vehRot[1] + ", " + vehRot[2] );
    } else {
        local plaPos = getPlayerPosition( playerid ) ;
        local plaRot = getPlayerRotation( playerid );
        log( "Player: " + plaPos[0] + ", " + plaPos[1] + ", " + plaPos[2] + ", " + plaRot[0] + ", " + plaRot[1] + ", " + plaRot[2] );
    }

    // for info about reading modes check out
    // http://www.cplusplus.com/reference/cstdio/fopen/
    local posfile = file("positions.txt", "a");
    local pos, rot;


    if (isPlayerInVehicle(playerid)) {
        pos = getVehiclePosition( getPlayerVehicle(playerid) );
        rot = getVehicleRotation( getPlayerVehicle(playerid) );
    } else {
        pos = getPlayerPosition( playerid );
        rot = getPlayerRotation( playerid );
    }


    pos.insert(0, vehicleModel);

    foreach (idx, value in rot) {
        pos.push(value);
    }

    // read rest of the input string (if there any)
    // concat it, and push to the pos array

    pos.push(" // "+str);

    // iterate over px,y,z]
    foreach (idx, value in pos) {

        // convert value to string,
        // and iterate over each char
        local coord = value.tostring();
        for (local i = 0; i < coord.len(); i++) {
            posfile.writen(coord[i], 'b');
        }

        // also write whitespace after the number
        if (idx != (pos.len()-1) && idx != (pos.len()-2)) {
            posfile.writen(',', 'b');
            posfile.writen(' ', 'b');
        }
    }
    // posfile.writen(" // "+str, 'b');
    // and dont forget push newline before closing
    posfile.writen('\n', 'b');
    posfile.close();
});



acmd("getspeed", function ( playerid ) {
    if( isPlayerInVehicle( playerid ) ) {
        local vehicleid = getPlayerVehicle( playerid ) ;
        local velocity = getVehicleSpeed( vehicleid );
        sendPlayerMessage( playerid,  " Current velocity on points is X = " + velocity[0] + ", Y = " + velocity[1] + ", Z = " + velocity[2] + "." );
    }
});


//================================================================================================================================================
//                                                              TELEPORT
//================================================================================================================================================

acmd("pos", function(playerid, x, y, z) {
    local myPos = getPlayerPosition( playerid );
    setPlayerPosition( playerid, myPos[0]+x.tofloat(), myPos[1]+y.tofloat(), myPos[2]+z.tofloat() );
});

acmd("gotovinchi", function(playerid) {
    setPlayerPosition( playerid, -1680.47, 955.375, 0.48104 );
});

//================================================================================================================================================
//                                                          TEST COLORS BEGIN
//================================================================================================================================================


// working
acmd("colors1",  function ( playerid, color = "POMEGRANATE"  ) { colorMsgSelect(playerid, color); });
acmd("colors2",  function ( playerid, color = "ALIZARIN"     ) { colorMsgSelect(playerid, color); });
acmd("colors3",  function ( playerid, color = "AMETHYST"     ) { colorMsgSelect(playerid, color); });
acmd("colors4",  function ( playerid, color = "WISTERIA"     ) { colorMsgSelect(playerid, color); });
acmd("colors5",  function ( playerid, color = "BELIZEHOLE"   ) { colorMsgSelect(playerid, color); });
acmd("colors6",  function ( playerid, color = "PETERRIVER"   ) { colorMsgSelect(playerid, color); });
acmd("colors7",  function ( playerid, color = "TURQUOISE"    ) { colorMsgSelect(playerid, color); });
acmd("colors8",  function ( playerid, color = "GREENSEA"     ) { colorMsgSelect(playerid, color); });
acmd("colors9",  function ( playerid, color = "NEPHRITIS"    ) { colorMsgSelect(playerid, color); });
acmd("colors10", function ( playerid, color = "EMERALD"      ) { colorMsgSelect(playerid, color); });

acmd("colors11", function ( playerid, color = "SUNFLOWER"    ) { colorMsgSelect(playerid, color); });
acmd("colors12", function ( playerid, color = "ORANGE"       ) { colorMsgSelect(playerid, color); });
acmd("colors13", function ( playerid, color = "CARROT"       ) { colorMsgSelect(playerid, color); });
acmd("colors14", function ( playerid, color = "PUMPKIN"      ) { colorMsgSelect(playerid, color); });
acmd("colors15", function ( playerid, color = "SILVER"       ) { colorMsgSelect(playerid, color); });
acmd("colors16", function ( playerid, color = "CONCRETE"     ) { colorMsgSelect(playerid, color); });
acmd("colors17", function ( playerid, color = "WETASPHALT"   ) { colorMsgSelect(playerid, color); });


function colorMsgSelect(playerid, color) {
    msg(playerid, "============== "+color+" ===============", CL_WHITE);
    msg(playerid, "This is Test color  CL_"+color,      getroottable()["CL_"+color] );

    for (local i = 2; i < 8; i++) {
        msg(playerid, "This is Test color  CL_"+color+"_"+(i * 10), getroottable()["CL_"+color+"_"+(i * 10)]);
    }
}


// working
acmd("colors101", function ( playerid ) {
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


acmd("colors102", function ( playerid ) {
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


acmd("colors103", function ( playerid ) {
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

acmd("colors104", function ( playerid ) {
    msg(playerid, "============== COLOR Page 4 ===============", CL_WHITE);
    msg(playerid, "This is Test color  CL_CLOUDS"       ,  CL_CLOUDS       );
    msg(playerid, "This is Test color  CL_ASBESTOS"     ,  CL_ASBESTOS     );
    msg(playerid, "This is Test color  CL_MIDNIGHTBLUE" ,  CL_MIDNIGHTBLUE );
    msg(playerid, "This is Test color  CL_ERROR"        ,  CL_ERROR        );
    msg(playerid, "This is Test color  CL_WARNING"      ,  CL_WARNING      );
    msg(playerid, "This is Test color  CL_SUCCESS"      ,  CL_SUCCESS      );
    msg(playerid, "This is Test color  CL_INFO"         ,  CL_INFO         );
    msg(playerid, "This is Test color  CL_PLAIN"        ,  CL_PLAIN        );
    msg(playerid, "This is Test color  CL_WASH"         ,  CL_WASH         );
});

//================================================================================================================================================
//                                                          TEST COLORS END
//================================================================================================================================================


cmd("dice", function ( playerid ) {
    local dice = random(1, 6);
    msgr(playerid, "utils.diсe", [ getAuthor2(playerid), dice ], CL_WHITE, 10);

    // statistics
    statisticsPushMessage(playerid, dice, "dice");
});



cmd("hat", function ( playerid, count = null) {
    if (count == null || !isNumeric(count)) {
        return msg( playerid, "utils.hatnull");
    }

    local count = count.tointeger();
    if (count > 1) {
        local hat = random(1, count);
        msgr(playerid, "utils.hat", [ count, getAuthor2(playerid), hat ], CL_WHITE, 10);
        // statistics
        statisticsPushMessage(playerid, hat, "hat");
    }
});


translate("en", {
    "utils.diсe"            : "%s threw the dice: %d"
    "utils.hat"             : "There are %d balls in the cap. %s pulled the ball with number %d."
    "utils.hatnull"         : "Need to set count of participants. Example: /hat 15"
});
