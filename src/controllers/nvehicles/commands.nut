function keyCreation(playerid, vehicle) {
    if (vehicle == null) return;

    local VKey = Item.VehicleKey();
    VKey.setParentId( md5(vehicle.id.tostring()) );

    players[playerid].inventory.push(VKey);
}


acmd(["vehicle"], function( playerid, model ) {
    local model = model.tointeger();
    local pos = getPlayerPosition( playerid );
    local veh = Vehicle( model ).setPosition(pos[0] + 2.0, pos[1], pos[2] + 1.0);

    // vehicles.set(veh.id, veh);
    veh.save();

    veh.spawn();
    keyCreation(playerid, veh);
});


acmd(["vehicle"], ["despawn"], function( playerid, vehicle = null ) {
    if (vehicle == null) {
        vehicles.nearestVehicle(playerid).despawn();
        return;
    }
    vehicle.despawn();
});

// acmd(["tune"], function( playerid ) {
//     if( original__isPlayerInVehicle( playerid ) )
//     {
//         local vehicleid = original__getPlayerVehicle( playerid );
//         setVehicleTuningTable( vehicleid, 3 );

//         setVehicleWheelTexture( vehicleid, 0, 11 );
//         setVehicleWheelTexture( vehicleid, 1, 11 );
//     }
// });

acmd(["fix"], function( playerid, targetid = null ) {
    // if( !original__isPlayerInVehicle( playerid ) && !targetid )  return;
    // if( original__isPlayerInVehicle( playerid ) && !targetid )  targetid = original__getPlayerVehicle( playerid );
    // if( targetid )  targetid = targetid.tointeger();

    // repairVehicle( targetid );
    // setVehicleFuel(targetid, getDefaultVehicleFuel(targetid));
    //
    if( !original__isPlayerInVehicle( playerid ) && targetid == null ) {
        local vehicle = vehicles.nearestVehicle(playerid);
        local hull = vehicle.components.findOne(VehicleComponent.Hull);
        local fueltank = vehicle.components.findOne(VehicleComponent.FuelTank);
        hull.repair();
        fueltank.setFuelToMax();
        vehicle.correct();
    }

    if( original__isPlayerInVehicle( playerid ) && targetid == null ) {
        local vehicleid = original__getPlayerVehicle(playerid);
        local hull = vehicles[vehicleid].components.findOne(VehicleComponent.Hull);
        local fueltank = vehicles[vehicleid].components.findOne(VehicleComponent.FuelTank);
        hull.repair();
        fueltank.setFuelToMax();
        vehicles[vehicleid].correct();
    }

    if( !original__isPlayerInVehicle( playerid ) && targetid != null ) {
        local hull = vehicles[targetid].components.findOne(VehicleComponent.Hull);
        local fueltank = vehicles[targetid].components.findOne(VehicleComponent.FuelTank);
        hull.repair();
        fueltank.setFuelToMax();
        vehicles[targetid].correct();
    }

});



acmd(["clean"], function( playerid, targetid = null ) {
    if( !original__isPlayerInVehicle( playerid ) && targetid == null ) {
        local vehicle = vehicles.nearestVehicle(playerid);
        local hull = vehicle.components.findOne(VehicleComponent.Hull);
        hull.setDirt(0.0);
    }

    if( original__isPlayerInVehicle( playerid ) && targetid == null ) {
        local vehicleid = original__getPlayerVehicle(playerid);
        local hull = vehicles[vehicleid].components.findOne(VehicleComponent.Hull);
        hull.setDirt(0.0);
    }

    if( !original__isPlayerInVehicle( playerid ) && targetid != null ) {
        local hull = vehicles[targetid].components.findOne(VehicleComponent.Hull);
        hull.setDirt(0.0);
    }

});

// acmd(["rot"], function( playerid, targetid = null ) {
//     if( !original__isPlayerInVehicle( playerid ) && !targetid )  return;
//     if( original__isPlayerInVehicle( playerid ) && !targetid )  targetid = original__getPlayerVehicle( playerid );
//     if( targetid )  targetid = targetid.tointeger();

