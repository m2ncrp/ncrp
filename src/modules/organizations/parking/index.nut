include("modules/organizations/parking/translations.nut");

local PARKING_COORDS = [ -1211.12, 1342.12, -1390.86, 1364.81 ];
local PARKING_NAME = "CarPound";
local PARKING_COST = 45.0;

local parkingPlaceStatus = [];

local parkingPlace = [
    [-1380.0, 1358.0, -13.31],
    [-1376.0, 1358.0, -13.31],
    [-1372.0, 1358.0, -13.31],
    [-1368.0, 1358.0, -13.31],
    [-1364.0, 1358.0, -13.31],
    [-1360.0, 1358.0, -13.31],
    [-1356.0, 1358.0, -13.31],
    [-1352.0, 1358.0, -13.31],
    [-1348.0, 1358.0, -13.31],
    [-1344.0, 1358.0, -13.31],
    [-1340.0, 1358.0, -13.31],
    [-1336.0, 1358.0, -13.31],
    [-1332.0, 1358.0, -13.31],
    [-1328.0, 1358.0, -13.31],
    [-1324.0, 1358.0, -13.31],
    [-1320.0, 1358.0, -13.31],
    [-1316.0, 1358.0, -13.31],
    [-1312.0, 1358.0, -13.31],
    [-1308.0, 1358.0, -13.31],
    [-1304.0, 1358.0, -13.31],
    [-1300.0, 1358.0, -13.31],
    [-1296.0, 1358.0, -13.31],
    [-1292.0, 1358.0, -13.31],
    [-1288.0, 1358.0, -13.31],
    [-1284.0, 1358.0, -13.31],
    [-1280.0, 1358.0, -13.31],
    [-1276.0, 1358.0, -13.31],
    [-1272.0, 1358.0, -13.31],
    [-1268.0, 1358.0, -13.31],
    [-1264.0, 1358.0, -13.31],
    [-1260.0, 1358.0, -13.31],
    [-1256.0, 1358.0, -13.31],
    [-1252.0, 1358.0, -13.31],
    [-1248.0, 1358.0, -13.31],
    [-1244.0, 1358.0, -13.31],
    [-1240.0, 1358.0, -13.31],
    [-1236.0, 1358.0, -13.31],
    [-1232.0, 1358.0, -13.31],
    [-1228.0, 1358.0, -13.31],
    [-1224.0, 1358.0, -13.31],
    [-1220.0, 1358.0, -13.31],
];

    foreach (idx, value in parkingPlace) {
        parkingPlaceStatus.push("free");
    }

alternativeTranslate({
    "en|parking.needEnterPlate"    : "Need to enter plate number."
    "en|parking.checkPlate"        : "Check the correct plate number of the car."
    "en|parking.peopleInside"     : "Impossible pick up the car at car pound with people."
    "en|parking.alreadyParking"    : "Car already parked."
    "en|parking.complete"          : "Car has been parked at car pound."
    "en|parking.noFreeSpace"       : "No free space at car pound."
    "en|parking.carNotParked"      : "Car with plate number %s is not parked."
    "en|parking.notenoughmoney"    : "You don't have enough money."
    "en|parking.notYourCar"        : "This is not your car."
    "en|parking.free"              : "The car has been freed sucsessfully."
    "en|parking.pay"               : "If you have the key, need to pay to unpark (/unpark):"
    "en|parking.pay.fix"           : " - $%.2f (fixed rate)"
    "en|parking.pay.peni"          : " - $%.2f (storage)"
    "en|parking.pay.tax"           : " - $%.2f (tax)"
    "en|parking.pay.payment"       : "Payment is made from the bank account."

    "ru|parking.needEnterPlate"    : "Необходимо указать номер автомобиля."
    "ru|parking.checkPlate"        : "Проверьте правильность указанного номера автомобиля."
    "ru|parking.peopleInside"     : "Невозможно эвакуировать авто на штрафстоянку с людьми внутри."
    "ru|parking.alreadyParking"    : "Автомобиль уже находится на штрафстоянке."
    "ru|parking.complete"          : "Автомобиль эвакуирован на штрафстоянку."
    "ru|parking.noFreeSpace"       : "На штрафстоянке нет свободных мест."
    "ru|parking.carNotParked"      : "Автомобиль с номером %s отсутствует на штрафстоянке."
    "ru|parking.notenoughmoney"    : "Недостаточно наличных денег."
    "ru|parking.notYourCar"        : "Этот автомобиль вам не принадлежит."
    "ru|parking.free"              : "Вы забрали автомобиль со штрафстоянки."
    "ru|parking.pay"               : "Если у вас есть ключ от этого автомобиля, то, чтобы его забрать (/unpark), нужно заплатить:"
    "ru|parking.pay.fix"           : " - $%.2f (фиксированный тариф)"
    "ru|parking.pay.peni"          : " - $%.2f (хранение)"
    "ru|parking.pay.tax"           : " - $%.2f (начисленный налог)"
    "ru|parking.pay.payment"       : "Оплата производится со счёта в банке."
});

