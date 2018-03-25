include("modules/shops/carpaint/commands.nut");

local CARPAINT_NAME = "CarPaint";
local CARPAINT_COORDS_INSIDE  = [ 25.280, -432.900, 35.280, -422.900 ];
local CARPAINT_COORDS_OUTSIDE = [ 20.280, -437.900, 40.280, -417.900 ];
local CARPAINT_COORDS_PLACE  = [ 30.2854, -427.900, -20.0367 ];

local CARPAINT_COST   = 80.0;
local CARPAINT_RADIUS = 16.0;
local CARPAINT_RADIUS_SMALL = 6.0;
local CARPAINT_ROCKET_TIMER = 30; // in seconds

local CARPAINT_CARID    = null;    // null or last carid
local CARPAINT_PLAYERID = null; // null or last playerid

local CARPAINT_TIMER    = null; // timer hash
local CARPAINT_INDEX    = 0;    // index of colors array
local availableCars = [0, 1, 4, 6, 7, 8, 9, 10, 12, 13, 14, 15, 17, 18, 22, 23, 25, 28, 29, 30, 31, 32, 41, 43, 44, 45, 46, 47, 48, 50, 52, 53];

local car_paint = {};


/*

key("q", function(playerid) {
    local character = players[playerid];
    if (!isPlayerInNVehicle(playerid)) return;

    local vehicle = getPlayerNVehicle(playerid);
    local keylock = vehicle.components.findOne(NVC.KeyLock);
    local engine  = vehicle.components.findOne(NVC.Engine);

    if (!keylock || keylock.isUnlockableBy(character)) {
        if (engine) engine.toggle();
    } else {
        msg(playerid, "you dont have a proper key")
    }
})

 */

event("onPlayerPlaceEnter", function(playerid, name) {
    if (!isPlayerInNVehicle(playerid)) return;

    local vehicle = getPlayerNVehicle(playerid);
    local vehicleid = vehicle.vehicleid;
    local modelid = vehicle.getComponent(NVC.Hull).getModel();

    local carid = vehicle.id;
    local character = players[playerid];

    if (name == CARPAINT_NAME+"_outside") {
        if( CARPAINT_CARID != null) {

            vehicle
                .setPosition(45.1, -427.8, vehicle.getPosition().z)
                .setRotation(90.0, vehicle.getRotation().y, vehicle.getRotation().z)
                .setSpeed();

            msg(playerid, "carpaint.placebusy", CL_MALIBU);
            return;
        }
    }

    if (name == CARPAINT_NAME+"_inside") {

        if((carid in car_paint) == false) {
            car_paint[carid] <- {};
        }

        if(!("availableColors" in car_paint[carid])) {
            car_paint[carid]["availableColors"] <- null;
            car_paint[carid]["currentColor"] <- null;
        }

        CARPAINT_CARID     = carid;
        CARPAINT_PLAYERID  = playerid;

        local keylock = vehicle.components.findOne(NVC.KeyLock);

        if( availableCars.find(modelid) != null && (!keylock || keylock.isUnlockableBy(character)) ) {
            car_paint[carid]["availableColors"] = getVehicleColorsArray( vehicleid );
            car_paint[carid]["currentColor"]    = vehicle.getComponent(NVC.Hull).getColor();

            CARPAINT_INDEX = 0;

            msg(playerid, "carpaint.help1");
            msg(playerid, "carpaint.help2", CARPAINT_COST);

        } else {
            msg(playerid, "carpaint.cantrepaintthiscar", CL_MALIBU);
        }
    }
});

