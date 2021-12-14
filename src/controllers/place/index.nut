// local placeIterator = 0;
local areaRegister = {};

event("native:onPlayerPlaceEnter", function(playerid, placeid) {
    if (!isPlayerLoaded(playerid)) {
        return;
    }

    if (!(placeid in areaRegister)) {
        return;
    }

    trigger("onPlayerPlaceEnter", playerid, areaRegister[placeid].name);
});

event("native:onPlayerPlaceExit", function(playerid, placeid) {
    if (!isPlayerLoaded(playerid)) {
        return;
    }

    if (!(placeid in areaRegister)) {
        return;
    }

    trigger("onPlayerPlaceExit", playerid, areaRegister[placeid].name);
});

event("onServerPlayerStarted", function(playerid) {
    foreach (idx, obj in areaRegister) {
        if (obj.private == false || obj.private == getPlayerName(playerid)) {
            if(obj.type == "place") {
                // dbg("sending place with", idx, idx, obj.a.x, obj.a.y, obj.b.x, obj.b.y);
                trigger(playerid, "onServerPlaceAdded", idx, obj.type, obj.a.x, obj.a.y, obj.b.x, obj.b.y);
            } else {
                trigger(playerid, "onServerPolygonAdded", idx, obj.type, JSONEncoder.encode(obj.points));
            }
        }
    }
});


/**
 * Create new place
 * @param  {String} name
 * @param  {Float} x1
 * @param  {Float} y1
 * @param  {Float} x2
 * @param  {Float} y2
 * @return {String}
 */
function createPlace(name, x1, y1, x2, y2) {
    local id = md5(name);

    if (id in areaRegister) {
        throw "createPlace: this name is already taken: " + name;
    }

    areaRegister[id] <- { private = false, type = "place", name = name, a = { x = x1.tofloat(), y = y1.tofloat() },  b = { x = x2.tofloat(), y = y2.tofloat() }};

    if ("players" in getroottable()) {
        local obj = areaRegister[id];

        players.each(function(playerid) {
            trigger(playerid, "onServerPlaceAdded", id, obj.type, obj.a.x, obj.a.y, obj.b.x, obj.b.y);
        });
    }

    return name;
}

/**
 * Create new private place
 * @param  {Integer} playerid
 * @param  {String} name
 * @param  {Float} x1
 * @param  {Float} y1
 * @param  {Float} x2
 * @param  {Float} y2
 * @return {String}
 */
function createPrivatePlace(playerid, name, x1, y1, x2, y2) {
    local id = md5(name + "_" + getPlayerName(playerid));

    if (id in areaRegister) {
        throw "createPlace: this name is already taken: " + name;
    }

    areaRegister[id] <- { private = getPlayerName(playerid), type = "place", name = name, a = { x = x1.tofloat(), y = y1.tofloat() },  b = { x = x2.tofloat(), y = y2.tofloat() }};
    local obj = areaRegister[id];
    trigger(playerid, "onServerPlaceAdded", id, obj.type, obj.a.x, obj.a.y, obj.b.x, obj.b.y);

    return name;
}

/**
 * Create new place
 * @param  {String} name
 * @param  {Float} x1
 * @param  {Float} y1
 * @param  {Float} x2
 * @param  {Float} y2
 * @return {String}
 */
function createPolygon(name, points) {
    local id = md5(name);

    if (id in areaRegister) {
        throw "createPlace: this name is already taken: " + name;
    }

    areaRegister[id] <- {
        private = false,
        type = "polygon",
        name = name,
        points = points.map(function(point) {
            return [point[0].tofloat(), point[1].tofloat()];
        })
    };

    if ("players" in getroottable()) {
        local obj = areaRegister[id];

        players.each(function(playerid) {
            trigger(playerid, "onServerPolygonAdded", id, obj.type, JSONEncoder.encode(obj.points));
        });
    }

    return name;
}

/**
 * Remove created player
 * @param  {String} name
 * @return {Boolean}
 */
function removePlace(name) {
    local id = md5(name);

    if (!(id in areaRegister)) {
        return dbg("trying to remove non-exiting place: " + place);
    }

    if ("players" in getroottable()) {
        players.each(function(playerid) {
            trigger(playerid, "onServerPlaceRemoved", id);
        });
    }

    delete areaRegister[id];
    return true;
}

