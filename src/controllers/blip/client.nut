local ticker = null;
local _blip_objects = {};
local _blip_cooldown_ticks = 0;

function onBlipTimer() {
    foreach(blip in _blip_objects) {
        local pos = getPlayerPosition(getLocalPlayer());
        local dist = getDistanceBetweenPoints2D(pos[0], pos[1], blip.x, blip.y);
        if (dist <= blip.r.tofloat() || blip.r.tointeger() == -1) {
            if (!blip.visible) {
                blip.id = createBlip(blip.x.tofloat(), blip.y.tofloat(), blip.library, blip.icon);
                blip.visible = true;
            }
        } else {
            if (blip.visible) {
                blip.visible = false;
                destroyBlip(blip.id);
                blip.id = -1;
            }
        }
    }

    return true;
}

addEventHandler("onServerBlipAdd", function(uid, x, y, r, library, icon) {
    local obj = {id = -1, x = x.tofloat(), y = y.tofloat(), r = r.tofloat(), library = library, icon = icon, visible = false};
    _blip_objects[uid] <- obj;

    if (!ticker) {
        ticker = timer(onBlipTimer, 500, -1);
    }
});

addEventHandler("onServerBlipDelete", function(uid) {
    if (uid in _blip_objects) {
        if (_blip_objects[uid].id != -1) {
            destroyBlip(_blip_objects[uid].id);
        }
        delete _blip_objects[uid];
    }
});

/**
 * Admin blips
 */

local blipP = [];
local blipV = [];

addEventHandler("onServerToggleBlip", function(type) {
    if (type == "p") {
        if (!blipP.len()) {
            // no blips - create
            foreach (idx, value in getPlayers()) {
                local pos  = getPlayerPosition(idx);
                local blip = createBlip(pos[0], pos[1], 0, 1);
                attachBlipToPlayer(blip, idx);
                blipP.push(blip);
            }
        } else {
            // remove all blips
            foreach (idx, value in blipP) {
                destroyBlip(value);
            }
            blipP.clear();
        }
    } else if (type == "v") {
        if (!blipV.len()) {
            // no blips - create
            foreach (idx, value in getVehicles()) {
                local pos  = getVehiclePosition(idx);
                local blip = createBlip(pos[0], pos[1], 0, 2);
                attachBlipToVehicle(blip, idx);
                blipV.push(blip);
            }
        } else {
            // remove all blips
            foreach (idx, value in blipV) {
                destroyBlip(value);
            }
            blipV.clear();
        }
    }
});
