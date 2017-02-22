local CARPAINT_NAME = "CarPaint";
local CARPAINT_COORDS_INSIDE  = [ 19.4775, -437.571, 29.5091, -427.52 ];
local CARPAINT_COORDS_OUTSIDE = [ 19.4349, -422.503, 35.0077, -442.85 ];
local CARPAINT_COORDS_PLACE  = [ 23.8129, -432.991, -19.9632 ];
local CARPAINT_COST   = 2.5;
local CARPAINT_RADIUS = 16.0;
local CARPAINT_RADIUS_SMALL = 6.0;
local CARPAINT_ROCKET_TIMER = 20; // in seconds

local CARPAINT_EMPTY    = null; // null or last vehicleid
local CARPAINT_PLAYERID = null; // null or last playerid

local CARPAINT_TIMER    = null; // timer hash
local CARPAINT_INDEX    = 0;    // index of colors array
local availableCars = [0, 1, 4, 6, 7, 8, 9, 10, 12, 13, 14, 15, 17, 18, 22, 23, 25, 28, 29, 30, 31, 32, 41, 43, 44, 45, 46, 47, 48, 50, 52, 53];

local car_paint = {};


event("onPlayerPlaceEnter", function(playerid, name) {
    if (!isPlayerInVehicle(playerid)) return;

    local vehicleid = getPlayerVehicle( playerid );
    local modelid   = getVehicleModel( vehicleid );

    if (name == CARPAINT_NAME+"_outside") {
        if( CARPAINT_EMPTY != null) {
            local vehPos = getVehiclePosition(vehicleid);
            local vehRot = getVehicleRotation(vehicleid);
            setVehicleRotation(vehicleid, 90.0, vehRot[1], vehRot[2]);
            setVehiclePosition(vehicleid, 45.1, -427.8, vehPos[2]);
            setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
            msg(playerid, "carpaint.placebusy", CL_ROYALBLUE);
            return;
        }
    }

    if (name == CARPAINT_NAME+"_inside") {

        if((vehicleid in car_paint) == false) {
            car_paint[vehicleid] <- {};
        }

        if(!("availableColors" in car_paint[vehicleid])) {
            car_paint[vehicleid]["availableColors"] <- null;
            car_paint[vehicleid]["currentColor"] <- null;
        }

        CARPAINT_EMPTY    = vehicleid;
        CARPAINT_PLAYERID = playerid;

        if( availableCars.find(modelid) != null) {
            car_paint[vehicleid]["availableColors"] = getVehicleColorsArray( vehicleid );
            car_paint[vehicleid]["currentColor"]    = getVehicleColour( vehicleid );
        }
    }
});

event("onPlayerPlaceExit", function(playerid, name) {
    if (!isPlayerInVehicle(playerid)) return;

    local vehicleid = getPlayerVehicle( playerid );
    local modelid   = getVehicleModel( vehicleid );

    if (name == CARPAINT_NAME+"_inside") {
        if( availableCars.find(modelid) == null) return;
        if(checkVehiclePaintColorChanged(vehicleid) == true) {
            if(!canMoneyBeSubstracted(playerid, CARPAINT_COST)) {
                local cr = car_paint[vehicleid]["currentColor"];
                setVehicleColour(vehicleid, cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
                return msg(playerid, "carpaint.notenoughmoney");
            }
            msg(playerid, "good!");
            subMoneyToPlayer(playerid, CARPAINT_COST);
        } else {
            msg(playerid, "Bye!");
        }
        car_paint[vehicleid].clear();
    }

    if (name == CARPAINT_NAME+"_outside") {
        if(CARPAINT_EMPTY == vehicleid) {
            CARPAINT_EMPTY    = null;
            CARPAINT_PLAYERID = null;
        }
    }

});

event("onPlayerDisconnect", function(playerid, reason) {
    carPaintRocket(playerid);
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    carPaintRocket(playerid);
});

event("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    carPaintRocketCancel(playerid, vehicleid);
});

