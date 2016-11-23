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
    local obj = {id = -1, x = x, y = y, r = r, library = library, icon = icon, visible = false};
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
