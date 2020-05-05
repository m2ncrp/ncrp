function fuelStationManage(playerid) {
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

    local data = {
        stationName = station.name,
        amount = station.data.fuel.amount.tostring(),
        price = station.data.fuel.price.tostring(),
        amountIn = station.data.fuel.amountIn.tostring(),
        priceIn = station.data.fuel.priceIn.tostring(),
        state = station.state,
        money = station.data.money.tostring(),
        name = station.name,
        saleprice = station.saleprice.tostring(),
        saleToCityPrice = getFuelStationSaleToCityPrice(station).tostring(),
        baseprice = station.baseprice.tostring(),
        lang = getPlayerLocale(playerid)
    }

    trigger(playerid, "showFuelStationGUI", JSONEncoder.encode(data));
}


event("bizFuelStationSave", function(playerid, stationName, salePrice, purchaseAmount, purchasePrice) {
    salePrice = salePrice.tofloat();
    purchaseAmount = purchaseAmount.tofloat()
    purchasePrice = purchasePrice.tofloat();

    local station = getFuelStationEntity(stationName);
    station.data.fuel.price = salePrice;
    station.data.fuel.amountIn = purchaseAmount;
    station.data.fuel.priceIn = purchasePrice;
    station.save();
    fuelStationReloadPrivateInteractionsForAllAtStation(station)
    info(playerid, "Уведомление", "Изменения сохранены");
})

event("bizFuelStationClose", function(playerid, stationName) {
    local station = getFuelStationEntity(stationName);
    station.state = "closed";
    station.save();
    fuelStationReloadPrivateInteractionsForAllAtStation(station);
})

event("bizFuelStationOpen", function(playerid, stationName) {
    local station = getFuelStationEntity(stationName);
    station.state = "opened";
    station.save();
    fuelStationReloadPrivateInteractionsForAllAtStation(station);
})

event("bizFuelStationOnSale", function(playerid, stationName, price) {
    local station = getFuelStationEntity(stationName);
    station.state = "onsale";
    station.saleprice = price.tofloat();
    station.save();
    fuelStationReloadPrivateInteractionsForAllAtStation(station);
})

event("bizFuelStationOnSaleToCity", function(playerid, stationName) {
    local station = getFuelStationEntity(stationName);
    local amount = getFuelStationSaleToCityPrice(station);
    if(station.data.money > 0) {
        return alert(playerid, "Баланс автозаправки должен быть равен 0.")
    }
    if(getTreasuryMoney() < amount) {
        return alert(playerid, "В данный момент город не может выкупить\r\nавтозаправку обратно.", [], 2)
    }
    triggerClientEvent(playerid, "hideFuelStaionGUI");
    addPlayerMoney(playerid, amount);
    subTreasuryMoney(amount);
    station.state = "onsale";
    station.ownerid = -1;
    station.saleprice = 0;
    station.data.tax = 0;
    station.save();
    msg(playerid, "business.fuelStation.sold", [stationName], CL_SUCCESS);
    fuelStationReloadPrivateInteractionsForAllAtStation(station);
})