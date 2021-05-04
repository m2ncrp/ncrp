const VEHICLE_RESPAWN_TIME      = 300; // 5 (real) minutes
const VEHICLE_FUEL_DEFAULT      = 40.0;
const VEHICLE_MIN_DIRT          = 0.25;
const VEHICLE_MAX_DIRT          = 0.75;
const VEHICLE_DEFAULT_OWNER     = "";
const VEHICLE_OWNERSHIP_NONE    = 0;
const VEHICLE_OWNERSHIP_SINGLE  = 1;
const VEHICLE_OWNER_CITY        = "__cityNCRP";

translate("en", {
    "vehicle.sell.amount"       : "You need to set the amount you wish to sell your car for."
    "vehicle.sell.2passangers"  : "You need potential buyer to sit in the vehicle with you."
    "vehicle.sell.ask"          : "%s offers you to buy his vehicle for $%.2f."
    "vehicle.sell.log"          : "You offered %s to buy your vehicle for $%.2f."
    "vehicle.sell.success"      : "You've successfuly sold this car."
    "vehicle.buy.success"       : "You've successfuly bought this car."
    "vehicle.sell.failure"      : "%s refused to buy this car."
    "vehicle.buy.failure"       : "You refused to buy this car."
    "vehicle.sell.notowner"     : "You can't sell car tht doesn't belong to you."
});

event("onScriptInit", function() {
    // police cars
    addVehicleOverride(42, function(id) {
        setVehicleColour(id, 255, 255, 255, 0, 0, 0);
        setVehicleSirenState(id, false);
        setVehicleBeaconLightState(id, false);
        setVehiclePlateText(id, getRandomVehiclePlate("PD"));
    });

    addVehicleOverride(51, function(id) {
        setVehicleColour(id, 0, 0, 0, 150, 150, 150);
        setVehicleSirenState(id, false);
        setVehicleBeaconLightState(id, false);
        // added override for plate number
        setVehiclePlateText(id, getRandomVehiclePlate("PD"));
    });

    // trucks
    addVehicleOverride(range(34, 39), function(id) {
        setVehicleColour(id, 30, 30, 30, 154, 154, 154);
    });

    // trucks fish
    addVehicleOverride(38, function(id) {
        setVehicleColour(id, 15, 32, 24, 80, 80, 80);
    });

    // armoured lassiter 75
    addVehicleOverride(17, function(id) {
        setVehicleColour(id, 0, 0, 0, 0, 0, 0);
    });

    // milk
    addVehicleOverride(19, function(id) {
        setVehicleColour(id, 154, 154, 154, 98, 26, 21);
    });
});

// binding events
event("onServerStarted", function() {
    logStr("[vehicles] starting...");
    local counter = 0;

    // load all vehicles from db
    Vehicle.findBy({ reserved = 0, deleted = 0 }, function(err, results) {
        foreach (idx, vehicle in results) {

            /*
            if (vehicle.parking > 0 && getParkingDaysByTimestamp(vehicle.parking) >= 90) {
                continue;
            }
            */

            // init vehicle positions and rotations
            local x = vehicle.x.tofloat();
            local y = vehicle.y.tofloat();
            local z = vehicle.z.tofloat();
            local rx = vehicle.rx.tofloat();;
            local ry = vehicle.ry.tofloat();;
            local rz = vehicle.rz.tofloat();;

            local data = vehicle.data;

            // create vehicle
            local vehicleid = createVehicle( vehicle.model, x, y, z, rx, ry, rz );

            setVehicleRespawnEx(vehicleid, false);

            if("defaultRot" in data) {
                rx = data.defaultRot.x;
                ry = data.defaultRot.y;
                rz = data.defaultRot.z;
                setVehicleRespawnRotationObj(vehicleid, data.defaultRot)
            }

            if("defaultPos" in data) {
                x = data.defaultPos.x;
                y = data.defaultPos.y;
                z = data.defaultPos.z;
                setVehicleRespawnPositionObj(vehicleid, data.defaultPos)
                setVehicleRespawnEx(vehicleid, true)
            }


            // load all the data
            setVehicleColour      ( vehicleid, vehicle.cra, vehicle.cga, vehicle.cba, vehicle.crb, vehicle.cgb, vehicle.cbb );
            setVehicleRotation    ( vehicleid, vehicle.rx, vehicle.ry, vehicle.rz );
            setVehicleTuningTable ( vehicleid, vehicle.tunetable );
            setVehicleDirtLevel   ( vehicleid, vehicle.dirtlevel );
            setVehicleFuel        ( vehicleid, vehicle.fuellevel );
            setVehiclePlateText   ( vehicleid, vehicle.plate );
            setVehicleOwner       ( vehicleid, vehicle.owner, vehicle.ownerid );

            // secial methods for custom vehicles
            setVehicleSaving      ( vehicleid, true );
            setVehicleEntity      ( vehicleid, vehicle );

            // block vehicle by default
            blockVehicle          ( vehicleid );

            local setWheelsGenerator = function(id, entity) {
                return function() {
                    setVehicleWheelTexture( id, 0, entity.fwheel );
                    setVehicleWheelTexture( id, 1, entity.rwheel );
                };
            };

            delayedFunction(1000, setWheelsGenerator(vehicleid, vehicle));
            counter++;
        }

        logStr("[vehicles] loaded " + counter + " vehicles from database.");
    });
});

