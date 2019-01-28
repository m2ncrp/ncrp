local calls_counter = 0;
local calls_priority = false;
local calls_timeout = 60; // seconds
local price = 0.001; // тариф за 1 метр // доллар за 1 км
local moneyMinimum = 12.5; // минимальный баланс наличных денег для вызова

TAXICALLS <- {};
local TAXI_CHARACTERS_LIMIT = 1000000;
local TAXI_LASTCALL_ID = null;

local TAXI_PLACE_SMALL = 10;

function addTaxiCall(placeNumber, playerid, drid) {
    local cuid = playerid;

    if (playerid < TAXI_CHARACTERS_LIMIT) {
        cuid = getCharacterIdFromPlayerId(playerid);
    }

    if (!cuid) return;

    TAXICALLS[calls_counter] <- {
                  id = calls_counter,
              status = null,
                cuid = cuid,
                drid = drid,
        mileageStart = null,
       positionStart = null,
             placeId = placeNumber,
       targetPlaceId = null,
    };

    calls_counter += 1;
    return TAXICALLS[calls_counter - 1];
}

// Получить статус звонка
function getTaxiCallStatus(callNumber) {
    return TAXICALLS[callNumber].status;
}

// Записать статус звонка
function setTaxiCallStatus(callNumber, status) {
    TAXICALLS[callNumber].status = status;
}

// Получить дистанцию по звонку
function getTaxiCallDistance(callNumber) {
    return TAXICALLS[callNumber].distance;
}

// Записать дистанцию по звонку
function setTaxiCallDistance(callNumber, distance) {
    TAXICALLS[callNumber].distance = distance;
}

// Записать charid водителя в обьект звонка
function setTaxiCallDriver(callNumber, drid) {
    TAXICALLS[callNumber].drid = drid;
}

// Очистить поле drid (водителя) в обьекте звонка
function removeTaxiCallDriver(callNumber) {
    TAXICALLS[callNumber].drid = null;
}

// Удалить звонок
function removeTaxiCall(callNumber) {
    delete TAXICALLS[callNumber];
}

function getCalls() {
    log(TAXICALLS);
    return TAXICALLS;
}

// Записать значение пробега авто в обьект звонка
function setTaxiCallMileage(callNumber, mileageStart) {
    TAXICALLS[callNumber].mileageStart = mileageStart;
}

// получить ОБЬЕКТ звонка по ID ЗВОНКА
function getTaxiCallObjectByCallNumber(callNumber) {
    if(TAXICALLS[callNumber]) {
        return TAXICALLS[callNumber]
    }
    return false;
}

// получить ОБЬЕКТ звонка по ID КЛИЕНТА
function getTaxiCallObjectByCuid(cuid) {
    foreach(callNumber, value in TAXICALLS) {
        if(value.cuid == cuid) {
            return value;
        }
    }
    return false;
}

// получить ОБЬЕКТ звонка по ID ВОДИТЕЛЯ
function getTaxiCallObjectByDrid(drid) {
    foreach(callNumber, value in TAXICALLS) {
        if(value.drid == drid) {
            return value;
        }
    }
    return false;
}


// получить НОМЕР звонка по ID КЛИЕНТА
function getTaxiCallNumberByCuid(cuid) {
    local callObject = getTaxiCallObjectByCuid(cuid);
    if(callObject) return callObject.id;
    return false;
}


// получить НОМЕР звонка по ID ВОДИТЕЛЯ
function getTaxiCallNumberByDrid(drid) {
    local callObject = getTaxiCallObjectByDrid(drid);
    if(callObject) return callObject.id;
    return false;
}


// получить ID КЛИЕНТА по ID ВОДИТЕЛЯ
function getTaxiCallCuidByDrid(drid) {
    local callObject = getTaxiCallObjectByDrid(drid);
    if(callObject) return callObject.cuid;
    return false;
}

// у таксиста есть о заказ?
function isDridHaveTaxiCall(drid) {
    return (getTaxiCallObjectByDrid(drid) != false);
}

// у клиента есть о заказ?
function isCuidHaveTaxiCall(cuid) {
    return (getTaxiCallObjectByCuid(cuid) != false);
}

event("onPlayerPhoneCall", function(playerid, number, place) {
    if(number == "taxi") {
        if (!canMoneyBeSubstracted(playerid, moneyMinimum)) {
            return msg_taxi_cu(playerid, "taxi.call.notenoughmoney", [ moneyMinimum ] );
        }
        taxiAddCall(playerid, place);
    }
});


