cmd("time", function(playerid) {
    msg(playerid, "Current time is: " + getDateTime());
});

cmd("time", "s", function(playerid) {
    msg(playerid, "Current timestamp is: " + getTimestamp());
});

cmd("time", "m", function(playerid) {
    dbg(format("%.0f", getTimestampMili()));
    msg(playerid, "Current timestamp is: " + floatToString(getTimestampMili()));
});
