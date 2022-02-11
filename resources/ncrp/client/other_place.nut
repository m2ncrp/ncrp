local DEBUG = false;
local placeRegistry = {};
local linesRegistry = {};
local ticker = null;
local buffer = [];
local lines = [];

addEventHandler("onServerPlaceAdded", function(id, type, x1, y1, x2, y2, z = null, height = null) {
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
            z = z,
            height = height,
            type = type,
            state = false
        };
    }
});

addEventHandler("onServerPolygonAdded", function(id, type, points, z = null, height = null) {
    local points = compilestring.call(getroottable(), format("return %s", points))();
    if (!(id in placeRegistry)) {
        placeRegistry[id] <- {
            points = points.map(function(point) {
                return { x = point[0], y = point[1] };
            }),
            z = z,
            height = height,
            type = type,
            state = false
        };
    }
});

addEventHandler("onServerLineQueueAdded", function() {
    local pos = getPlayerPosition(getLocalPlayer());
    lines.push({ x = pos[0], y = pos[1], z = pos[2] });
});

addEventHandler("onServerLineAdded", function(id, x1, y1, z1, x2, y2, z2) {
    if (!(id in linesRegistry)) {
        linesRegistry[id] <- {
            points = {
                a = { x = x1, y = y1, z = z1 },
                b = { x = x2, y = y2, z = z2 },
            },
        };
    }
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

    // draw queue lines
    for (local i = 0; i < lines.len(); i++) {
        if (i == 0) continue;

        local prv = lines[i-1];
        local cur = lines[i];

        dxDrawLineWorld(prv.x, prv.y, prv.z, cur.x, cur.y, cur.z, 0xFFFFFFFF);
    }

    // local data = clone(buffer);
    local localPos;
    if (isPlayerInVehicle(getLocalPlayer())) {
        localPos = getVehiclePosition(getPlayerVehicle(getLocalPlayer()));
    } else {
        localPos = getPlayerPosition(getLocalPlayer());
    }

    if (typeof(localPos) != "array") return;

    // draw lines
    foreach (id, line in linesRegistry) {

        local fDis = pow(line.points.a.x - localPos[0], 2) + pow(line.points.a.y - localPos[1], 2);

        if (fDis > 10000) continue;

        dxDrawLineWorld(line.points.a.x, line.points.a.y, line.points.a.z, line.points.b.x, line.points.b.y, line.points.b.z, 0xFFFFFFFF);
    }

    if (!DEBUG) return;

    // draw places
    foreach (id, place in placeRegistry) {

        local points = place.points;

        local fDistance = pow(points[0].x - localPos[0], 2) + pow(points[0].y - localPos[1], 2);

        if (fDistance > 22500) continue;

        local z = (place.z != null) ? place.z : getPlayerPosition(getLocalPlayer())[2];
        local color = 0xFFFF0000;
        if (place.state) color = 0xFF00FF00;

        local len = points.len();
        for (local i = 1; i < len; i++) {
            dxDrawLineWorld(points[i-1].x, points[i-1].y, z, points[i].x, points[i].y, z, color);

            if(place.height != null) {
                // upper side
                dxDrawLineWorld(points[i-1].x, points[i-1].y, z + place.height, points[i].x, points[i].y, z + place.height, color);

                // ribs
                dxDrawLineWorld(points[i].x, points[i].y, z, points[i].x, points[i].y, z + place.height, color);
            }

        }
        // line from zero point to last point
        dxDrawLineWorld(points[0].x, points[0].y, z, points[len-1].x, points[len-1].y, z, color);

        if(place.height != null) {
            // upper side
            dxDrawLineWorld(points[0].x, points[0].y, z + place.height, points[len-1].x, points[len-1].y, z + place.height, color);

            // zero point rib
            dxDrawLineWorld(points[0].x, points[0].y, z, points[0].x, points[0].y, z + place.height, color);
        }
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

addEventHandler("onServerLineRemoved", function(id) {
    if (id in linesRegistry) {
        // if (placeRegistry[id].state) {
        //     triggerServerEvent("onPlayerAreaLeave", getLocalPlayer(), id);
        // }

        delete linesRegistry[id];
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

function isInPlace(points, x, y, z, pointsZ, height) {
    return ((points[0].x < x && x < points[2].x) || (points[0].x > x && x > points[2].x)) &&
            ((points[0].y < y && y < points[2].y) || (points[0].y > y && y > points[2].y)) &&
            (pointsZ == null ? true : ((z > pointsZ) && (z < (pointsZ + height))))
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
    local pos;
    if (isPlayerInVehicle(getLocalPlayer())) {
        pos = getVehiclePosition(getPlayerVehicle(getLocalPlayer()));
    } else {
        pos = getPlayerPosition(getLocalPlayer());
    }
    local x = pos[0];
    local y = pos[1];
    local z = pos[2];

    foreach (idx, place in placeRegistry) {

        // log("inside place with id " + idx);
        // log(format("x1: %f y1: %f;  x2: %f y2: %f;", place.a.x, place.a.y, place.b.x, place.b.y));
        // log(x + " " + y + "\n\n");

        local isInArea = place.type == "place" ? isInPlace(place.points, x, y, z, place.z, place.height) : isInPolygon(place.points, x, y);

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
