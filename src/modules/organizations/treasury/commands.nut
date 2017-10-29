acmd(["treas"], "get", function( playerid) {
    msg(playerid, "treasury.get", getMoneyTreasury() );
});


acmd(["treas"], "add", function( playerid, amount = 0.0) {
    addMoneyToTreasury(amount);
    msg(playerid, "treasury.add", [ amount.tofloat(), getMoneyTreasury() ], CL_EUCALYPTUS );
});


acmd(["treas"], "sub", function( playerid, amount = 0.0) {
    subMoneyToTreasury(amount);
    msg(playerid, "treasury.sub", [ amount.tofloat(), getMoneyTreasury() ], CL_THUNDERBIRD );
});


/* Commands to government - HARDCODE */

// meria coords
local coords = [-122.331, -62.9116, -12.041];

// Name of governor
local govName = "Nicolas Bertone";

cmd(["treasury"], "get", function( playerid) {

    if (!isPlayerInValidPoint(playerid, coords[0], coords[1], 1.0 )) {
        return;
    }

    if (getPlayerName(playerid) != govName) {
        return;
    }

    msg(playerid, "treasury.get", getMoneyTreasury() );
});


cmd(["treasury"], "add", function( playerid, amount = 0.0) {

    if (!isPlayerInValidPoint(playerid, coords[0], coords[1], 1.0 )) {
        return;
    }

    if (getPlayerName(playerid) != govName) {
        return;
    }

    if (!canMoneyBeSubstracted(playerid, amount)) {
        return msg(playerid, "treasury.player.notenough", CL_THUNDERBIRD);
    }

    addMoneyToTreasury(amount);
    subMoneyToPlayer(playerid, amount);
    msg(playerid, "treasury.add", [ amount.tofloat(), getMoneyTreasury() ], CL_EUCALYPTUS );
});


cmd(["treasury"], "sub", function( playerid, amount = 0.0) {

    if (!isPlayerInValidPoint(playerid, coords[0], coords[1], 1.0 )) {
        return;
    }

    if (getPlayerName(playerid) != govName) {
        return;
    }

    if(amount.tofloat() > getMoneyTreasury().tofloat()) {
        return msg(playerid, "treasury.notenough", CL_THUNDERBIRD );
    }

    subMoneyToTreasury(amount);
    addMoneyToPlayer(playerid, amount);
    msg(playerid, "treasury.sub", [ amount.tofloat(), getMoneyTreasury() ], CL_THUNDERBIRD );
});




/* ------------------------------------------------------------------------------------------------------------------------------------------------------------ */
local phrases = {
    "en|treasury.get" : "Treasury: $%.2f"
    "ru|treasury.get" : "Городская казна: $%.2f"

    "en|treasury.add" : "Treasury: add $%.2f. Now: $%.2f"
    "ru|treasury.add" : "Городская казна пополнена на $%.2f. Баланс: $%.2f"

    "en|treasury.sub" : "Treasury: sub $%.2f. Now: $%.2f"
    "ru|treasury.sub" : "Городская казна уменьшена на $%.2f. Баланс: $%.2f"

    "en|treasury.notenough" : "Not enought money in treasury."
    "ru|treasury.notenough" : "В казне нет такой суммы."

    "en|treasury.player.notenough" : "You dont have enough money!"
    "ru|treasury.player.notenough" : "У вас недостаточно денег!"
}
alternativeTranslate(phrases);
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------ */
