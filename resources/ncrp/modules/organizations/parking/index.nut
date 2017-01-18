local PARKING_COORDS = [ 29.5264, 112.01, 11.8024, 130.534 ];
local PARKING_NAME = "Car Pound";

local parkingPlaceStatus = [ "free", "free", "free", "free", "free", "free", "free", "free"];

local parkingPlace = [
    [ 16.15 , 116.7   , -13.8 ],
    [ 19.5  , 116.7   , -13.8 ],
    [ 22.85 , 116.7   , -13.8 ],
    [ 26.2  , 116.7   , -13.8 ],
    [ 16.15 , 126.415 , -13.8 ],
    [ 19.5  , 126.415 , -13.8 ],
    [ 22.85 , 126.415 , -13.8 ],
    [ 26.2  , 126.415 , -13.8 ],
];

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

    findBusyPlaces();
});

event("onPlayerPlaceEnter", function(playerid, name) {
    if (isPlayerInVehicle(playerid) && name == PARKING_NAME) {
        local vehicleid = getPlayerVehicle(playerid);
        setVehiclePosition(vehicleid, 23.2244, 106.793, -13.3134);
        setVehicleRotation(vehicleid, 90.1467, 0.104741, 3.21106);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
    }

});

event("onPlayerPlaceExit", function(playerid, name) {
    msg(playerid, "you've exited " + name);
    dbg(playerid, "you've exited " + name);
});

/*
18, 26.2059, 116.661, -13.7832, 1.39352, -0.00380342, 0.312747 );// park1
1, 22.8451, 116.858, -13.839, 0.900037, -0.581753, 0.857125 // park2
1, 26.2784, 126.415, -13.8633, -179.148, -0.0816921, -0.197537 // park5
*/


function findBusyPlaces() {
    //parkingPlaceStatus = [ "free", "free", "free", "free", "free", "free", "free", "free"];
    foreach (vehicleid, vehicle in __vehicles) {
        if (isVehicleOwned(vehicleid)) {
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

acmd("park", function ( playerid, plate = null) {
    if (plate == null) {
        return msg( playerid, "Need enter plate number.");
    }

    local vehicleid = getVehicleByPlateText(plate.toupper());
    if(vehicleid == null) {
        return msg( playerid, "Car with plate number "+plate+" not found");
    }

    if (!isVehicleEmpty(vehicleid)) {
        return msg( playerid, "There are people in the car. Impossible pick up the car at car pound with people.");
    }

    if(parkingPlaceStatus.find(vehicleid) != null) {
        return msg(playerid, "Car already parked");
    }

    if (!isVehicleOwned(vehicleid)) {
        return tryRespawnVehicleById(vehicleid, true);
    }

    findBusyPlaces(); //read before
    dbg(parkingPlaceStatus);
    local tpcomplete = false;
    foreach (placeid, place in parkingPlaceStatus) {
        if(place != "free") {
            dbg ("continue");
            continue;
        }
        parkingPlaceStatus[placeid] = vehicleid;
        tpcomplete = true;
        setVehiclePosition(vehicleid, parkingPlace[placeid][0], parkingPlace[placeid][1], parkingPlace[placeid][2]);
        setVehicleRotation(vehicleid, 0.0, 0.0, 0.0 );
        dbg(" ---- SPAWN ---- ");
        dbg("vehicleid: "+vehicleid+"; placeid: "+placeid+"; status: "+parkingPlaceStatus[placeid]);
        break;
    }
    findBusyPlaces(); //read after
    dbg(parkingPlaceStatus);
    if(tpcomplete) msg(playerid, "Car has been parked at car pound.");
    else msg(playerid, "No free space at car pound.");
});


cmd("unpark", function ( playerid ) {
    findBusyPlaces(); //read before
    dbg(parkingPlaceStatus);

    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getPlayerVehicle( playerid ) ;

     if (!isPlayerVehicleOwner(playerid, vehicleid)) {
        return msg(playerid, "This is not you car.");
    }

    if(parkingPlaceStatus.find(vehicleid) == null) {
        return msg(playerid, "no car at car pound");
    }

    foreach (placeid, place in parkingPlaceStatus) {
        dbg("place: "+place+"; vehicleid: "+vehicleid+"; placeid: "+placeid+"; status: "+parkingPlaceStatus[placeid]);
        if(place == vehicleid) {
        //local vehicleid = place;
        parkingPlaceStatus[placeid] = "free";
        unblockVehicle(vehicleid);
        subMoneyToPlayer(playerid, 5.0);
        msg(playerid, "The car has been freed sucsessfully.");
        break;
        }
    }
    dbg(parkingPlaceStatus);
});


event("onPlayerVehicleEnterCarPound", function(playerid, vehicleid) {
    local vehPos = getVehiclePosition(vehicleid);

    if(vehPos[0] <= PARKING_COORDS[0] && vehPos[0] >= PARKING_COORDS[2] && vehPos[1] <= PARKING_COORDS[3] && vehPos[1] >= PARKING_COORDS[1])
    {
        blockVehicle(vehicleid);
        if (!isPlayerVehicleOwner(playerid, vehicleid)) {
            return msg(playerid, "This is not you car.");
        }
        msg(playerid, "Need pay $5 to unpark: /unpark");
    }
});

event("onServerSecondChange", function() {

    if ((getSecond() % 10) != 0) {
        return;
    }

    foreach (placeid, place in parkingPlaceStatus) {
        if(place != "free") {
            local vehicleid = place;
            local vehPos = getVehiclePosition(vehicleid);
            local dist = getDistanceBetweenPoints2D(parkingPlace[placeid][0], parkingPlace[placeid][1], vehPos[0], vehPos[1]);
            if(dist > 1) {
                dbg(" ---- SECOND CHANGE ---- ");
                setVehiclePosition(vehicleid, parkingPlace[placeid][0], parkingPlace[placeid][1], parkingPlace[placeid][2]);
                setVehicleRotation(vehicleid, 0.0, 0.0, 0.0 );
            }
        }
    }
});


event("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    trigger("onPlayerVehicleEnterCarPound", playerid, vehicleid);
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    local plaPos = getPlayerPosition( playerid );
    if(plaPos[0] <= PARKING_COORDS[0] && plaPos[0] >= PARKING_COORDS[2] && plaPos[1] <= PARKING_COORDS[3] && plaPos[1] >= PARKING_COORDS[1])
    {
        findBusyPlaces();
    }
});
