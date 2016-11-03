cmd("time", function(playerid) {
    msg(playerid, "Current time is: " + getDateTime());
});

cmd("timest", function(playerid) {
    msg(playerid, "Current timestamp is: " + getTimestamp());
});

cmd("timestm", function(playerid) {
    dbg(format("%.0f", getTimestampMili()));
    msg(playerid, "Current timestamp is: " + floatToString(getTimestampMili()));
});
