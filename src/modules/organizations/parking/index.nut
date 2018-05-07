include("modules/organizations/parking/parkingPlaces.nut");
include("modules/organizations/parking/commands.nut");
include("modules/organizations/parking/translations.nut");

local PARKING_COORDS = [ -1211.12, 1342.12, -1390.86, 1364.81 ];
local PARKING_NAME = "CarPound";
local PARKING_COST = 15.0;

event("onServerStarted", function() {
    log("[police] parking...");

    createPlace(PARKING_NAME, PARKING_COORDS[0], PARKING_COORDS[1], PARKING_COORDS[2], PARKING_COORDS[3]);

    createBlip  ( -1300.0, 1358.0, [ 0, 5 ], 4000.0);

    setBusyParkingPlaces();
});

function findBusyPlaces() {
    foreach (vehicleid, vehicle in __vehicles) {
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

function getParkingDaysForVehicle(vehicle) {
    if(vehicle.data.parking > 0) {
        return floor((getTimestamp() - vehicle.data.parking) / 43200);  // делим на реальных 12 часов = 1 игровым суткам
    }
    return 0;
}

function getParkingPeniForVehicle(vehicle) {

    local modelid = vehicle.components.findOne(NVC.Hull).getModel();

    local car = getCarInfoModelById(modelid);

    local days = getParkingDaysForVehicle(vehicle);

    local peni = 0.0;

    days -= 2; // 2 бесплатных игровых дня

    if (days > 0) {
        // если авто стоит на штрафке меньше либо равно 8 игровым дням
        if (days <= 8) {
           peni = 0.005 * car.price * days;
        } else {
           peni = 0.005 * car.price * 8 + 0.012 * car.price * (days - 8);
        }
    }

    return peni;
}



event("onVehicleSetToCarPound", function(playerid, plate = null) {
    if (plate == null) {
        return msg( playerid, "parking.needEnterPlate");
    }

    local vehicleid = getVehicleByPlateText(plate.toupper());

    if (isOriginalVehicleExists(vehicleid)) {
        return tryRespawnVehicleById(vehicleid, true);
    }

    //local vehicle = getNVehicleByPlateText(plate.toupper());
    local vehicle = getNVehicleByVehicleId(vehicleid);

    if(vehicle == null) {
        return msg( playerid, "parking.checkPlate");
    }

    if (!vehicle.isEmpty()) {
        return msg( playerid, "parking.peoopleInside");
    }

    if(isNVehicleInParking(vehicle)) {
        return msg(playerid, "parking.alreadyParking");
    }

    local tpcomplete = sendNVehicleToParking(vehicle);

    if(tpcomplete) {
        setBusyParkingPlaces(); //read before
        vehicleWanted = getVehicleWantedForTax();
        msg(playerid, "parking.complete");
        dbg("chat", "police", getAuthor(playerid), format("Отправил на штрафстоянку автомобиль с номером %s", getVehiclePlateText(vehicleid)) );
    } else {
        msg(playerid, "parking.noFreeSpace");
        dbg("chat", "police", getAuthor(playerid), "Нет своободных мест на штрафстоянке" );
    }
});


event("onVehicleGetFromCarPound", function(playerid) {
    //setBusyParkingPlaces(); //read before
    local character = players[playerid];

    if (!isPlayerInNVehicle(character)) {
        return;
    }

    local vehicle = getPlayerNVehicle( character ) ;

    if(isNVehicleInParking(vehicle) == false) {
        return msg(playerid, "parking.carNotParked", CL_CHAT_MONEY_SUB);
    }

    local price = PARKING_COST + getParkingPeniForVehicle(vehicle);

    if(!canBankMoneyBeSubstracted(playerid, price)) {
        return msg(playerid, "parking.notenoughmoney", CL_CHAT_MONEY_SUB);
    }

    local keylock = vehicle.components.findOne(NVC.KeyLock);

    if (keylock && !keylock.isUnlockableBy(character)) {
        msg(playerid, "vehicle.owner.warning", CL_CHAT_MONEY_SUB);
    }

    local removeComplete = removeNVehicleFromParking(vehicle);

    if(removeComplete) {
        subMoneyToDeposit(playerid, price);
        addMoneyToTreasury(price);
        msg(playerid, "parking.free", CL_SUCCESS);
        vehicleWanted = getVehicleWantedForTax();
        dbg("chat", "police", getAuthor(playerid), format("Забрал со штрафстоянки автомобиль с номером %s", getVehiclePlateText(vehicleid)) );
        return;
    }
    msg(playerid, "Something went wrong. Ask an admin!", CL_CHAT_MONEY_SUB);
});


event("onPlayerNVehicleEnter", function(character, vehicle, seat) {

    if(vehicle.data.parking > 0) {
        msg(character, "parking.pay", CL_PETERRIVER);
        msg(character, "parking.pay.fix", PARKING_COST );
        msg(character, "parking.pay.peni", getParkingPeniForVehicle(vehicle) );
        msg(character, "parking.pay.payment", CL_PETERRIVER);
    }

});

event("onPlayerPlaceEnter", function(playerid, name) {
    if(name == PARKING_NAME) {
        if(isPlayerInVehicle(playerid)) {
            local vehicleid = getPlayerVehicle(playerid);
            local vehPos = getVehiclePosition(vehicleid);
            setVehiclePosition(vehicleid, vehPos[0], 1333.6, vehPos[2]);
            setVehicleRotation(vehicleid, -90.0, -0.0703264, -5.01594);
            setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
        }

        if(isPlayerInNVehicle(playerid)) {
            local vehicle = getPlayerNVehicle(playerid);
            vehicle
                .setPosition(vehicle.getPosition().x, 1333.6, vehicle.getPosition().z)
                .setRotation(-90.0, -0.0703264, -5.01594)
                .setSpeed();
        }
    }
});
