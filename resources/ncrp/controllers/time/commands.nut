// usage: /time
cmd("time", function(playerid) {
    msg(playerid, "Current time is: " + getDateTime());
});

// usage: /time s
cmd("time", "s", function(playerid) {
    msg(playerid, "Current timestamp is: " + getTimestamp());
});

// usage: /time s m
cmd("time", ["s", "m"], function(playerid) {
    msg(playerid, "Current mili timestamp is: " + getTimestampMili());
});

// usage: /time day
cmd("time", "day", function(playerid) {
    msg(playerid, "Current day is: " + getDay());
});

// usage: /time mon
cmd("time", "mon", function(playerid) {
    msg(playerid, "Current month is: " + getMonth());
});

// usage: /time day tomorrow
cmd("time", ["day", "tomorrow"], function(playerid) {
    msg(playerid, "Tomorrow day is: " + (getDay() + 1));
});

//usage: /time day plus 5
cmd("time", ["day", "plus"], function(playerid, days) {
    msg(playerid, "Current day plus is: " + (getDay() + days.tointeger()));
});
