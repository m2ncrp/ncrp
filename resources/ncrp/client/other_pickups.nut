addEventHandler("loadPickups", function () {
    log("load " + executeLua("game.sds:ActivateStreamMapLine(\"marker_load\")"));
});

addEventHandler("createPickup", function (name, x, y, z) {
    executeLua(format("DelayBuffer:Insert(function(l_5_0) CommandBuffer:Insert(l_6_0,{function(l_3_0) icon = game.entitywrapper:GetEntityByName(\"%s\") icon:SetPos(Math:newVector(%f, %f, %f)) icon:Activate() end}) end,{},14,0,false)", name, x.tofloat(), y.tofloat(), z.tofloat()));
});

addEventHandler("rotatePickup", function (name) {
    log("" + executeLua(format("DelayBuffer:Insert(function(l_5_0) CommandBuffer:Insert(l_6_0,{function(l_3_0) rot=Math:newMatrix() rot:setRotEuler(0,0,0.05) icon = game.entitywrapper:GetEntityByName(\"%s\") icon:SetDir(icon:GetDir()*rot) end}) end,{},14,0,false)", name)));
});

addEventHandler("destroyPickup", function (name) {
    executeLua(format("DelayBuffer:Insert(function(l_5_0) CommandBuffer:Insert(l_6_0,{function(l_3_0) icon = game.entitywrapper:GetEntityByName(\"%s\") icon:Deactivate() end}) end,{},14,0,false)", name));
});

addEventHandler("stopPickup", function (name) {
    log("stop pickup")
    executeLua(format("DelayBuffer:Insert(function(l_5_0) CommandBuffer:Insert(l_6_0,{function(l_3_0) icon = game.entitywrapper:GetEntityByName(\"%s\") rot=Math:newMatrix() rot:setRotEuler(0,0,-0.05) icon:SetDir(icon:GetDir()*rot) end}) end,{},14,0,false)", name));
});

addEventHandler("movePickup", function (name, x, y, z) {
    executeLua(format("game.entitywrapper:GetEntityByName(\"%s\"):SetPos(Math:newVector(%f, %f, %f))", name, x.tofloat(), y.tofloat(), z.tofloat()));
});

addEventHandler("hPickup", function (name) {
    log("stop pickup")
    executeLua(format("DelayBuffer:Insert(function(l_5_0) CommandBuffer:Insert(l_6_0,{function(l_3_0) icon = game.entitywrapper:GetEntityByName(\"%s\") rot=Math:newMatrix() rot:setRotEuler(0,0,-0.05) icon:SetDir(icon:GetDir()*rot) end}) end,{},14,0,false)", name));
});

/*
    Math:Random
    Math:newMatrix
    Math:newQuat
    Math:newTransform
    Math:newVector
*/