event("onServerStarted", function() {
    logStr("[police] parking...");
/*
    createVehicle(18, 16.15, 116.7, -13.8, 0.0, 0.0, 0.0 ); // 1
    createVehicle(18, 19.5,  116.7, -13.8, 0.0, 0.0, 0.0 ); // 2
    createVehicle(18, 22.85, 116.7, -13.8, 0.0, 0.0, 0.0 ); // 3
    createVehicle(18, 26.2,  116.7, -13.8, 0.0, 0.0, 0.0 ); // 4

    createVehicle(18, 16.15, 126.415, -13.8, 0.0, 0.0, 0.0 ); // 5
    createVehicle(18, 19.5,  126.415, -13.8, 0.0, 0.0, 0.0 ); // 6
    createVehicle(18, 22.85, 126.415, -13.8, 0.0, 0.0, 0.0 ); // 7
    createVehicle(18, 26.2,  126.415, -13.8, 0.0, 0.0, 0.0 ); // 8
*/
    // Create Police Officers Manager here
    // POLICE_MANAGER = OfficerManager();

    createPlace(PARKING_NAME, PARKING_COORDS[0], PARKING_COORDS[1], PARKING_COORDS[2], PARKING_COORDS[3]);

    createBlip  (-1300.0, 1358.0, [ 0, 5 ], ICON_RANGE_VISIBLE);

    findBusyPlaces();
});

event("onPlayerPlaceEnter", function(playerid, name) {
    if (isPlayerInVehicle(playerid) && name == PARKING_NAME) {
        local vehicleid = getPlayerVehicle(playerid);
        local vehPos = getVehiclePosition(vehicleid);
        setVehiclePosition(vehicleid, vehPos[0], 1333.6, vehPos[2]);
        setVehicleRotation(vehicleid, -90.0, -0.0703264, -5.01594);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
    }

});

/*
event("onPlayerPlaceExit", function(playerid, name) {
    if (isPlayerInVehicle(playerid) && name == PARKING_NAME) {
        msg(playerid, "You've exited " + name);
    }
});
*/

function isVehicleInParking(vehicleid) {
    if(parkingPlaceStatus.find(vehicleid) != null) {
        return true;
    }
    return false;
}

function findBusyPlaces() {
    foreach (vehicleid, vehicle in __vehicles) {

        if (!vehicle) continue;

        if (!isVehicleOwned(vehicleid)) {
            continue;
        }

        foreach (placeid, place in parkingPlaceStatus) {
            local vehPos = getVehiclePosition(vehicleid);
            local dist = getDistanceBetweenPoints2D(parkingPlace[placeid][0], parkingPlace[placeid][1], vehPos[0], vehPos[1]);
            if(dist < 3.0 && isVehicleEmpty(vehicleid) && parkingPlaceStatus[placeid] == "free") {
                parkingPlaceStatus[placeid] = vehicleid;
                //continue;
            }
        }
    }
}

function getParkingDaysByTimestamp(timestamp) {
    return floor((getTimestamp() - timestamp) / 86400);  // в настоящих днях
}

function getParkingDaysForVehicle(vehicleid) {
    if(__vehicles[vehicleid].entity && __vehicles[vehicleid].entity.parking && __vehicles[vehicleid].entity.parking > 0) {
        return getParkingDaysByTimestamp(__vehicles[vehicleid].entity.parking);
    }
    return 0;
}

