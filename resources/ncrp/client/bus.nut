local ticker = null;

addEventHandler("onServerPlayerBusEnter", function(busid) {
    ticker = timer(function() {
        local pos = getVehiclePosition(busid.tointeger());
        triggerServerEvent("onClientRequestedPosition", pos[0], pos[1], pos[2] + 0.5);
    }, 25, -1);
});

addEventHandler("onServerPlayerBusExit", function() {
    if (ticker) {
        ticker.Kill();
        ticker = null;
    }
});
