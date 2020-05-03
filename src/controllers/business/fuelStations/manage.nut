function fuelStationManage(playerid) {
    dbg("fuelStationManage");

    local charid = getCharacterIdFromPlayerId(playerid);
    local stationName = getFuelStationCache(charid).name;

    if(!stationName) return;

    local stationCoords = getFuelStationCoordsByName(stationName);

    if (!isInRadius(playerid, stationCoords.private[0], stationCoords.private[1], stationCoords.private[2], 1.0) ) {
        return;
    }

    local station = getFuelStationEntity(stationName);

    if(charid != station.ownerid) {
        return;
    }

    msg(playerid, "Hello! It's your fuel station", CL_SUCCESS);
    msg(playerid, "You can:", CL_SUCCESS);
    msg(playerid, " - set selling price for fuel: /biz fuel price", CL_SUCCESS);
    msg(playerid, " - set purchase price for fuel", CL_SUCCESS);
    msg(playerid, " - set amount of fuel for purchase", CL_SUCCESS);
    msg(playerid, " - set the fuel station on sale", CL_SUCCESS);
    msg(playerid, " - temporarily close the fuel station", CL_SUCCESS);
    msg(playerid, " - sale the fuel station to the city immediately", CL_SUCCESS);

		local data = {
			amount = station.data.fuel.amount.tostring(),
			price = station.data.fuel.price.tostring(),
			amountIn = station.data.fuel.amountIn.tostring(),
			priceIn = station.data.fuel.priceIn.tostring(),
			state = station.state,
			money = station.data.money.tostring(),
			name = station.name,
			saleprice = station.saleprice.tostring(),
			baseprice = station.baseprice.tostring(),
			lang = getPlayerLocale(playerid)
		}

		trigger(playerid, "showFuelStaionGUI", JSONEncoder.encode(data));
}