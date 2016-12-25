include("modules/organizations/bank/commands.nut");

translation("en", {
    "bank.letsgo"                       :   "Let's go to building of Grand Imperial Bank at Midtown."
    "bank.deposit.minimum"              :   "You can't deposit this amount. Minimum deposit is $100."
    "bank.deposit.notenough"            :   "You can't deposit this amount: not enough money."
    "bank.withdraw.minimum"             :   "You can't withdraw this amount. Minimum withdrawal amount is $100."
    "bank.withdraw.notenough"           :   "You can't withdraw this amount: not enough money at account."
    "bank.provideamount"                :   "You must provide amount."
    "bank.help.commandslist"            :   "List of available commands for BANK:"

    "help.bank.account"                 :   "Show information about your account in bank."
    "help.bank.deposit"                 :   "Put AMOUNT dollars into account."
    "help.bank.depositall"              :   "Put all money into account."
    "help.bank.withdraw"                :   "Withdraw AMOUNT dollars from account."
    "help.bank.withdrawall"             :   "Withdraw all money from account."

    "help.cmd.bank.account"             :   "/bank account"
    "help.cmd.bank.deposit"             :   "/bank deposit AMOUNT"
    "help.cmd.bank.depositall"          :   "/bank deposit all"
    "help.cmd.bank.withdraw"            :   "/bank withdraw AMOUNT"
    "help.cmd.bank.withdrawall"         :   "/bank withdraw all"
});
/*
[12:40:27] Vehicle iD: 0 is at 20, 128.514, -239.62, -19.8645, 175.759, 0.084436, -0.261477 // BankMidtownHernya

*/

const BANK_RATE = 0.0; //bank rate for deposit (x<1) in day
const BANK_RADIUS = 3.0;
const BANK_X = 64.8113;  //Bank X
const BANK_Y = -202.754; //Bank Y
const BANK_Z = -20.2314;

const BANK_OFFICE_X = -323.211;  //Bank X
const BANK_OFFICE_Y = -99.6398; //Bank Y
const BANK_OFFICE_Z = -10.6255;

event("onServerStarted", function() {
    log("[jobs] loading bank...");
    createVehicle(27, 124.65, -240.0, -19.8645, 180.0, 0.0, 0.0);   // securityCAR1
    createVehicle(27, 124.65, -222.5, -19.8645, 180.0, 0.0, 0.0);   // securityCAR2

    //creating 3dtext for Bank
    create3DText ( BANK_X, BANK_Y, BANK_Z+0.35, "GRAND IMERIAL BANK", CL_ROYALBLUE );
    create3DText ( BANK_X, BANK_Y, BANK_Z+0.20, "/bank", CL_WHITE.applyAlpha(75), BANK_RADIUS );
    createBlip(BANK_X, BANK_Y, ICON_MAFIA, 4000.0 )

    //creating 3dtext for Bank Office
    create3DText ( BANK_OFFICE_X, BANK_OFFICE_Y, BANK_OFFICE_Z+0.35, "GRAND IMERIAL BANK", CL_ROYALBLUE );
    create3DText ( BANK_OFFICE_X, BANK_OFFICE_Y, BANK_OFFICE_Z+0.20, "/bank", CL_WHITE.applyAlpha(75), BANK_RADIUS );
    createBlip(BANK_OFFICE_X, BANK_OFFICE_Y, ICON_MAFIA, 4000.0 )
});

function bankPlayerInValidPoint(playerid) {
    return (isPlayerInValidPoint(playerid, BANK_X, BANK_Y, BANK_RADIUS) || isPlayerInValidPoint(playerid, BANK_OFFICE_X, BANK_OFFICE_Y, BANK_RADIUS));
}

function bankGetPlayerDeposit(playerid) {
    return formatMoney(players[playerid]["deposit"]);
}

function bankAccount(playerid) {

    if(!bankPlayerInValidPoint( playerid )) {
        return msg( playerid, "bank.letsgo" );
    }

    msg( playerid, "Your deposit in bank: $"+bankGetPlayerDeposit(playerid) );
}

function bankDeposit(playerid, amount) {

    if(!bankPlayerInValidPoint( playerid )) {
        return msg( playerid, "bank.letsgo" );
    }

    if(amount == null) {
        return msg( playerid, "bank.provideamount" );
    }

    local amount = round(fabs(amount.tofloat()), 2);
    if(amount < 100.0) {
        return msg(playerid, "bank.deposit.minimum");
    }

    if(!canMoneyBeSubstracted(playerid, amount)) {
        return msg(playerid, "bank.deposit.notenough");
    }

    subMoneyToPlayer(playerid, amount);
    players[playerid]["deposit"] += amount;
    msg( playerid, "You deposit to bank $"+formatMoney(amount)+". Balance: $"+bankGetPlayerDeposit(playerid) );
}

function bankWithdraw(playerid, amount) {

    if(!bankPlayerInValidPoint( playerid )) {
        return msg( playerid, "bank.letsgo" );
    }

    if(amount == null) {
        return msg( playerid, "bank.provideamount" );
    }

    local amount = round(fabs(amount.tofloat()), 2);
    if(amount < 100.0) {
        return msg( playerid, "bank.withdraw.minimum" );
    }

    if(players[playerid]["deposit"] < amount) {
        return msg( playerid, "bank.withdraw.notenough" );
    }

    players[playerid]["deposit"] -= amount;
    addMoneyToPlayer(playerid, amount);
    msg( playerid, "You withdraw from bank $"+formatMoney(amount)+". Balance: $"+bankGetPlayerDeposit(playerid) )
}


event("onServerHourChange", function() {
// called every game time minute changes
    foreach (playerid, value in players) {
        if (players[playerid]["deposit"] == 0.0) {
            continue;
        }
        players[playerid]["deposit"] += players[playerid]["deposit"]*BANK_RATE;
    }
});


function helpBank(playerid) {
    local title = "bank.help.commandslist";
    local commands = [
        { name = "help.cmd.bank.account",        desc = "help.bank.account" },
        { name = "help.cmd.bank.deposit",        desc = "help.bank.deposit" },
        { name = "help.cmd.bank.depositall",     desc = "help.bank.depositall" },
        { name = "help.cmd.bank.withdraw",       desc = "help.bank.withdraw"},
        { name = "help.cmd.bank.withdrawall",    desc = "help.bank.withdrawall"}
    ];
    msg_help(playerid, title, commands);
}