function taxiAddCall(playerid, place) {

   //if (isTaxiDriver(playerid) && getTaxiDriverStatus(playerid, true) != "offair") {
   //    return msg_taxi_dr(playerid, "job.taxi.driver.dontfoolaround"); // don't fool around
   //}

    local cuid = getCharacterIdFromPlayerId(playerid);

    if(isCuidHaveTaxiCall(cuid)) {
        return msg_taxi_cu(playerid, "Вы уже сделали заказ такси по этому адресу. Ожидайте...");
    }

    local check = false;
    local distance = 10000.0;
    local winnerDrid = null;
    local phoneObj = getPhoneObj(place);

    foreach(drid, value in DRIVERS) {
        local driverid = getPlayerIdFromCharacterId(drid);
        log(value);
        if(value.status == "onair"/* && isPlayerCarTaxi(driverid)*/) {

            local distanceToCurrentDrid = getDistanceByRect(getPlayerPositionObj(driverid), { x = phoneObj[0], y = phoneObj[0] });
            if(distanceToCurrentDrid < distance) {
                winnerDrid = drid;
                distance = distanceToCurrentDrid;
            }

            check = true;
        }
    }

    if(!check) {
        return msg_taxi_cu(playerid, "taxi.call.nofreecars");
    }

    local driverid = getPlayerIdFromCharacterId(winnerDrid);

    // Добавим звонок в список звонков
    addTaxiCall(place.slice(9).tointeger(), playerid, winnerDrid);

    msg_taxi_dr(driverid, "job.taxi.call.new", [ plocalize(driverid, place) ]);
    msg_taxi_cu(playerid, "taxi.call.youcalled", plocalize(playerid, place));

    local placeNameSmall = "taxiSmall"+cuid;

    if(isPlaceExists(placeNameSmall)) {
        removePlace(placeNameSmall);
    }

    setTaxiDriverStatus(winnerDrid, "busy");
    trigger(driverid, "setGPS", phoneObj[0], phoneObj[1]);

    createPlace(placeNameSmall, phoneObj[0]-TAXI_PLACE_SMALL, phoneObj[1]+TAXI_PLACE_SMALL, phoneObj[0]+TAXI_PLACE_SMALL, phoneObj[1]-TAXI_PLACE_SMALL);
    createPlace("taxi"+winnerDrid+"Customer"+cuid, phoneObj[0]-30, phoneObj[1]+30, phoneObj[0]+30, phoneObj[1]-30);
}


function taxiCallStartNew () {

}

/* ******************************************************************************************************************************************************* */
/**
 * Call taxi car from <place>
 * @param  {int} playerid
 * @param  {string} place   - address place of call
 * @param  {int} again      - if set 1, message not be shown for playerid
 */
