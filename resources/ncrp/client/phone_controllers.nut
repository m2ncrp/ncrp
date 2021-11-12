addEventHandler("ringPhone", function(flag) {
    executeLua(format("game.datastore:SetBool(\"PhoneBoothRinging\", %s)", flag.tostring()));
});

addEventHandler("ringPhoneStatic", function(flag, x, y, z) {
    local lua = "game.entitywrapper:GetEntityByName(\"S_PhoneGlobal1\"):SetPos(Math:newVector(%f, %f, %f))";
    executeLua(format(lua, x, y, z));
    if (flag) {
        executeLua("game.entitywrapper:GetEntityByName(\"S_PhoneGlobal1\"):Activate()");
    } else {
        executeLua("game.entitywrapper:GetEntityByName(\"S_PhoneGlobal1\"):Deactivate()");
    }
});
