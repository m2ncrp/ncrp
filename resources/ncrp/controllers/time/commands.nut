cmd("time", function(playerid) {
    msg(playerid, "Current time is: " + getDateTime());
});

cmd("timest", function(playerid) {
    msg(playerid, "Current timestamp is: " + getTimestamp());
});
