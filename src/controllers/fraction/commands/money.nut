/**
 * List amount of money in the current fraction
 */
cmd("f", "money", function(playerid) {
    local fracs = fractions.getManaged(playerid, FRACTION_MONEY_PERMISSION);

    if (!fracs.len()) {
        return msg(playerid, "fraction.money.notaccess", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    msg(playerid, "fraction.money.amount", [ fraction.title, fraction.money ], CL_INFO);
});

/**
 * Add money to fraction from players account
 * @param  {Integer} playerid
 * @param  {Float} amount
 */
cmd("f", ["money", "add"], function(playerid, amount = 0.0) {
    local fracs = fractions.getContaining(playerid);
    amount = amount.tofloat();

    if (!fracs.len()) {
        return msg(playerid, "fraction.money.notaccess", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    if (!canMoneyBeSubstracted(playerid, amount)) {
        return msg(playerid, "fraction.money.notenough", CL_ERROR);
    }

    subMoneyToPlayer(playerid, amount);

    fraction.money = fraction.money + amount;
    fraction.save();

    msg(playerid, "fraction.money.add", [ amount, fraction.title ], CL_SUCCESS);

    if (fraction[playerid].level <= FRACTION_MONEY_PERMISSION) {
        msg(playerid, "fraction.money.amount", [ fraction.title, fraction.money ], CL_INFO);
    }
});

/**
 * Subtract from fraction to players account
 * @param  {Integer} playerid
 * @param  {Float} amount
 */
cmd("f", ["money", "sub"], function(playerid, amount = 0.0) {
    local fracs = fractions.getManaged(playerid, FRACTION_MONEY_PERMISSION);
    amount = amount.tofloat();

    if (!fracs.len()) {
        return msg(playerid, "fraction.money.notaccess", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    if (fraction.money - amount < 0.0) {
        return msg(playerid, "fraction.money.cannotsubstract", CL_ERROR);
    }

    fraction.money = fraction.money - amount;
    fraction.save();

    addMoneyToPlayer(playerid, amount);

    msg(playerid, "fraction.money.substract", [ amount ], CL_SUCCESS);

    if (fraction[playerid].level <= FRACTION_MONEY_PERMISSION) {
        msg(playerid, "fraction.money.amount", [ fraction.title, fraction.money ], CL_INFO);
    }
});
