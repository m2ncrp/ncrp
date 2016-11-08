include("controllers/rentcar/commands.nut");

local rentcars = {};
addEventHandlerEx("onServerStarted", function() {
    log("[vehicles] loading rent cars module...");

    rentcars[createVehicle(31, 579.762, 802.5, -12.5, 34.939,  0.37609, -0.0309878)]    <- [ 0.28, "free" ];
    rentcars[createVehicle(43,  575.099, 802.5, -12.5, 36.7076, 0.287637, 0.0469708)]   <- [ 0.28, "free" ];
    rentcars[createVehicle(53, 570.128, 802.5, -12.5, 38.578,  0.206956, -0.591333)]    <- [ 0.28, "free" ];
    rentcars[createVehicle(50, 565.087, 802.5, -12.5, 40.5424, 0.668225, -0.409561)]    <- [ 0.36, "free" ];
    rentcars[createVehicle(25, 560.053, 802.5, -12.5, 42.1816, 0.300678, 0.0441727)]    <- [ 0.28, "free" ];
    rentcars[createVehicle(47, 554.652, 802.5, -12.5, 38.7988, 0.134398, -0.381655)]    <- [ 0.28, "free" ];
    rentcars[createVehicle(15, 548.724, 802.5, -12.5, 45.0359, 0.392815, 0.00316114)]   <- [ 0.61, "free" ];

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
        return msg(playerid, "Go to parking CAR RENTAL in North Millville to rent a car.");
    }
    if(!isPlayerCarRent(playerid)) {
        return msg(playerid, "This car can not be rented.");
    }

    local vehicleid = getPlayerVehicle(playerid);
    local rentprice = rentcars[vehicleid][0].tofloat();
    if(!canMoneyBeSubstracted(playerid, rentprice)) {
        return msg(playerid, "You don't have enough money.");
    }
    rentcars[vehicleid][1] = playerid;
    setVehicleFuel(vehicleid, 28.0);
    msg(playerid, "You rented this car. If you want to refuse from rent: /rent refuse");
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
        }
    }
    msg(playerid, "You refused from rent all cars. Thank you for choosing North Millville Car Rental!");
}

addEventHandler ( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if(isPlayerCarRent(playerid)) {
        local whorent = getPlayerWhoRentVehicle(vehicleid);
        if(whorent != playerid) {
            setVehicleFuel(vehicleid, 0.0);
            msg(playerid, "You can rent this car for $"+getVehicleRentPrice(vehicleid)+" in minute. If you agree: /rent");
        }
    }
});


addEventHandlerEx("onServerMinuteChange", function() {
// called every game time minute changes
    foreach (vehicleid, value in rentcars) {
        if (value[1] == "free") {
            continue;
        }
        local playerid = value[1];
        if(!canMoneyBeSubstracted(playerid, value[0])) {
            setVehicleFuel(vehicleid, 0.0);
            setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
            rentcars[vehicleid][1] = "free";
            msg(playerid, "You can't drive this car more, because you don't have enough money. Please, get out of the car.");
        } else {
            subMoneyToPlayer(playerid, value[0]);
            msg(playerid, "You paid for car. Your balance: "+getPlayerBalance(playerid));
        }
    }
});
