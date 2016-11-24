cmd( ["fuel"], "up", function( playerid ) {
    return fuelup(playerid);
});

cmd( ["fuel"], "low", function( playerid ) {
    local vehicleid = getPlayerVehicle(playerid);
    return setVehicleFuel(vehicleid, 10.0);
});


cmd( ["fuel"], "test", function( playerid ) {
    local vehicleid = getPlayerVehicle(playerid);
    local volume = getVehicleFuel(vehicleid) + 1.0;
    msg( playerid, "Fuel level: "+volume );
    return setVehicleFuel(vehicleid, volume);
});
