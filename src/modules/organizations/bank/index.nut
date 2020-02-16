include("modules/organizations/bank/models/Bank.nut");
include("modules/organizations/bank/commands.nut");

include("modules/organizations/bank/models/main-bank.nut");

alternativeTranslate({
    "ru|bank.letsgo1"                      :   "Чтобы посетить офис банка, отправляйтесь к зданию Grand Imperial Bank в центре Мидтауна."
    "ru|bank.letsgo2"                      :   "Чтобы посетить главное здание, отправляйтесь на восток Мидтауна."
    "ru|bank.enter-correct-amount"         :   "Укажите корректную сумму"
    "ru|bank.deposit.minimum"              :   "Минимальная сумма вклада $50"
    "ru|bank.deposit.notenough"            :   "Недостаточно наличных денег"
    "ru|bank.withdraw.minimum"             :   "Минимальная сумма снятия $50"
    "ru|bank.withdraw.notenough"           :   "Недостаточно средств на балансе."
    "ru|bank.provideamount"                :   "Вам необходимо указать сумму."
    "ru|bank.help.title"                   :   "Grand Imperial Bank"
    "ru|bank.deposit.completed"            :   "На ваш счёт зачислено $%.2f"
    "ru|bank.withdraw.completed"           :   " С вашего счёта снято $%.2f"

    "en|bank.letsgo1"                      :   "Let's go to building of Grand Imperial Bank at Midtown."
    "en|bank.letsgo2"                      :   "Let's go to building of Grand Imperial Bank at Midtown."
    "en|bank.enter-correct-amount"         :   "Enter correct amount"
    "en|bank.deposit.minimum"              :   "Minimum deposit is $50."
    "en|bank.deposit.notenough"            :   "You can't deposit this amount: not enough money."
    "en|bank.withdraw.minimum"             :   "You can't withdraw this amount. Minimum withdrawal amount is $10."
    "en|bank.withdraw.notenough"           :   "You can't withdraw this amount: not enough money at account."
    "en|bank.provideamount"                :   "You must provide amount."
    "en|bank.help.title"                   :   "Grand Imperial Bank"
    "en|bank.deposit.completed"            :   "На ваш счёт зачислено $%.2f"
    "en|bank.withdraw.completed"           :   " С вашего счёта снято $%.2f"
});
/*
[12:40:27] Vehicle iD: 0 is at 20, 128.514, -239.62, -19.8645, 175.759, 0.084436, -0.261477 // BankMidtownHernya

*/

/**
 * Check is player's vehicle is a security car
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleSecurity(playerid) {
    return (isPlayerInValidVehicle(playerid, 27));
}

const BANK_RATE = 0.0; //bank rate for deposit (x<1) in day
const BANK_RADIUS = 2.0;

const BANK_X = 119.838;
const BANK_Y = -203.018;
const BANK_Z = -20.2504;

const BANK1_X = 64.8113;
const BANK1_Y = -202.754;
const BANK1_Z = -20.2314;

const BANK_OFFICE_PLACE_NAME = "BankOffice";
const BANK_OFFICE_X = -323.211;
const BANK_OFFICE_Y = -99.6398;
const BANK_OFFICE_Z = -10.6255;

event("onServerStarted", function() {
    log("[jobs] loading bank...");
    createVehicle(27, 124.65, -240.0, -20.061, 180.0, 0.0, 0.0);   // securityCAR1
    createVehicle(27, 124.65, -222.5, -20.061, 180.0, 0.0, 0.0);   // securityCAR2

    //creating place and blip for Bank
    createPlace(BANK_OFFICE_PLACE_NAME, BANK_OFFICE_X - BANK_RADIUS, BANK_OFFICE_Y - BANK_RADIUS, BANK_OFFICE_X + BANK_RADIUS, BANK_OFFICE_Y + BANK_RADIUS);
    createBlip(BANK_X, BANK_Y, ICON_MAFIA, 150.0 )
    createBlip(BANK_OFFICE_X, BANK_OFFICE_Y, ICON_DOLLAR, 150.0 )
});

event("onServerPlayerStarted", function( playerid ) {
    //creating 3dtext for Main Bank Building
    createPrivate3DText ( playerid, BANK_X, BANK_Y, BANK_Z+0.35, plocalize(playerid, "GRAND IMPERIAL BANK"), CL_ROYALBLUE );
    createPrivate3DText ( playerid, BANK_X, BANK_Y, BANK_Z+0.20, plocalize(playerid, "3dtext.job.press.E"), CL_WHITE.applyAlpha(75), BANK_RADIUS );

    //creating 3dtext for Bank Office
    createPrivate3DText ( playerid, BANK_OFFICE_X, BANK_OFFICE_Y, BANK_OFFICE_Z+0.35, plocalize(playerid, "3dtext.organizations.bank"), CL_ROYALBLUE );
    createPrivate3DText ( playerid, BANK_OFFICE_X, BANK_OFFICE_Y, BANK_OFFICE_Z+0.20, plocalize(playerid, "3dtext.job.press.E"), CL_WHITE.applyAlpha(75), BANK_RADIUS );
});

event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
    if (!isPlayerVehicleSecurity(playerid)) {
        return;
    }

    blockDriving(playerid, vehicleid);
});

event("onPlayerPlaceExit", function(playerid, name) {
    if (name == BANK_OFFICE_PLACE_NAME) {
        return trigger(playerid, "hideBankGUI");
    }
});


function bankPlayerInValidPoint(playerid) {
    return ( /*isPlayerInValidPoint(playerid, BANK_X, BANK_Y, BANK_RADIUS) || */ isPlayerInValidPoint(playerid, BANK_OFFICE_X, BANK_OFFICE_Y, BANK_RADIUS));
}

