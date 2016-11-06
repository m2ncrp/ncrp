cmd(["vehicle"], function( playerid, id ) {
    local pos = getPlayerPosition( playerid );
    local vehicle = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
    setVehicleColour(vehicle, 0, 0, 0, 0, 0, 0);
});

cmd(["tune"], function( playerid ) {
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        setVehicleTuningTable( vehicleid, 3 );

        setVehicleWheelTexture( vehicleid, 0, 11 );
        setVehicleWheelTexture( vehicleid, 1, 11 );
    }
});

cmd(["fix"], function( playerid ) {
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        repairVehicle( vehicleid );
    }
});

cmd(["destroyVehicle"], function( playerid ) {
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        destroyVehicle( vehicleid );
    }
});

addCommandHandler("checkcar", function( playerid ) {
    local vehicleid = getPlayerVehicle( playerid );
    local vehicleModel = getVehicleModel( vehicleid );

    sendPlayerMessage( playerid, "Car: id #" + vehicleid + ", model #" + vehicleModel);
});

cmd("paint", function(playerid, red, green, blue) {
    local r = min(red.tointeger(), 255);
    local g = min(green.tointeger(), 255);
    local b = min(blue.tointeger(), 255);

    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    setVehicleColour(getPlayerVehicle(playerid), r, g, b, r, g, b);
});

addKeyboardHandler("k", "up", function(playerid) {
    switchLights(playerid);
    msg(playerid, "Keyboard: LightSwitch");
});

addKeyboardHandler("h", "up", function(playerid) {
    switchLeftLight(playerid);
    msg(playerid, "Keyboard: Left Light");
});

addKeyboardHandler("j", "up", function(playerid) {
    switchRightLight(playerid);
    msg(playerid, "Keyboard: Right Light");
});

addKeyboardHandler("g", "up", function(playerid) {
    switchBothLight(playerid);
    msg(playerid, "Keyboard: Both Light");
});


cmd("lights", function(playerid) {
    switchLights(playerid);
    msg(playerid, "LightSwitch");
});

cmd("turnleft", function(playerid) {
    switchLeftLight(playerid);
});

cmd("turnright", function(playerid) {
    switchRightLight(playerid);
});

cmd("aviar", function(playerid) {
    switchBothLight(playerid);
});
