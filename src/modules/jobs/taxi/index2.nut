include("modules/jobs/taxi/commands.nut");
include("modules/jobs/taxi/translations.nut");
include("modules/jobs/taxi/peds_coords.nut");


local job_taxi = {};
local price = 0.0015; // for 1 meter

const TAXI_JOB_SKIN = 171;
const TAXI_JOB_LEVEL = 2;

local TAXI_BLIP = [-710.638, 255.64, 0.365978];
local TAXI_COORDS = [-720.586, 248.261, 0.365978];
local TAXI_RADIUS = 2.0;
local TAXI_CHARACTERS_LIMIT = 1000000;

local calls_counter = 0;
local calls_priority = false;
local calls_in_queue = 0;
local calls_timeout = 60; // seconds

local TAXI_CALLS = {};

function addTaxiCall(placeNumber, playerid) {
    local cuid = playerid;

    if (playerid < TAXI_CHARACTERS_LIMIT) {
        cuid = getCharacterIdFromPlayerId(playerid);
    }

    if (!cuid) return;

    TAXI_CALLS[calls_counter] <- {
            cuid = cuid,
           place = placeNumber,
            drid = null,
         counter = { status = "stop", value = 0 }, // stop / play / pause
          number = calls_counter
    };

    calls_counter += 1;
    return TAXI_CALLS[calls_counter - 1];
}

function setTaxiDriverToCall(callNumber, drid) {
    TAXI_CALLS[callNumber].drid = drid;
}

function removeTaxiDriverFromCall(callNumber) {
    TAXI_CALLS[callNumber].drid = null;
}

function removeTaxiCall(callNumber) {
    delete TAXI_CALLS[callNumber];
}

function getCalls() {
    log(TAXI_CALLS);
    return TAXI_CALLS;
}



// получить обьект звонка по id звонка
function getTaxiCallObjectByCallNumber(callNumber) {
    if(TAXI_CALLS[callNumber]) {
        return TAXI_CALLS[callNumber]
    }
    return false;
}

// получить обьект звонка по id клиента
function getTaxiCallObjectByCuid(cuid) {
    foreach(callNumber, value in TAXI_CALLS) {
        if(value.cuid == cuid) {
            local callObject = clone(value)
            callObject.number <- callNumber;
            return callObject;
        }
    }
    return false;
}


// получить номер звонка по id клиента
function getTaxiCallNumberByCuid(cuid) {
    local callObject = getTaxiCallObjectByCuid(cuid);
    if(callObject) return callObject.number;
    return false;
}


// получить обьект звонка по id водителя
function getTaxiCallObjectByDrid(drid) {
    foreach(callNumber, value in TAXI_CALLS) {
        if(value.drid == drid) {
            local callObject = clone(value)
            callObject.number <- callNumber;
            return callObject;
        }
    }
    return false;
}


// получить номер звонка по id водителя
function getTaxiCallNumberByDrid(drid) {
    local callObject = getTaxiCallObjectByDrid(drid);
    if(callObject) return callObject.number;
    return false;
}


// получить id клиента по id водителя
function getTaxiCallCuidByDrid(drid) {
    local callObject = getTaxiCallObjectByDrid(drid);
    if(callObject) return callObject.cuid;
    return false;
}

// у таксиста есть о заказ?
function isDridHaveTaxiCall(drid) {
    return (getTaxiCallNumberByDrid(drid) != false);
}


local DRIVERS = {};

function getDrivers() {
    log(DRIVERS);
    return DRIVERS;
}


// добавить водителя такси по charid
function addTaxiDriver(drid) {
    DRIVERS[drid] <- {
        status = "offair",
        vehicleid = null
    };
}

function setTaxiDriverStatus(drid, status) {
    log("Set status to "+status);
    return DRIVERS[drid].status = status;
}

function getTaxiDriverStatus(xid, byPlayerid = false) {
    if(byPlayerid) xid = getCharacterIdFromPlayerId(xid);
    return DRIVERS[xid].status;
}

function setTaxiDriverCar(drid, vehicleid) {
    log("Set vehicleid to "+vehicleid);
    return DRIVERS[drid].vehicleid = vehicleid;
}

