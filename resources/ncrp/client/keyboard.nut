addEventHandler("onServerKeyboardRegistration", function(key, state) {
    bindKey(key, state, function() {
        triggerServerEvent("onClientKeyboardPress", key, state);
    });
});

addEventHandler("onServerKeyboardUnregistration", function(key, state) {
    unbindKey(key, state);
});

local ticker;
function onServerFreezePlayer(state) {
    if (state) return;

    if (isInputVisible()) {
        ticker = timer(function () {
            onServerFreezePlayer(false);
        }, 1000, -1);
    } else {
        togglePlayerControls(false);
        if (ticker) {
            ticker.Kill();
            ticker = null;
        }
    }
}

addEventHandler("onServerFreezePlayer", onServerFreezePlayer);
