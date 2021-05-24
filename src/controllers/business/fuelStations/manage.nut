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

    trigger(playerid, "showFuelStationGUI", getFuelStaionDataGUI(playerid, station));
}

function getFuelStaionDataGUI(playerid, station) {
    local data = {
        stationName = station.name,
        amount = round(station.data.fuel.amount, 2).tostring(),
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

    return JSONEncoder.encode(data);
}

event("bizFuelStationSave", function(playerid, stationName, salePrice, purchaseAmount, purchasePrice) {
    salePrice = salePrice.len() > 0 ? salePrice.tofloat() : 0;
    purchaseAmount = purchaseAmount.len() > 0 ? purchaseAmount.tofloat() : 0;
    purchasePrice = purchasePrice.len() > 0 ? purchasePrice.tofloat() : 0;

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
        return alert(playerid, "Касса автозаправки должна быть равна 0.")
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

event("bizFuelStationOnAddBalanceMoney", function(playerid, stationName, amount) {
    local station = getFuelStationEntity(stationName);
    amount = amount.tofloat();
    amount = round(amount, 2);

    if (!canMoneyBeSubstracted(playerid, amount)) {
        return alert(playerid, "У вас нет такой суммы денег");
    }

    station.data.money += amount;
    subPlayerMoney(playerid, amount);
    triggerClientEvent(playerid, "redrawFuelStationGUI", getFuelStaionDataGUI(playerid, station));
    station.save();
})


event("bizFuelStationOnSubBalanceMoney", function(playerid, stationName, amount) {
    local station = getFuelStationEntity(stationName);
    amount = amount.tofloat();
    amount = round(amount, 2);

    if(round(station.data.money, 2) < amount) {
        return alert(playerid, "На балансе автозаправки нет такой суммы.")
    }

    station.data.money -= amount;
    if(station.data.money < 0.01) {
        station.data.money = 0.0;
    }
    addPlayerMoney(playerid, amount);
    triggerClientEvent(playerid, "redrawFuelStationGUI", getFuelStaionDataGUI(playerid, station));
    station.save();

})
