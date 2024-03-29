include("controllers/keyboard/functions.nut");
include("controllers/keyboard/commands.nut");

// register events
event("onPlayerConnect", function(playerid) {
    delayedFunction(1000, function() {
        sendKeyboardRegistration(playerid);
        sendPrivateKeyboardRegistration(playerid);
    });
});

event("onClientKeyboardPress", function(playerid, key, state) {
    trigger(playerid, "onServerKeyboard", key, state);

    if (isPlayerLogined(playerid)) {
        triggerKeyboardPress(playerid, key, state);
        setPlayerAfk(playerid, false);
    }
});

event("onClientNativeKeyboardPress", function(playerid, key, state) {
    if (key == "enter" && state == "down") {
        trigger(playerid, "onServerPressEnter");
    }
});

event("onServerStopping", function() {
    playerList.each(function(playerid) {
        return sendKeyboardUnregistration(playerid);
    });
});

translate("en", {
    "keyboard.layout.info"      : "To change layout enter: /layout list"
    "kayboard.layout.list"      : "Available layouts: %s"
    "keyboard.layout.success"   : "Layout successfuly changed!"
});

addKeyboardLayout("qwerty", {});
addKeyboardLayout("azerty", {
    "q" : "a"
    "w" : "z"
    "a" : "q"
    "z" : "w"
});
