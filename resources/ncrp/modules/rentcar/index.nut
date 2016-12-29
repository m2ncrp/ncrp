include("modules/rentcar/commands.nut");

local rentcars = {};
event ("onServerStarted", function() {
    log("[vehicles] loading rent cars module...");

    rentcars[createVehicle(31, 579.762, 802.5, -12.5, 34.939,  0.37609, -0.0309878)]    <- [ 0.03, "free" ];
    rentcars[createVehicle(43, 575.099, 802.5, -12.5, 36.7076, 0.287637, 0.0469708)]    <- [ 0.02, "free" ];
    rentcars[createVehicle(53, 570.128, 802.5, -12.5, 38.578,  0.206956, -0.591333)]    <- [ 0.04, "free" ];
    rentcars[createVehicle(50, 565.087, 802.5, -12.5, 40.5424, 0.668225, -0.409561)]    <- [ 0.07, "free" ];
    rentcars[createVehicle(25, 560.053, 802.5, -12.5, 42.1816, 0.300678, 0.0441727)]    <- [ 0.03, "free" ];
    rentcars[createVehicle(47, 554.652, 802.5, -12.5, 38.7988, 0.134398, -0.381655)]    <- [ 0.03, "free" ];
    rentcars[createVehicle(15, 548.724, 802.5, -12.5, 45.0359, 0.392815, 0.00316114)]   <- [ 0.17, "free" ];

    // Vokzal
    rentcars[createVehicle(43, -547.328, 1583.16, -16.3215, 1.03211, 0.00669244, -0.743004)]  <- [ 0.02, "free" ];
    rentcars[createVehicle(53, -539.312, 1600.12, -16.3687, -179.923, -0.285566, 0.826165)]   <- [ 0.04, "free" ];
    rentcars[createVehicle(25, -536.281, 1599.85, -16.4633, -179.624, -0.121403, 0.225714)]   <- [ 0.03, "free" ];

    //Port
    rentcars[createVehicle(43, -419.388, -667.238, -20.8829, 87.5226, -0.29715, -1.18796)]  <- [ 0.02, "free" ];
    rentcars[createVehicle(44, -419.57, -670.935, -21.0624, 88.1328, -0.25944, -1.9095)]    <- [ 0.08, "free" ];
    rentcars[createVehicle(31, -419.314, -677.798, -21.2509, -93.2246, 0.213046, -2.23081)] <- [ 0.03, "free" ];
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
    local minute = getMinute().tofloat();
    local minutesleft = ceil( minute / 10 ) * 10 - minute; // minutes to near largest round number: if minute == 36 then minutesleft = 4
    local rentprice = rentcars[vehicleid][0].tofloat()*minutesleft;

    if(!canMoneyBeSubstracted(playerid, rentprice)) {
        return msg(playerid, "rentcar.notenough");
    }
    rentcars[vehicleid][1] = playerid;
    unblockVehicle(vehicleid);
    setVehicleFuel(vehicleid, 28.0);
    setVehicleRespawnEx(vehicleid, false);
    subMoneyToPlayer( playerid, rentprice );
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
        if (value[1] == playerid) {
            rentcars[vehicleid][1] = "free";
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


event ("onServerMinuteChange", function() {
    if (((getMinute()+1) % 10.0) != 0) {
        return;
    }
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
            local rentprice = value[0] * 10;
            subMoneyToPlayer(playerid, rentprice );
            msg(playerid, "rentcar.paidcar", [ rentprice, getPlayerBalance(playerid)] );
        }
    }
});


function showRentCarGUI(playerid, vehicleid){
    local windowText =  plocalize(playerid, "rentcar.gui.window");
    local labelText =   plocalize(playerid, "rentcar.gui.canrent", [getVehicleRentPrice(vehicleid)*10, getVehicleRentPrice(vehicleid)*60]);
    local button1Text = plocalize(playerid, "rentcar.gui.buttonRent");
    local button2Text = plocalize(playerid, "rentcar.gui.buttonRefuse");
    triggerClientEvent(playerid, "showRentCarGUI", windowText,labelText,button1Text,button2Text);
}
