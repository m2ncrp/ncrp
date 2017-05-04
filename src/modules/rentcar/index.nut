include("modules/rentcar/commands.nut");

local rentcars = {};
event ("onServerStarted", function() {
    log("[vehicles] loading rent cars module...");

    rentcars[createVehicle(43, 579.762, 802.5, -12.5, 34.939,  0.37609, -0.0309878)]    <- [ "free" ];
    rentcars[createVehicle(53, 575.099, 802.5, -12.5, 36.7076, 0.287637, 0.0469708)]    <- [ "free" ];
    rentcars[createVehicle(44, 570.128, 802.5, -12.5, 38.578,  0.206956, -0.591333)]    <- [ "free" ];
    rentcars[createVehicle(25, 565.087, 802.5, -12.5, 40.5424, 0.668225, -0.409561)]    <- [ "free" ];
    rentcars[createVehicle(50, 560.053, 802.5, -12.5, 42.1816, 0.300678, 0.0441727)]    <- [ "free" ];
    rentcars[createVehicle(22, 554.652, 802.5, -12.5, 38.7988, 0.134398, -0.381655)]    <- [ "free" ];
    rentcars[createVehicle(52, 548.724, 802.5, -12.5, 45.0359, 0.392815, 0.00316114)]   <- [ "free" ];

    // Vokzal
    rentcars[createVehicle(43, -547.328, 1583.16, -16.3215, 1.03211, 0.00669244, -0.743004)]  <- [ "free" ];
  //rentcars[createVehicle(44, -539.312, 1600.12, -16.3687, -179.923, -0.285566, 0.826165)]   <- [ "free" ];
    rentcars[createVehicle(44, -536.281, 1599.85, -16.4633, -179.624, -0.121403, 0.225714)]   <- [ "free" ];

    //Port
  //rentcars[createVehicle(44, -419.388, -667.238, -20.8829, 87.5226, -0.29715, -1.18796)]  <- [ "free" ];
    rentcars[createVehicle(43, -419.57, -670.935, -21.0624, 88.1328, -0.25944, -1.9095)]    <- [ "free" ];
    rentcars[createVehicle(23, -419.314, -677.798, -21.2509, 90.0, 0.213046, -1.64081)]     <- [ "free" ];

    foreach (idx, value in rentcars) {
        setVehiclePlateText(idx, getRandomVehiclePlate("CR"));
        local modelid = getVehicleModel(idx);
        setVehicleDirtLevel(idx, 0);
        if(modelid == 41 || modelid == 25 || modelid == 31) {
            setVehicleColour(idx, 120, 80, 10, 170, 120, 10);
            continue;
        }
        setVehicleColour(idx, 170, 120, 10, 120, 80, 10);
    }

    // need for helper in game
/*  local houston = createVehicle(9, 1037.01, 842.146, -3.55631, 70.4218, 5.2121, 0.6804);
    rentcars[houston]     <- [ 0.07, "free" ];
    setVehicleColour( houston, 10, 10, 10, 10, 10, 10 );
    setVehicleDirtLevel( houston 0.0 );
*/
    // end

    createBlip  (  570.26, 830.175, [ 6, 4 ], 4000.0);
});

function isPlayerCarRent(playerid) {
    return (getPlayerVehicle(playerid) in rentcars);
}

function getVehicleRentPrice(vehicleid) {
    local modelid = getVehicleModel(vehicleid);
    return getCarInfoModelById(modelid).rent.tofloat();
}

function getPlayerWhoRentVehicle(vehicleid) {
    return rentcars[vehicleid][0];
}

