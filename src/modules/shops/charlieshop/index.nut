include("modules/shops/charlieshop/commands.nut");

local CHARLIESHOP_NAME = "CharlieShop";
local CHARLIESHOP_COORDS_INSIDE  = [ 25.280, -432.900, 35.280, -422.900 ];
local CHARLIESHOP_COORDS_OUTSIDE = [ 20.280, -437.900, 40.280, -417.900 ];
local CHARLIESHOP_COORDS_PLACE  = [ 30.2854, -427.900, -20.0367 ];

local CHARLIESHOP_COST   = 80.0;
local CHARLIESHOP_RADIUS = 16.0;
local CHARLIESHOP_RADIUS_SMALL = 6.0;
local CHARLIESHOP_ROCKET_TIMER = 30; // in seconds

local CHARLIESHOP_CARID    = null;    // null or last carid
local CHARLIESHOP_PLAYERID = null; // null or last playerid

local CHARLIESHOP_TIMER    = null; // timer hash
local CHARLIESHOP_COLOR_INDEX    = 0;    // index of colors array
local CHARLIESHOP_WHEEL_INDEX    = 0;    // index of colors array
local availablePaintCars = [0, 1, 4, 6, 7, 8, 9, 10, 12, 13, 14, 15, 17, 18, 22, 23, 25, 28, 29, 30, 31, 32, 41, 43, 44, 45, 46, 47, 48, 50, 52, 53];
local availableWheelCars = [0, 1, 4, 6, 7, 8, 9, 10, 12, 13, 14, 15, 17, 18, 22, 23, 25, 28, 29, 30, 31, 32, 41, 43, 44, 45, 46, 47, 48, 50, 52, 53];

local car_info = {};
local car_wheels = [
    {
        model = 0,
        price = 70.0,
        available = true,
        name = "Dunniel Spinner"
    },
    {
        model = 1,
        price = 75.0,
        available = true,
        name = "Dunniel Black Rook"
    },
    {
        model = 2,
        price = 90.0,
        available = true,
        name = "Speedstone Alpha"
    },
    {
        model = 3,
        price = 95.0,
        available = false,
        name = "Speedstone Beta"
    },
    {
        model = 4,
        price = 105.0,
        available = true,
        name = "Speedstone Top Speed"
    },
    {
        model = 5,
        price = 114.0,
        available = false,
        name = "Galahad Tiara"
    },
    {
        model = 6,
        price = 119.0,
        available = true,
        name = "Galahad Silver Band"
    },
    {
        model = 7,
        price = 130.0,
        available = false,
        name = "Speedstone Diabolica"
    },
    {
        model = 8,
        price = 134.0,
        available = false,
        name = "Galahad Coronet"
    },
    {
        model = 9,
        price = 139.0,
        available = true,
        name = "Galahad Gold Crown"
    },
    {
        model = 10,
        price = 155.0,
        available = true,
        name = "Speedstone Pacific"
    },
    {
        model = 11,
        price = 160.0,
        available = false,
        name = "Paytone Mistyhawk"
    },
    {
        model = 12,
        price = 60.0,
        available = true,
        name = "Jeep Offroad"
    }
];

// pay for [3, 5, 7, 8, 11]

cmd("wheels", function(playerid) {
    local character = players[playerid];
    getVehicleWheelsArray( character.inventory );
});


cmd("kupon", function(playerid) {
    local coupon = Item.CouponWheels11();
    players[playerid].inventory.push( coupon );
    coupon.save();
    players[playerid].inventory.sync();
});

cmd("box", function(playerid) {
    local box = Item.Box();
    players[playerid].inventory.push( box );
    box.save();
    players[playerid].inventory.sync();
});

cmd("setwheel", function(playerid, model) {
    if (!isPlayerInNVehicle(playerid)) return;

    local vehicle = getPlayerNVehicle(playerid);
    vehicle.getComponent(NVC.WheelPair).setAll(model.tointeger());

});

cmd("ch", function(playerid, char) {

    local ch = char.tointeger();
    msg(playerid, "symbol: "+ch.tochar())

});

function tt() {
    local privateWheels = players[0].inventory
        .filter(@(item) (item instanceof Item.CouponWheels))
        .map(@(key) key.model);

    log(privateWheels);
}

