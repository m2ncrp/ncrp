local PARKING_COORDS = [ -1211.12, 1342.12, -1390.86, 1364.81 ];
local PARKING_NAME = "CarPound";
local PARKING_COST = 17.5;

local parkingPlaceStatus = [];

local parkingPlace = [
    [-1300.0, 1358.0, -13.31],

    [-1304.0, 1358.0, -13.31],
    [-1296.0, 1358.0, -13.31],

    [-1308.0, 1358.0, -13.31],
    [-1292.0, 1358.0, -13.31],

    [-1312.0, 1358.0, -13.31],
    [-1288.0, 1358.0, -13.31],

    [-1316.0, 1358.0, -13.31],
    [-1284.0, 1358.0, -13.31],

    [-1320.0, 1358.0, -13.31],
    [-1280.0, 1358.0, -13.31],

    [-1324.0, 1358.0, -13.31],
    [-1276.0, 1358.0, -13.31],

    [-1328.0, 1358.0, -13.31],
    [-1272.0, 1358.0, -13.31],

    [-1332.0, 1358.0, -13.31],
    [-1268.0, 1358.0, -13.31],

    [-1336.0, 1358.0, -13.31],
    [-1264.0, 1358.0, -13.31],

    [-1340.0, 1358.0, -13.31],
    [-1260.0, 1358.0, -13.31],

    [-1344.0, 1358.0, -13.31],
    [-1256.0, 1358.0, -13.31],

    [-1348.0, 1358.0, -13.31],
    [-1252.0, 1358.0, -13.31],

    [-1352.0, 1358.0, -13.31],
    [-1248.0, 1358.0, -13.31],

    [-1356.0, 1358.0, -13.31],
    [-1244.0, 1358.0, -13.31],

    [-1360.0, 1358.0, -13.31],
    [-1240.0, 1358.0, -13.31],
];

    foreach (idx, value in parkingPlace) {
        parkingPlaceStatus.push("free");
    }

translate("en", {
    "parking.needEnterPlate"    : "Need to enter plate number."
    "parking.checkPlate"        : "Check the correct plate number of the car."
    "parking.peoopleInside"     : "Impossible pick up the car at car pound with people."
    "parking.alreadyParking"    : "Car already parked."
    "parking.complete"          : "Car has been parked at car pound."
    "parking.noFreeSpace"       : "No free space at car pound."
    "parking.carNotParked"      : "Car with plate number %s is not parked."
    "parking.notenoughmoney"    : "You don't have enough money."
    "parking.notYourCar"        : "This is not your car."
    "parking.free"              : "The car has been freed sucsessfully."
    "parking.pay"               : "Need to pay $%d to unpark: /unpark"
});

event("onServerStarted", function() {
    log("[police] parking...");
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

    createBlip  (  -1300.0, 1358.0, [ 0, 5 ], 4000.0);

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

// /park plate_number
acmd("apark", function ( playerid, plate) {
    trigger("onVehicleSetToCarPound", playerid, plate);
});

// player need to be in car
acmd("aunpark", function ( playerid ) {
    trigger("onVehicleGetFromCarPound", playerid);
});


event("onVehicleSetToCarPound", function(playerid, plate = null) {
    if (plate == null) {
        return msg( playerid, "parking.needEnterPlate");
    }

    local vehicleid = getVehicleByPlateText(plate.toupper());
    if(vehicleid == null) {
        return msg( playerid, "parking.checkPlate");
    }

    if (!isVehicleEmpty(vehicleid)) {
        return msg( playerid, "parking.peoopleInside");
    }

    if(parkingPlaceStatus.find(vehicleid) != null) {
        return msg(playerid, "parking.alreadyParking");
    }

    if (!isVehicleOwned(vehicleid)) {
        return tryRespawnVehicleById(vehicleid, true);
    }

    findBusyPlaces(); //read before
    dbg(parkingPlaceStatus);
    local tpcomplete = false;
    foreach (placeid, place in parkingPlaceStatus) {
        if(place != "free") {
            continue;
        }
        parkingPlaceStatus[placeid] = vehicleid;
        tpcomplete = true;
        setVehiclePosition(vehicleid, parkingPlace[placeid][0], parkingPlace[placeid][1], parkingPlace[placeid][2]);
        setVehicleRotation(vehicleid, 180.0, 0.0, 0.0 );
        delayedFunction(3000, function() {
            setVehiclePosition(vehicleid, parkingPlace[placeid][0], parkingPlace[placeid][1], parkingPlace[placeid][2] );
        });
        break;
    }
    delayedFunction(1000, findBusyPlaces()); //read after
    dbg(parkingPlaceStatus);
    if(tpcomplete) msg(playerid, "parking.complete");
    else msg(playerid, "parking.noFreeSpace");
});


event("onVehicleGetFromCarPound", function(playerid) {
    findBusyPlaces(); //read before
    dbg(parkingPlaceStatus);

    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getPlayerVehicle( playerid ) ;
    if(parkingPlaceStatus.find(vehicleid) == null) {
        return msg(playerid, "parking.carNotParked");
    }

     if(!canBankMoneyBeSubstracted(playerid, PARKING_COST)) {
        return msg(playerid, "parking.notenoughmoney");
    }

    if (!isPlayerVehicleOwner(playerid, vehicleid)) {
        return msg(playerid, "parking.notYourCar");
    }

    foreach (placeid, place in parkingPlaceStatus) {
        if(place == vehicleid) {
        //local vehicleid = place;
        parkingPlaceStatus[placeid] = "free";
        unblockVehicle(vehicleid);
        subBankMoneyToPlayer(playerid, PARKING_COST);
        addMoneyToTreasury(PARKING_COST);
        msg(playerid, "parking.free");
        setVehicleSpeed(vehicleid, 0.0, -12.0, 0.0);
        break;
        }
    }
    dbg(parkingPlaceStatus);
});


event("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    local vehPos = getVehiclePosition(vehicleid);

    if(vehPos[0] <= PARKING_COORDS[0] && vehPos[0] >= PARKING_COORDS[2] && vehPos[1] <= PARKING_COORDS[3] && vehPos[1] >= PARKING_COORDS[1])
    {
        blockVehicle(vehicleid);
        if (!isPlayerVehicleOwner(playerid, vehicleid)) {
            return msg(playerid, "parking.notYourCar");
        }
        msg(playerid, "parking.pay", PARKING_COST);
    }
});

event("onServerSecondChange", function() {
/*
    if ((getSecond() % 10) != 0) {
        return;
    }
*/
    foreach (placeid, place in parkingPlaceStatus) {
        if(place != "free") {
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

