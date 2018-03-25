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

function setBusyParkingPlaces() {
    foreach (carid, vehicle in vehicles) {

        if(vehicle.data.parking == 0) continue;

        foreach (placeid, place in parkingPlaceStatus) {
            local vehPos = vehicle.getPosition();
            local dist = getDistanceBetweenPoints2D(parkingPlace[placeid][0], parkingPlace[placeid][1], vehPos.x, vehPos.y);
            if(dist < 3.0 && vehicle.isEmpty() && parkingPlaceStatus[placeid] == "free") {
                parkingPlaceStatus[placeid] = vehicle.id;
            }
        }

    }
}

function isNVehicleInParking(vehicle) {
    return parkingPlaceStatus.find(vehicle.id) ? true : false;
}

function sendNVehicleToParking(vehicle) {
    foreach (placeid, place in parkingPlaceStatus) {
        if(place != "free") {
            continue;
        }
        parkingPlaceStatus[placeid] = vehicle.id;

        vehicle.data.parking = getTimestamp();
        vehicle
            .setPosition(parkingPlace[placeid][0], parkingPlace[placeid][1], 150.0)
            .setRotation(180.0, 0.0, 0.0)
            .components.findOne(NVC.Engine).setStatusTo(false)

        delayedFunction(4000, function() {
            vehicle
                .setPosition(parkingPlace[placeid][0], parkingPlace[placeid][1], parkingPlace[placeid][2])
                .setRotation(180.0, 0.0, 0.0)
                .save();
        });

        return true;
    }
    return false;
}

function removeNVehicleFromParking(vehicle) {
    foreach (placeid, place in parkingPlaceStatus) {
        if(place == vehicle.id) {

            parkingPlaceStatus[placeid] = "free";

            vehicle.data.parking = 0;
            vehicle.setSpeed(0.0, -12.0, 0.0);

            delayedFunction(1500, function() {
                vehicle.setSpeed();
            });

            return true;
        }
    }
    return false;
}

event("onServerDayChange", function() {
    foreach (placeid, place in parkingPlaceStatus) {

        if(place != "free") {

            local vehicle = vehicles[place];

            if(getParkingDaysForVehicle(vehicle) >= 90) {
                parkingPlaceStatus[placeid] = "free";
                dbg("Vehicle with plate "+vehicle.components.findOne(NVC.Plate).get()+" has been removed from parking (last owner: "+getPlayerName(getPlayerIdFromCharacterId(vehicle.ownerid))+")");
                vehicle.despawn();
            }
        }
    }
});


//event("onServerSecondChange", function() {
///*
//    if ((getSecond() % 10) != 0) {
//        return;
//    }
//*/
//    foreach (placeid, place in parkingPlaceStatus) {
//        if(place != "free") {
//            local vehicle = vehicles[place];
//            local vehPos = vehicle.getPosition();
//            local dist = getDistanceBetweenPoints2D(parkingPlace[placeid][0], parkingPlace[placeid][1], vehPos.x, vehPos.y);
//            if(dist > 1) {
//                setVehiclePosition(vehicleid, parkingPlace[placeid][0], parkingPlace[placeid][1], parkingPlace[placeid][2]);
//                setVehicleRotation(vehicleid, 180.0, 0.0, 0.0 );
//            }
//        }
//    }
//});
