include("controllers/area/lines.nut");

local areaRegister = {};

event("native:onPlayerAreaEnter", function(playerid, placeid) {
    if (!isPlayerLoaded(playerid)) {
        return;
    }

    if (!(placeid in areaRegister)) {
        return;
    }

    trigger("onPlayerAreaEnter", playerid, areaRegister[placeid].name);
});

event("native:onPlayerAreaLeave", function(playerid, placeid) {
    if (!isPlayerLoaded(playerid)) {
        return;
    }

    if (!(placeid in areaRegister)) {
        return;
    }

    trigger("onPlayerAreaLeave", playerid, areaRegister[placeid].name);
});

event("onServerPlayerStarted", function(playerid) {
    foreach (idx, obj in areaRegister) {
        if (obj.private == false || obj.private == getPlayerName(playerid)) {
            if(obj.type == "place") {
                // dbg("sending place with", idx, idx, obj.a.x, obj.a.y, obj.b.x, obj.b.y);
                trigger(playerid, "onServerPlaceAdded", idx, obj.type, obj.a.x, obj.a.y, obj.b.x, obj.b.y, obj.z, obj.height);
            } else {
                trigger(playerid, "onServerPolygonAdded", idx, obj.type, JSONEncoder.encode(obj.points), obj.z, obj.height);
            }
        }
    }
});

function generatePrivateAreaId(name, playerid) {
    return md5(name + "_" + getPlayerName(playerid));
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
function createPlace(name, x1, y1, x2, y2, z = null, height = null) {
    local id = md5(name);

    if (id in areaRegister) {
        throw "createPlace: this name is already taken: " + name;
    }

    areaRegister[id] <- {
        private = false,
        type = "place",
        name = name,
        a = { x = x1.tofloat(), y = y1.tofloat() },
        b = { x = x2.tofloat(), y = y2.tofloat() },
        z = z,
        height = height
    };

    if ("players" in getroottable()) {
        local obj = areaRegister[id];

        players.each(function(playerid) {
            trigger(playerid, "onServerPlaceAdded", id, obj.type, obj.a.x, obj.a.y, obj.b.x, obj.b.y, obj.z, obj.height);
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
    local id = generatePrivateAreaId(name, playerid);

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
function createPolygon(name, points, z = null, height = null) {
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
        z = z,
        height = height
    };

    if ("players" in getroottable()) {
        local obj = areaRegister[id];

        players.each(function(playerid) {
            trigger(playerid, "onServerPolygonAdded", id, obj.type, JSONEncoder.encode(obj.points), obj.z, obj.height);
        });
    }

    return name;
}

/**
 * Remove created player
 * @param  {String} name
 * @return {Boolean}
 */
function removeArea(name) {
    local id = md5(name);

    if (!(id in areaRegister)) {
        return dbg("trying to remove non-exiting place: " + place);
    }

    if ("players" in getroottable()) {
        players.each(function(playerid) {
            trigger(playerid, "onServerAreaRemoved", id);
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
function removePrivateArea(playerid, name) {
    local id = generatePrivateAreaId(name, playerid);

    if (!(id in areaRegister)) {
        return dbg("trying to remove non-exiting place: " + place);
    }

    trigger(playerid, "onServerAreaRemoved", id);

    delete areaRegister[id];
    return true;
}

/* CHECKERS --------- */

function isInArea(name, x, y, z) {
    local id = md5(name);

    return _isInArea(id, x, y, z)
}

function isInPrivateArea(playerid, name, x, y, z) {
    local id = generatePrivateAreaId(name, playerid);

    return _isInArea(id, x, y, z);
}

function _isInArea(id, x, y, z) {
    if (!(id in areaRegister)) {
        return false;
    }

    local area = areaRegister[id];
    x = x.tofloat();
    y = y.tofloat();
    z = z.tofloat();

    if(area.type == "place") {
        return _isInPlace(area, x, y, z)
    } else if(area.type == "polygon") {
        return _isInPolygon(area, x, y)
    }
}

function _isInPlace(place, x, y, z = null) {
    return (
        ((place.a.x < x && x < place.b.x) || (place.a.x > x && x > place.b.x)) &&
        ((place.a.y < y && y < place.b.y) || (place.a.y > y && y > place.b.y)) &&
        (place.z == null ? true : ((z > place.z) && (z < (place.z + place.height))))
    );
}

function _isInPolygon(polygon, x, y) {
    local points = polygon.points;
    local npol = points.len();
    local j = npol - 1;
    local c = 0;
    for (local i = 0; i < npol; i++) {
      if (
        ((points[i][1] <= y && y < points[j][1]) ||
          (points[j][1] <= y && y < points[i][1])) &&
        x >
          ((points[j][0] - points[i][0]) * (y - points[i][1])) /
            (points[j][1] - points[i][1]) +
            points[i][0]
      ) {
        c = !c;
      }
      j = i;
    }
    return !!c;
}


acmd("placedbg", function(playerid) {
    trigger(playerid, "onDebugToggle");
});

acmd("addline", function(playerid) {
    trigger(playerid, "onServerLineAdded");
});


// createPlace("test1", -612.941, 454.184, -560.539, 440.482);
// createPlace("test2", -576.303, 444.865, -579.186, 449.768);

// event("onPlayerAreaEnter", function(playerid, place) {
//     msg(playerid, "you've entered " + place, CL_SUCCESS);
// });

// event("onPlayerAreaLeave", function(playerid, place) {
//     msg(playerid, "you've exited " + place, CL_ERROR);
// });

function isVehicleInArea(vehicleid, name) {
    local pos = getVehiclePosition(vehicleid);
    return isInArea(name, pos[0], pos[1], pos[2]);
}

function isVehicleInPrivateArea(vehicleid, playerid, name) {
    local pos = getVehiclePosition(vehicleid);
    return isInPrivateArea(playerid, name, pos[0], pos[1], pos[2]);
}

function isPlaceExists(name) {
    return md5(name) in areaRegister;
}

function isPrivatePlaceExists(name, playerid) {
    return generatePrivateAreaId(name, playerid) in areaRegister;
}

