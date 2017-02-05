local _3Dtext_vectors = {};
local _3Dtext_objects = {};

event("onClientFramePreRender", function() {
    foreach(i,obj in _3Dtext_objects) {
        local pos = obj.pos;
        _3Dtext_vectors[i] <- getScreenFromWorld(pos.x, pos.y, (pos.z + 1.0));
    }
});

event("onClientFrameRender", function(post) {
    if (!post) {
        foreach(i,obj in _3Dtext_objects) {
            local pos = obj.pos;
            local lclPos;
            if (isPlayerInVehicle(getLocalPlayer())) {
                lclPos = getVehiclePosition(getPlayerVehicle(getLocalPlayer()));
            } else {
                lclPos = getPlayerPosition(getLocalPlayer());
            }

            if (typeof(lclPos) != "array") return;
            local fDistance = pow(pos.x - lclPos[0], 2) + pow(pos.y - lclPos[1], 2) + pow(pos.z - lclPos[2], 2);

            if (fDistance <= pow(obj.distance, 2) && (i in _3Dtext_vectors) && _3Dtext_vectors[i][2] < 1) {
                local dims = dxGetTextDimensions(obj.name, 1.0, "tahoma-bold");

                // dxDrawText(obj.name, (_3Dtext_vectors[i][0] - (dims[0] / 2)) + 1, _3Dtext_vectors[i][1] + 1, 0xFF000000, false, "tahoma-bold");
                dxDrawText(obj.name, (_3Dtext_vectors[i][0] - (dims[0] / 2)), _3Dtext_vectors[i][1], obj.color, false, "tahoma-bold");
            }
        }
    }
});

event("onServer3DTextAdd", function(uid, x, y, z, text, color, d) {
    local obj = {
        uid = uid,
        name = text.tostring(),
        pos = {
            x = x.tofloat(),
            y = y.tofloat(),
            z = z.tofloat()
        },
        color = color.tointeger(),
        distance = d.tofloat()
    };

    _3Dtext_objects[obj.uid] <- obj;
});

event("onServer3DTextDelete", function(uid) {
    if (uid in _3Dtext_objects) {
        delete _3Dtext_objects[uid];
    }
});
