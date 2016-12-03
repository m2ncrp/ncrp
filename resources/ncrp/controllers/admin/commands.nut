acmd(["admin", "adm", "a"], function(playerid, ...) {
    return sendPlayerMessageToAll("[ADMIN] " + concat(vargv), CL_MEDIUMPURPLE.r, CL_MEDIUMPURPLE.g, CL_MEDIUMPURPLE.b);
});

acmd("test1", function(playerid, number = 100) {
    local pos = getPlayerPositionObj(playerid);
    local id;
    for (local i = 0; i < number.tofloat(); i++) {
        id = create3DText(pos.x + i, pos.y + i, pos.z, "A A", CL_MEDIUMPURPLE, 10000.0);
    }
    msg(playerid, format("created #%s texts", id));
});
