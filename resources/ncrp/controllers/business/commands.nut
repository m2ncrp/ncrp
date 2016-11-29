acmd("business", "create", function(playerid, type = 0) {
    local pos = getPlayerPosition(playerid);
    local id  = createBusiness(pos[0], pos[1], pos[2], "Default", type.tointeger());
    msg(playerid, "You've created business # " + id);
});

acmd("business", ["set", "name"], function(playerid, id, ...) {
    if (setBusinessName(id.tointeger(), concat(vargv))) {
        msg(playerid, "You've set name of business to " + concat(vargv));
    } else {
        msg(playerid, "No business found by id " + id);
    }
});

acmd("business", ["set", "price"], function(playerid, id, amount) {
    if (setBusinessPrice(id.tointeger(), amount)) {
        msg(playerid, "You've set type of business to " + amount);
    } else {
        msg(playerid, "No business found by id " + id);
    }
});

acmd("business", ["set", "type"], function(playerid, id, type) {
    if (setBusinessType(id.tointeger(), type)) {
        msg(playerid, "You've set type of business to " + type);
    } else {
        msg(playerid, "No business found by id " + id);
    }
});

acmd("business", ["set", "income"], function(playerid, id, amount) {
    if (setBusinessIncome(id.tointeger(), amount)) {
        msg(playerid, "You've set income of business to " + amount);
    } else {
        msg(playerid, "No business found by id " + id);
    }
});

acmd("business", ["set", "owner"], function(playerid, id, ownerid) {
    if (setBusinessOwner(id.tointeger(), ownerid.tointeger())) {
        msg(playerid, "You've set income of business to " + ownerid);
    } else {
        msg(playerid, "No business found by id " + getPlayerName(id));
    }
});

cmd("business", "buy", function(playerid, a = 0, b = 0) {
    msg(playerid, "business.error.cantbuy", CL_WARNING);
});
