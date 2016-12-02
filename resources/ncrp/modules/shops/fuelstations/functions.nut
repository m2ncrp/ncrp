function isNearFuelStation(playerid) {
    foreach (station in fuel_stations) {
        if ( isInRadius(playerid, station[0], station[1], station[2], FUEL_RADIUS) ) {
            return true;
        }
    }
    msg(playerid, "shops.fuelstations.toofar", [], CL_THUNDERBIRD);
    return false;
}


/**
 * Return value player need to fuel up his vehicle
 * @param  {integer}    playerid
 * @return {float}      fuel used
 */
function getFuelNeed(playerid) {
    local vehicleid = getPlayerVehicle(playerid);
    local vehicle_model = getVehicleModel(vehicleid);
    return vehicle_tank[vehicle_model][1] - getVehicleFuel(vehicleid);
}

function isFuelNeeded(playerid) {
    local vehicleid = getPlayerVehicle(playerid);
    return getFuelNeed(playerid) > 1.0;
}


/**
 * Fuel up player vehicle
 * @param  {integer}    playerid
 * @return {void}
 */
function fuelup(playerid) {
    local vehicleid = getPlayerVehicle(playerid);
    local fuel = round( getFuelNeed(playerid), 2 );
    local cost = round(GALLON_COST*fuel, 2);

    if ( isNearFuelStation(playerid) ) {
        if ( !isFuelNeeded(playerid) ) {
            return msg(playerid, "shops.fuelstations.fueltank.full");
        }
        if ( !canMoneyBeSubstracted(playerid, cost) ) {
            return msg(playerid, "shops.fuelstations.money.notenough", [cost, getPlayerBalance(playerid)], CL_THUNDERBIRD);
        }
        if(isPlayerVehicleMoving(playerid)) {
            return msg( playerid, "shops.fuelstations.stopyourmoves", CL_RED );
        }
        setVehicleFuel(vehicleid, getDefaultVehicleFuel(vehicleid));
        subMoneyToPlayer(playerid, cost);
        return msg(playerid, "shops.fuelstations.fuel.payed", [cost, fuel, getPlayerBalance(playerid)]);
    }
}
