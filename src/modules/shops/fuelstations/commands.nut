cmd( ["fuel"], "up", function( playerid ) {

    if (!isPlayerInVehicle(playerid) ) { /*&& isPlayerNearVehicle(playerid)*/
        return msg(playerid, "shops.fuelstations.farfromvehicle");
    }

    if ( !isNearFuelStation(playerid) ) {
        return msg(playerid, "shops.fuelstations.toofar", [], CL_THUNDERBIRD);
    }

    if(isPlayerVehicleMoving(playerid)) {
        return msg( playerid, "shops.fuelstations.stopyourmoves", CL_THUNDERBIRD );
    }

    local vehicleid = getPlayerVehicle(playerid);
    local fuel = round(getVehicleFuelNeed(vehicleid), 2);
    local cost = round(GALLON_COST * fuel, 2);

    if ( !isVehicleFuelNeeded(vehicleid) ) {
        return msg(playerid, "shops.fuelstations.fueltank.full");
    }

    if ( !canMoneyBeSubstracted(playerid, cost) ) {
        return msg(playerid, "shops.fuelstations.money.notenough", [cost, getPlayerBalance(playerid)], CL_THUNDERBIRD);
    }

    setVehicleFuel(vehicleid, getDefaultVehicleFuel(vehicleid));
    subMoneyToPlayer(playerid, cost);
    addMoneyToTreasury(cost);
    return msg(playerid, "shops.fuelstations.fuel.payed", [cost, fuel, getPlayerBalance(playerid)]);
});

acmd( ["fuel"], "low", function( playerid ) {
    local vehicleid = getPlayerVehicle(playerid);
    return setVehicleFuel(vehicleid, 10.0);
});


acmd( ["fuel"], "test", function( playerid ) {
    local vehicleid = getPlayerVehicle(playerid);
    local volume = getVehicleFuel(vehicleid) + 1.0;
    msg( playerid, "shops.fuelstations.fueltank.check", [volume] );
    return setVehicleFuel(vehicleid, volume);
});

function fuelStationsHelp ( playerid ) {
    local title = "job.taxi.help.title";
    local commands = [
        { name = "/fuel up",    desc = "shops.fuelstations.help.fuelup" }
    ];
    msg_help(playerid, title, commands);
}


cmd("help", "fuel", fuelStationsHelp); // Attention to developers: don't move this string to up.
