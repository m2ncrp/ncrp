local ticker;
function onServerFreezePlayer(state) {
    if (state) return;

    if (isInputVisible()) {
        ticker = timer(function () {
            onServerFreezePlayer(false);
        }, 1000, 1);
    } else {
        togglePlayerControls(false);
        if (ticker) {
            ticker = null;
        }
    }
}

addEventHandler("onServerFreezePlayer", onServerFreezePlayer);



local keyboard_proxy = [
    "tab", "ctrl", "shift", "enter", "space",
    // "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",

];

keyboard_proxy.map(function(key) {
    bindKey(key, "up",   function() { triggerServerEvent("onClientKeyboardPress", key, "up"); });
    bindKey(key, "down", function() { triggerServerEvent("onClientKeyboardPress", key, "down"); });
});

addEventHandler("onServerKeyboardRegistration", function(key, state) {
    if (keyboard_proxy.find(key) != null) {
        return;
    }

    bindKey(key, state, function() {
        triggerServerEvent("onClientKeyboardPress", key, state);
    });
});

addEventHandler("onServerKeyboardUnregistration", function(key, state) {
    // unbindKey(key, state);
});
