local placeRegistry = {};
local ticker = null;

addEventHandler("onServerClientStarted", function(version) {
    ticker = timer(onPlayerTick, 100, -1);
});

addEventHandler("onServerPlaceAdded", function(id, x1, y1, x2, y2) {
    if (!(id in placeRegistry)) {
        placeRegistry[id] <- { a = { x = x1, y = y1 }, b = { x = x2, y = y2 }, state = false };
    }
});

addEventHandler("onServerPlaceRemoved", function(id) {
    if (id in placeRegistry) {
        delete placeRegistry[id];
    }
});

addEventHandler("onClientScriptExit", function() {
    ticker.Kill();
    ticker = null;
});

function onPlayerTick() {
    local pos = getPlayerPosition(getLocalPlayer());
    local x = pos[0];
    local y = pos[1];

    foreach (idx, place in placeRegistry) {
        if (isPointInArea2D(x, y, place.a.x, place.a.y, place.b.x, place.b.y)) {
            if (place.state) continue;

            // player was outside
            // now he entering
            place.state = true;
            triggerServerEvent("onPlayerPlaceEnter", playerid, idx);
        } else {
            if (!place.state) continue;

            // player was inside
            // now hes exiting
            place.state = false;
            triggerServerEvent("onPlayerPlaceExit", playerid, idx);
        }
    }
}
