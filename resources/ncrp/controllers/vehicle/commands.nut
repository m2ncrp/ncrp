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
        setVehicleFuel( vehicleid, 50.0 );
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

cmd("lights", function(playerid) {
    switchLights(playerid);
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

cmd("jump", function(playerid) {
    if (isPlayerInVehicle(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        local sp = getVehicleSpeed(vehicleid);
        setVehicleSpeed(vehicleid, sp[0], sp[1], sp[2] + 4.0);
    }
});

/**
 * KEYBINDS
 */
addKeyboardHandler("k", "up", function(playerid) {
    switchLights(playerid);
});

addKeyboardHandler("h", "up", function(playerid) {
    switchLeftLight(playerid);
});

addKeyboardHandler("j", "up", function(playerid) {
    switchRightLight(playerid);
});

addKeyboardHandler("g", "up", function(playerid) {
    switchBothLight(playerid);
});

addKeyboardHandler("y", "up", function(playerid) {
    if (isPlayerInVehicle(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        local sp = getVehicleSpeed(vehicleid);
        setVehicleSpeed(vehicleid, sp[0], sp[1], sp[2] + 4.0);
    }
});
