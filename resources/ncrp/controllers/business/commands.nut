acmd("biz", "create", function(playerid, type = 0) {
    local pos = getPlayerPosition(playerid);
    local id  = createBusiness(pos[0], pos[1], pos[2], "Default", type.tointeger());
    msg(playerid, "You've created business # " + id);
});

acmd("biz", ["set", "name"], function(playerid, id, ...) {
    if (setBusinessName(id.tointeger(), concat(vargv))) {
        msg(playerid, "You've set name of business to " + concat(vargv));
    } else {
        msg(playerid, "No business found by id " + id);
    }
});

acmd("biz", ["set", "price"], function(playerid, id, amount) {
    if (setBusinessPrice(id.tointeger(), amount)) {
        msg(playerid, "You've set type of business to " + amount);
    } else {
        msg(playerid, "No business found by id " + id);
    }
});

acmd("biz", ["set", "type"], function(playerid, id, type) {
    if (setBusinessType(id.tointeger(), type)) {
        msg(playerid, "You've set type of business to " + type);
    } else {
        msg(playerid, "No business found by id " + id);
    }
});

acmd("biz", ["set", "income"], function(playerid, id, amount) {
    if (setBusinessIncome(id.tointeger(), amount)) {
        msg(playerid, "You've set income of business to " + amount);
    } else {
        msg(playerid, "No business found by id " + id);
    }
});

acmd("biz", ["set", "owner"], function(playerid, id, ownerid) {
    if (setBusinessOwner(id.tointeger(), ownerid.tointeger())) {
        msg(playerid, "You've set income of business to " + ownerid);
    } else {
        msg(playerid, "No business found by id " + getPlayerName(id));
    }
});

acmd("bizc", function(playerid, type, price, income, ...) {
    local pos = getPlayerPosition(playerid);
    local id  = createBusiness(pos[0], pos[1], pos[2], "Default", type.tointeger());
    setBusinessName(id.tointeger(), concat(vargv));
    setBusinessPrice(id.tointeger(), price.tofloat());
    setBusinessIncome(id.tointeger(), income.tofloat());
    msg(playerid, "You've created business # " + id);
});

cmd("business", "buy", function(playerid) {
    local bizid = getBusinessNearPlayer(playerid);

    if (bizid == null) {
        return msg(playerid, "business.error.faraway", CL_ERROR);
    }

    if (getBusinessOwner(bizid) != "") {
        return msg(playerid, "business.error.owned", CL_ERROR);
    }

    if (getBusinessPrice(bizid) == false || !canMoneyBeSubstracted(playerid, getBusinessPrice(bizid))) {
        return msg(playerid, "business.error.cantbuy", CL_ERROR);
    }

    subMoneyToPlayer(playerid, getBusinessPrice(bizid));
    setBusinessOwner(bizid, getPlayerName(playerid));

    msg(playerid, "business.purchase.success", [getBusinessName(bizid)], CL_SUCCESS);
});
