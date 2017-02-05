

addEventHandler("onServerScriptEvaluate", function(code) {
    log("[debug] trying to evaluate script code;");
    log("[debug] code: " + code);

    try {
        local result = compilestring(format("return %s;", code))();
        log(JSONEncoder.encode(result));
        sendMessage(JSONEncoder.encode(result));
    } catch (e) {
        triggerServerEvent("onClientScriptError", JSONEncoder.encode(e));
    }
});

local toggler = false;
local step = 0.5;

bindKey("0", "down", function() {
    if (toggler) {
        sendMessage("[tp] you are now in default mode!");
        togglePlayerControls(false);
        toggler = false;
    } else {
        triggerServerEvent("onClientDebugToggle");
    }
});

addEventHandler("onServerDebugToggle", function() {
    sendMessage("[tp] you are now in free fly mode!");
    togglePlayerControls(true);
    toggler = true;
});

bindKey("2", "down", function() {
    if (!toggler) return;
    step += step;
    sendMessage("[tp] step is now: " + step);
});

bindKey("1", "down", function() {
    if (!toggler) return;
    step -= (step / 2);
    sendMessage("[tp] step is now: " + step);
});

bindKey("space", "down", function() {
    if (!toggler) return;

    local size     = getScreenSize();
    local position = getWorldFromScreen( (size[0] / 2).tofloat(), (size[1] / 2).tofloat(), 100.0 );
    local current  = getPlayerPosition( getLocalPlayer() );

    local dx = ((position[0] - current[0])) * step;
    local dy = (-1 * (current[1]  - position[1])) * step;

    triggerServerEvent("onPlayerTeleportRequested", current[0].tofloat() - dx, current[1].tofloat() - dy, current[2] );
});

bindKey("3", "down", function() {
    if (!toggler) return;
    local current = getPlayerPosition( getLocalPlayer() );

    triggerServerEvent("onPlayerTeleportRequested", current[0], current[1], current[2] - step );
});


bindKey("4", "down", function() {
    if (!toggler) return;
    local current = getPlayerPosition( getLocalPlayer() );

    triggerServerEvent("onPlayerTeleportRequested", current[0], current[1], current[2] + step );
});
