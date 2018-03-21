/**
 * KEYBINDS
 */
key("q", function(playerid) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    if (!isPlayerVehicleDriver(playerid)) {
        return;
    }

    return switchEngine(getPlayerVehicle(playerid));
});


// Фары
    addKeyboardHandler("r", "up", function(playerid) {
        switchLights(playerid);
    });

    addKeyboardHandler("num_0", "up", function(playerid) {
        switchLights(playerid);
    });

// Поворотник влево
    addKeyboardHandler("z", "up", function(playerid) {
        switchLeftLight(playerid);
    });

    addKeyboardHandler("num_1", "up", function(playerid) {
        switchLeftLight(playerid);
    });

// Поворотник вправо
    addKeyboardHandler("c", "up", function(playerid) {
        switchRightLight(playerid);
    });

    addKeyboardHandler("num_3", "up", function(playerid) {
        switchRightLight(playerid);
    });


// Аварийка
    addKeyboardHandler("x", "up", function(playerid) {
        switchBothLight(playerid);
    });

    addKeyboardHandler("num_2", "up", function(playerid) {
        switchBothLight(playerid);
    });



//cmd("engine", "on", function(playerid) {
//    local vehicleid = getPlayerVehicle( playerid );
//
//    if (!isPlayerVehicleDriver(playerid)) {
//        return;
//    }
//
//    setVehicleEngineState(vehicleid, true);
//});

//cmd("engine", "off", function(playerid) {
//    local vehicleid = getPlayerVehicle( playerid );
//
//    if (!isPlayerVehicleDriver(playerid)) {
//        return;
//    }
//
//    setVehicleEngineState(vehicleid, false);
//});

//cmd("lights", function(playerid) {
//    switchLights(playerid);
//});

//cmd("turnleft", function(playerid) {
//    switchLeftLight(playerid);
//});

//cmd("turnright", function(playerid) {
//    switchRightLight(playerid);
//});

//cmd("aviar", function(playerid) {
//    switchBothLight(playerid);
//});

/*
cmd("sell", function(playerid, amount = null) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getPlayerVehicle(playerid);

    if (!isPlayerVehicleOwner(playerid, vehicleid)) {
        return msg(playerid, "vehicle.sell.notowner", CL_ERROR);
    }

    if (!amount) {
        return msg(playerid, "vehicle.sell.amount", CL_ERROR);
    }

    if (getVehiclePassengersCount(vehicleid) != 2) {
        return msg(playerid, "vehicle.sell.2passangers", CL_ERROR);
    }

    local passangers = getVehiclePassengers(vehicleid);

    foreach (idx, targetid in passangers) {
        // prevent selling to yourself
        if (targetid == playerid) continue;

        msg(targetid, "vehicle.sell.ask", [getPlayerName(playerid), amount.tofloat()], CL_WARNING);
        msg(playerid, "vehicle.sell.log", [getPlayerName(targetid), amount.tofloat()], CL_WARNING);

        sendInvoiceSilent(playerid, targetid, amount.tofloat(), function(invreciever, invsender, result) {
            if (result) {
                setVehicleOwner(vehicleid, invreciever);
                msg(invsender, "vehicle.sell.success", CL_SUCCESS);
                msg(invreciever, "vehicle.buy.success" , CL_SUCCESS);

                dbg("vehicle", "selling success", getIdentity(invsender), getIdentity(invreciever), getVehiclePlateText(vehicleid));

                // block it
                blockVehicle(vehicleid);
                return;
            } else {
                msg(invsender, "vehicle.sell.failure", [getPlayerName(invreciever)], CL_ERROR);
                msg(invreciever, "vehicle.buy.failure", CL_ERROR);

                dbg("vehicle", "selling error", getIdentity(invsender), getIdentity(invreciever), getVehiclePlateText(vehicleid));
            }
        });
    }
});
*/
