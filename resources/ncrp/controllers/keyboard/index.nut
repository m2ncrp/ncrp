include("controllers/keyboard/functions.nut");
include("controllers/keyboard/commands.nut");

// register events
addEventHandlerEx("onPlayerConnect", function(playerid, nickname, ip, serial) {
    sendKeyboardRegistration(playerid);
});

addEventHandler("onClientKeyboardPress", function(playerid, key, state) {
    triggerKeyboardPress(playerid, key, state);
});

addEventHandler("onServerStopping", function() {
    playerList.each(function(playerid) {
        return sendKeyboardUnregistration(playerid);
    });
});
