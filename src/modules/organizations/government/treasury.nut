acmd(["treas"], "get", function( playerid) {
    msg(playerid, "treasury.get", getTreasuryMoney() );
});


acmd(["treas"], "add", function( playerid, amount = 0.0) {
    addTreasuryMoney(amount);
    msg(playerid, "treasury.add", [ amount.tofloat(), getTreasuryMoney() ], CL_EUCALYPTUS );
});


acmd(["treas"], "sub", function( playerid, amount = 0.0) {
    subTreasuryMoney(amount);
    msg(playerid, "treasury.sub", [ amount.tofloat(), getTreasuryMoney() ], CL_THUNDERBIRD );
});


/* Commands to government - HARDCODE */

// meria coords
local coords = [-122.331, -62.9116, -12.041];

fmd("gov", ["gov.treasury"], "$f treasury get", function(fraction, character) {

    if (!isPlayerInValidPoint(character.playerid, coords[0], coords[1], 1.0 )) {
        return msg(character.playerid, "treasury.toofar", CL_THUNDERBIRD );
    }

    msg(character.playerid, "treasury.get", getTreasuryMoney() );
});

fmd("gov", ["gov.treasury"], "$f treasury add", function(fraction, character, amount, ...) {

    if (!isPlayerInValidPoint(character.playerid, coords[0], coords[1], 1.0 )) {
        return msg(character.playerid, "treasury.toofar", CL_THUNDERBIRD );
    }

    if(!vargv) return msg(character.playerid, "treasury.enterreason", CL_THUNDERBIRD );

    amount = amount.tofloat() || 0;

    if (!canMoneyBeSubstracted(character.playerid, amount)) {
        return msg(character.playerid, "treasury.player.notenough", CL_THUNDERBIRD);
    }

    local moneyInTreasuryOld = getMoneyTreasury();
    addTreasuryMoney(amount);
    local moneyInTreasuryNow = getMoneyTreasury();

    subMoneyToPlayer(character.playerid, amount);
    msg(character.playerid, "treasury.add", [ amount.tofloat(), moneyInTreasuryNow ], CL_EUCALYPTUS );
    dbg("gov", "treasury", "add", getPlayerName(character.playerid), getDateTime(), [["Было", "$"+moneyInTreasuryOld.tostring()], ["Сумма", "+$"+amount.tostring()], ["Стало", "$"+moneyInTreasuryNow.tostring()],["Основание", concat(vargv)]]);
});

fmd("gov", ["gov.treasury"], "$f treasury sub", function(fraction, character, amount, ...) {

    if (!isPlayerInValidPoint(character.playerid, coords[0], coords[1], 1.0 )) {
        return msg(character.playerid, "treasury.toofar", CL_THUNDERBIRD );
    }

    if(!vargv) return msg(character.playerid, "treasury.enterreason", CL_THUNDERBIRD );

    amount = amount.tofloat() || 0;

    if(amount.tofloat() > getTreasuryMoney().tofloat()) {
        return msg(character.playerid, "treasury.notenough", CL_THUNDERBIRD );
    }

    local moneyInTreasuryOld = getMoneyTreasury();
    subTreasuryMoney(amount);
    local moneyInTreasuryNow = getMoneyTreasury();

    addMoneyToPlayer(character.playerid, amount);
    msg(character.playerid, "treasury.sub", [ amount.tofloat(), getMoneyTreasury() ], CL_THUNDERBIRD );
    dbg("gov", "treasury", "sub", getPlayerName(character.playerid), getDateTime(), [["Было", "$"+moneyInTreasuryOld.tostring()], ["Сумма", "-$"+amount.tostring()], ["Стало", "$"+moneyInTreasuryNow.tostring()],["Основание", concat(vargv)]]);
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


function addTreasuryMoney(amount) {
    local amount = round(fabs(amount.tofloat()), 2);
    local currentAmount = getTreasuryMoney();
    local newAmount = currentAmount + amount;
    setTreasuryMoney(newAmount);
    dbg("chat", "idea", "Городская казна", format("Пополнение на сумму: $%.2f", amount));
}


function subTreasuryMoney(amount, options) {
    local amount = round(fabs(amount.tofloat()), 2);
    local currentAmount = getTreasuryMoney();
    local newAmount = currentAmount - amount;
    setTreasuryMoney(newAmount);
    if("silent" in options == false) {
        dbg("chat", "idea", "Городская казна", format("Списание на сумму: $%.2f", amount));
    }
}

function canTreasuryMoneyBeSubstracted(amount) {
    local amount = round(fabs(amount.tofloat()), 2);
    return (getTreasuryMoney() >= amount);
}


function getTreasuryMoney() {
    return getGovernmentValue("treasury");
}

function setTreasuryMoney(amount) {
    return setGovernmentValue("treasury", amount);
}