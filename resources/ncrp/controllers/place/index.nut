// local placeIterator = 0;
local placeRegister = {};

event("native:onPlayerPlaceEnter", function(playerid, placeid) {
    if (!isPlayerLoaded(playerid)) {
        return;
    }

    if (!(placeid in placeRegister)) {
        return;
    }

    trigger("onPlayerPlaceEnter", playerid, placeRegister[placeid].name);
});

event("native:onPlayerPlaceExit", function(playerid, placeid) {
    if (!isPlayerLoaded(playerid)) {
        return;
    }

    if (!(placeid in placeRegister)) {
        return;
    }

    trigger("onPlayerPlaceExit", playerid, placeRegister[placeid].name);
});

event("onServerPlayerStarted", function(playerid) {
    foreach (idx, obj in placeRegister) {
        trigger(playerid, "onServerPlaceAdded", idx, obj.a.x, obj.a.y, obj.b.x, obj.b.y);
        dbg("sending place with", idx, idx, obj.a.x, obj.a.y, obj.b.x, obj.b.y);
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

    if (id in placeRegister) {
        throw "createPlace: this name is already taken: " + name;
    }

    placeRegister[id] <- { name = name, a = { x = x1.tofloat(), y = y1.tofloat() },  b = { x = x2.tofloat(), y = y2.tofloat() }};

    if ("players" in getroottable()) {
        local obj = placeRegister[id];

        players.each(function(playerid) {
            trigger(playerid, "onServerPlaceAdded", id, obj.a.x, obj.a.y, obj.b.x, obj.b.y);
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

    if (!(id in placeRegister)) {
        return dbg("trying to remove non-exiting place: " + place);
    }

    if ("players" in getroottable()) {
        players.each(function(playerid) {
            trigger(playerid, "onServerPlaceRemoved", id);
        });
    }

    delete placeRegister[id];
    return true;
}

/**
 * Check if coords are inside place
 * @param  {String} name
 * @param  {Float} x
 * @param  {Float} y
 * @return {Booelan}
 */
function isInPlace(name, x, y) {
    local id = md5(name);

    if (!(id in placeRegister)) {
        return false;
    }

    local place = placeRegister[id];
    x = x.tofloat();
    y = y.tofloat();

    return (
        ((place.a.x < x && x < place.b.x) || (place.a.x > x && x > place.b.x)) &&
        ((place.a.y < y && y < place.b.y) || (place.a.y > y && y > place.b.y))
    );
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
    return isInPlace(name, pos[0], pos[1]);
}
