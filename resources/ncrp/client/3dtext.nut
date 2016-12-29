local _3Dtext_vectors = {};
local _3Dtext_objects = {};

local ticker = null;
local loadedTexts  = {};
local visibleTexts = {};

addEventHandler("onClientFramePreRender", function() {
    foreach (idx, obj in visibleTexts) {
        obj["coords"] <- getScreenFromWorld(obj.pos.x, obj.pos.y, obj.pos.z + 1.0);
    }
});

addEventHandler("onClientFrameRender", function(aftergui) {
    if (aftergui) return;

    foreach (idx, obj in visibleTexts) {
        if (!("coords" in obj)) continue;

        local coords = obj.coords;

        // hacky check
        if (coords[2] < 1) {
            dxDrawText(obj.name, coords[0] - obj.dims[0] * 0.5, coords[1], obj.color, false, "tahoma-bold");
        }
    }
});

addEventHandler("onServerClientStarted", function(version) {
    ticker = timer(function() {

        foreach (idx, obj in loadedTexts) {
            local pos = obj.pos;

            // get local position
            local lclPos;
            if (isPlayerInVehicle(getLocalPlayer())) {
                lclPos = getVehiclePosition(getPlayerVehicle(getLocalPlayer()));
            } else {
                lclPos = getPlayerPosition(getLocalPlayer());
            }

            if (typeof lclPos != "array") return;

            // get dist^2
            local distance = pow(pos.x - lclPos[0], 2) + pow(pos.y - lclPos[1], 2) + pow(pos.z - lclPos[2], 2);
            local limit = pow(obj.distance, 2);

            // log("checking dist with " + distance + " and limit " + limit);

            if (obj.uid in visibleTexts) {
                if (limit > distance) continue;

                // text was visible, now remove it
                delete visibleTexts[obj.uid];
            } else {
                if (limit < distance) continue;

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
            z = z.tofloat()
        },
        color = color,
        distance = d.tofloat()
    };

    loadedTexts[obj.uid] <- obj;
});

addEventHandler("onServer3DTextDelete", function(uid) {
    if (uid in loadedTexts) {
        delete loadedTexts[uid];
    }

    if (uid in visibleTexts) {
        delete visibleTexts[uid];
    }
});
