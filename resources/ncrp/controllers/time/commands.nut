cmd("time", function(playerid) {
    msg(playerid, "Current time is: " + getDateTime());
});

cmd("time", ["s"], function(playerid) {
    msg(playerid, "Current timestamp is: " + getTimestamp());
});

cmd("time", ["s", "m"], function(playerid) {
    msg(playerid, "Current mili timestamp is: " + getTimestampMili());
});

cmd("time", "d", function(playerid) {
    msg(playerid, "Current day is: " + getDay());
});

cmd("time", "m", function(playerid) {
    msg(playerid, "Current month is: " + getMonth());
});
