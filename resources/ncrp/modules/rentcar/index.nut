include("modules/rentcar/commands.nut");

local rentcars = {};
addEventHandlerEx("onServerStarted", function() {
    log("[vehicles] loading rent cars module...");

    rentcars[createVehicle(31, 579.762, 802.5, -12.5, 34.939,  0.37609, -0.0309878)]    <- [ 0.28, "free" ];
    rentcars[createVehicle(43, 575.099, 802.5, -12.5, 36.7076, 0.287637, 0.0469708)]    <- [ 0.28, "free" ];
    rentcars[createVehicle(53, 570.128, 802.5, -12.5, 38.578,  0.206956, -0.591333)]    <- [ 0.28, "free" ];
    rentcars[createVehicle(50, 565.087, 802.5, -12.5, 40.5424, 0.668225, -0.409561)]    <- [ 0.36, "free" ];
    rentcars[createVehicle(25, 560.053, 802.5, -12.5, 42.1816, 0.300678, 0.0441727)]    <- [ 0.28, "free" ];
    rentcars[createVehicle(47, 554.652, 802.5, -12.5, 38.7988, 0.134398, -0.381655)]    <- [ 0.28, "free" ];
    rentcars[createVehicle(15, 548.724, 802.5, -12.5, 45.0359, 0.392815, 0.00316114)]   <- [ 0.61, "free" ];

    createBlip  (  570.26, 830.175, [ 6, 4 ], 4000.0);
});

translation("en", {
    "rentcar.goto"          : "Go to parking CAR RENTAL in North Millville to rent a car."
    "rentcar.notrent"       : "This car can not be rented."
    "rentcar.notenough"     : "You don't have enough money."
    "rentcar.rented"        : "You rented this car. If you want to refuse from rent: /rent refuse"
    "rentcar.refused"       : "You refused from rent all cars. Thank you for choosing North Millville Car Rental!"
    "rentcar.canrent"       : "You can rent this car for $%.2f in minute. If you agree: /rent"
    "rentcar.cantrent"      : "You can't drive this car more, because you don't have enough money. Please, get out of the car."
    "rentcar.paidcar"       : "You paid for car. Your balance: $%.2f."

    "rentcar.help.title"    : "List of available commands for CAR RENTAL:"
    "rentcar.help.rent"     : "Rent this car (need to be in a car)"
    "rentcar.help.refuse"   : "Refuse from all rented cars"
});

translation("ru", {
    "rentcar.goto"          : "Отправляйтесь на парковку авто, предоставляемых в аренду, в North Millville."
    "rentcar.notrent"       : "Этот автомобиль нельзя арендовать."
    "rentcar.notenough"     : "У вас недостаточно денег."
    "rentcar.rented"        : "Вы арендовали этот автомобиль. Отказаться от аренды: /rent refuse"
    "rentcar.refused"       : "Вы отказались от аренды всех автомобилей. Благодарим за выбор North Millville Car Rental!"
    "rentcar.canrent"       : "Вы можете взять этот автомобиль в аренду за $%.2f в минуту. Если согласны: /rent"
    "rentcar.cantrent"      : "У вас закончились деньги, аренда приостановлена. Пожалуйста, покиньте автомобиль."
    "rentcar.paidcar"       : "Вы заплатили за аренду автомобиля. Ваш баланс: $%.2f."

    "rentcar.help.title"    : "Список команд, доступных для аренды автомобилей:"
    "rentcar.help.rent"     : "Арендовать автомобиль (нужно быть в автомобиле)"
    "rentcar.help.refuse"   : "Отказаться от аренды всех автомобилей"
});

function isPlayerCarRent(playerid) {
    return (getPlayerVehicle(playerid) in rentcars);
}

function getVehicleRentPrice(vehicleid) {
    return rentcars[vehicleid][0].tofloat();
}

function getPlayerWhoRentVehicle(vehicleid) {
    return rentcars[vehicleid][1];
}

function RentCar(playerid) {
    if (!isPlayerInVehicle) {
        return msg(playerid, "rentcar.goto");
    }
    if(!isPlayerCarRent(playerid)) {
        return msg(playerid, "rentcar.notrent");
    }

    local vehicleid = getPlayerVehicle(playerid);
    local rentprice = rentcars[vehicleid][0].tofloat();
    if(!canMoneyBeSubstracted(playerid, rentprice)) {
        return msg(playerid, "rentcar.notenough");
    }
    rentcars[vehicleid][1] = playerid;
    setVehicleFuel(vehicleid, 28.0);
    setVehicleRespawnEx(vehicleid, false);
    msg(playerid, "rentcar.rented");
}

function RentCarRefuse(playerid) {
    if(isPlayerInVehicle && isPlayerCarRent(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        setVehicleFuel(vehicleid, 0.0);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
    }

    foreach (vehicleid, value in rentcars) {
        if (value[1] == playerid) {
            rentcars[vehicleid][1] = "free";
            setVehicleRespawnEx(vehicleid, true);
        }
    }
    msg(playerid, "rentcar.refused");
}

addEventHandler ( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if(isPlayerCarRent(playerid)) {
        local whorent = getPlayerWhoRentVehicle(vehicleid);
        if(whorent != playerid) {
            setVehicleFuel(vehicleid, 0.0);
            msg(playerid, "rentcar.canrent", getVehicleRentPrice(vehicleid));
        }
    }
});

addEventHandler( "onPlayerDisconnect",  function ( playerid, reason ) {
        foreach (vehicleid, value in rentcars) {
            if (value[1] == "free") {
                continue;
            }
            if (playerid == value[1]) {
                setVehicleFuel(vehicleid, 0.0);
                setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
                rentcars[vehicleid][1] = "free";
                setVehicleRespawnEx(vehicleid, true);
            }
        }
});


addEventHandlerEx("onServerMinuteChange", function() {
// called every game time minute changes
    foreach (vehicleid, value in rentcars) {
        if (value[1] == "free") {
            setVehicleFuel(vehicleid, 0.0);
            continue;
        }
        local playerid = value[1];
        if(!canMoneyBeSubstracted(playerid, value[0])) {
            setVehicleFuel(vehicleid, 0.0);
            setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
            rentcars[vehicleid][1] = "free";
            setVehicleRespawnEx(vehicleid, true);
            msg(playerid, "rentcar.cantrent");
        } else {
            subMoneyToPlayer(playerid, value[0]);
            msg(playerid, "rentcar.paidcar", getPlayerBalance(playerid) );
        }
    }
});