function getParkingPeniForVehicle(vehicleid) {
    local modelid = getVehicleModel(vehicleid);
    local car = getCarInfoModelById(modelid);

    local days = getParkingDaysForVehicle(vehicleid);

    local peni = 0.0;

    days -= 2; // 2 бесплатных игровых дня
    peni = 0.01 * car.price;
    // if (days > 0) {
    //     // если авто стоит на штрафке меньше либо равно 8 игровым дням
    //     if (days <= 8) {
    //        peni = 0.005 * car.price * days;
    //     } else {
    //        peni = 0.005 * car.price * 8 + 0.012 * car.price * (days - 8);
    //     }
    // }

    return peni;
}

// /park plate_number
acmd("apark", function ( playerid, plate) {
    trigger("onVehicleSetToCarPound", playerid, plate);
});

// player need to be in car
acmd("aunpark", function ( playerid ) {
    trigger("onVehicleGetFromCarPound", playerid);
});


event("onVehicleSetToCarPound", function(playerid, plate) {
    if (!plate) {
        return msg( playerid, "parking.needEnterPlate", CL_ERROR);
    }

    local vehicleid = getVehicleByPlateText(plate.toupper());
    if(vehicleid == null) {
        return msg( playerid, "parking.checkPlate", CL_ERROR);
    }

    if (!isVehicleEmpty(vehicleid)) {
        return msg( playerid, "parking.peopleInside", CL_ERROR);
    }

    if(parkingPlaceStatus.find(vehicleid) != null) {
        return msg(playerid, "parking.alreadyParking", CL_ERROR);
    }

    local plate = getVehiclePlateText(vehicleid);

    if (!isVehicleOwned(vehicleid) || plate.find("CR-") != null) {
        return tryRespawnVehicleById(vehicleid, true);
    }

    if(setVehicleToCarPound(vehicleid)) {
        msg(playerid, "parking.complete");
        nano({
            "path": "discord",
            "server": "police",
            "channel": "parking",
            "action": "send",
            "author": getPlayerName(playerid),
            "description": "Отправил автомобиль на штрафстоянку",
            "color": "red",
            "datetime": getVirtualDate(),
            "fields": [
                ["Номер", getVehiclePlateText(vehicleid)],
                ["Модель", getVehicleNameByModelId(getVehicleModel(vehicleid))]
            ]
        });
        if(isVehicleCarRent(vehicleid)) {
            setVehicleRespawnEx(vehicleid, false);
            local veh = getVehicleEntity(vehicleid);
            veh.data.rent.enabled = false;
            veh.save();
        }
    } else {
        msg(playerid, "parking.noFreeSpace");
        nano({
            "path": "discord",
            "server": "police",
            "channel": "parking",
            "action": "no-free-space",
            "author": getPlayerName(playerid),
            "description": "Не может отправить автомобиль на штрафстоянку: нет своободных мест",
            "color": "brown",
            "datetime": getVirtualDate(),
            "fields": [
                ["Номер", getVehiclePlateText(vehicleid)],
                ["Модель", getVehicleNameByModelId(getVehicleModel(vehicleid))]
            ]
        });
    }
});


function setVehicleToCarPound (vehicleid) {

    findBusyPlaces(); //read before
    local tpcomplete = false;
    foreach (placeid, place in parkingPlaceStatus) {
        if(place != "free") {
            continue;
        }
        parkingPlaceStatus[placeid] = vehicleid;
        tpcomplete = true;
        __vehicles[vehicleid].entity.parking = getTimestamp();
        __vehicles[vehicleid].entity.save();
        setVehiclePosition(vehicleid, parkingPlace[placeid][0], parkingPlace[placeid][1], parkingPlace[placeid][2]);
        setVehicleRotation(vehicleid, 180.0, 0.0, 0.0 );
        delayedFunction(8000, function() {
            setVehiclePosition(vehicleid, parkingPlace[placeid][0], parkingPlace[placeid][1], parkingPlace[placeid][2] );
            setVehicleRotation(vehicleid, 180.0, 0.0, 0.0 );
        });
        delayedFunction(1000, findBusyPlaces()); //read after
        vehicleWanted = getVehicleWantedForTax();
        break;
    }

    return tpcomplete;
}


