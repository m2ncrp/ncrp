local DEBUG = false;
local placeRegistry = {};
local ticker = null;
local buffer = [];

addEventHandler("onServerPlaceAdded", function(id, x1, y1, x2, y2) {
    // log("registering place with id " + id);
    // log(format("x1: %f y1: %f;  x2: %f y2: %f;", x1, y1, x2, y2));

    if (!(id in placeRegistry)) {
        placeRegistry[id] <- { a = { x = x1, y = y1 }, b = { x = x2, y = y2 }, state = false };
    }
});

addEventHandler("onClientFramePreRender", function() {
    if (!DEBUG) return;

    local data = clone(placeRegistry);
    local z = getPlayerPosition(getLocalPlayer())[2];

    buffer.clear();

    foreach (idx, v in data) {
        buffer.push([
            getScreenFromWorld(v.a.x, v.a.y, z),
            getScreenFromWorld(v.b.x, v.a.y, z),
            getScreenFromWorld(v.b.x, v.b.y, z),
            getScreenFromWorld(v.a.x, v.b.y, z),
        ]);
    }

    return true;
});

addEventHandler("onClientFrameRender", function(isGUIdrawn) {
    if (!DEBUG) return;
    if (!isGUIdrawn) return;

    local data = clone(buffer);

    foreach (idx1, place in data) {
        local a = place[0];
        local b = place[1];
        local c = place[2];
        local d = place[3];

        // if (a[2] >= 1 && b[2] >= 1 && c[2] >= 1 && d[2] >= 1) continue;

        if (a[2] < 1 && b[2] < 1) dxDrawLine(a[0], a[1], b[0], b[1], 0xFFFF0000);
        if (b[2] < 1 && c[2] < 1) dxDrawLine(b[0], b[1], c[0], c[1], 0xFFFF0000);
        if (c[2] < 1 && d[2] < 1) dxDrawLine(c[0], c[1], d[0], d[1], 0xFFFF0000);
        if (d[2] < 1 && a[2] < 1) dxDrawLine(d[0], d[1], a[0], a[1], 0xFFFF0000);
    }
});

addEventHandler("onServerPlaceRemoved", function(id) {
    if (id in placeRegistry) {
        // if (placeRegistry[id].state) {
        //     triggerServerEvent("onPlayerPlaceExit", getLocalPlayer(), id);
        // }

        delete placeRegistry[id];
    }
});

addEventHandler("onClientScriptExit", function() {
    if (ticker) {
        try {
            ticker.Kill();
        }
        catch (e) {}
    }

    ticker = null;
});

addEventHandler("onDebugToggle", function() {
    DEBUG = !DEBUG;
});

function onPlayerTick() {
    local pos = getPlayerPosition(getLocalPlayer());
    local x = pos[0];
    local y = pos[1];
    local data = clone(placeRegistry);

    foreach (idx, place in data) {

        // log("inside place with id " + idx);
        // log(format("x1: %f y1: %f;  x2: %f y2: %f;", place.a.x, place.a.y, place.b.x, place.b.y));
        // log(x + " " + y + "\n\n");

        if (
            ((place.a.x < x && x < place.b.x) || (place.a.x > x && x > place.b.x)) &&
            ((place.a.y < y && y < place.b.y) || (place.a.y > y && y > place.b.y))
        ) {

            if (place.state) continue;

            // player was outside
            // now he entering
            place.state = true;
            triggerServerEvent("onPlayerPlaceEnter", idx);
        } else {
            if (!place.state) continue;

            // player was inside
            // now hes exiting
            place.state = false;
            triggerServerEvent("onPlayerPlaceExit", idx);
        }
    }
}

addEventHandler("onServerClientStarted", function(version) {
    ticker = timer(onPlayerTick, 100, -1);
});
