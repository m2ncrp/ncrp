include("controllers/money/commands.nut");

function addMoneyToPlayer(playerid, amount) {
    players[playerid]["money"] += amount.tofloat();
}

/**
 * Check if <amount> money can be subsctracted from <playerid>
 * @param  {int} playerid
 * @param  {float} amount
 * @return {bool} true/false
 */
function canMoneyBeSubstracted(playerid, amount) {
    local amount = round(fabs(amount.tofloat()), 2);
    return (players[playerid]["money"] >= amount);
}

function subMoneyToPlayer(playerid, amount) {
    players[playerid]["money"] -= amount.tofloat();
}

function getPlayerBalance(playerid) {
    return players[playerid]["money"];
}

/**
 * Send <amount> dollars from <playerid> to <targetid>
 * @param  {int} playerid
 * @param  {int} targetid
 * @param  {float} amount
 */
function sendMoney(playerid, targetid, amount) {
    local targetid = targetid.tointeger();
    local amount = round(fabs(amount.tofloat()), 2);
    if (playerid == targetid) {
        msg(playerid, "You put money from one pocket to another.");
        return;
    }
    if ( !isPlayerConnected(targetid) ) {
        msg(playerid, "There's no such person on server!");
        return;
    }
    if (isBothInRadius(playerid, targetid, 2.0)) {
        if(canMoneyBeSubstracted(playerid, amount)) {
            subMoneyToPlayer(playerid, amount);
            addMoneyToPlayer(targetid, amount);
            msg(playerid, "You've given $" + amount + " to " + getAuthor2(targetid) + ". Your balance: $" + getPlayerBalance(playerid) );
            msg(targetid, "You've taken $" + amount + " from " + getAuthor2(playerid) + ". Your balance: $" + getPlayerBalance(targetid) );
        } else {
            msg(playerid, "Not enough money to give!");
            msg(targetid, getAuthor2(playerid) + " can't give you money!");
        }
    } else { msg(playerid, "Distance between both players is too large!"); }
}

/**
 * Send invoice to transfer <amount> dollars from <playerid> to <targetid>
 * @param  {int} playerid
 * @param  {int} targetid
 * @param  {float} amount
 */
function sendInvoice(playerid, targetid, amount) {
    local targetid = targetid.tointeger();
    local amount = round(fabs(amount.tofloat()), 2);
    if (playerid == targetid) {
        msg(playerid, "You can't transfer money to yourself.");
        return;
    }
    if ( !isPlayerConnected(targetid) ) {
        msg(playerid, "There's no such person on server!");
        return;
    }
    if (isBothInRadius(playerid, targetid, 2.0)) {
        players[playerid]["request"][targetid] <- amount;
        msg(playerid, "You send invoice to " + getAuthor2(targetid) + " on $" + amount + "." );
        msg(targetid, "You received invoice from " + getAuthor2(playerid) + " on $" + amount + ". Please, /accept " + playerid + " or /decline " + playerid + " this invoice." );
    } else { msg(playerid, "Distance between you and receiver is too large!"); }
}

/**
 * Accept invoice to transfer from <senderid> to <playerid>
 * @param  {int} playerid
 * @param  {int} senderid
 */
function invoiceAccept(playerid, senderid) {
    local senderid = senderid.tointeger();
    if ( !isPlayerConnected(senderid) ) {
        msg(playerid, "Sender is'not on server!");
        return;
    }
    if (isBothInRadius(playerid, senderid, 2.0)) {
        if ("request" in players[senderid] && playerid in players[senderid]["request"]) {
            local amount = players[senderid]["request"][playerid];
            if(canMoneyBeSubstracted(playerid, amount)) {
                subMoneyToPlayer(playerid, amount);
                addMoneyToPlayer(senderid, amount);
                delete players[senderid]["request"][playerid];
                msg(playerid, "You've given $" + amount + " to " + getAuthor2(senderid) + ". Your balance: $" + getPlayerBalance(playerid) );
                msg(senderid,  getAuthor2(playerid) + " accepted your invoice. You earned $" + amount + ". Your balance: $" + getPlayerBalance(senderid) );
            } else {
                msg(playerid, "Not enough money to accept the invoice!");
                msg(senderid, getAuthor2(playerid) + " can't accept your invoice!");
            }
        }
    } else { msg(playerid, "Distance between you and receiver is too large!"); }
}

/**
 * Decline invoice to transfer from <senderid> to <playerid>
 * @param  {int} playerid
 * @param  {int} senderid
 */
function invoiceDecline(playerid, senderid) {
    local senderid = senderid.tointeger();
    if ( !isPlayerConnected(senderid) ) {
        msg(playerid, "Sender is'not on server!");
        return;
    }
    if ("request" in players[senderid] && playerid in players[senderid]["request"]) {
        delete players[senderid]["request"][playerid];
    }
    msg(playerid, "You decline invoice from " + getAuthor2(senderid) + "." );
    msg(senderid,  getAuthor2(playerid) + " declined your invoice." );
}