function tt2() {
    local availableWheels = car_wheels.filter(function(i, item) {
        if(item.available) return item.model;
    });
    log(availableWheels)
}

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

    if (name == CHARLIESHOP_NAME+"_outside") {
        if( CHARLIESHOP_CARID != null) {

            vehicle
                .setPosition(45.1, -427.8, vehicle.getPosition().z)
                .setRotation(90.0, vehicle.getRotation().y, vehicle.getRotation().z)
                .setSpeed();

            msg(character, "charlie.placebusy", CL_MALIBU);
            return;
        }
    }

    if (name == CHARLIESHOP_NAME+"_inside") {

        if((carid in car_info) == false) {
            car_info[carid] <- {};
        }

        if(!("availableColors" in car_info[carid])) {
            car_info[carid]["availableColors"] <- null;
            car_info[carid]["currentColor"] <- null;
        }

        if(!("currentWheels" in car_info[carid])) {
            car_info[carid]["currentWheels"] <- null;
        }

        CHARLIESHOP_CARID     = carid;
        CHARLIESHOP_PLAYERID  = playerid;

        local keylock = vehicle.components.findOne(NVC.KeyLock);
        local isUnlock = (!keylock || keylock.isUnlockableBy(character));

        if(!isUnlock) {
            return msg(character, "charlie.canttouchthiscar", CL_MALIBU);
        }

        local isPaint = availablePaintCars.find(modelid) != null;
        local isWheel = availableWheelCars.find(modelid) != null;

        msg(character, "charlie.welcome");

        if(isPaint) {
            car_info[carid]["availableColors"] = getVehicleColorsArray( vehicleid );
            car_info[carid]["currentColor"]    = vehicle.getComponent(NVC.Hull).getColor();

            CHARLIESHOP_COLOR_INDEX = 0;

            msg(character, "charlie.help1", CHARLIESHOP_COST);
        }

        if(isWheel) {
            car_info[carid]["availableWheels"] = getVehicleWheelsArray( character.inventory );
            car_info[carid]["currentWheels"] = vehicle.getComponent(NVC.WheelPair).getAll();

            CHARLIESHOP_WHEEL_INDEX = 0;

            log(car_info[carid]["availableWheels"]);
            log(car_info[carid]["currentWheels"]);

            msg(character, "charlie.help2");
        }

        if(isPaint || isWheel) {
            msg(character, "charlie.help3");
            msg(character, "charlie.help4");
            return;
        }

        msg(character, "charlie.canttouchthiscar", CL_MALIBU);
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

    if (name == CHARLIESHOP_NAME+"_inside") {
        local keylock = vehicle.components.findOne(NVC.KeyLock);

        if( availablePaintCars.find(modelid) == null || keylock == null || keylock.isUnlockableBy(character) == false) return;

        if(checkVehiclePaintColorChanged(carid) == true) {



            if(!canMoneyBeSubstracted(playerid, CHARLIESHOP_COST)) {
                local cr = car_info[carid]["currentColor"];
                hull.setColor(cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
                vehicle.save();
                return msg(playerid, "charlie.notenoughmoney", CL_MALIBU);
            }


            msg(playerid, "charlie.goodluck", CL_MALIBU);
            msg(playerid, "charlie.payforcolor", CHARLIESHOP_COST);
            subMoneyToPlayer(playerid, CHARLIESHOP_COST);
        } else {
            msg(playerid, "charlie.bye", CL_MALIBU);
        }
        car_info[carid].clear();
    }

    if (name == CHARLIESHOP_NAME+"_outside") {
        if(CHARLIESHOP_CARID == carid) {
            CHARLIESHOP_CARID    = null;
            CHARLIESHOP_PLAYERID = null;
        }
    }

});

event("onPlayerDisconnect", function(playerid, reason) {
    charlieRocket(players[playerid]);
});

event("onPlayerNVehicleExit", function(character, vehicle, seat) {
    charlieRocket(character);
});

event("onPlayerNVehicleEnter", function(character, vehicle, seat) {
    charlieRocketCancel(character, vehicle);
});

