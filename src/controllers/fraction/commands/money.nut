/**
 * List amount of money in the current fraction
 */
cmd("f", "money", function(playerid) {
    local fracs = fractions.getManaged(playerid, FRACTION_MONEY_PERMISSION);

    if (!fracs.len()) {
        return msg(playerid, "You dont have access to that.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    msg(playerid, format("Current amount money in the fraction %s: $%.2f", fraction.title, fraction.money), CL_INFO);
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
        return msg(playerid, "You dont have access to that.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    if (!canMoneyBeSubstracted(playerid, amount)) {
        return msg(playerid, "You dont have enough money!", CL_ERROR);
    }

    subMoneyToPlayer(playerid, amount);

    fraction.money = fraction.money + amount;
    fraction.save();

    msg(playerid, format("You've successfuly added $%.2f to the fraction", amount), CL_SUCCESS);

    if (fraction[playerid].level <= FRACTION_MONEY_PERMISSION) {
        msg(playerid, format("Current money in the fraction %s: $%.2f", fraction.title, fraction.money), CL_INFO);
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
        return msg(playerid, "You dont have access to that.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    if (fraction.money - amount < 0.0) {
        return msg(playerid, "You cannot subtract more money then fraction has", CL_ERROR);
    }

    fraction.money = fraction.money - amount;
    fraction.save();

    addMoneyToPlayer(playerid, amount);

    msg(playerid, format("You've successfuly subtracted %.2f from the fraction", amount), CL_SUCCESS);

    if (fraction[playerid].level <= FRACTION_MONEY_PERMISSION) {
        msg(playerid, format("Current amount money in the fraction %s: $%.2f", fraction.title, fraction.money), CL_INFO);
    }
});