/**
 * Remove created player
 * @param  {String} name
 * @return {Boolean}
 */
function removePrivatePlace(playerid, name) {
    local id = md5(name + "_" + getPlayerName(playerid));

    if (!(id in areaRegister)) {
        return dbg("trying to remove non-exiting place: " + place);
    }

    trigger(playerid, "onServerPlaceRemoved", id);

    delete areaRegister[id];
    return true;
}

/**
 * Check if coords are inside place
 * @param  {String} name
 * @param  {Float} x
 * @param  {Float} y
 * @return {Boolean}
 */
function isInArea(name, x, y) {
    local id = md5(name);

    if (!(id in areaRegister)) {
        return false;
    }

    local place = areaRegister[id];
    x = x.tofloat();
    y = y.tofloat();

    return (
        ((place.a.x < x && x < place.b.x) || (place.a.x > x && x > place.b.x)) &&
        ((place.a.y < y && y < place.b.y) || (place.a.y > y && y > place.b.y))
    );
}

function isInPrivatePlace(playerid, name, x, y) {
    local id = md5(name + "_" + getPlayerName(playerid));

    if (!(id in areaRegister)) {
        return false;
    }

    local place = areaRegister[id];
    x = x.tofloat();
    y = y.tofloat();

    return (
        ((place.a.x < x && x < place.b.x) || (place.a.x > x && x > place.b.x)) &&
        ((place.a.y < y && y < place.b.y) || (place.a.y > y && y > place.b.y))
    );
}

/**
 * Check if coords are inside place
 * @param  {String} name
 * @param  {Float} x
 * @param  {Float} y
 * @return {Boolean}
 */
function isInPolygon(name, x, y) {
    local id = md5(name);

    if (!(id in areaRegister)) {
        return false;
    }

    local polygon = areaRegister[id].points;
    x = x.tofloat();
    y = y.tofloat();

    local npol = polygon.len();
    local j = npol - 1;
    local c = 0;
    for (local i = 0; i < npol; i++) {
      if (
        ((polygon[i][1] <= y && y < polygon[j][1]) ||
          (polygon[j][1] <= y && y < polygon[i][1])) &&
        x >
          ((polygon[j][0] - polygon[i][0]) * (y - polygon[i][1])) /
            (polygon[j][1] - polygon[i][1]) +
            polygon[i][0]
      ) {
        c = !c;
      }
      j = i;
    }
    return !!c;
}

function isInArea(name, x, y) {
    local id = md5(name);

    if (!(id in areaRegister)) {
        return false;
    }

    local area = areaRegister[id];

    if(area == "place") {
        return isInArea(name, x, y)
    } else if(area == "polygon") {
        return isInPolygon(name, x, y)
    }
}

// local temp = {};
// acmd("a", function(playerid) {
//     if (!(playerid in temp)) {
//         temp[playerid] <- []
//     }
// });

acmd("placedbg", function(playerid) {
    trigger(playerid, "onDebugToggle");
});

acmd("addline", function(playerid) {
    trigger(playerid, "onServerLineAdded");
});


// createPlace("test1", -612.941, 454.184, -560.539, 440.482);
// createPlace("test2", -576.303, 444.865, -579.186, 449.768);

// event("onPlayerPlaceEnter", function(playerid, place) {
//     msg(playerid, "you've entered " + place, CL_SUCCESS);
// });

// event("onPlayerPlaceExit", function(playerid, place) {
//     msg(playerid, "you've exited " + place, CL_ERROR);
// });

function isVehicleInPlace(vehicleid, name) {
    local pos = getVehiclePosition(vehicleid);
    return isInArea(name, pos[0], pos[1]);
}

function isVehicleInPrivatePlace(vehicleid, playerid, name) {
    local pos = getVehiclePosition(vehicleid);
    return isInPrivatePlace(playerid, name, pos[0], pos[1]);
}

function isPlaceExists(name) {
    return md5(name) in areaRegister;
}

function isPrivatePlaceExists(name) {
    return md5(name + "_" + getPlayerName(playerid)) in areaRegister;
}