event("onVehicleGetFromCarPound", function(playerid) {
    findBusyPlaces(); //read before

    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getPlayerVehicle( playerid ) ;
    if(parkingPlaceStatus.find(vehicleid) == null) {
        return msg(playerid, "parking.carNotParked", getVehiclePlateText(vehicleid), CL_CHAT_MONEY_SUB);
    }

    local price = PARKING_COST + getVehicleTax(vehicleid);

    if(!canMoneyBeSubstracted(playerid, price)) {
        return msg(playerid, "parking.notenoughmoney", CL_CHAT_MONEY_SUB);
    }

    if (!isPlayerHaveVehicleKey(playerid, vehicleid)) {
        return msg(playerid, "vehicle.owner.warning", CL_CHAT_MONEY_SUB);
    }

    foreach (placeid, place in parkingPlaceStatus) {
        if(place == vehicleid) {
        //local vehicleid = place;
        parkingPlaceStatus[placeid] = "free";
        unblockDriving(vehicleid);
        __vehicles[vehicleid].entity.parking = 0;
        __vehicles[vehicleid].entity.data.tax = 0;
        __vehicles[vehicleid].entity.save();
        subPlayerMoney(playerid, price);
        addTreasuryMoney(price);
        msg(playerid, "parking.free", CL_SUCCESS);
        setVehicleSpeed(vehicleid, 0.0, -12.0, 0.0);
        break;
        }
    }
    vehicleWanted = getVehicleWantedForTax();

    nano({
        "path": "discord",
        "server": "police",
        "channel": "parking",
        "action": "out",
        "author": "Владелец",
        "description": "Забрал автомобиль со штрафстоянки",
        "color": "green",
        "datetime": getVirtualDate(),
        "fields": [
            ["Номер", getVehiclePlateText(vehicleid)],
            ["Модель", getVehicleNameByModelId(getVehicleModel(vehicleid))]
        ]
    });
});


event("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    local vehPos = getVehiclePosition(vehicleid);

    if(vehPos[0] <= PARKING_COORDS[0] && vehPos[0] >= PARKING_COORDS[2] && vehPos[1] <= PARKING_COORDS[3] && vehPos[1] >= PARKING_COORDS[1])
    {
        blockDriving(playerid, vehicleid);
        //if (!isPlayerVehicleOwner(playerid, vehicleid)) {
        //    return msg(playerid, "parking.notYourCar");
        //}
        msg(playerid, "parking.pay", CL_PETERRIVER);
        msg(playerid, "parking.pay.fix", PARKING_COST );
        // msg(playerid, "parking.pay.peni", getParkingPeniForVehicle(vehicleid) );
        msg(playerid, "parking.pay.tax", getVehicleTax(vehicleid) );
        // msg(playerid, "parking.pay.payment", CL_PETERRIVER);
    }
});

event("onServerStarted", function() {
    foreach (placeid, place in parkingPlaceStatus) {
        if(place != "free") {
            local vehicleid = place;
            if(getParkingDaysForVehicle(vehicleid) >= 15) {
                parkingPlaceStatus[placeid] = "free";
                dbg("police", "parking", "remove", getVehicleOwner(vehicleid), getDateTime(), [["Номер", getVehiclePlateText(vehicleid)], ["Модель", getVehicleNameByModelId(getVehicleModel(vehicleid))]]);
                //removeVehicle(vehicleid);
                destroyVehicle(vehicleid);
                local veh = getVehicleEntity(vehicleid);
                //veh.reserved = 0;
                veh.deleted = 1;
                veh.save();
            }
        }
    }
});

event("onServerSecondChange", function() {
/*
    if ((getSecond() % 10) != 0) {
        return;
    }
*/
    foreach (placeid, place in parkingPlaceStatus) {
        if(place != "free" && isInteger(place)) {
            local vehicleid = place;
            local vehPos = getVehiclePosition(vehicleid);
            local dist = getDistanceBetweenPoints2D(parkingPlace[placeid][0], parkingPlace[placeid][1], vehPos[0], vehPos[1]);
            if(dist > 1) {
                setVehiclePosition(vehicleid, parkingPlace[placeid][0], parkingPlace[placeid][1], parkingPlace[placeid][2]);
                setVehicleRotation(vehicleid, 180.0, 0.0, 0.0 );
            }
        }
    }
});

/*
event("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    trigger("onPlayerVehicleEnterCarPound", playerid, vehicleid);
});
*/

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    local plaPos = getPlayerPosition( playerid );
    if(plaPos[0] <= PARKING_COORDS[0] && plaPos[0] >= PARKING_COORDS[2] && plaPos[1] <= PARKING_COORDS[3] && plaPos[1] >= PARKING_COORDS[1])
    {
        findBusyPlaces();
    }
});