function bankGetPlayerDeposit(playerid) {
    return formatMoney(players[playerid]["deposit"]);
}


function canBankMoneyBeSubstracted(playerid, amount) {
    local amount = round(fabs(amount.tofloat()), 2);
    return (players[playerid]["deposit"] >= amount);
}

function addMoneyToDeposit(playerid, amount) {
    local old_amount = players[playerid]["deposit"];
    local new_amount = old_amount + amount.tofloat();
    players[playerid]["deposit"] = new_amount;
    dbg("[DEPOSIT] "+getPlayerName(playerid)+" [ "+getAccountName(playerid)+" ] -> +"+format("%.2f", amount)+" dollars. Was: $"+format("%.2f", old_amount)+". Now: $"+format("%.2f", new_amount));
}

function subMoneyToDeposit(playerid, amount) {
    local old_amount = players[playerid]["deposit"];
    local new_amount = old_amount - amount.tofloat();
    players[playerid]["deposit"] = new_amount;
    dbg("[DEPOSIT] "+getPlayerName(playerid)+" [ "+getAccountName(playerid)+" ] -> -"+format("%.2f", amount)+" dollars. Was: $"+format("%.2f", old_amount)+". Now: $"+format("%.2f", new_amount));
}

event("bankPlayerDeposit", function(playerid, amount = "") {

    if(!bankPlayerInValidPoint( playerid )) {
        msg( playerid, "bank.letsgo" );
        return trigger(playerid, "hideBankGUI");
    }

    if(!isNumeric(amount) && amount != "all") {
        return trigger(playerid, "bankSetErrorText", plocalize(playerid, "bank.enter-correct-amount"));
    }

    local playerMoney = getPlayerMoney(playerid);

    if(amount == "all") {
        amount = playerMoney;
        if(amount == 0) {
            return trigger(playerid, "bankSetErrorText", plocalize(playerid, "bank.deposit.minimum"));
        }
    } else {
        amount = round(fabs(amount.tofloat()), 2);

        if(playerMoney < amount) {
            return trigger(playerid, "bankSetErrorText", plocalize(playerid, "bank.deposit.notenough"));
        }

        if(amount < 50.0) {
            return trigger(playerid, "bankSetErrorText", plocalize(playerid, "bank.deposit.minimum"));
        }
    }

    subMoneyToPlayer(playerid, amount);
    addMoneyToDeposit(playerid, amount);

    trigger(playerid, "bankSetErrorText",  plocalize(playerid, "bank.deposit.completed", [amount]));
    trigger(playerid, "bankUpdateBalance", bankGetPlayerDeposit(playerid));
});


event("bankPlayerWithdraw", function(playerid, amount = "") {

    if(!bankPlayerInValidPoint( playerid )) {
        msg( playerid, "bank.letsgo" );
        return trigger(playerid, "hideBankGUI");
    }

    if(!isNumeric(amount) && amount != "all") {
        return trigger(playerid, "bankSetErrorText", plocalize(playerid, "bank.enter-correct-amount"));
    }

    local playerDeposit = players[playerid]["deposit"];

    if(amount == "all") {
        amount = playerDeposit;
        if(amount == 0) {
            return trigger(playerid, "bankSetErrorText", plocalize(playerid, "bank.withdraw.minimum"));
        }
    } else {
        amount = round(fabs(amount.tofloat()), 2);

        if(amount < 50.0) {
            return trigger(playerid, "bankSetErrorText", plocalize(playerid, "bank.withdraw.minimum"));
        }

        if(playerDeposit < amount) {
            return trigger(playerid, "bankSetErrorText", plocalize(playerid, "bank.withdraw.notenough"));
        }
    }

    subMoneyToDeposit(playerid, amount);
    addMoneyToPlayer(playerid, amount);
    trigger(playerid, "bankSetErrorText", plocalize(playerid, "bank.withdraw.completed", [amount]));
    trigger(playerid, "bankUpdateBalance", bankGetPlayerDeposit(playerid));
});

event("onServerHourChange", function() {
// called every game time minute changes
    foreach (playerid, value in players) {
        if (players[playerid]["deposit"] == 0.0) {
            continue;
        }
        players[playerid]["deposit"] += players[playerid]["deposit"]*BANK_RATE;
    }
});

/**
Event: JOB - Bus driver - Already have job
*/
key("e", function(playerid) {

    if(!isPlayerInValidPoint(playerid, BANK_OFFICE_X, BANK_OFFICE_Y, BANK_RADIUS)) {
        return;
    }

    trigger(playerid, "showBankGUI", bankGetPlayerDeposit(playerid));
})

function helpBank(playerid) {
    msg(playerid, "===========================================", CL_HELP_LINE);
    msg(playerid, "bank.help.title", CL_HELP_TITLE);
    msg(playerid, "bank.letsgo", CL_SILVERSAND);
}
