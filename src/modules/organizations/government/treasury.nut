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

fmd("gov", ["gov.treasury"], "$f treasury get", function(fraction, character) {

    if (!isPlayerInValidPoint(character.playerid, coords[0], coords[1], 1.0 )) {
        return msg(character.playerid, "treasury.toofar", CL_THUNDERBIRD );
    }

    msg(character.playerid, "treasury.get", getMoneyTreasury() );
});

fmd("gov", ["gov.treasury"], "$f treasury add", function(fraction, character, amount = "0", reason = null) {

    if (!isPlayerInValidPoint(character.playerid, coords[0], coords[1], 1.0 )) {
        return msg(character.playerid, "treasury.toofar", CL_THUNDERBIRD );
    }

    if(!reason) return msg(character.playerid, "treasury.enterreason", CL_THUNDERBIRD );

    amount = amount.tofloat();

    if (!canMoneyBeSubstracted(character.playerid, amount)) {
        return msg(character.playerid, "treasury.player.notenough", CL_THUNDERBIRD);
    }

    addMoneyToTreasury(amount);
    subMoneyToPlayer(character.playerid, amount);
    msg(character.playerid, "treasury.add", [ amount.tofloat(), getMoneyTreasury() ], CL_EUCALYPTUS );
    dbg("chat", "idea", getAuthor(character.playerid), "Добавлено в казну: "+amount.tostring()+". Основание: "+reason);
});

fmd("gov", ["gov.treasury"], "$f treasury sub", function(fraction, character, amount = "0", reason = null) {

    if (!isPlayerInValidPoint(character.playerid, coords[0], coords[1], 1.0 )) {
        return msg(character.playerid, "treasury.toofar", CL_THUNDERBIRD );
    }

    if(!reason) return msg(character.playerid, "treasury.enterreason", CL_THUNDERBIRD );

    amount = amount.tofloat();

    if(amount.tofloat() > getMoneyTreasury().tofloat()) {
        return msg(character.playerid, "treasury.notenough", CL_THUNDERBIRD );
    }

    subMoneyToTreasury(amount);
    addMoneyToPlayer(character.playerid, amount);
    msg(character.playerid, "treasury.sub", [ amount.tofloat(), getMoneyTreasury() ], CL_THUNDERBIRD );
    dbg("chat", "idea", getAuthor(character.playerid), "Взято из казны: "+amount.tostring()+". Основание: "+reason);
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

    "en|treasury.enterreason" : "Enter purpose of transaction."
    "ru|treasury.enterreason" : "Укажите основание для проведения операции."

    "en|treasury.player.notenough" : "You dont have enough money!"
    "ru|treasury.player.notenough" : "У вас недостаточно денег!"

    "en|treasury.toofar"            : "Operations with the city treasury are available only in the city hall."
    "ru|treasury.toofar"            : "Операции с городской казной доступны только в мэрии города."
}
alternativeTranslate(phrases);
/* ------------------------------------------------------------------------------------------------------------------------------------------------------------ */



function addMoneyToTreasury(amount) {
    local amount = round(fabs(amount.tofloat()), 2);
    TREASURY.amount += amount;
    TREASURY.save();
    dbg("chat", "idea", "Городская казна", "Пополнение на сумму: "+amount.tostring());
}


function subMoneyToTreasury(amount) {
    local amount = round(fabs(amount.tofloat()), 2);
    TREASURY.amount -= amount;
    TREASURY.save();
    dbg("chat", "idea", "Городская казна", "Списание на сумму: "+amount.tostring());
}


function canTreasuryMoneyBeSubstracted(amount) {
    local amount = round(fabs(amount.tofloat()), 2);
    return (TREASURY.amount >= amount);
}


function getMoneyTreasury() {
    return TREASURY.amount;
}
