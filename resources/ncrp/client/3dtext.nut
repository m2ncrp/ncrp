local _3Dtext_vectors = {};
local _3Dtext_objects = {};

addEventHandler("onClientFramePreRender", function() {
    foreach(i,obj in _3Dtext_objects) {
        local pos = obj.pos;
        _3Dtext_vectors[i] <- getScreenFromWorld(pos.x, pos.y, (pos.z + 1.0));
    }
});

addEventHandler("onClientFrameRender", function(post) {
    if (!post) {
        foreach(i,obj in _3Dtext_objects) {
            local pos = obj.pos;
            local lclPos = getPlayerPosition(getLocalPlayer());
            if (typeof(lclPos) != "array") return;
            local fDistance = getDistanceBetweenPoints3D(pos.x, pos.y, pos.z, lclPos[0], lclPos[1], lclPos[2]);

            if (fDistance <= 35.0 && (i in _3Dtext_vectors) && _3Dtext_vectors[i][2] < 1) {
                local dims = dxGetTextDimensions(obj.name, 1.0, "tahoma-bold");

                // dxDrawText(obj.name, (_3Dtext_vectors[i][0] - (dims[0] / 2)) + 1, _3Dtext_vectors[i][1] + 1, 0xFF000000, false, "tahoma-bold");
                dxDrawText(obj.name, (_3Dtext_vectors[i][0] - (dims[0] / 2)), _3Dtext_vectors[i][1], obj.color, false, "tahoma-bold");
            }
        }
    }
});

addEventHandler("onServer3DTextAdd", function(uid, x, y, z, text, c, s) {
    log("[debug] creating 3d text");
    local obj = {uid = uid, name = text, pos = {x = x, y = y, z = z}, color = c, shadow = s};
    _3Dtext_objects[obj.uid] <- obj;
});

addEventHandler("onServer3DTextDelete", function(uid) {
    delete _3Dtext_objects[uid];
});
