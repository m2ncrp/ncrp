/**
 * Find vehicle id, owner by full, or partial plate number
 * Usage:
 *     /plate 25
 *     /plate PD
 *     /plate LA-1
 */
acmd("plate", function(playerid, text = "") {
    local plates = getRegisteredVehiclePlates();

    if (text.len() < 2) {
        return msg(playerid, "Введите не менее 2 символов номера авто", CL_ERROR);
    }

    msg(playerid, "Найдены автомобили:", CL_INFO);

    foreach (plate, vehicleid in plates) {
        if (plate.tolower().find(text.tolower()) != null) {
            msg(playerid, format(
                "ID: %d | Номер: %s | Модель: %d | Владелец: %s",
                vehicleid, plate, getVehicleModel(vehicleid), (getVehicleOwner(vehicleid) ? getVehicleOwner(vehicleid) : "none")
            ));
            local parkingDays = getParkingDaysForVehicle(vehicleid);
            if(parkingDays > 0) {
                local lostDays = 90 - parkingDays;
                msg(playerid, format(
                    "На штрафстоянке: %d игр. дн. (осталось: %d) | Штраф: $%.2f",
                    getParkingDaysForVehicle(vehicleid), lostDays, getParkingPeniForVehicle(vehicleid)
                ), CL_HELP);
            }
        }
    }
});

/**
 * /history - сидя в авто, получить его историю
 * /history 5 - сидя в авто, показать его историю игроку с id 5
 * /history PV-557 - получить историю авто с номером PV-557
 * /history PV-557 5 - показать игроку с id 5 историю авто с номером PV-557
 */
acmd("history", function(playerid, plate = null, targetid = null) {

    local vehicleid;

    if (plate == null) {
        if( !isPlayerInVehicle( playerid ) ) {
            return msg( playerid, "Сядьте в автомобиль или введите его номер.");
        }
        vehicleid = getPlayerVehicle(playerid);
        plate = getVehiclePlateText(vehicleid);
    } else {
        if(plate.len() < 6) {
            targetid = plate.tointeger();
            vehicleid = getPlayerVehicle(playerid);
            plate = getVehiclePlateText(vehicleid);
        } else {
            vehicleid = getVehicleByPlateText(plate.toupper());
        }
    }

    if(vehicleid == -1) {
        return msg( playerid, "parking.checkPlate");
    }

    local history = __vehicles[vehicleid].entity && __vehicles[vehicleid].entity.history && __vehicles[vehicleid].entity.history != "" ? JSONParser.parse(__vehicles[vehicleid].entity.history) : [];

    if(history.len() == 0) {
        return msg( playerid, "В автомобиль пока ещё никто не садился.");
    }

    if (targetid != null) {
        msg(playerid, format("Вы отправили %s историю автомобиля %s.", getPlayerName(targetid.tointeger()), plate.toupper()), CL_SUCCESS );
        playerid = targetid.tointeger();
    }

    msg( playerid, "=== История автомобиля с номером "+plate.toupper()+" ===", CL_HELP_TITLE);

    foreach (line in history) {
        local message = format("%s - %s - %.2f", line[0], line[1], line[2]);

        msg(playerid, message, CL_CASCADE );
    }

})

mcmd(["admin.car"], ["tune"], function( playerid, tune = 3 ) {
    if( isPlayerInVehicle( playerid ) )
    {
        local vehicleid = getPlayerVehicle( playerid );
        setVehicleTuningTable( vehicleid, tune.tointeger() );

        setVehicleWheelTexture( vehicleid, 0, 11 );
        setVehicleWheelTexture( vehicleid, 1, 11 );
    }
});

mcmd(["admin.fix"], ["fix"], function( playerid, targetid = null ) {
    if( !isPlayerInVehicle( playerid ) && !targetid )  return;
    if( isPlayerInVehicle( playerid ) && !targetid )  targetid = getPlayerVehicle( playerid );
    if( targetid )  targetid = targetid.tointeger();

    repairVehicle( targetid );
    setVehicleFuel(targetid, getDefaultVehicleFuel(targetid));
});

acmd(["rot"], function( playerid, targetid = null ) {
    if( !isPlayerInVehicle( playerid ) && !targetid )  return;
    if( isPlayerInVehicle( playerid ) && !targetid )  targetid = getPlayerVehicle( playerid );
    if( targetid )  targetid = targetid.tointeger();

    local vehRot = getVehicleRotation(targetid);
    setVehicleRotation( targetid, vehRot[0], 0.0, 0.0 );
});

acmd(["stop"], function( playerid, targetid = null ) {
    targetid = targetid ? targetid.tointeger() : playerid;
    stopPlayerVehicle( targetid );
});

//acmd(["vehicle"], function( playerid, id ) {
//    local pos = getPlayerPosition( playerid );
//    local vehicle = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
//    // setVehicleColour(vehicle, 0, 0, 0, 0, 0, 0);
//});

