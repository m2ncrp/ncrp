include("modules/organizations/bank/commands.nut");

/*
[12:40:27] Vehicle iD: 0 is at 20, 128.514, -239.62, -19.8645, 175.759, 0.084436, -0.261477 // BankMidtownHernya

*/

const BANK_RATE = 0.005; //bank rate for deposit (x<1) in day
const BANK_RADIUS = 3.0;
const BANK_X = 64.8113;  //Bank X
const BANK_Y = -202.754; //Bank Y
const BANK_Z = -20.2314;

addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading bank...");
    createVehicle(27, 124.65, -240.0, -19.8645, 180.0, 0.0, 0.0);   // securityCAR1
    createVehicle(27, 124.65, -222.5, -19.8645, 180.0, 0.0, 0.0);   // securityCAR2

    //creating 3dtext for bus depot
    create3DText ( BANK_X, BANK_Y, BANK_Z+0.35, "GRAND IMERIAL BANK", CL_ROYALBLUE );
    create3DText ( BANK_X, BANK_Y, BANK_Z+0.20, "/bank", CL_WHITE.applyAlpha(75), BANK_RADIUS );

    createBlip(BANK_X, BANK_Y, ICON_MAFIA, 4000.0 )
});

function bankGetPlayerDeposit(playerid) {
    return formatMoney(players[playerid]["deposit"]);
}

function bankAccount(playerid) {

    if(!isPlayerInValidPoint(playerid, BANK_X, BANK_Y, BANK_RADIUS)) {
        return msg( playerid, "bank.letsgo" );
    }

    msg( playerid, "Your deposit in bank: $"+bankGetPlayerDeposit(playerid) );
}

function bankDeposit(playerid, amount) {

    if(!isPlayerInValidPoint(playerid, BANK_X, BANK_Y, BANK_RADIUS)) {
        return msg( playerid, "bank.letsgo" );
    }

    if(amount == null) {
        return msg( playerid, "bank.provideamount" );
    }

    local amount = round(fabs(amount.tofloat()), 2);
    if(amount < 50.0) {
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

    if(!isPlayerInValidPoint(playerid, BANK_X, BANK_Y, BANK_RADIUS)) {
        return msg( playerid, "bank.letsgo" );
    }

    if(amount == null) {
        return msg( playerid, "bank.provideamount" );
    }

    local amount = round(fabs(amount.tofloat()), 2);
    if(amount < 1.0) {
        return msg( playerid, "bank.withdraw.minimum" );
    }

    if(players[playerid]["deposit"] < amount) {
        return msg( playerid, "bank.withdraw.notenough" );
    }

    players[playerid]["deposit"] -= amount;
    addMoneyToPlayer(playerid, amount);
    msg( playerid, "You withdraw from bank $"+formatMoney(amount)+". Balance: $"+bankGetPlayerDeposit(playerid) )
}


addEventHandlerEx("onServerHourChange", function() {
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
        { name = "/bank account",               desc = "Show information about your account in bank." },
        { name = "/bank deposit <amount>",      desc = "Put <amount> dollars into the account." },
        { name = "/bank deposit all",           desc = "Put all money into the account." },
        { name = "/bank withdraw <amount>",     desc = "Withdraw <amount> dollars from the account."},
        { name = "/bank withdraw all",          desc = "Withdraw all money from the account."}
    ];
    msg_help(playerid, title, commands);
}
