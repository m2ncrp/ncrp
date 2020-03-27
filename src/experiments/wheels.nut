
local ii = 0;
function whee (vehicleid) {
    delayedFunction(3000, function () {
        setVehicleWheelTexture(vehicleid, 0, ii)
        setVehicleWheelTexture(vehicleid, 1, ii)
        logStr(ii+" completed")
        ii++;

        whee(vehicleid);
    });
}

cmd("whe", function(playerid) {
    local vehicleid = getNearestVehicleForPlayer(playerid, 30.0);
    whee(vehicleid);
});