event("onServerStarted", function() {
    log("[shop] car paint...");

    createPlace(CARPAINT_NAME+"_inside",   CARPAINT_COORDS_INSIDE[0],  CARPAINT_COORDS_INSIDE[1],  CARPAINT_COORDS_INSIDE[2],  CARPAINT_COORDS_INSIDE[3]);
    createPlace(CARPAINT_NAME+"_outside", CARPAINT_COORDS_OUTSIDE[0], CARPAINT_COORDS_OUTSIDE[1], CARPAINT_COORDS_OUTSIDE[2], CARPAINT_COORDS_OUTSIDE[3]);

    create3DText ( CARPAINT_COORDS_PLACE[0], CARPAINT_COORDS_PLACE[1], CARPAINT_COORDS_PLACE[2]+0.35, "=== CAR PAINT SHOP ===", CL_ROYALBLUE, CARPAINT_RADIUS );
    create3DText ( CARPAINT_COORDS_PLACE[0], CARPAINT_COORDS_PLACE[1], CARPAINT_COORDS_PLACE[2]+0.20, "Press 2", CL_WHITE.applyAlpha(150), CARPAINT_RADIUS_SMALL );

});



function carPaintRocket(playerid) {
    if(CARPAINT_EMPTY == null) return;
    if(CARPAINT_PLAYERID != playerid) return;
    local vehicleid = CARPAINT_EMPTY;

    if(isPlayerConnected(playerid)) msg(playerid, "carpaint.rocketstart", CL_ROYALBLUE);

    trigger(playerid, "hudCreateTimer", CARPAINT_ROCKET_TIMER, true, true);

    CARPAINT_TIMER = delayedFunction(1000 * CARPAINT_ROCKET_TIMER, function() {
        if(!isVehicleEmpty(vehicleid)) return;
            local modelid   = getVehicleModel( vehicleid );
        if( (vehicleid in car_paint) && (availableCars.find(modelid) != null) ) {
            local cr = car_paint[vehicleid]["currentColor"];
            setVehicleColour(vehicleid, cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
        }
        local vehRot = getVehicleRotation(vehicleid);
        local vehPos = getVehiclePosition(vehicleid);

        setVehicleRotation(vehicleid, 90.0, vehRot[1], vehRot[2]);
        setVehiclePosition(vehicleid, 46.4,  -428.107, vehPos[2]);
        CARPAINT_EMPTY    = null;
        CARPAINT_PLAYERID = null;

        car_paint[vehicleid].clear();
    });
}

function carPaintRocketCancel(playerid, vehicleid) {
    if(CARPAINT_EMPTY == null || vehicleid != CARPAINT_EMPTY) return;
    if(CARPAINT_PLAYERID != playerid) return;
    if(isVehicleEmpty(vehicleid)) return;
    trigger(playerid, "hudDestroyTimer");
    if( CARPAINT_TIMER.IsActive() ) {
        CARPAINT_TIMER.Kill()
    }
}

function carPaintChangeColor(playerid, setdefault = null) {

    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    if(!isVehicleInValidPoint(playerid, CARPAINT_COORDS_PLACE[0], CARPAINT_COORDS_PLACE[1], CARPAINT_RADIUS_SMALL)) {
        return;
    }

    local vehicleid = getPlayerVehicle(playerid);
    local modelid = getVehicleModel(vehicleid);

    if(CARPAINT_EMPTY != vehicleid) return;

    if( availableCars.find(modelid) == null) {
        return msg(playerid, "carpaint.cantrepaintthiscar", CL_ROYALBLUE);
    }

    if( car_paint[vehicleid]["availableColors"] == null ) {
        return msg(playerid, "carpaint.nocolorsrothiscar", CL_ROYALBLUE);
    }

    local cr = null;
    if (setdefault == null) {
        cr = car_paint[vehicleid]["availableColors"][CARPAINT_INDEX];
        CARPAINT_INDEX += 1;
        if(CARPAINT_INDEX >= car_paint[vehicleid]["availableColors"].len()) CARPAINT_INDEX = 0;
    } else {
        cr = car_paint[vehicleid]["currentColor"];
    }
    setVehicleColour(vehicleid, cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
}


key("2", function(playerid) {
    carPaintChangeColor(playerid);
}, KEY_UP);

key("1", function(playerid) {
    carPaintChangeColor(playerid, true);
}, KEY_UP);


function checkVehiclePaintColorChanged(vehicleid) {
    local cr = car_paint[vehicleid]["currentColor"];
    local nowcr = getVehicleColour( vehicleid );
    for (local i = 0; i < cr.len(); i++) {
        if(cr[i] != nowcr[i]) {
            return true;
        }
    }
    return false;
}

key("3", function(playerid) {
    local vehicleid = getPlayerVehicle(playerid);
    if(checkVehiclePaintColorChanged(vehicleid) == false) { msg(playerid, "good"); }
}, KEY_UP);
