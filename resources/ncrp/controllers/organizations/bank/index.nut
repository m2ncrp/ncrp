include("controllers/organizations/bank/commands.nut");

const BANK_RATE = 0.005; //bank rate for deposit (x<1) in day
const BANK_RADIUS = 3.0;
const BANK_X = 64.8113;  //Bank X
const BANK_Y = -202.754; //Bank Y
const BANK_Z = -20.2314;

addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading bank...");
    createVehicle(27, 124.65, -240.0, -19.2512, 180.0, 0.0, 0.0);   // securityCAR1
    createVehicle(27, 124.65, -222.5, -19.2512, 180.0, 0.0, 0.0);   // securityCAR2

    //creating 3dtext for bus depot
    create3DText ( BANK_X, BANK_Y, BANK_Z+0.35, "GRAND IMERIAL BANK", CL_ROYALBLUE );
    create3DText ( BANK_X, BANK_Y, BANK_Z+0.20, "/bank", CL_WHITE.applyAlpha(75), BANK_RADIUS );

    createBlip(BANK_X, BANK_Y, ICON_MAFIA, 4000.0 )
});


function bankGetPlayerDeposit(playerid) {
    return format("%.2f", players[playerid]["deposit"]);
}

function bankAccount(playerid) {

    if(!isPlayerInValidPoint(playerid, BANK_X, BANK_Y, BANK_RADIUS)) {
        return msg( playerid, "Let's go to building of Grand Imperial Bank at Midtown." );
    }

    msg( playerid, "Your deposit in bank: $"+bankGetPlayerDeposit(playerid) );
}

function bankDeposit(playerid, amount) {

    if(!isPlayerInValidPoint(playerid, BANK_X, BANK_Y, BANK_RADIUS)) {
        return msg( playerid, "Let's go to building of Grand Imperial Bank at Midtown." );
    }

    local amount = amount.tofloat();
    if(!canMoneyBeSubstracted(playerid, amount)) {
        return msg(playerid, "You can't deposit this amount: not enough money.");
    }

    subMoneyToPlayer(playerid, amount);
    players[playerid]["deposit"] += amount;
    msg( playerid, "You deposit to bank $"+amount+". Balance: $"+bankGetPlayerDeposit(playerid) );
}

function bankWithdraw(playerid, amount) {

    if(!isPlayerInValidPoint(playerid, BANK_X, BANK_Y, BANK_RADIUS)) {
        return msg( playerid, "Let's go to building of Grand Imperial Bank at Midtown." );
    }

    local amount = amount.tofloat();
    if(players[playerid]["deposit"] < amount) {
        return msg( playerid, "You can't withdraw this amount: not enough money at account." );
    }

    players[playerid]["deposit"] -= amount;
    addMoneyToPlayer(playerid, amount);
    msg( playerid, "You withdraw from bank $"+amount+". Balance: $"+bankGetPlayerDeposit(playerid) )
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
    local title = "List of available commands for BANK:";
    local commands = [
        { name = "/bank account",               desc = "Show information about your account in bank." },
        { name = "/bank deposit <amount>",      desc = "Put <amount> dollars into the account." },
        { name = "/bank deposit all",           desc = "Put all money into the account." },
        { name = "/bank withdraw <amount>",     desc = "Withdraw <amount> dollars from the account."},
        { name = "/bank withdraw all",          desc = "Withdraw all money from the account."}
    ];
    msg_help(playerid, title, commands);
}
