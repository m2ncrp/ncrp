include("controllers/keyboard/functions.nut");
include("controllers/keyboard/commands.nut");

// register events
event("onPlayerConnect", function(playerid, nickname, ip, serial) {
    delayedFunction(1000, function() { sendKeyboardRegistration(playerid); });
});

event("onClientKeyboardPress", function(playerid, key, state) {
    triggerKeyboardPress(playerid, key, state);
});

event("onServerStopping", function() {
    playerList.each(function(playerid) {
        return sendKeyboardUnregistration(playerid);
    });
});
