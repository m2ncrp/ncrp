acmd(["vehicle"], function( playerid, id ) {
    local pos = getPlayerPosition( playerid );
    local vehicle = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
    // setVehicleColour(vehicle, 0, 0, 0, 0, 0, 0);
});

acmd(["tune"], function( playerid ) {
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        setVehicleTuningTable( vehicleid, 3 );

        setVehicleWheelTexture( vehicleid, 0, 11 );
        setVehicleWheelTexture( vehicleid, 1, 11 );
    }
});

acmd(["fix"], function( playerid ) {
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        repairVehicle( vehicleid );
        setVehicleFuel( vehicleid, 50.0 );
    }
});

acmd("checkcar", function( playerid ) {
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

cmd("engine", "on", function(playerid) {
    local vehicleid = getPlayerVehicle( playerid );
    setVehicleEngineState(vehicleid, true);
});

cmd("engine", "off", function(playerid) {
    local vehicleid = getPlayerVehicle( playerid );
    setVehicleEngineState(vehicleid, false);
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

acmd("jump", function(playerid) {
    if (isPlayerInVehicle(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        local sp = getVehicleSpeed(vehicleid);
        setVehicleSpeed(vehicleid, sp[0], sp[1], sp[2] + 4.0);
    }
});

acmd("myveh", function(playerid, modelid) {
    local pos = getPlayerPosition( playerid );
    local vehicleid = createVehicle( modelid.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
    // setVehicleColour(vehicleid, 0, 0, 0, 0, 0, 0);
    setVehicleOwner(vehicleid, "none");
    setVehicleSaving(vehicleid, true); // it will be saved to database
    setVehicleRespawnEx(vehicleid, true); // it wont respawn
});

acmd("who", function(playerid) {
    if (isPlayerInVehicle(playerid)) {
        if (isPlayerVehicleOwner(playerid, getPlayerVehicle(playerid))) {
            msg(playerid, "You are owner", CL_SNUFF);
        } else {
            msg(playerid, "You are not an owner", CL_SNUFF);
        }
    }
});

/**
 * KEYBINDS
 */
addKeyboardHandler("q", "up", function(playerid) {
    switchLights(playerid);
});

addKeyboardHandler("z", "up", function(playerid) {
    switchLeftLight(playerid);
});

addKeyboardHandler("c", "up", function(playerid) {
    switchRightLight(playerid);
});

addKeyboardHandler("x", "up", function(playerid) {
    switchBothLight(playerid);
});

addKeyboardHandler("2", "up", function(playerid) {
    if (isPlayerInVehicle(playerid) && isPlayerAdmin(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        local sp = getVehicleSpeed(vehicleid);
        setVehicleSpeed(vehicleid, sp[0], sp[1], sp[2] + 5.0);
    }
});

addKeyboardHandler("3", "up", function(playerid) {
    if (isPlayerInVehicle(playerid) && isPlayerAdmin(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        local rot = getVehicleRotation(vehicleid);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
        setVehicleRotation(vehicleid, rot[0], rot[1] * -0.9, rot[2] * -0.9);
    }
});

addKeyboardHandler("e", "up", function(playerid) {
    if (isPlayerInVehicle(playerid) && getPlayerName(playerid) == "Inlife" && isPlayerAdmin(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        local sp = getVehicleSpeed(vehicleid);
        setVehicleSpeed(vehicleid, sp[0], sp[1], sp[2] + 5.0);
    }
});

addKeyboardHandler("num_0", "up", function(playerid) {
    switchLights(playerid);
});

addKeyboardHandler("num_1", "up", function(playerid) {
    switchLeftLight(playerid);
});

addKeyboardHandler("num_3", "up", function(playerid) {
    switchRightLight(playerid);
});

addKeyboardHandler("num_2", "up", function(playerid) {
    switchBothLight(playerid);
});