// respawn cars and update passangers
event("onServerMinuteChange", function() {
    updateVehiclePassengers();
    checkVehicleRespawns();
});

// handle vehicle enter
event("native:onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    logger.logf(
        "[VEHICLE ENTER] (%s) %s [%d] | (vehid: %d) %s - %s (model: %d) | coords: [%.5f, %.5f, %.5f] | haveKey: %s",
            getAccountName(playerid),
            getPlayerName(playerid),
            playerid,
            vehicleid,
            getVehiclePlateText(vehicleid),
            getVehicleNameByModelId(getVehicleModel(vehicleid)),
            getVehicleModel(vehicleid),
            getVehiclePositionObj(vehicleid).x,
            getVehiclePositionObj(vehicleid).y,
            getVehiclePositionObj(vehicleid).z,
            isVehicleOwned(vehicleid) ? (isPlayerHaveVehicleKey(playerid, vehicleid) ? "true" : "false") : "city_ncrp"
    );

    if(!("seatPos" in __vehicles[vehicleid])) {
        __vehicles[vehicleid].seatPos <- [];
    }

    __vehicles[vehicleid].seatPos <- getVehiclePosition( vehicleid );


    // handle vehicle passangers
    addVehiclePassenger(vehicleid, playerid, seat);

    if (getVehicleFuel(vehicleid) > 0 && seat == 0) {
        // set state of the engine as on
        if (vehicleid in __vehicles) {
            __vehicles[vehicleid].state = true;
        }
    }

    // check blocking
    if (isVehicleOwned(vehicleid) && seat == 0) {

        dbg("player", "vehicle", "enter", getVehiclePlateText(vehicleid), getIdentity(playerid), "haveKey: " + isPlayerHaveVehicleKey(playerid, vehicleid));

        if (isPlayerHaveVehicleKey(playerid, vehicleid)) {
            unblockDriving(vehicleid);
            setVehicleOwner(vehicleid, playerid);
        } else {
            if(!isVehicleCarRent(vehicleid)) {
              msg(playerid, "vehicle.owner.warning", CL_WARNING);
            }
            blockDriving(playerid, vehicleid);
        }
    }

    // handle respawning and saving
    resetVehicleRespawnTimer(vehicleid);
    trySaveVehicle(vehicleid);

    // trigger other events
    trigger("onPlayerVehicleEnter", playerid, vehicleid, seat);

    // local modelid = getVehicleModel(vehicleid);

    // local steers = {
        // model23 = -0.125,
        // model24 = -0.125
    // }
    // triggerClientEvent(playerid, "setVehicleSteer", steers["model"+modelid])
});

key(["f"], function(playerid) {
    if (isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getNearestVehicleForPlayer(playerid, 3.0);

    if (vehicleid == -1) {
        return;
    }

    local hasKey = isPlayerHaveVehicleKey(playerid, vehicleid);

    if (!hasKey) {
        setVehicleEngineState(vehicleid, true)
        delayedFunction(125, function() {
            setVehicleEngineState(vehicleid, false)
        })
        return;
    }

    unblockVehicle(vehicleid);
    setVehicleEngineState(vehicleid, true)
    delayedFunction(100, function() {
        if(getPlayerVehicle(playerid) == vehicleid && hasKey) {
            return
        }
        setVehicleEngineState(vehicleid, false);
        if(!hasKey) {
            blockVehicle(vehicleid);
        }
    });


}, KEY_UP);

key(["w", "s"], function(playerid) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getPlayerVehicle(playerid);

    if (!isPlayerVehicleDriver(playerid)) {
        return;
    }

    if(getVehicleFuel(vehicleid) > 0 && vehicleid in __vehicles) {
        __vehicles[vehicleid].state = true;
    }

}, KEY_BOTH);