event("onPlayerPlaceExit", function(playerid, name) {
    if (!isPlayerInNVehicle(playerid)) return;

    local vehicle = getPlayerNVehicle(playerid);
    local hull = vehicle.getComponent(NVC.Hull);
    local modelid = hull.getModel();
    local vehicleid = vehicle.vehicleid;
    local carid = vehicle.id;

    local character = players[playerid];

    if (name == CARPAINT_NAME+"_inside") {
        local keylock = vehicle.components.findOne(NVC.KeyLock);

        if( availableCars.find(modelid) == null || keylock == null || keylock.isUnlockableBy(character) == false) return;

        if(checkVehiclePaintColorChanged(carid) == true) {
            if(!canMoneyBeSubstracted(playerid, CARPAINT_COST)) {
                local cr = car_paint[carid]["currentColor"];
                hull.setColor(cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
                vehicle.save();
                return msg(playerid, "carpaint.notenoughmoney", CL_MALIBU);
            }
            msg(playerid, "carpaint.goodluck", CL_MALIBU);
            msg(playerid, "carpaint.payforcolor", CARPAINT_COST);
            subMoneyToPlayer(playerid, CARPAINT_COST);
        } else {
            msg(playerid, "carpaint.bye", CL_MALIBU);
        }
        car_paint[carid].clear();
    }

    if (name == CARPAINT_NAME+"_outside") {
        if(CARPAINT_CARID == carid) {
            CARPAINT_CARID    = null;
            CARPAINT_PLAYERID = null;
        }
    }

});

event("onPlayerDisconnect", function(playerid, reason) {
    carPaintRocket(players[playerid]);
});

event("onPlayerNVehicleExit", function(character, vehicle, seat) {
    carPaintRocket(character);
});

event("onPlayerNVehicleEnter", function(character, vehicle, seat) {
    carPaintRocketCancel(character, vehicle);
});

event("onServerStarted", function() {
    log("[shops] loading car paint...");

    createPlace(CARPAINT_NAME+"_inside",   CARPAINT_COORDS_INSIDE[0],  CARPAINT_COORDS_INSIDE[1],  CARPAINT_COORDS_INSIDE[2],  CARPAINT_COORDS_INSIDE[3]);
    createPlace(CARPAINT_NAME+"_outside", CARPAINT_COORDS_OUTSIDE[0], CARPAINT_COORDS_OUTSIDE[1], CARPAINT_COORDS_OUTSIDE[2], CARPAINT_COORDS_OUTSIDE[3]);

    create3DText ( CARPAINT_COORDS_PLACE[0], CARPAINT_COORDS_PLACE[1], CARPAINT_COORDS_PLACE[2]+0.35, "=== CAR PAINT SHOP ===", CL_ROYALBLUE, CARPAINT_RADIUS );
    create3DText ( CARPAINT_COORDS_PLACE[0], CARPAINT_COORDS_PLACE[1], CARPAINT_COORDS_PLACE[2]+0.00, "Press 2 to change color", CL_WHITE.applyAlpha(150), CARPAINT_RADIUS_SMALL );
    create3DText ( CARPAINT_COORDS_PLACE[0], CARPAINT_COORDS_PLACE[1], CARPAINT_COORDS_PLACE[2]-0.25, "Press 1 to reset", CL_WHITE.applyAlpha(150), CARPAINT_RADIUS_SMALL );

    createBlip  (  CARPAINT_COORDS_PLACE[0], CARPAINT_COORDS_PLACE[1], [ 14, 4 ], 4000.0);
});



function carPaintRocket(character) {
    local playerid = character.playerid;
    if(CARPAINT_CARID == null) return;
    if(CARPAINT_PLAYERID != playerid) return;
    local vehicle = vehicles[CARPAINT_CARID];
    local carid = CARPAINT_CARID;
    local vehicleid = vehicle.vehicleid;

    if(isPlayerConnected(playerid)) msg(playerid, "carpaint.rocketstart", CL_MALIBU);

    trigger(playerid, "hudCreateTimer", CARPAINT_ROCKET_TIMER, true, true);

    CARPAINT_TIMER = delayedFunction(1000 * CARPAINT_ROCKET_TIMER, function() {

        if(!vehicle.isEmpty()) return;

        local hull = vehicle.getComponent(NVC.Hull);
        local modelid = hull.getModel();
        local keylock = vehicle.components.findOne(NVC.KeyLock);
        local character = players[playerid];

        if( (carid in car_paint) && (availableCars.find(modelid) != null) && ( !keylock || keylock.isUnlockableBy(character))) {
            local cr = car_paint[carid]["currentColor"];

            hull.setColor(cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
            vehicle.save();
        }

        vehicle
            .setPosition(46.4, -428.107, vehicle.getPosition().z)
            .setRotation(90.0, vehicle.getRotation().y, vehicle.getRotation().z)
            .setSpeed();

        CARPAINT_CARID    = null;
        CARPAINT_PLAYERID = null;

        car_paint[carid].clear();
    });
}

function carPaintRocketCancel(character, vehicle) {
    local playerid = character.playerid;
    local carid = vehicle.id;
    if(CARPAINT_CARID == null || carid != CARPAINT_CARID) return;
    if(CARPAINT_PLAYERID != playerid) return;
    if(vehicle.isEmpty()) return;
    trigger(playerid, "hudDestroyTimer");
    if (CARPAINT_TIMER && CARPAINT_TIMER.IsActive()) {
        CARPAINT_TIMER.Kill()
    }
}

function carPaintChangeColor(playerid, setdefault = null) {

    if (!isPlayerInNVehicle(playerid)) {
        return;
    }

    if(!isPlayerNVehicleInValidPoint(playerid, CARPAINT_COORDS_PLACE[0], CARPAINT_COORDS_PLACE[1], CARPAINT_RADIUS_SMALL)) {
        log("isVehicleInValidPoint")
        return;
    }

    local vehicle = getPlayerNVehicle(playerid);
    local hull = vehicle.getComponent(NVC.Hull);
    local modelid = hull.getModel();
    local vehicleid = vehicle.vehicleid;
    local carid = vehicle.id;

    if(CARPAINT_CARID != carid) return;

    local keylock = vehicle.components.findOne(NVC.KeyLock);
    local character = players[playerid];

    if( availableCars.find(modelid) == null || keylock == null || keylock.isUnlockableBy(character) == false) {
        return msg(playerid, "carpaint.cantrepaintthiscar", CL_MALIBU);
    }

    if( car_paint[carid]["availableColors"] == null ) {
        return msg(playerid, "carpaint.nocolorsforthiscar", CL_MALIBU);
    }

    local cr = null;
    if (setdefault == null) {
        cr = car_paint[carid]["availableColors"][CARPAINT_INDEX];
        CARPAINT_INDEX += 1;
        if(CARPAINT_INDEX >= car_paint[carid]["availableColors"].len()) CARPAINT_INDEX = 0;
    } else {
        cr = car_paint[carid]["currentColor"];
    }
    hull.setColor(cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
    vehicle.save();

    //setVehicleColour(vehicleid, cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
}

function checkVehiclePaintColorChanged(carid) {
    local cr = car_paint[carid]["currentColor"];
    local nowcr = vehicles[carid].getComponent(NVC.Hull).getColor();
    for (local i = 0; i < cr.len(); i++) {
        if(cr[i] != nowcr[i]) {
            return true;
        }
    }
    return false;
}

local translations = {

    "en|carpaint.goodluck"               :   "[PAINT] Nice! Good luck and we'll be glad to see you again!"
    "ru|carpaint.goodluck"               :   "[PAINT] Отличный выбор! Будем рады видеть вас снова!"

    "en|carpaint.payforcolor"            :   "Your paid $%.2f for car painting."
    "ru|carpaint.payforcolor"            :   "Вы заплатили $%.2f за покраску."

    "en|carpaint.bye"                    :   "[PAINT] Return in any convenient time! We'll be glad to see you again!"
    "ru|carpaint.bye"                    :   "[PAINT] Заезжай к нам в удобное время! Покрасим на отлично!"

    "en|carpaint.notenoughmoney"         :   "Not enough money to pay!"
    "ru|carpaint.notenoughmoney"         :   "Увы, у тебя недостаточно денег."

    "en|carpaint.nocolorsforthiscar"     :   "[PAINT] I have no paint for this car now. Look later, buddy."
    "ru|carpaint.nocolorsforthiscar"     :   "[PAINT] У меня сейчас нет краски для этого автомобиля. Загляни позже, дружище."

    "en|carpaint.cantrepaintthiscar"     :   "[PAINT] Not enough money to pay!"
    "ru|carpaint.cantrepaintthiscar"     :   "[PAINT] Нее, чувак, я не буду красить эту тачку."

    "en|carpaint.rocketstart"            :   "[PAINT] Leave the car here is dangerous. Drive off better."
    "ru|carpaint.rocketstart"            :   "[PAINT] Оставлять здесь авто неприлично опасно. Лучше отъедь."

    "en|carpaint.placebusy"              :   "[PAINT] Hey! Do you see that place is taken? Wait your turn!"
    "ru|carpaint.placebusy"              :   "[PAINT] Хэй! Не видишь, что место занято? Жди своей очереди!"

    "en|carpaint.help1"                  :   "To change color - press button 2. To reset color - press button 1."
    "ru|carpaint.help1"                  :   "Смена цвета - кнопка 2. Вернуть свой цвет - кнопка 1."

    "en|carpaint.help2"                  :   "Price: $%.2f. If you chosen color - free up place."
    "ru|carpaint.help2"                  :   "Цена покраски: $%.2f. Если выбрал цвет - освобождай место."

}

alternativeTranslate(translations);
