local linesRegister = {};

event("onServerPlayerStarted", function(playerid) {
    foreach (idx, obj in linesRegister) {
        trigger(playerid, "onServerLineAdded", idx, obj.a.x, obj.a.y, obj.a.z, obj.b.x, obj.b.y, obj.b.z);
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
function createLine(name, x1, y1, z1, x2, y2, z2) {
    local id = md5(name);

    if (id in linesRegister) {
        throw "linesRegister: this name is already taken: " + name;
    }

    linesRegister[id] <- {
        name = name,
        a = { x = x1.tofloat(), y = y1.tofloat(), z = z1.tofloat() },
        b = { x = x2.tofloat(), y = y2.tofloat(), z = z2.tofloat() },
    };

    if ("players" in getroottable()) {
        local obj = linesRegister[id];

        players.each(function(playerid) {
            trigger(playerid, "onServerLineAdded", id, obj.a.x, obj.a.y, obj.a.z, obj.b.x, obj.b.y, obj.b.z);
        });
    }

    return name;
}

/**
 * Remove created player
 * @param  {String} name
 * @return {Boolean}
 */
function removeLine(name) {
    local id = md5(name);

    if (!(id in linesRegister)) {
        return dbg("trying to remove non-exiting line: " + place);
    }

    if ("players" in getroottable()) {
        players.each(function(playerid) {
            trigger(playerid, "onServerLineaRemoved", id);
        });
    }

    delete linesRegister[id];
    return true;
}

acmd("placedbg", function(playerid) {
    trigger(playerid, "onDebugToggle");
});

acmd("addline", function(playerid) {
    trigger(playerid, "onServerLineAdded");
});