/*
function taxiCallByPlayer(playerid, place, again = 0) {
    log("place:");
    log(place)

    local cuid = getCharacterIdFromPlayerId(playerid);

    local callNumber = addTaxiCall(place.slice(9).tointeger(), playerid).id;

    // Устанавливаем приоритет звонков от игроков над звонками от ботов, сбрасываем через 60 секунд
    calls_priority = true;
    delayedFunction(calls_timeout * 1000, function() {
        calls_priority = false;
        local callObject = getTaxiCallObjectByCallNumber(callNumber);
        if(callObject && callObject.drid == null) {
            removeTaxiCall(callNumber);
        }
    });

    local placeNameSmall = "taxiSmall"+cuid;
    if(isPlaceExists(placeNameSmall)) {
        removePlace(placeNameSmall);
    }
    local phoneObj = getPhoneObj(place);

    createPlace(placeNameSmall, phoneObj[0]-7.5, phoneObj[1]+7.5, phoneObj[0]+7.5, phoneObj[1]-7.5);

    if (!again) msg_taxi_cu(playerid, "taxi.call.youcalled", plocalize(playerid, place));
}
*/
// Завершение поездки для реального игрока
function taxiCallFinishForPlayer (playerid) {
    if (!isTaxiDriver(playerid) || !isPlayerCarTaxi(playerid)) {
        return;
    }

    local drid = getCharacterIdFromPlayerId(playerid);
    local driverStatus = getTaxiDriverStatus(drid);

    if(driverStatus == "offair") {
        return msg_taxi_dr(playerid, "job.taxi.cantmanagecall");
    }

    local callObject = getTaxiCallObjectByDrid(drid);
    if(!callObject) {
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    // if(callObject.targetPlaceId) {
    //     return msg_taxi_dr(playerid, "job.taxi.needdrive");
    // }

    local status = getTaxiCallStatus(callObject.id)

    // Если статус не указан, водитель не подобрал пассажира
    if(!status) {
        return msg_taxi_dr(playerid, "job.taxi.pickup");
    }

    local vehicleid = getPlayerVehicle(playerid);
    local targetid = getPlayerIdFromCharacterId(callObject.cuid);

    local distance = 0;

    // Если звонок выполнен
    if(status == "resolved") {
        // прочитаем значение дистанции из звонка
        distance = callObject.distance;
    }

    // Если звонок в процессе выполнения и хотим завершить его
    if(status == "active") {
        // расчитаем и запишем дистанцию, сменим статус
        distance = getVehicleMileage(vehicleid).tofloat() - callObject.mileageStart;
        setTaxiCallDistance(callObject.id, distance);
        setTaxiCallStatus(callObject.id, "resolved");

        // зададим позицию пассажира, равную позиции автомобиля такси (на случай краша) и принудительно сохраним
        if(targetid) {
            setPlayerPositionObj(targetid, getVehiclePositionObj(vehicleid));
            players[targetid].save();
        }
    }


/*
    local finishPos = getVehiclePositionObj(vehicleid);


    local startPos = null;

    // если пассажир вызывал по телефону
    if(callObject.positionStart) {
        local phoneObj = getPhoneObjById(callObject.placeId);
        startPos = { x = phoneObj[0], y = phoneObj[1] };
    }

    // если пассажира подобрали
    if(callObject.positionStart) {
        startPos = callObject.positionStart;
    }

*/

    local amount = round(distance * price, 2);
    local distanceKm = round(distance / 1000, 2);

    msg_taxi_dr(playerid, "taxi.call.finish.waitpaying", [ amount, distanceKm ] );
    msg(playerid, "taxi.call.finish.waitpaying.hint1", CL_GRAY);
    msg(playerid, "taxi.call.finish.waitpaying.hint2", CL_GRAY);

    if(targetid) {
        msg_taxi_cu(targetid, "taxi.call.finish.needpay", [ amount, distanceKm ] );
        msg(targetid, "taxi.call.finish.needpay.hint", [ amount, playerid, amount ], CL_GRAY);
    } else {
        msg(playerid, "taxi.call.finish.waitpaying.offline", CL_ERROR);
    }
    //removeTaxiCall(callObject.id);

}














function taxiCallTake (playerid) {
    if (!isTaxiDriver(playerid) || !isPlayerCarTaxi(playerid)) {
        return ;
    }

    local drid = getCharacterIdFromPlayerId(playerid);
    local driverStatus = getTaxiDriverStatus(drid);

    if(driverStatus == "offair") {
        return msg_taxi_dr(playerid, "job.taxi.canttakecall"); // нельзя взять, нужно выйти на линию
    }

    if(driverStatus == "busy") {
        return msg_taxi_dr(playerid, "job.taxi.takencall"); // уже есть другой заказ
    }

}

/**
 * Manage call
 * @param  {int} playerid
 * @param  {int} customerid - id customer
 */
function taxiManageCall(playerid) {

    if (!isTaxiDriver(playerid)) {
        return;
    }

    local drid = getCharacterIdFromPlayerId(playerid);
    local driverStatus = getTaxiDriverStatus(drid);

    if(driverStatus == "offair") {
        return msg_taxi_dr(playerid, "job.taxi.canttakecall");
    }

    if(driverStatus == "busy") {
        return msg_taxi_dr(playerid, "job.taxi.takencall");
    }



    local callObject = getTaxiCallObjectByDrid(drid);

    if(!callObject) {
        return msg_taxi_dr(playerid, "job.taxi.nofreecalls");
    }
    log( callObject );
    if(callObject && callObject.drid == null) {
        log( callObject );
        log( "in if" );
        //if(isCounterStarted(playerid)) {
        //    taxiCallDone(playerid);
        //}
        return;
    }


    return log("my end of function");
    // здесь вызывается функция отказа от заказа (которой нет)
    // if(job_taxi[players[playerid].id]["customer"] != null) {
    // dbg("refusing"); return taxiCallRefuse(playerid);
    // };



    if(callObject.drid == drid) {
        return msg_taxi_dr(playerid, "job.taxi.takenthiscall", callObject.number);
    }

    if(callObject.drid) {
        return msg_taxi_dr(playerid, "job.taxi.callalreadytaken", callObject.number);
    }

    local cuid = callObject.cuid;
    local customerid = cuid;

    if( callObject.cuid < TAXI_CHARACTERS_LIMIT ) {
        local customerid = getPlayerIdFromCharacterId(cuid);
    }

    if ( !customerid || customerid == false || customerid == playerid ) {
        return msg_taxi_dr(playerid, "job.taxi.callnotexist");
    }

    setTaxiCallDriver(callObject.number, drid);
    setTaxiDriverStatus(drid, "busy");

    msg_taxi_dr(playerid, "job.taxi.youtakencall");

    if( callObject.cuid < TAXI_CHARACTERS_LIMIT) {
        msg_taxi_cu(customerid, "taxi.call.received");
    } else {
        log("callObject.place"+ callObject.place)
        local ped_coords = getPedTaxiCoords(callObject.place);
        if (ped_coords != false) {
            trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, ped_coords[0], ped_coords[1], ped_coords[2], ped_coords[3], 0.0, 0.0 );
        }
    }

    local phoneObj = getPhoneObj("telephone"+callObject.place);
    trigger(playerid, "setGPS", phoneObj[0], phoneObj[1]);
    createPlace("taxi"+drid+"Customer"+customerid, phoneObj[0]-10, phoneObj[1]+10, phoneObj[0]+10, phoneObj[1]-10);

}
