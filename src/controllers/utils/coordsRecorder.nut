local isTimerEnabled = false;
function getCoordsByTimer(playerid) {
    delayedFunction(1000, function () {
        dbg(getPlayerPosition(playerid));
        if(isTimerEnabled) getCoordsByTimer(playerid);
    });
}

key("num_0", function(playerid) {
    isTimerEnabled = !isTimerEnabled;

    if(isTimerEnabled) {
        getCoordsByTimer(playerid);
        msg(playerid, "Timer started", CL_SUCCESS);
    } else {
        msg(playerid, "Timer stopped", CL_ERROR);
    }
});