// handle vehicle exit
event("native:onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    logger.logf(
        "[VEHICLE EXIT] (%s) %s [%d] | (vehid: %d) %s - %s (model: %d) | coords: [%.5f, %.5f, %.5f] | haveKey: %s",
            getAccountName(playerid),
            getPlayerName(playerid),
            playerid,
            vehicleid,
            getVehiclePlateText(vehicleid),
            getVehicleNameByModelId(getVehicleModel(vehicleid)),
            getVehicleModel(vehicleid),
            getVehiclePositionObj(vehicleid).x,
            getVehiclePositionObj(vehicleid).y,
            getVehiclePositionObj(vehicleid).z,
            isVehicleOwned(vehicleid) ? (isPlayerVehicleOwner(playerid, vehicleid) ? "true" : "false") : "city_ncrp"
    );

    if("seatPos" in __vehicles[vehicleid]) {
        local posOld = __vehicles[vehicleid].seatPos;
        local posNew = getVehiclePosition( vehicleid );
        local dis = getDistanceBetweenPoints3D( posOld[0], posOld[1], posOld[2], posNew[0], posNew[1], posNew[2] );
        if(dis > 0.4 && __vehicles[vehicleid].entity) {
            local history = __vehicles[vehicleid].entity.history == "" ? [] : JSONParser.parse(__vehicles[vehicleid].entity.history);
            if(history.len() == 200) {
                history.remove(0);
            }
            history.push([getRealDateTime(), getPlayerName(playerid), dis]);
            __vehicles[vehicleid].entity.history = JSONEncoder.encode(history);
        }
    }

    // handle vehicle passangers
    removeVehiclePassenger(vehicleid, playerid, seat);

    // check blocking
    if (isVehicleOwned(vehicleid) && isPlayerVehicleOwner(playerid, vehicleid)) {
        blockDriving(playerid, vehicleid);
    }

    // handle respawning and saving
    resetVehicleRespawnTimer(vehicleid);
    trySaveVehicle(vehicleid);

    // trigger other events
    trigger("onPlayerVehicleExit", playerid, vehicleid, seat);
});

// force resetting vehicle position to death point
event("onPlayerDeath", function(playerid) {
    dbg("player", "death", "vehicle", getAuthor(playerid), getVehiclePlateText(getPlayerVehicle(playerid)));

    if (isPlayerInVehicle(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);

        delayedFunction(1500, function() {
            setVehiclePositionObj(vehicleid, getVehiclePositionObj(vehicleid));
        });

        delayedFunction(5000, function() {
            setVehiclePositionObj(vehicleid, getVehiclePositionObj(vehicleid));
        });
    }
});

event("onPlayerSpawned", function(playerid) {
    local ppos = players[playerid].getPosition();

    // special check for spawning inside closed truck
    foreach (vehicleid, value in __vehicles) {
        if(!value) continue;
        local vehModel = getVehicleModel(vehicleid);
        if (vehModel == 38 || vehModel == 34 || vehModel == 46) {

            local vpos = getVehiclePosition(vehicleid);
            // if inside vehicle, set offsetted position
            if (getDistanceBetweenPoints3D(ppos.x, ppos.y, ppos.z, vpos[0], vpos[1], vpos[2]) < 4.0) {
                dbg("player", "spawn", getIdentity(playerid), "inside closed truck, respawning...");
                players[playerid].setPosition(ppos.x + 1.5, ppos.y + 1.5, ppos.z);
                return;
            }
        }
    }
});

event("onPlayerDisconnect", function(playerid, reason) {
    clearAllPrivateKey(playerid);
});

event("onServerPlayerStarted", function( playerid ){
    clearAllPrivateKey(playerid);
});

include("controllers/vehicle/functions");
include("controllers/vehicle/commands.nut");
include("controllers/vehicle/vehicleInfo.nut");
include("controllers/vehicle/translations.nut");
//include("controllers/vehicle/hiddencars.nut");
