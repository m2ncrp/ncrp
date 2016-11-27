cmd( ["fuel"], "up", function( playerid ) {
    if (!isPlayerInVehicle(playerid) ) { /*&& isPlayerNearVehicle(playerid)*/
        return msg(playerid, "shops.fuelstations.farfromvehicle");
    }
    // check if speed is 0 and engine is off
    return fuelup(playerid);
});

cmd( ["fuel"], "low", function( playerid ) {
    local vehicleid = getPlayerVehicle(playerid);
    return setVehicleFuel(vehicleid, 10.0);
});


cmd( ["fuel"], "test", function( playerid ) {
    local vehicleid = getPlayerVehicle(playerid);
    local volume = getVehicleFuel(vehicleid) + 1.0;
    msg( playerid, "shops.fuelstations.fueltank.check", [volume] );
    return setVehicleFuel(vehicleid, volume);
});
