local stations = ["Delta", "Classic", "Empire"];

function getVehicleRadioStationObj(vehicleid) {
    local veh = getVehicleEntity(vehicleid);
    if(veh == null) return false;

    if(!("audio" in veh.data.options)) {
        return false;
    }

    return veh.data.options.audio;
}

function getCurrentVehicleRadioStation(vehicleid) {
    local obj = getVehicleRadioStationObj(vehicleid)

    return obj ? obj.station : false;
}

function isVehicleRadioEnabled(vehicleid) {
    local obj = getVehicleRadioStationObj(vehicleid)

    return obj && obj.enabled;
}

function setVehicleDefaultRadioStationObj(vehicleid, playerid = -1) {
    local veh = getVehicleEntity(vehicleid);
    if(veh == null) return false;

    veh.data.options.audio <- {
        station = stations[2], // Empire
        enabled = true
    }

    if(playerid > -1) {
        triggerClientEvent(playerid, "setRadio", "Empire");
        triggerClientEvent(playerid, "setRadioOn");
    }
}

function applyVehicleRadio(vehicleid, playerid) {
    local obj = getVehicleRadioStationObj(vehicleid);
    if(!obj) return;

    triggerClientEvent(playerid, "setRadio", obj.station);
    triggerClientEvent(playerid, "setRadio"+obj.enabled ? "On" : "Off");
}

function setNextVehicleRadioStation(vehicleid) {
    local obj = getVehicleRadioStationObj(vehicleid)

    if(!obj) {
        return;
    }

    if(!obj.enabled) {
        obj.station = stations[0]; // Delta
        obj.enabled = true;
        return;
    }

    if(obj.station == "Empire") {
        obj.enabled = false;
        return;
    }

    if(obj.station == "Delta") {
        obj.station = "Classic";
        return;
    }

    if(obj.station == "Classic") {
        obj.station = "Empire";
        return;
    }
}

function setPrevVehicleRadioStation(vehicleid) {
    local obj = getVehicleRadioStationObj(vehicleid)

    if(!obj) {
        return;
    }

    if(!obj.enabled) {
        obj.station = stations[2]; // Empire
        obj.enabled = true;
        return;
    }

    if(obj.station == "Delta") {
        obj.enabled = false;
        return;
    }

    if(obj.station == "Empire") {
        obj.station = "Classic";
        return;
    }

    if(obj.station == "Classic") {
        obj.station = "Delta";
        return;
    }
}

event("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
    if(seat == 0) {
        delayedFunction(1500, function() {
            msg(playerid, "timer end, binding key...")

            local veh = getVehicleEntity(vehicleid);
            if(veh == null) return false;

            if(!("audio" in veh.data.options)) {
                setVehicleDefaultRadioStationObj(vehicleid, playerid);
            } else {
                applyVehicleRadio(vehicleid, playerid);
            }

            privateKey(playerid, ".", "radioNext", function(playerid) { setNextVehicleRadioStation(vehicleid) });
            privateKey(playerid, ",", "radioPrev", function(playerid) { setPrevVehicleRadioStation(vehicleid) });
        });
    }
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if(seat == 0) {
        msg(playerid, "removing bindkey...");
        removePrivateKey(playerid, ".", "radioNext");
        removePrivateKey(playerid, ",", "radioPrev");
    }
});


key("4", function(playerid) {
    msg(playerid, "set Delta");
    triggerClientEvent(playerid, "setRadio", "Delta");
});

key("5", function(playerid) {
    msg(playerid, "set Classic");
    triggerClientEvent(playerid, "setRadio", "Classic");
});

key("6", function(playerid) {
    msg(playerid, "set Empire");
    triggerClientEvent(playerid, "setRadio", "Empire");
});

key("7", function(playerid) {
    msg(playerid, "set radio on");
    triggerClientEvent(playerid, "setRadioOn");
});

key("8", function(playerid) {
    msg(playerid, "set radio off");
    triggerClientEvent(playerid, "setRadioOff");
});
