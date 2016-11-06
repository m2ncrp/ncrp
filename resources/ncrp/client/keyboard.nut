addEventHandler("onServerKeyboardRegistration", function(key, state) {
    bindKey(key, state, function() {
        triggerServerEvent("onClientKeyboardPress", key, state);
    });
});

addEventHandler("onServerKeyboardUnregistration", function(key, state) {
    unbindKey(key, state);
});
