/**
 * List amount of money in the current fraction
 */
fmd("*", ["money.list"], "$f money", function(fraction, character) {
    msg(character.playerid, "fraction.money.amount", [ plocalize(character.playerid, fraction.title), fraction.money ], CL_INFO);
});

/**
 * Add money to fraction from players account
 * @param  {Fraction} fraction
 * @param  {Character} character
 * @param  {Float} amount
 */
fmd("*", ["money.add"], "$f money add", function(fraction, character, amount = "0") {
    amount = amount.tofloat();

    if (!canMoneyBeSubstracted(character.playerid, amount)) {
        return msg(character.playerid, "fraction.money.notenough", CL_ERROR);
    }

    subMoneyToPlayer(character.playerid, amount);

    fraction.money = fraction.money + amount;
    fraction.save();

    msg(character.playerid, "fraction.money.add", [ amount, plocalize(character.playerid, fraction.title) ], CL_SUCCESS);

    if (fraction.members.get(character).permitted("money.list")) {
        msg(character.playerid, "fraction.money.amount", [ plocalize(character.playerid, fraction.title), fraction.money ], CL_INFO);
    }
});

/**
 * Subtract from fraction to players account
 * @param  {Fraction} fraction
 * @param  {Character} character
 * @param  {Float} amount
 */
fmd("*", ["money.remove"], "$f money sub", function(fraction, character, amount = "0") {
    amount = amount.tofloat();

    if (fraction.money - amount < 0.0) {
        return msg(character.playerid, "fraction.money.cannotsubstract", CL_ERROR);
    }

    fraction.money = fraction.money - amount;
    fraction.save();

    addMoneyToPlayer(character.playerid, amount);

    msg(character.playerid, "fraction.money.substract", [ amount, plocalize(character.playerid, fraction.title) ], CL_SUCCESS);

    if (fraction.members.get(character).permitted("money.list")) {
        msg(character.playerid, "fraction.money.amount", [ plocalize(character.playerid, fraction.title), fraction.money ], CL_INFO);
    }
});
