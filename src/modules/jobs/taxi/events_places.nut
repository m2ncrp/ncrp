/* ENTER/EXIT PLACES ***************************************************************************************************************************************************** */

/* onPlaceEnter. Вход ВОДИТЕЛЯ в зону - при прибытии к клиенту */
event("onPlayerPlaceEnter", function(playerid, name) {

    if (!isTaxiDriver(playerid) || !isPlayerCarTaxi(playerid)) {
        return;
    }

    // получаем обьект заказа, если его нет - водитель либо offair, либо onair без заказа
    local drid = getCharacterIdFromPlayerId(playerid);
    local callObject = getTaxiCallObjectByDrid(drid);
    if(!callObject) {
        return;
    }
    log("- CALL: -----------------------")
    log(callObject)
    log("-------------------------------")

    local cuid = callObject.cuid;
    if ("taxi"+drid+"Customer"+cuid == name) {

        local plate = getVehiclePlateText( getPlayerVehicle( playerid ) );

        // removePlace("taxi"+drid+"Customer"+cuid);
        trigger(playerid, "removeGPS");

        msg_taxi_dr(playerid, "job.taxi.wait");

        // выполняется если Клиент - реальный игрок
        if (cuid < TAXI_CHARACTERS_LIMIT) {
            if(isPlaceExists("taxiSmall" + cuid)) {
                removePlace("taxiSmall" + cuid);
            }
            msg_taxi_cu(getPlayerIdFromCharacterId(cuid), "taxi.call.arrived", plate);
        }
    }
});


/* onPlaceExit. Выход ВОДИТЕЛЯ пешком из зоны вокруг автомобиля */
event("onPlayerPlaceExit", function(playerid, name) {
    local drid = getCharacterIdFromPlayerId(playerid);
    if(!isTaxiDriver(playerid) || getTaxiDriverStatus(drid) == "offair" || name != "TaxiDriverZone"+drid ) {
        return;
    }

    setTaxiDriverStatus(drid, "offair");

    setTaxiLightState(getTaxiDriverCar(drid), false);
    setTaxiDriverCar(drid, null);
    removePlace("TaxiDriverZone"+drid);
    msg_taxi_dr(playerid, "job.taxi.leaveline");

    local callObject = getTaxiCallObjectByDrid(drid);
    if(callObject) {
        local cuid = callObject.cuid;

        removePlace("taxi"+drid+"Customer"+cuid);
        trigger(playerid, "removeGPS");

        msg_taxi_dr(playerid, "job.taxi.leaveline_fine", 10.0);
        subMoneyToPlayer(playerid, 10.0)

        // выполняется если Клиент - реальный игрок
        if (cuid < TAXI_CHARACTERS_LIMIT) {
            removePlace("taxiSmall" + cuid);

            local playerid = getPlayerIdFromCharacterId(cuid);
            msg_taxi_cu(playerid, "taxi.call.leftline");

            // Удаляем текущий звонок и создаём новый
            removeTaxiCall(callObject.id);
            delayedFunction(3000, function () {
                taxiAddCall(playerid, "telephone"+callObject.placeId)
            });
        }
    }
});


/* onPlaceExit. Выход КЛИЕНТА из зоны вызова до приезда водителя */
event("onPlayerPlaceExit", function(playerid, name) {
    local cuid = getCharacterIdFromPlayerId(playerid);
    if ("taxiSmall" + cuid == name) {
        msg_taxi_cu(playerid, "taxi.call.ifyouaway");
        return;
    }

    local callObject = getTaxiCallObjectByCuid(cuid);

    if(!callObject) {
        return;
    }

    local drid = callObject.drid;
    local placeName = "taxi"+drid+"Customer"+cuid

    if (placeName == name) {
        msg_taxi_cu(playerid, "taxi.call.fakecall");

        local placeNameSmall = "taxiSmall"+cuid;
        if(isPlaceExists(placeNameSmall)) {
            removePlace(placeNameSmall);
        }

        removeTaxiCall(callObject.id);

        if(isPlaceExists(placeName)) {
            removePlace(placeName);
        }

        setTaxiDriverStatus(drid, "onair");

        local driverid = getPlayerIdFromCharacterId(drid);
        trigger(driverid, "removeGPS");
        msg_taxi_dr(driverid, "job.taxi.callnotexist");
    }

});