function getTaxiDriverCar(drid) {
    log("get vehicleid");
    return DRIVERS[drid].vehicleid;
}

// есть ли свободная машина?
function isHaveFreeDriver() {
    foreach(drid, value in DRIVERS) {
        local driverid = getPlayerIdFromCharacterId(drid);
        if(value.status == "onair" && isPlayerCarTaxi(driverid)) {
            return true;
        }
    }
    return false;
}


event("onServerStarted", function() {
    log("[jobs] loading taxi job...");
    local taxicars = [
        createVehicle(24, -127.650, 412.521, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 1
        createVehicle(24, -127.650, 408.872, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 2
        createVehicle(24, -127.650, 405.611, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 3
        createVehicle(24, -127.650, 402.069, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 4
        createVehicle(33, -127.650, 398.769, -13.98, -90.0, 0.2, -0.2),   // taxi East Side 5
        createVehicle(33, -708.733, 248.0, 0.504346, -0.44367, -0.00094714, -0.230679 ), // Taxi1
        createVehicle(33, -714.508, 248.0, 0.504346, -0.44367, -0.00094714, -0.244627 ), // Taxi2
        createVehicle(24, -718.301, 261.576, 0.504056, 141.868, -0.025185, 0.340924 ), // Taxi3
        createVehicle(24, -712.0, 262.183, 0.504394, 141.868, -0.025185, 0.340924   ), // Taxi4
        createVehicle(33, -479.656, 702.3, 1.2, -179.983, -2.09183, 0.445576  ),     // taxi Uptown 1
        createVehicle(24, -483.363, 702.3, 1.2, -178.785, -2.16034, 0.16853   ),     // taxi Uptown 2

        createVehicle(24, -533.348, 1583.63, -16.4578, 0.272268, 0.379557, -0.261274 ),         // taxi_naprotiv_vokzala_1
        createVehicle(33, -547.207, 1600.14, -16.4299, -179.116, -0.221615, 0.447305 ),         // taxi_naprotiv_vokzala_2
        // createVehicle(24, -551.133, 1583.27, -16.4543, 0.443711, 0.00174642, -0.451021 ),    // taxi_naprotiv_vokzala_3
        // createVehicle(   24, -658.287, 236.719, 1.17881, -179.192, 0.255169, -0.234465 ),    // TaxiDEVELOPER
        // createVehicle(33, -487.191, 702.3, 1.2, -178.078, -2.24803, 0.0579244 ),             // taxi Uptown 3
    ];

    registerPersonalJobBlip("taxidriver", TAXI_BLIP[0], TAXI_BLIP[1]);
    delayedFunction(10000, function() {
        callTaxiByPed();
    });
});

event("onPlayerConnect", function(playerid) {
    if(isTaxiDriver(playerid)) {
        local drid = getCharacterIdFromPlayerId(playerid);
        if ( !(drid in DRIVERS) ) {
            addTaxiDriver(drid);
        }
    }
});

event("onPlayerDisconnect", function(playerid, reason) {
    if(isTaxiDriver(playerid)) {
        local drid = getCharacterIdFromPlayerId(playerid);
        if(getTaxiDriverStatus(drid) == "onair") {
            setTaxiDriverStatus(drid, "offair");
        }
        setTaxiDriverCar(drid, null);
    }
});

event("onServerPlayerStarted", function( playerid ){
    if(isTaxiDriver(playerid)) {
        msg_taxi_dr( playerid, "job.taxi.continue");
        msg_taxi_dr( playerid, "job.taxi.ifyouwantstart");
        createText ( playerid, "taxiJob3dText", TAXI_COORDS[0], TAXI_COORDS[1], TAXI_COORDS[2]+0.20, "Press Q to leave job", CL_WHITE.applyAlpha(150), TAXI_RADIUS );
    } else {
        createText ( playerid, "taxiJob3dText", TAXI_COORDS[0], TAXI_COORDS[1], TAXI_COORDS[2]+0.20, "Press E to get job", CL_WHITE.applyAlpha(150), TAXI_RADIUS );
    }
});


/* onVehicleEnter. Вход в авто: */
event( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    /* возможного ВОДИТЕЛЯ или действительного ВОДИТЕЛЯ */
    if(isVehicleCarTaxi(vehicleid) && seat == 0) {
        // если водитель не таксист - блочим тачку
        if(!isTaxiDriver(playerid)) {
            blockVehicle(vehicleid);
        } else {
            // иначе разблочим тачку
            unblockVehicle(vehicleid);
            // устанавливаем новый айди авто для таксиста
            local drid = getCharacterIdFromPlayerId(playerid);
            setTaxiDriverCar(drid, vehicleid);
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

        local cuid = getCharacterIdFromPlayerId(playerid);
        local drid = getCharacterIdFromPlayerId(driverid);

        local driverStatus = getTaxiDriverStatus(drid);
        if(driverStatus == "onair") {
            //показать предложение принять вызов: Возможный пассажир сел в ваш автомобиль такси. Начать поездку?
            return;
        }

        if(driverStatus == "offair") return;

        // раз попали сюда, значит у водителя статус 'busy', а значит на нём висит вызов:
        local callObject = getTaxiCallObjectByCuid(cuid);

        // если cuid вошедшего игрока равен cuid звонка, продолжаем поездку
        if(cuid == callObject.cuid) {
            msg_taxi_dr( driverid, "job.taxi.taximeteron");
            // включить таксиметр на продолжение отсчёта
        }

        //// start taximeter
        //taxiStartCounter(driverid);
        //if(job_taxi[driverid]["counter"][0] != "pause") { // if player enters into vehicle in process again - don't show messages
        //    msg_taxi_cu( playerid, "taxi.call.isfree");
        //    msg_taxi_dr( driverid, "job.taxi.taximeteron");
        //}

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

        // Выход ВОДИТЕЛЯ из авто - создания зоны сброса
        if(seat == 0 && isTaxiDriver(playerid) && getTaxiDriverStatus(playerid, true) != "offair") {
            local drid = getCharacterIdFromPlayerId(playerid);
            local vehPos = getVehiclePosition(vehicleid);
            createPlace("TaxiDriverZone"+drid, vehPos[0]-25, vehPos[1]+25, vehPos[0]+25, vehPos[1]-25);
        }

    }
});



/* ******************************************************************************************************************************************************* */

/* onPlaceEnter. Вход ВОДИТЕЛЯ в зону - при прибытии к клиенту */
event("onPlayerPlaceEnter", function(playerid, name) {

    if (!isTaxiDriver(playerid)) {
        return;
    }

    if (!isPlayerCarTaxi(playerid)) {
        return;
    }

    // получаем обьект заказа, если его нет - водитель либо offair, либо onair без заказа
    local drid = getCharacterIdFromPlayerId(playerid);
    local callObject = getTaxiCallObjectByDrid(drid);
    if(!callObject) {
        return;
    }

    local cuid = callObject.cuid;
    if ("taxi"+drid+"Customer"+cuid == name) {

        local plate = getVehiclePlateText( getPlayerVehicle( playerid ) );

        removePlace("taxi"+drid+"Customer"+cuid);
        trigger(playerid, "removeGPS");

        msg_taxi_dr(playerid, "job.taxi.wait");

        // выполняется если Клиент - реальный игрок
        if (cuid < TAXI_CHARACTERS_LIMIT) {
            removePlace("taxiSmall" + cuid);
            removePlace("taxiBig" + cuid);
            msg_taxi_cu(getPlayerIdFromCharacterId(cuid), "taxi.call.arrived", plate);
        }
    }
});



/* onPlaceExit. Выход ВОДИТЕЛЯ пешком из зоны сброса */
event("onPlayerPlaceExit", function(playerid, name) {
    local drid = getCharacterIdFromPlayerId(playerid);
    if(!isTaxiDriver(playerid) || getTaxiDriverStatus(drid) == "offair" || name != "TaxiDriverZone"+drid ) {
        return;
    }
    //taxiStopCounter(playerid);
    setTaxiDriverStatus(drid, "offair");

    setTaxiLightState(getTaxiDriverCar(drid), false);
    setTaxiDriverCar(drid, null);
    removePlace("TaxiDriverZone"+drid);
    msg_taxi_dr(playerid, "job.taxi.leaveline");
    local callObject = getTaxiCallObjectByDrid(drid);
    removeTaxiCall(callObject.number);
});


/* onPlaceExit. Выход КЛИЕНТА из зоны вызова до приезда водителя */
event("onPlayerPlaceExit", function(playerid, name) {
    local cuid = getCharacterIdFromPlayerId(playerid);
    if ("taxiSmall" + cuid  == name) {
        msg_taxi_cu(playerid, "taxi.call.ifyouaway");
        return;
    }

    if ("taxiBig" + cuid  == name) {
        msg_taxi_cu(playerid, "taxi.call.fakecall");
        removePlace("taxiSmall" + cuid);
        removePlace("taxiBig" + cuid);

        local callObject = getTaxiCallObjectByCuid(cuid);
        if(callObject) {
            removeTaxiCall(callObject.number);
            if(callObject.drid) {
                local drid = callObject.drid;

                removePlace("taxi"+drid+"Customer"+cuid);
                setTaxiDriverStatus(drid, "onair");

                local driverid = getPlayerIdFromCharacterId(drid);
                trigger(driverid, "removeGPS");
                msg_taxi_dr(driverid, "job.taxi.callnotexist");
            }
        }
    }

});



event("onPlayerPhoneCall", function(playerid, number, place) {
    if(number == "taxi") {
        taxiAddCallToQueue(playerid, place);
    }
});







function taxiAddCallToQueue(playerid, place) {

    if (isTaxiDriver(playerid) && getTaxiDriverStatus(playerid, true) != "offair") {
        return msg_taxi_dr(playerid, "job.taxi.driver.dontfoolaround"); // don't fool around
    }

    local check = false;
    foreach(drid, value in DRIVERS) {
        local driverid = getPlayerIdFromCharacterId(drid);
        if(value.status == "onair" && isPlayerCarTaxi(driverid)) {
            check = true;
            if (calls_in_queue == 0) {
                msg_taxi_dr(driverid, "job.taxi.call.new", [ plocalize(driverid, place) ]);
                msg_taxi_dr(driverid, "job.taxi.call.new.if" );
                taxiCall(playerid, place);
            } else {
                delayedFunction(calls_timeout * calls_in_queue * 1000, function() {
                    taxiCall(playerid, place);
                });
            }
        }
    }

    if(!check) {
        return msg_taxi_cu(playerid, "taxi.call.nofreecars");
    }

}











/* ******************************************************************************************************************************************************* */
/**
 * Call taxi car from <place>
 * @param  {int} playerid
 * @param  {string} place   - address place of call
 * @param  {int} again      - if set 1, message not be shown for playerid
 */

function taxiCall(playerid, place, again = 0) {



    //local check = false;
    //foreach(drid, value in DRIVERS) {
    //    local driverid = getPlayerIdFromCharacterId(drid);
    //    if(value.status == "onair" && isPlayerCarTaxi(driverid)) {
    //        check = true;
    //        msg_taxi_dr(driverid, "job.taxi.call.new", [ plocalize(driverid, place) ]);
    //        msg_taxi_dr(driverid, "job.taxi.call.new.if" );
    //    }
    //}

    //if(!check) {
    //    return msg_taxi_cu(playerid, "taxi.call.nofreecars");
    //}

    local cuid = getCharacterIdFromPlayerId(playerid);

    local callNumber = addTaxiCall(place.slice(9).tointeger(), playerid).number;

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
    local placeNameBig   = "taxiBig"+cuid;
    if(isPlaceExists(placeNameSmall) || isPlaceExists(placeNameBig)) {
        removePlace(placeNameSmall);
        removePlace(placeNameBig);
    }
    local phoneObj = getPhoneObj(place);

    createPlace(placeNameSmall, phoneObj[0]-7.5, phoneObj[1]+7.5, phoneObj[0]+7.5, phoneObj[1]-7.5);
    createPlace(placeNameBig,   phoneObj[0]-15, phoneObj[1]+15, phoneObj[0]+15, phoneObj[1]-15);

    if (!again) msg_taxi_cu(playerid, "taxi.call.youcalled", plocalize(playerid, place));
}


/* ******************************************************************************************************************************************************* */
/**
 * Call taxi car from current place (для пассажира, который сел без звонка)
 * @param  {int} playerid
 * @param  {string} place   - address place of call
 * @param  {int} again      - if set 1, message not be shown for playerid
 */




/* ******************************************************************************************************************************************************* */
/**
 * Call taxi car by ped
 */

function callTaxiByPed() {

    // вызывать такси от бота каждый 5-15 секунд
    delayedFunction(random(5, 15)*1000, function() {
        callTaxiByPed();
    });

    if(calls_priority == true) {
        return;
    }


    //local pedid = (random(10, 99).tostring()+random(10, 99).tostring()+random(100, 999).tostring()).tointeger();
    local placeNumber = random(0, 93 /* 54, 54 */);

    local check = false;
    foreach(drid, value in DRIVERS) {
        local driverid = getPlayerIdFromCharacterId(drid);
        if(value.status == "onair" && isPlayerCarTaxi(driverid)) {
            check = true;
            msg_taxi_dr(driverid, "job.taxi.call.new", [ plocalize(driverid, "telephone"+placeNumber) ]);
            msg_taxi_dr(driverid, "job.taxi.call.new.if" );
        }
    }

    if(!check) {
        //log("No free drivers");
        return;
    }

    local cuid = (random(10, 99).tostring()+random(10, 99).tostring()+random(100, 999).tostring()).tointeger();
    local callObject = addTaxiCall(placeNumber, cuid);

    // если за calls_timeout секунд заказ никто не взял - заказ удаляется
    delayedFunction(calls_timeout * 1000, function() {
        local callObj = getTaxiCallObjectByCallNumber(callObject.number);
        if(callObj && callObj.drid == null) {
            removeTaxiCall(callObject.number);
        }
    });

    log("Pedid "+callObject.cuid+" called taxi to telephone"+placeNumber);

}


/* ******************************************************************************************************************************************************* */

/**
 * Switch userstatus air
 * @param  {int} playerid
 */
function taxiSwitchAir(playerid) {

    if (!isTaxiDriver(playerid) || !isPlayerCarTaxi(playerid)) {
        return ;
    }

    local drid = getCharacterIdFromPlayerId(playerid);
    local status = getTaxiDriverStatus(drid);
    if(status == "busy") {
        return msg_taxi_dr(playerid, "job.taxi.cantchangestatus");
    }

    if(status == "offair") {
        setTaxiDriverStatus(drid, "onair");
        setTaxiLightState(getPlayerVehicle(playerid), true);
        msg_taxi_dr(playerid, "job.taxi.statuson" );

    } else {
        setTaxiDriverStatus(drid, "offair");
        setTaxiLightState(getPlayerVehicle(playerid), false);
        msg_taxi_dr(playerid, "job.taxi.statusoff");
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

    local callObject = getTaxiCallObjectByDrid(drid);

    if(callObject == null) {
        return msg_taxi_dr(playerid, "job.taxi.nofreecalls");
    }

    if(callObject && callObject.counter.status == "") {
        local callObject = getTaxiCallObjectByDrid(drid);
        log( callObject );
        log("completeRoute");
        //if(isCounterStarted(playerid)) {
        //    taxiCallDone(playerid);
        //}
        return;
    }

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

    setTaxiDriverToCall(callObject.number, drid);
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

/* ******************************************************************************************************************************************************* */


/**
 * Report that the taxicar has arrived to the address
 * @param  {int} playerid
 */
/*
function taxiCallReady(playerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.driver.not");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.needcar");
    }

    local customerid = job_taxi[players[playerid].id]["customer"];

    if (customerid == null){
dbg(customerid);
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    local plate = getVehiclePlateText( getPlayerVehicle( playerid ) );
    msg_taxi_dr(playerid, "job.taxi.wait");
    msg_taxi_cu(customerid, "taxi.call.arrived", plate);
    setPlayerTaxiUserStatus(playerid, "onroute");
}
*/
/**
 * Refuse the call
 * @param  {int} playerid
 */
function taxiCallRefuse(playerid) {

    local customerid = job_taxi[players[playerid].id]["customer"];
/*
    if (customerid == null){
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }
*/
    if(getPlayerTaxiUserStatus(playerid) == "onroute") {
        return msg_taxi_dr(playerid, "job.taxi.cantrefuse");
    }

    job_taxi[players[playerid].id]["customer"] = null;
    setPlayerTaxiUserStatus(playerid, "onair");

    msg_taxi_dr(playerid, "job.taxi.refusedcall");
    msg_taxi_cu(customerid, "taxi.call.refused");
    removePlace("taxi"+playerid+"Customer"+customerid);
    trigger(playerid, "removeGPS");

    delayedFunction(5000,  function() {
        taxiCall(customerid, TAXI_CALLS[customerid][0], 1);
    });
}



/* ******************************************************************************************************************************************************* */


/**
 * End trip, pay for trip and call
 * @param  {int} playerid
 * @param  {float} amount   - amount for trip at taxi. Default $3.0
 */
function taxiCallDone(playerid) {


    local customerid = job_taxi[players[playerid].id]["customer"];

    if (customerid == null){
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    local distance = job_taxi[players[playerid].id]["counter"][1];
    msg_taxi_dr( playerid, "job.taxi.endtrip", [ distance ] );
    msg_taxi_cu( customerid, "taxi.call.completed" );
    taxiStopCounter(playerid);

    delete TAXI_CALLS[ job_taxi[players[playerid].id]["customer"] ];

    setPlayerTaxiUserStatus(playerid, "onair");
    //job_taxi[players[playerid].id]["counter"][0] <- "stop";
    //job_taxi[players[playerid].id]["counter"][1] <- null;
    job_taxi[players[playerid].id]["customer"] <- null;

    if(distance > 250.0) {
    local amount = distance * price;
        if(canTreasuryMoneyBeSubstracted(amount)) {
            subMoneyToTreasury(amount);
            addMoneyToPlayer(playerid, amount);
            msg_taxi_dr( playerid, "job.taxi.youearn", amount );
            dbg("[TAXI] "+getPlayerName(playerid)+" earned $"+amount+" for "+distance+" meters");
        } else {
            msg_taxi_dr( playerid, "job.taxi.treasurynotenough" );
        }
    } else {
        msg_taxi_dr( playerid, "job.taxi.treasurynotenough" );
    }

/*
    msg_taxi_dr(playerid, "job.taxi.requested", amount );
    msg_taxi_cu(customerid, "taxi.call.request", amount);
    sendInvoiceSilent(playerid, customerid, amount, function(customerid, driverid, result) {
        // playerid responded to invoice from customerid with result
        // (true - acepted / false - declined)
        if(result == true) {
            players[customerid]["taxi"]["call_state"] = "closed";
            job_taxi[driverid]["customer"] = null;
            job_taxi[driverid]["userstatus"] = "onair";
            msg_taxi_dr(driverid, "job.taxi.completed", playerid );
            msg_taxi_cu(customerid, "taxi.call.completed" );
        } else {
            msg(driverid "job.taxi.psngdeclined", getPlayerNameShort(customerid), CL_RED );
            msg(customerid, "taxi.call.declined", CL_RED );
        }
    }
    );
*/

}


/**
 * Close call
 * @param  {int} playerid
 */
function taxiCallClose(playerid) {

    if (!isTaxiDriver(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.driver.not");
    }

    if (!isPlayerCarTaxi(playerid)) {
        return msg_taxi_dr(playerid, "job.taxi.needcar");
    }

    local customerid = job_taxi[players[playerid].id]["customer"];

    if (customerid == null){
        return msg_taxi_dr(playerid, "job.taxi.noanycalls");
    }

    players[customerid]["taxi"]["call_state"] = "closed";
    job_taxi[players[playerid].id]["customer"] = null;
    setPlayerTaxiUserStatus(playerid, "onair");
    msg_taxi_dr(playerid, "job.taxi.callclosed" );
}



/* ******************************************************************************************************************************************************* */



key("e", function(playerid) {
    taxiJobGet ( playerid );
}, KEY_UP);

key("q", function(playerid) {
    taxiJobRefuseLeave ( playerid );
}, KEY_UP);

key("1", function(playerid) {
    taxiSwitchAir(playerid);
}, KEY_UP);

key("2", function(playerid) {
    //taxiCallTakeRefuse ( playerid );
    taxiManageCall( playerid );
}, KEY_UP);

key("4", function(playerid) {
    //taxiCallTakeRefuse ( playerid );
    calls_priority = !calls_priority;
    log("set priority to: "+calls_priority)
}, KEY_UP);


/*

key("3", function(playerid) {
    job_taxi[players[playerid].id]["userstatus"] <- "onair";
}, KEY_UP);

key("4", function(playerid) {
    dbg("=====================================================");
    dbg("LASTCALL: "+TAXI_LASTCALL);
    dbg(TAXI_CALLS);
    dbg("userstatus: "+getPlayerTaxiUserStatus(playerid));
    dbg(job_taxi[players[playerid].id]["counter"]);
    dbg("customer: "+job_taxi[players[playerid].id]["customer"]);
    dbg("car: "+job_taxi[players[playerid].id]["car"]);
}, KEY_UP);

local posA = null;
key("5", function(playerid) {
    if(posA == null) { posA = getPlayerPosition(playerid); msg( playerid, "Save posA." );}
    else {
    local posB = getPlayerPosition(playerid);
    local distance = getDistanceBetweenPoints3D( posA[0], posA[1], posA[2], posB[0], posB[1], posB[2] );
        msg( playerid, "Distance: " + distance + "." );
    posA = null;
    }

}, KEY_UP);

*/

/* ******************************************************************************************************************************************************* */



/**
 * Get taxi driver job
 * @param  {int} playerid
 */
function taxiJobGet(playerid) {
    if(!isPlayerInValidPoint(playerid, TAXI_COORDS[0], TAXI_COORDS[1], TAXI_RADIUS)) {
        return;
    }

    //return msg(playerid, "job.taxi.novacancy", CL_WARNING);


    //if(!isPlayerLevelValid ( playerid, TAXI_JOB_LEVEL )) {
    //    return msg(playerid, "job.taxi.needlevel", TAXI_JOB_LEVEL );
    //}

    if(isTaxiDriver(playerid)) {
        return msg(playerid, "job.taxi.driver.already");
    }

    if(isPlayerHaveJob(playerid)) {
        return msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid) );
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg_taxi_dr(playerid, "job.taxi.driver.now");
        msg_taxi_dr( playerid, "job.taxi.ifyouwantstart");
        renameText ( playerid, "taxiJob3dText", "Press Q to leave job");
        setPlayerJob( playerid, "taxidriver");
        setPlayerModel( playerid, TAXI_JOB_SKIN );
    });
}



/* ******************************************************************************************************************************************************* */



/**
 * Leave from taxi driver job
 * @param  {int} playerid
 */
function taxiJobRefuseLeave(playerid) {
    if(!isPlayerInValidPoint(playerid, TAXI_COORDS[0], TAXI_COORDS[1], TAXI_RADIUS)) {
        return;
    }

    if(!isTaxiDriver(playerid)) {
        return msg(playerid, "job.taxi.driver.not");
    }

    if(getPlayerTaxiUserStatus(playerid) == "busy") {
        return msg_taxi_dr(playerid, "job.taxi.cantleavejob1");
    }

    if(getPlayerTaxiUserStatus(playerid) == "onroute") {
        return msg_taxi_dr(playerid, "job.taxi.cantleavejob2");
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg_taxi_dr(playerid, "job.leave");
        setPlayerJob( playerid, null );
        restorePlayerModel(playerid);
        renameText ( playerid, "taxiJob3dText", "Press E to get job");
        setPlayerTaxiUserStatus(playerid, "offair");

        if(job_taxi[players[playerid].id]["car"] != null) {
            setTaxiLightState(job_taxi[players[playerid].id]["car"], false);
            job_taxi[players[playerid].id]["car"] = null;
        }
    });
}


/* ******************************************************************************************************************************************************* */






/* ******************************************************************************************************************************************************* */


/**
 * msg to taxi customer
 * @param  {int}  playerid
 * @param  {string} text
 * @param  {string} options
 */
function msg_taxi_cu(playerid, text, options = []) {
    return msg(playerid, text, options, CL_CREAMCAN);
}

/**
 * msg to taxi driver
 * @param  {int}  playerid
 * @param  {string} text
 * @param  {string} options
 */

function msg_taxi_dr(playerid, text, options = []) {
    return msg(playerid, text, options, CL_ECSTASY);
}

/**
 * Check is player is a taxidriver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isTaxiDriver (playerid) {
    return (isPlayerHaveValidJob(playerid, "taxidriver"));
}

/**
 * Check is player's vehicle is a taxi car
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerCarTaxi(playerid) {
    return (isPlayerInValidVehicle(playerid, 24) || isPlayerInValidVehicle(playerid, 33));
}


/**
 * Check vehicle is a taxi car
 * @param  {int}  vehicleid
 * @return {Boolean} true/false
 */
function isVehicleCarTaxi(vehicleid) {
    return (getVehicleModel( vehicleid ) == 24 || getVehicleModel( vehicleid ) == 33);
}


function isCarTaxiFreeForDriver(vehicleid) {
    local check = true;
    foreach (targetid, value in job_taxi) {
        if (value["car"] == vehicleid ) {
            check = false;
        }
    }
    return check;
}





/* ******************************************************************************************************************************************************* */
/* не проверен весь блок ниже
/* ******************************************************************************************************************************************************* */

function taxiCounter (playerid, vx = null, vy = null, vz = null) {
    if (!isPlayerConnected(playerid) || job_taxi[players[playerid].id]["customer"] == null || !isPlayerConnected(job_taxi[players[playerid].id]["customer"]) || job_taxi[players[playerid].id]["counter"][0] != "play" || (job_taxi[players[playerid].id]["car"] != getPlayerVehicle(playerid) && getPlayerVehicle(playerid) != -1) ) {
        return;
    }

    local vehicleid = job_taxi[players[playerid].id]["car"];
   /*
dbg(getDistanceBtwPlayerAndVehicle(playerid, vehicleid));
    if( getPlayerVehicle(playerid) == -1) {
        delayedFunction(3000, function(){
            if (checkDistanceBtwPlayerAndVehicle(playerid, vehicleid, 40) == false) {
                job_taxi[players[playerid].id]["counter"] = null;
                dbg("Taxi counter bye");
                return;
            }
        });
    }
*/
    local vehPosOld = null;
    if (vx != null) {
        vehPosOld = [vx, vy, vz];
    } else {
        vehPosOld = getVehiclePosition(vehicleid);
    }


    local vehPosNew = getVehiclePosition(vehicleid);
    local dis = getDistanceBetweenPoints3D( vehPosOld[0], vehPosOld[1], vehPosOld[2], vehPosNew[0], vehPosNew[1], vehPosNew[2] );
    job_taxi[players[playerid].id]["counter"][1] += dis;
//dbg("taxi counter: "+dis);
    //msg( playerid, "Distance: "+job_taxi[players[playerid].id]["counter"] );

    delayedFunction(3500, function(){
        taxiCounter (playerid, vehPosNew[0], vehPosNew[1], vehPosNew[2]);
    });
}

/* ******************************************************************************************************************************************************* */


function taxiStartCounter(playerid) {
    if(job_taxi[players[playerid].id]["counter"][0] == "stop" ) {
        job_taxi[players[playerid].id]["counter"][1] = 0;
    }
    job_taxi[players[playerid].id]["counter"][0] = "play";
    taxiCounter (playerid);
}

function taxiStopCounter(playerid) {
    job_taxi[players[playerid].id]["counter"][0] = "stop";
    job_taxi[players[playerid].id]["counter"][1] = null;
    taxiCounter (playerid);
}

function taxiPauseCounter(playerid) {
    job_taxi[players[playerid].id]["counter"][0] = "pause";
    taxiCounter (playerid);
}

function isCounterStarted(playerid) {
    return (job_taxi[players[playerid].id]["counter"][0] != "stop") ? true : false;
}

/* ******************************************************************************************************************************************************* */
/* ******************************************************************************************************************************************************* */