local _3Dtext_vectors = {};
local _3Dtext_objects = {};

local ticker = null;
local loadedTexts  = {};
local visibleTexts = {};

addEventHandler("onClientFramePreRender", function() {
    // foreach (idx, obj in visibleTexts) {

    foreach (i, obj in visibleTexts) {
        if (!(i in visibleTexts)) continue;
        local obj = visibleTexts[i];

        if (!obj || typeof obj != "table") continue;
        if (obj.deleted) continue;

        obj["coords"] <- getScreenFromWorld(obj.pos.x, obj.pos.y, obj.pos.z + 1.0);
    }
});

addEventHandler("onClientFrameRender", function(aftergui) {
    if (aftergui) return;

    // foreach (idx, obj in visibleTexts) {

    foreach (i, obj in visibleTexts) {
        if (!(i in visibleTexts)) continue;

        local obj = visibleTexts[i];

        if (!obj || typeof obj != "table") continue;
        if (obj.deleted) continue;
        if (!("coords" in obj)) continue;

        local coords = obj.coords;

        if (!coords || !coords.len() || !(2 in coords)) continue;

        // hacky check
        if (coords[2].tofloat() < 1) {
            dxDrawText(obj.name, coords[0] - obj.dims[0] * 0.5, coords[1], obj.color, false, "tahoma-bold");
        }
    }
});

addEventHandler("onServerClientStarted", function(version) {
    ticker = timer(function() {

        local ltSize = loadedTexts.len();
        foreach (i, obj in loadedTexts) {
            if (!(i in loadedTexts)) continue;

            local obj = loadedTexts[i];

            if (!obj || typeof obj != "table") continue;
            if (obj.deleted) continue;

            local pos = obj.pos;

            // get local position
            local lclPos;
            if (isPlayerInVehicle(getLocalPlayer())) {
                lclPos = getVehiclePosition(getPlayerVehicle(getLocalPlayer()));
            } else {
                lclPos = getPlayerPosition(getLocalPlayer());
            }

            if (!lclPos || !lclPos.len() || !(2 in lclPos)) continue;
            if (typeof lclPos != "array") continue;

            // get dist^2
            local zDistance = pow(pos.x - lclPos[0], 2) + pow(pos.y - lclPos[1], 2) + pow(pos.z - lclPos[2], 2);
            local zLimit = pow(obj.distance, 2);

            if (!zLimit || !zDistance) continue;

            // log("checking dist with " + zDistance + " and limit " + zLimit);

            if (obj.uid in visibleTexts) {
                if (zLimit > zDistance) continue;

                // text was visible, now remove it
                delete visibleTexts[obj.uid];
            } else {
                if (zLimit < zDistance) continue;

                if (!("dims" in obj)) {
                    obj["dims"] <- dxGetTextDimensions(obj.name, 1.0, "tahoma-bold");
                }

                // text has become visible
                visibleTexts[obj.uid] <- obj;
            }
        }

    }, 100, -1);
});

addEventHandler("onServer3DTextAdd", function(uid, x, y, z, text, color, d) {
    local obj = {
        uid = uid,
        name = text.tostring(),
        pos = {
            x = x.tofloat(),
            y = y.tofloat(),
            z = z.tofloat(),
        },
        color    = color,
        distance = d.tofloat(),
        deleted  = false
    };

    loadedTexts[obj.uid] <- obj;
});

addEventHandler("onServer3DTextDelete", function(uid) {
    if (uid in loadedTexts) {
        loadedTexts[uid].deleted <- true;
    }
});