function RentCar(playerid) {
    if (!isPlayerInVehicle) {
        return msg(playerid, "rentcar.goto");
    }
    if(!isPlayerCarRent(playerid)) {
        return msg(playerid, "rentcar.notrent");
    }

    local vehicleid = getPlayerVehicle(playerid);
    local minute = getMinute().tofloat();
    local minutesleft = ceil( minute / 10 ) * 10 - minute; // minutes to near largest round number: if minute == 36 then minutesleft = 4
    if (minutesleft == 0) { minutesleft = 10; }
    local rentprice = getVehicleRentPrice(vehicleid).tofloat()*minutesleft;

    if(!canMoneyBeSubstracted(playerid, rentprice)) {
        return msg(playerid, "rentcar.notenough");
    }
    rentcars[vehicleid][0] = playerid;
    unblockVehicle(vehicleid);
    setVehicleFuel(vehicleid, 28.0);
    setVehicleRespawnEx(vehicleid, false);
    subMoneyToPlayer( playerid, rentprice );
    addMoneyToTreasury(rentprice);
    msg(playerid, "rentcar.rented");
    msg(playerid, "rentcar.paidcar", [ rentprice, getPlayerBalance(playerid)] );
}
addEventHandler("RentCar", RentCar);

function RentCarRefuse(playerid) {
    if(isPlayerInVehicle && isPlayerCarRent(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        setVehicleFuel(vehicleid, 0.0);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
    }

    foreach (vehicleid, value in rentcars) {
        if (value[0] == playerid) {
            rentcars[vehicleid][0] = "free";
            setVehicleRespawnEx(vehicleid, true);
        }
    }
    msg(playerid, "rentcar.refused");
}

event ( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if(isPlayerCarRent(playerid) && seat == 0) {
        local whorent = getPlayerWhoRentVehicle(vehicleid);
        if(whorent != playerid) {
            blockVehicle(vehicleid);
            //msg(playerid, "rentcar.canrent", [getVehicleRentPrice(vehicleid)*10, getVehicleRentPrice(vehicleid)*60 ]);
            showRentCarGUI(playerid, vehicleid);
        } else {
            unblockVehicle(vehicleid);
        }
    }
});

event ( "onPlayerVehicleExit", function ( playerid, vehicleid, seat ) {
    if (vehicleid in rentcars && seat == 0) {
        blockVehicle(vehicleid);
    }
});

event( "onPlayerDisconnect",  function ( playerid, reason ) {
        foreach (vehicleid, value in rentcars) {
            if (value[0] == "free") {
                continue;
            }
            if (playerid == value[0]) {
                setVehicleFuel(vehicleid, 0.0);
                setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
                rentcars[vehicleid][0] = "free";
                setVehicleRespawnEx(vehicleid, true);
            }
        }
});


event ("onServerMinuteChange", function() {
    if (((getMinute()+1) % 10.0) != 0) {
        return;
    }
// called every game time minute changes
    foreach (vehicleid, value in rentcars) {
        if (value[0] == "free") {
            setVehicleFuel(vehicleid, 0.0);
            continue;
        }
        local playerid = value[0];
        if(!canMoneyBeSubstracted(playerid, value[0])) {
            setVehicleFuel(vehicleid, 0.0);
            setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
            rentcars[vehicleid][0] = "free";
            setVehicleRespawnEx(vehicleid, true);
            msg(playerid, "rentcar.cantrent");
        } else {
            local rentprice = value[0] * 10;
            subMoneyToPlayer(playerid, rentprice );
            addMoneyToTreasury(rentprice);
            msg(playerid, "rentcar.paidcar", [ rentprice, getPlayerBalance(playerid)] );
        }
    }
});


event("onPlayerPhoneCall", function(playerid, number, place) {
    if(number == "0192") {
        msg(playerid, "You call to North Millville Car Rental. If you want to rent car - go to our parking in North Millville.");
    }
});

function showRentCarGUI(playerid, vehicleid){
    local windowText =  plocalize(playerid, "rentcar.gui.window");
    local labelText =   plocalize(playerid, "rentcar.gui.canrent", [getVehicleRentPrice(vehicleid)*10, getVehicleRentPrice(vehicleid)*60]);
    local button1Text = plocalize(playerid, "rentcar.gui.buttonRent");
    local button2Text = plocalize(playerid, "rentcar.gui.buttonRefuse");
    triggerClientEvent(playerid, "showRentCarGUI", windowText,labelText,button1Text,button2Text);
}
