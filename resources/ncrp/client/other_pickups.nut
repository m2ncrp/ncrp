local loadedPickups = {
    "RTR_ARROW_00": false,
}

addEventHandler("loadPickups", function () {
    log("load " + executeLua("game.sds:ActivateStreamMapLine(\"marker_load\")"));
});

addEventHandler("createPickup", function (name, x, y, z) {
    local lua = format("game.entitywrapper:GetEntityByName(\"%s\"):SetPos(Math:newVector(%f, %f, %f))", name, x.tofloat(), y.tofloat(), z.tofloat());
    log(lua);
    log("create " + executeLua(lua));
    log("" + executeLua(format("DelayBuffer:Insert(function(l_5_0) CommandBuffer:Insert(l_6_0,{function(l_3_0) rot=Math:newMatrix() rot:setRotEuler(0,0,0.05) icon = game.entitywrapper:GetEntityByName(\"%s\") icon:Activate() icon:SetDir(icon:GetDir()*-1*rot) end}) end,{},14,0,false)", name)));
    log(name + " " + loadedPickups[name]);
});

addEventHandler("destroyPickup", function (name) {
    executeLua(format("game.entitywrapper:GetEntityByName(\"%s\"):Deactivate()", name));
});

addEventHandler("movePickup", function (name, x, y, z) {
    executeLua(format("game.entitywrapper:GetEntityByName(\"%s\"):SetPos(Math:newVector(%f, %f, %f))", name, x.tofloat(), y.tofloat(), z.tofloat()));
    });
