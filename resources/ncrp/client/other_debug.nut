dbgc <- function(...) {
    sendMessage(JSONEncoder.encode(concat(vargv)));
};

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

addEventHandler("onServerDebugToggle", function() {
    sendMessage("[tp] you are now in free fly mode!");
    togglePlayerControls(true);
    toggler = true;
});

addEventHandler("onServerKeyboard", function(key, state) {
    if (state != "down") return;

    if (key == "0") {
        if (toggler) {
            sendMessage("[tp] you are now in default mode!");
            togglePlayerControls(false);
            toggler = false;
        } else {
            triggerServerEvent("onClientDebugToggle");
        }
    }

    if (!toggler) return;

    local current = getPlayerPosition( getLocalPlayer() );

    switch (key) {
        case "space":
            local size     = getScreenSize();
            local position = getWorldFromScreen( (size[0] / 2).tofloat(), (size[1] / 2).tofloat(), 100.0 );

            local dx = ((position[0] - current[0])) * step;
            local dy = (-1 * (current[1]  - position[1])) * step;

            triggerServerEvent("onPlayerTeleportRequested", current[0].tofloat() - dx, current[1].tofloat() - dy, current[2] );
            break;

        case "3":
            triggerServerEvent("onPlayerTeleportRequested", current[0], current[1], current[2] - step );
            break;
        case "4":
            triggerServerEvent("onPlayerTeleportRequested", current[0], current[1], current[2] + step );
            break;
    }

    if (key == "1") {
        step -= (step / 2);
        sendMessage("[tp] step is now: " + step);
    }

    if (key == "2") {
        step += step;
        sendMessage("[tp] step is now: " + step);
    }
});
