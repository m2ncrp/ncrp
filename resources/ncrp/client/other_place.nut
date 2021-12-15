local DEBUG = false;
local placeRegistry = {};
local ticker = null;
local buffer = [];
local lines = [];

addEventHandler("onServerPlaceAdded", function(id, type, x1, y1, x2, y2) {
    // log("registering place with id " + id);
    // log(format("x1: %f y1: %f;  x2: %f y2: %f;", x1, y1, x2, y2));

    if (!(id in placeRegistry)) {
        placeRegistry[id] <- {
            points = [
                { x = x1, y = y1 },
                { x = x2, y = y1 },
                { x = x2, y = y2 },
                { x = x1, y = y2 },
            ],
            type = type,
            state = false
        };
    }
});

addEventHandler("onServerPolygonAdded", function(id, type, points) {
    local points = compilestring.call(getroottable(), format("return %s", points))();
    if (!(id in placeRegistry)) {
        placeRegistry[id] <- {
            points = points.map(function(point) {
                return { x = point[0], y = point[1] };
            }),
            type = type,
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
        local points = place.points;
        local color = 0xFFFF0000;
        if (place.state) color = 0xFF00FF00;

        local len = points.len();
        for (local i = 1; i < len; i++) {
            dxDrawLineWorld(points[i-1].x, points[i-1].y, z, points[i].x, points[i].y, z, color);
        }
        // line from zero point to last point
        dxDrawLineWorld(points[0].x, points[0].y, z, points[len-1].x, points[len-1].y, z, color);
    }
});

addEventHandler("onServerAreaRemoved", function(id) {
    if (id in placeRegistry) {
        // if (placeRegistry[id].state) {
        //     triggerServerEvent("onPlayerAreaLeave", getLocalPlayer(), id);
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

function isInPlace(points, x, y) {
    return ((points[0].x < x && x < points[2].x) || (points[0].x > x && x > points[2].x)) &&
            ((points[0].y < y && y < points[2].y) || (points[0].y > y && y > points[2].y))
}

function isInPolygon(polygon, x, y) {
    local npol = polygon.len();
    local j = npol - 1;
    local c = 0;
    for (local i = 0; i < npol; i++) {
      if (
        ((polygon[i].y <= y && y < polygon[j].y) ||
          (polygon[j].y <= y && y < polygon[i].y)) &&
        x >
          ((polygon[j].x - polygon[i].x) * (y - polygon[i].y)) /
            (polygon[j].y - polygon[i].y) +
            polygon[i].x
      ) {
        c = !c;
      }
      j = i;
    }
    return c;
}

function onPlayerTick() {
    local pos = getPlayerPosition(getLocalPlayer());
    local x = pos[0];
    local y = pos[1];

    foreach (idx, place in placeRegistry) {

        // log("inside place with id " + idx);
        // log(format("x1: %f y1: %f;  x2: %f y2: %f;", place.a.x, place.a.y, place.b.x, place.b.y));
        // log(x + " " + y + "\n\n");
        local isInArea = place.type == "place" ? isInPlace(place.points, x, y) : isInPolygon(place.points, x, y);

        if (isInArea) {

            if (place.state) continue;

            // player was outside
            // now he entering
            place.state = true;
            triggerServerEvent("onPlayerAreaEnter", idx);
        } else {
            if (!place.state) continue;

            // player was inside
            // now hes exiting
            place.state = false;
            triggerServerEvent("onPlayerAreaLeave", idx);
        }
    }
}

addEventHandler("onServerClientStarted", function(version) {
    ticker = timer(onPlayerTick, 100, -1);
});