//acmd("checkcar", function( playerid ) {
//    local vehicleid = getPlayerVehicle( playerid );
//    msg(playerid, format(
//        "Car: %d | Plate: %s | Model: %d | Owner: %s",
//        vehicleid, getVehiclePlateText(vehicleid), getVehicleModel(vehicleid), (getVehicleOwner(vehicleid) ? getVehicleOwner(vehicleid) : "none")
//    ));
//});

//acmd("paint", function(playerid, red, green, blue) {
//    local r = min(red.tointeger(), 255);
//    local g = min(green.tointeger(), 255);
//    local b = min(blue.tointeger(), 255);
//
//    if (!isPlayerInVehicle(playerid)) {
//        return;
//    }
//
//    setVehicleColour(getPlayerVehicle(playerid), r, g, b, r, g, b);
//});

//acmd("p", function(playerid, r1 = 0, g1 = 0, b1 = 0, r2 = 0, g2 = 0, b2 = 0) {
//    local r1 = min(r1.tointeger(), 255);
//    local g1 = min(g1.tointeger(), 255);
//    local b1 = min(b1.tointeger(), 255);
//    local r2 = min(r2.tointeger(), 255);
//    local g2 = min(g2.tointeger(), 255);
//    local b2 = min(b2.tointeger(), 255);
//
//    if (!isPlayerInVehicle(playerid)) {
//        return;
//    }
//
//    setVehicleColour(getPlayerVehicle(playerid), r1, g1, b1, r2, g2, b2);
//});

//acmd("jump", function(playerid) {
//    if (isPlayerInVehicle(playerid)) {
//        local vehicleid = getPlayerVehicle(playerid);
//        local sp = getVehicleSpeed(vehicleid);
//        setVehicleSpeed(vehicleid, sp[0], sp[1], sp[2] + 4.0);
//    }
//});

mcmd(["admin.car"], "myveh", function(playerid, modelid) {
    local pos = getPlayerPosition( playerid );
    local vehicleid = createVehicle( modelid.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
    // setVehicleColour(vehicleid, 0, 0, 0, 0, 0, 0);
    setVehicleOwner(vehicleid, playerid);
    setVehicleSaving(vehicleid, true); // it will be saved to database
    setVehicleRespawnEx(vehicleid, false); // it will respawn (specially)
});

mcmd(["admin.car"], ["deletecar", "removecar", "deleteveh", "removeveh"], function(playerid, plate) {
    local vehicleid = getVehicleByPlateText(plate.toupper());
    if (vehicleid) {
        removePlayerVehicle(vehicleid);
        msg(playerid, "Vehicle "+plate.toupper()+" deleted.", CL_SNUFF);
    } else {
        msg(playerid, "Vehicle "+plate.toupper()+" not found. Enter full plate number.", CL_POMEGRANATE_50);
    }
});



// key("2") key(["2"])  bindkey("2") bind("2")
addKeyboardHandler("num_8", "up", function(playerid) {
    if(!isPlayerInVehicle(playerid)) return;
    local vehicleid = getPlayerVehicle(playerid);
    if(!isVehicleInPlace(vehicleid, "CarPaint_outside") && !isVehicleInPlace(vehicleid, "CarShop") && isPlayerAdmin(playerid) /*&& !isPlayerCarTaxi(playerid)*/) {
        local vehicleid = getPlayerVehicle(playerid);
        local sp = getVehicleSpeed(vehicleid);
        setVehicleSpeed(vehicleid, sp[0], sp[1], sp[2] + 5.0);
    }
});

addKeyboardHandler("num_5", "up", function(playerid) {
    if (isPlayerInVehicle(playerid) && isPlayerAdmin(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        local rot = getVehicleRotation(vehicleid);
        //setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
        setVehicleRotation(vehicleid, rot[0], 0.0, 0.0);
    }
});

addKeyboardHandler("e", "up", function(playerid) {
    if (isPlayerInVehicle(playerid) && getPlayerName(playerid) == "Inlife" && isPlayerAdmin(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        local sp = getVehicleSpeed(vehicleid);
        setVehicleSpeed(vehicleid, sp[0], sp[1], sp[2] + 5.0);
    }
});

addKeyboardHandler("num_4", "up", function(playerid) {
    if (isPlayerInVehicle(playerid) && isPlayerAdmin(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        local rot = getVehicleRotation(vehicleid);
        setVehicleRotation(vehicleid, rot[0]-5.0, rot[1], rot[2]);
    }
});

addKeyboardHandler("num_6", "up", function(playerid) {
    if (isPlayerInVehicle(playerid) && isPlayerAdmin(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        local rot = getVehicleRotation(vehicleid);
        setVehicleRotation(vehicleid, rot[0]+5.0, rot[1], rot[2]);
    }
});

// ==========================================================================================================

key("o", function(playerid) {
    if (isPlayerAdmin(playerid)) {
        trigger(playerid, "onServerToggleBlip", "v");
    }
});


