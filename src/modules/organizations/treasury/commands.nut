acmd(["treasury", "treas"], "get", function( playerid) {
    msg(playerid, "treasury.get", getMoneyTreasury() );
});


acmd(["treasury", "treas"], "add", function( playerid, amount = 0.0) {
    addMoneyToTreasury(amount);
    msg(playerid, "treasury.add", [ amount.tofloat(), getMoneyTreasury() ], CL_EUCALYPTUS );
});


acmd(["treasury", "treas"], "sub", function( playerid, amount = 0.0) {
    subMoneyToTreasury(amount);
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
}
alternativeTranslate(phrases);
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------ */