//     local vehRot = getVehicleRotation(targetid);
//     setVehicleRotation( targetid, vehRot[0], 0.0, 0.0 );
// });

// acmd("checkcar", function( playerid ) {
//     local vehicleid = original__getPlayerVehicle( playerid );
//     local vehicleModel = getVehicleModel( vehicleid );

//     sendPlayerMessage( playerid, "Car: id #" + vehicleid + ", model #" + vehicleModel);
// });

// acmd("paint", function(playerid, red, green, blue) {
//     local r = min(red.tointeger(), 255);
//     local g = min(green.tointeger(), 255);
//     local b = min(blue.tointeger(), 255);

//     if (!original__isPlayerInVehicle(playerid)) {
//         return;
//     }

//     setVehicleColour(original__getPlayerVehicle(playerid), r, g, b, r, g, b);
// });

// acmd("p", function(playerid, r1 = 0, g1 = 0, b1 = 0, r2 = 0, g2 = 0, b2 = 0) {
//     local r1 = min(r1.tointeger(), 255);
//     local g1 = min(g1.tointeger(), 255);
//     local b1 = min(b1.tointeger(), 255);
//     local r2 = min(r2.tointeger(), 255);
//     local g2 = min(g2.tointeger(), 255);
//     local b2 = min(b2.tointeger(), 255);

//     if (!original__isPlayerInVehicle(playerid)) {
//         return;
//     }

//     setVehicleColour(original__getPlayerVehicle(playerid), r1, g1, b1, r2, g2, b2);
// });

// cmd("engine", "on", function(playerid) {
//     local vehicleid = original__getPlayerVehicle( playerid );

//     if (!isPlayerVehicleDriver(playerid)) {
//         return;
//     }

//     setVehicleEngineState(vehicleid, true);
// });

// cmd("engine", "off", function(playerid) {
//     local vehicleid = original__getPlayerVehicle( playerid );

//     if (!isPlayerVehicleDriver(playerid)) {
//         return;
//     }

//     setVehicleEngineState(vehicleid, false);
// });

// cmd("lights", function(playerid) {
//     switchLights(playerid);
// });

// cmd("turnleft", function(playerid) {
//     switchLeftLight(playerid);
// });

// cmd("turnright", function(playerid) {
//     switchRightLight(playerid);
// });

// cmd("aviar", function(playerid) {
//     switchBothLight(playerid);
// });

// acmd("jump", function(playerid) {
//     if (original__isPlayerInVehicle(playerid)) {
//         local vehicleid = original__getPlayerVehicle(playerid);
//         local sp = getVehicleSpeed(vehicleid);
//         setVehicleSpeed(vehicleid, sp[0], sp[1], sp[2] + 4.0);
//     }
// });

// acmd("myveh", function(playerid, modelid) {
//     local pos = getPlayerPosition( playerid );
//     local vehicleid = createVehicle( modelid.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
//     // setVehicleColour(vehicleid, 0, 0, 0, 0, 0, 0);
//     setVehicleOwner(vehicleid, "__cityNCRP");
//     setVehicleSaving(vehicleid, true); // it will be saved to database
//     setVehicleRespawnEx(vehicleid, false); // it will respawn (specially)
// });

// acmd("who", function(playerid) {
//     if (original__isPlayerInVehicle(playerid)) {
//         if (isPlayerVehicleOwner(playerid, original__getPlayerVehicle(playerid))) {
//             msg(playerid, "vehicle.owner.true", CL_SNUFF);
//         } else {
//             msg(playerid, "vehicle.owner.false", CL_SNUFF);
//         }
//     }
// });

// cmd("sell", function(playerid, amount = null) {
//     if (!original__isPlayerInVehicle(playerid)) {
//         return;
//     }

//     local vehicleid = original__getPlayerVehicle(playerid);

//     if (!isPlayerVehicleOwner(playerid, vehicleid)) {
//         return msg(playerid, "vehicle.sell.notowner", CL_ERROR);
//     }

//     if (!amount) {
//         return msg(playerid, "vehicle.sell.amount", CL_ERROR);
//     }

//     if (getVehiclePassengersCount(vehicleid) != 2) {
//         return msg(playerid, "vehicle.sell.2passangers", CL_ERROR);
//     }