event("onServerStarted", function() {
    log("[shops] loading car paint...");

    createPlace(CHARLIESHOP_NAME+"_inside",   CHARLIESHOP_COORDS_INSIDE[0],  CHARLIESHOP_COORDS_INSIDE[1],  CHARLIESHOP_COORDS_INSIDE[2],  CHARLIESHOP_COORDS_INSIDE[3]);
    createPlace(CHARLIESHOP_NAME+"_outside", CHARLIESHOP_COORDS_OUTSIDE[0], CHARLIESHOP_COORDS_OUTSIDE[1], CHARLIESHOP_COORDS_OUTSIDE[2], CHARLIESHOP_COORDS_OUTSIDE[3]);

    create3DText ( CHARLIESHOP_COORDS_PLACE[0], CHARLIESHOP_COORDS_PLACE[1], CHARLIESHOP_COORDS_PLACE[2]+0.35, "=== CHARLIE'S SHOP ===", CL_ROYALBLUE, CHARLIESHOP_RADIUS );
    create3DText ( CHARLIESHOP_COORDS_PLACE[0], CHARLIESHOP_COORDS_PLACE[1], CHARLIESHOP_COORDS_PLACE[2]+0.20, "Press 0 to reset", CL_WHITE.applyAlpha(150), CHARLIESHOP_RADIUS_SMALL );
    create3DText ( CHARLIESHOP_COORDS_PLACE[0], CHARLIESHOP_COORDS_PLACE[1], CHARLIESHOP_COORDS_PLACE[2]+0.05, "Press 1 to change color", CL_WHITE.applyAlpha(150), CHARLIESHOP_RADIUS_SMALL );
    create3DText ( CHARLIESHOP_COORDS_PLACE[0], CHARLIESHOP_COORDS_PLACE[1], CHARLIESHOP_COORDS_PLACE[2]-0.10, "Press 2 to change wheels", CL_WHITE.applyAlpha(150), CHARLIESHOP_RADIUS_SMALL );


    createBlip  (  CHARLIESHOP_COORDS_PLACE[0], CHARLIESHOP_COORDS_PLACE[1], [ 14, 4 ], 4000.0);
});



