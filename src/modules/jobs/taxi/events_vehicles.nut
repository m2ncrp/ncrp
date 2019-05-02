/* ENTER/EXIT VEHICLES ***************************************************************************************************************************************************** */

/* onVehicleEnter. Вход в авто: */
event( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    /* возможного ВОДИТЕЛЯ или действительного ВОДИТЕЛЯ */
    if(isVehicleCarTaxi(vehicleid) && seat == 0) {
        local drid = getCharacterIdFromPlayerId(playerid);
        // если водитель не таксист - блочим тачку
        if(!isTaxiDriver(playerid)) {
            return blockVehicle(vehicleid);
        }

        privateKey(playerid, "b", "taxiSwitchAir", taxiSwitchAir);

        if(getTaxiDriverStatus(drid) == "offair") {
            msg_taxi_dr(playerid, "job.taxi.tostart");
            blockVehicle(vehicleid);
        } else {
            // иначе разблочим тачку
            unblockDriving(vehicleid);
            local drid = getCharacterIdFromPlayerId(playerid);

            local callObject = getTaxiCallNumberByDrid(drid);
            if(callObject && callObject.status == "active" && callObject.cuid < TAXI_CHARACTERS_LIMIT) {
                privateKey(playerid, "3", "taxiCallFinishForPlayer", taxiCallFinishForPlayer);
            }

            //setTaxiDriverCar(drid, vehicleid);
            // удаляем зону сброса если таковая существует
            if(getTaxiDriverStatus(drid) != "offair" && isPlaceExists("TaxiDriverZone"+drid)) {
                removePlace("TaxiDriverZone"+drid);
            }
        }
    }


    /* возможного КЛИЕНТА */
    if(isVehicleCarTaxi(vehicleid) && seat == 1 ) {
        // если нет водителя или он не таксист - return
        local driverid = getVehicleDriver(vehicleid);
        if(driverid == null || !isTaxiDriver(driverid)) return;

        local drid = getCharacterIdFromPlayerId(driverid);
        local cuid = getCharacterIdFromPlayerId(playerid);

        local driverStatus = getTaxiDriverStatus(drid);
        if(driverStatus == "onair") {
            privateKey(playerid, "2", "taxiCallStartNew", taxiCallStartNew);
            msg_taxi_dr(driverid, "Потенциальный пассажир сел в автомобиль. Нажмите клавишу 2, чтобы начать поездку");
            msg_taxi_dr(driverid, "Завершить поездку - клавиша 3");
            msg_taxi_cu(playerid, "Вы сели в свободное такси. Договоритесь с водителем о поездке");
            return;
        }

        if(driverStatus == "offair") {
            msg_taxi_cu(playerid, "Такси не на линии. Покиньте автомобиль.");
            return;
        }

        // раз попали сюда, значит у водителя статус 'busy', а значит на нём висит вызов:
        local callObject = getTaxiCallObjectByDrid(drid);

        // если cuid вошедшего игрока равен cuid из звонка, начинаем поездку
        if(cuid == callObject.cuid && !getTaxiCallStatus(callObject.id)) {
            msg_taxi_dr( driverid, "job.taxi.taximeteron");
            removePlace("taxi"+drid+"Customer"+cuid);

            privateKey(playerid, "3", "taxiCallFinishForPlayer", taxiCallFinishForPlayer);

            // Сменим статус на active
            setTaxiCallStatus(callObject.id, "active");

            // Запишем значение пробега авто в обьект звонка
            setTaxiCallMileage ( callObject.id, getVehicleMileage( vehicleid) );
        }

    }
});


/* onVehicleExit */
event( "onPlayerVehicleExit", function ( playerid, vehicleid, seat ) {
    if(isVehicleCarTaxi(vehicleid)) {

        // Выход КЛИЕНТА из авто при вероятном завершении заказа
        if(seat == 1) {
            local driverid = getVehicleDriver(vehicleid);
            if(driverid == null) return;
            local drid = getCharacterIdFromPlayerId(driverid);
            if(!isTaxiDriver(driverid) || !isDridHaveTaxiCall(drid)) return;
            local cuid = getCharacterIdFromPlayerId(playerid);
            if(cuid == getTaxiCallCuidByDrid(drid)) {
                msg_taxi_dr( driverid, "job.taxi.iftripend");
                //taxiPauseCounter(driverid);
                // вывести сумму для оплаты
            }
        }
        log("seat: "+seat)


        if(seat == 0) {
            local drid = getCharacterIdFromPlayerId(playerid);

            if(isTaxiDriver(playerid)) {

                removePrivateKey(playerid, "b", "taxiSwitchAir")

                // Выход ВОДИТЕЛЯ из авто - создание зоны сброса
                if(getTaxiDriverStatus(drid) != "offair") {
                    removePrivateKey(playerid, "2", "taxiCallStartNew");
                    removePrivateKey(playerid, "3", "taxiCallFinishForPlayer");
                    local vehPos = getVehiclePosition(vehicleid);
                    createPlace("TaxiDriverZone"+drid, vehPos[0]-25, vehPos[1]+25, vehPos[0]+25, vehPos[1]-25);
            }
            }
        }
    }
});
