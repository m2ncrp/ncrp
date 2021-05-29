local DEBUG = false;
local placeRegistry = {};
local ticker = null;
local buffer = [];
local lines = [];

addEventHandler("onServerPlaceAdded", function(id, x1, y1, x2, y2) {
    // log("registering place with id " + id);
    // log(format("x1: %f y1: %f;  x2: %f y2: %f;", x1, y1, x2, y2));

    if (!(id in placeRegistry)) {
        placeRegistry[id] <- {
            a = { x = x1, y = y1 },
            b = { x = x2, y = y1 },
            c = { x = x2, y = y2 },
            d = { x = x1, y = y2 },
            state = false
        };
    }
});

addEventHandler("onServerLineAdded", function() {
    local pos = getPlayerPosition(getLocalPlayer());
    lines.push({ x = pos[0], y = pos[1], z = pos[2] });
});

// addEventHandler("onClientFramePreRender", function() {
//     if (!DEBUG) return;

//     local data = clone(placeRegistry);
//     local z = getPlayerPosition(getLocalPlayer())[2];

//     buffer.clear();

//     foreach (idx, v in data) {
//         buffer.push([
//             getScreenFromWorld(v.a.x, v.a.y, z),
//             getScreenFromWorld(v.b.x, v.a.y, z),
//             getScreenFromWorld(v.b.x, v.b.y, z),
//             getScreenFromWorld(v.a.x, v.b.y, z),
//         ]);
//     }

//     return true;
// });

addEventHandler("onClientFrameRender", function(isGUIdrawn) {
    if (!isGUIdrawn) return;

    for (local i = 0; i < lines.len(); i++) {
        if (i == 0) continue;

        local prv = lines[i-1];
        local cur = lines[i];

        dxDrawLineWorld(prv.x, prv.y, prv.z, cur.x, cur.y, cur.z, 0xFFFFFFFF);
    }

    if (!DEBUG) return;
    local z = getPlayerPosition(getLocalPlayer())[2];

    // local data = clone(buffer);

    foreach (id, place in placeRegistry) {
        local a = place.a;
        local b = place.b;
        local c = place.c;
        local d = place.d;
        local color = 0xFFFF0000;
        if (place.state) color = 0xFF00FF00;

        dxDrawLineWorld(a.x, a.y, z, b.x, b.y, z, color);
        dxDrawLineWorld(b.x, b.y, z, c.x, c.y, z, color);
        dxDrawLineWorld(c.x, c.y, z, d.x, d.y, z, color);
        dxDrawLineWorld(d.x, d.y, z, a.x, a.y, z, color);

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

    foreach (idx, place in placeRegistry) {

        // log("inside place with id " + idx);
        // log(format("x1: %f y1: %f;  x2: %f y2: %f;", place.a.x, place.a.y, place.b.x, place.b.y));
        // log(x + " " + y + "\n\n");

        if (
            ((place.a.x < x && x < place.c.x) || (place.a.x > x && x > place.c.x)) &&
            ((place.a.y < y && y < place.c.y) || (place.a.y > y && y > place.c.y))
        ) {

            if (place.state) continue;

            // player was outside
            // now he entering
            place.state = true;
        log("inside place with id " + idx);
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