function charlieRocket(character) {
    local playerid = character.playerid;
    if(CHARLIESHOP_CARID == null) return;
    if(CHARLIESHOP_PLAYERID != playerid) return;
    local vehicle = vehicles[CHARLIESHOP_CARID];
    local carid = CHARLIESHOP_CARID;
    local vehicleid = vehicle.vehicleid;

    if(isPlayerConnected(playerid)) msg(playerid, "charlie.rocketstart", CL_MALIBU);

    trigger(playerid, "hudCreateTimer", CHARLIESHOP_ROCKET_TIMER, true, true);

    CHARLIESHOP_TIMER = delayedFunction(1000 * CHARLIESHOP_ROCKET_TIMER, function() {

        if(!vehicle.isEmpty()) return;

        local hull = vehicle.getComponent(NVC.Hull);
        local modelid = hull.getModel();
        local keylock = vehicle.components.findOne(NVC.KeyLock);
        local character = players[playerid];

        if( (carid in car_info) && (availablePaintCars.find(modelid) != null) && ( !keylock || keylock.isUnlockableBy(character))) {
            local cr = car_info[carid]["currentColor"];

            hull.setColor(cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
            vehicle.save();
        }

        vehicle
            .setPosition(46.4, -428.107, vehicle.getPosition().z)
            .setRotation(90.0, vehicle.getRotation().y, vehicle.getRotation().z)
            .setSpeed();

        CHARLIESHOP_CARID    = null;
        CHARLIESHOP_PLAYERID = null;

        car_info[carid].clear();
    });
}

function charlieRocketCancel(character, vehicle) {
    local playerid = character.playerid;
    local carid = vehicle.id;
    if(CHARLIESHOP_CARID == null || carid != CHARLIESHOP_CARID) return;
    if(CHARLIESHOP_PLAYERID != playerid) return;
    if(vehicle.isEmpty()) return;
    trigger(playerid, "hudDestroyTimer");
    if (CHARLIESHOP_TIMER && CHARLIESHOP_TIMER.IsActive()) {
        CHARLIESHOP_TIMER.Kill()
    }
}

function charlieChangeColor(playerid, setdefault = null) {

    if (!isPlayerInNVehicle(playerid)) {
        return;
    }

    if(!isPlayerNVehicleInValidPoint(playerid, CHARLIESHOP_COORDS_PLACE[0], CHARLIESHOP_COORDS_PLACE[1], CHARLIESHOP_RADIUS_SMALL)) {
        log("isVehicleInValidPoint")
        return;
    }

    local vehicle = getPlayerNVehicle(playerid);
    local hull = vehicle.getComponent(NVC.Hull);
    local modelid = hull.getModel();
    local vehicleid = vehicle.vehicleid;
    local carid = vehicle.id;

    if(CHARLIESHOP_CARID != carid) return;

    local keylock = vehicle.components.findOne(NVC.KeyLock);
    local character = players[playerid];

    if( availablePaintCars.find(modelid) == null || keylock == null || keylock.isUnlockableBy(character) == false) {
        return msg(playerid, "charlie.canttouchthiscar", CL_MALIBU);
    }

    if( car_info[carid]["availableColors"] == null ) {
        return msg(playerid, "charlie.nocolorsforthiscar", CL_MALIBU);
    }

    local cr = null;
    if (setdefault == null) {
        cr = car_info[carid]["availableColors"][CHARLIESHOP_COLOR_INDEX];
        CHARLIESHOP_COLOR_INDEX += 1;
        if(CHARLIESHOP_COLOR_INDEX >= car_info[carid]["availableColors"].len()) CHARLIESHOP_COLOR_INDEX = 0;
    } else {
        cr = car_info[carid]["currentColor"];
    }
    hull.setColor(cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
    vehicle.save();

    //setVehicleColour(vehicleid, cr[0], cr[1], cr[2], cr[3], cr[4], cr[5]);
}

function checkVehiclePaintColorChanged(carid) {
    local cr = car_info[carid]["currentColor"];
    local nowcr = vehicles[carid].getComponent(NVC.Hull).getColor();
    for (local i = 0; i < cr.len(); i++) {
        if(cr[i] != nowcr[i]) {
            return true;
        }
    }
    return false;
}

function checkVehicleWheelPairChanged(carid) {
    local wl = car_info[carid]["currentWheels"];
    local nowwl = vehicles[carid].getComponent(NVC.WheelPair).getAll();
    for (local i = 0; i < wl.len(); i++) {
        if(wl[i] != nowwl[i]) {
            return true;
        }
    }
    return false;
}


function getVehicleWheelsArray( playerInventory ) {

    local privateWheels = playerInventory
        .filter(@(item) (item instanceof Item.CouponWheels))
        .map(@(wheel) wheel.model);

    local preAvailableWheels = car_wheels
        .filter(@(i, item) (item.available))
        .map(@(item) item.model);

    preAvailableWheels.extend(privateWheels);

    preAvailableWheels.sort();

    return preAvailableWheels.filter(function(pos, item) {
        return !pos || item != preAvailableWheels[pos - 1];
    })

}

local translations = {

    "en|charlie.goodluck"               :   "[CHARLIE] Nice! Good luck and we'll be glad to see you again!"
    "ru|charlie.goodluck"               :   "[CHARLIE] Отличный выбор! Будем рады видеть вас снова!"

    "en|charlie.payforcolor"            :   "Your paid $%.2f for car painting."
    "ru|charlie.payforcolor"            :   "Вы заплатили $%.2f за покраску."

    "en|charlie.bye"                    :   "[CHARLIE] Return in any convenient time! We'll be glad to see you again!"
    "ru|charlie.bye"                    :   "[CHARLIE] Заезжай к нам в удобное время! Мы рады такому клиенту!"

    "en|charlie.notenoughmoney"         :   "Not enough money to pay!"
    "ru|charlie.notenoughmoney"         :   "Увы, у тебя недостаточно денег."

    "en|charlie.nocolorsforthiscar"     :   "[CHARLIE] I have no paint for this car now. Look later, buddy."
    "ru|charlie.nocolorsforthiscar"     :   "[CHARLIE] У меня сейчас нет краски для этого автомобиля. Загляни позже, дружище."

    "en|charlie.canttouchthiscar"       :   "[CHARLIE] No, man, I won't touch this car!"
    "ru|charlie.canttouchthiscar"       :   "[CHARLIE] Нее, чувак, я не притронусь к этой тачке."

    "en|charlie.rocketstart"            :   "[CHARLIE] Leave the car here is dangerous. Drive off better."
    "ru|charlie.rocketstart"            :   "[CHARLIE] Оставлять здесь авто неприлично опасно. Лучше отъедь."

    "en|charlie.placebusy"              :   "[CHARLIE] Hey! Do you see that place is taken? Wait your turn!"
    "ru|charlie.placebusy"              :   "[CHARLIE] Хэй! Не видишь, что место занято? Жди своей очереди!"


    "en|charlie.welcome"                :   "Welcome to Charlie's Service & Repair"
    "ru|charlie.welcome"                :   "Добро пожаловать в автомастерскую Чарли"

    "en|charlie.help1"                  :   "To change color - press button 1. Price: $%.2f."
    "ru|charlie.help1"                  :   "Смена цвета - кнопка 1. Цена: $%.2f."

    "en|charlie.help2"                  :   "To change wheels - press button 2. The price is different."
    "ru|charlie.help2"                  :   "Смена колёс - кнопка 2. Цена различается."

    "en|charlie.help3"                  :   "To reset choise - press button 0."
    "ru|charlie.help3"                  :   "Сбросить выбор - кнопка 0."

    "en|charlie.help4"                  :   "If you made a choice - free up the place."
    "ru|charlie.help4"                  :   "Если сделал выбор - освобождай место."

}

alternativeTranslate(translations);
