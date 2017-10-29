local event  = addEventHandler;
local busses = {};

event("onPlayerPutInBus", function(playerid, vehicleid) {
    playerid  = playerid.tointeger();
    vehicleid = vehicleid.tointeger();

    if (!(vehicleid in busses)) {
        busses[vehicleid] <- [];
    }

    busses[vehicleid].push(playerid);

    log(format("putting playerid: %d into the bus: %d", playerid, vehicleid));
});

event("onPlayerRemovedFromBus", function(playerid, vehicleid) {
    playerid  = playerid.tointeger();
    vehicleid = vehicleid.tointeger();

    if (!(vehicleid in busses)) {
        return;
    }

    local passid = busses[vehicleid].find(playerid);

    if (passid != null) {
        busses[vehicleid].remove(passid);
    }

    log(format("removing playerid: %d from the bus: %d", playerid, vehicleid));
});

event("onClientFrameRender", function(afterGUI) {
    if (afterGUI) return;

    foreach (vehicleid, bplayers in busses) {
        local busPos = getVehiclePosition(vehicleid);

        bplayers.map(function(playerid) {
            setPlayerPosition(playerid, busPos[0], busPos[1], busPos[2] + 0.6);
        });
    }
});