//     local passangers = getVehiclePassengers(vehicleid);

//     foreach (idx, targetid in passangers) {
//         // prevent selling to yourself
//         if (targetid == playerid) continue;

//         msg(targetid, "vehicle.sell.ask", [getPlayerName(playerid), amount.tofloat()], CL_WARNING);
//         msg(playerid, "vehicle.sell.log", [getPlayerName(targetid), amount.tofloat()], CL_WARNING);

//         sendInvoiceSilent(playerid, targetid, amount.tofloat(), function(invreciever, invsender, result) {
//             if (result) {
//                 setVehicleOwner(vehicleid, invreciever);
//                 msg(invsender, "vehicle.sell.success", CL_SUCCESS);
//                 msg(invreciever, "vehicle.buy.success" , CL_SUCCESS);

//                 // block it
//                 blockVehicle(vehicleid);
//                 return;
//             } else {
//                 msg(invsender, "vehicle.sell.failure", [getPlayerName(invreciever)], CL_ERROR);
//                 msg(invreciever, "vehicle.buy.failure", CL_ERROR);
//             }
//         });
//     }
// });

// addKeyboardHandler("2", "up", function(playerid) {
//     if (original__isPlayerInVehicle(playerid) && isPlayerAdmin(playerid)) {
//         local vehicleid = original__getPlayerVehicle(playerid);
//         local sp = getVehicleSpeed(vehicleid);
//         setVehicleSpeed(vehicleid, sp[0], sp[1], sp[2] + 5.0);
//     }
// });

// addKeyboardHandler("3", "up", function(playerid) {
//     if (original__isPlayerInVehicle(playerid) && isPlayerAdmin(playerid)) {
//         local vehicleid = original__getPlayerVehicle(playerid);
//         local rot = getVehicleRotation(vehicleid);
//         //setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
//         setVehicleRotation(vehicleid, rot[0], 0.0, 0.0);
//     }
// });

// addKeyboardHandler("e", "up", function(playerid) {
//     if (original__isPlayerInVehicle(playerid) && getPlayerName(playerid) == "Inlife" && isPlayerAdmin(playerid)) {
//         local vehicleid = original__getPlayerVehicle(playerid);
//         local sp = getVehicleSpeed(vehicleid);
//         setVehicleSpeed(vehicleid, sp[0], sp[1], sp[2] + 5.0);
//     }
// });

// addKeyboardHandler("num_4", "up", function(playerid) {
//     if (original__isPlayerInVehicle(playerid) && isPlayerAdmin(playerid)) {
//         local vehicleid = original__getPlayerVehicle(playerid);
//         local rot = getVehicleRotation(vehicleid);
//         setVehicleRotation(vehicleid, rot[0]-5.0, rot[1], rot[2]);
//     }
// });

// addKeyboardHandler("num_6", "up", function(playerid) {
//     if (original__isPlayerInVehicle(playerid) && isPlayerAdmin(playerid)) {
//         local vehicleid = original__getPlayerVehicle(playerid);
//         local rot = getVehicleRotation(vehicleid);
//         setVehicleRotation(vehicleid, rot[0]+5.0, rot[1], rot[2]);
//     }
// });

// addKeyboardHandler("num_0", "up", function(playerid) {
//     switchLights(playerid);
// });


// addKeyboardHandler("num_1", "up", function(playerid) {
//     switchLeftLight(playerid);
// });

// addKeyboardHandler("num_3", "up", function(playerid) {
//     switchRightLight(playerid);
// });

// addKeyboardHandler("num_2", "up", function(playerid) {
//     switchBothLight(playerid);
// });


acmd(["get"], ["keys"], function( playerid ) {
    keyCreation(playerid, vehicles.nearestVehicle(playerid));
});


/**
 * Create key for given vehicle by its DB id and five it to player with targetid
 */
acmd(["replicate"], ["keys"], function( playerid, vehicleid, targetid ) {
    local VKey = Item.VehicleKey();
    players[playerid].inventory.push(VKey);
    VKey.setParentId( vehicleid );
    // msg();
});
