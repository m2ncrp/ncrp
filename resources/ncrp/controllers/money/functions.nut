function addMoneyToPlayer(playerid, amount) {
    players[playerid]["money"] += amount.tofloat();
    setPlayerMoney(playerid, players[playerid]["money"]);
}

function addMoneyToDeposit(playerid, amount) {
    players[playerid]["deposit"] += amount.tofloat();
}


/**
 * Check if <amount> money can be subsctracted from <playerid>
 *
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
    setPlayerMoney(playerid, players[playerid]["money"]);
}

function getPlayerBalance(playerid) {
    return format("%.2f", players[playerid]["money"]);
}

function formatMoney(amount) {
    return format("%.2f", amount);
}


//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------


/**
 * Send <amount> dollars from <playerid> to <targetid>
 *
 * @param  {int} playerid
 * @param  {int} targetid
 * @param  {float} amount
 */
function sendMoney(playerid, targetid = null, amount = null) {

    if (targetid == null || amount == null) {
        return msg(playerid, "You must provide player id and amount for transfer money.");
    }

    local targetid = targetid.tointeger();
    local amount = round(fabs(amount.tofloat()), 2);
    if (playerid == targetid) {
        return msg(playerid, "You can't give money to yourself.");
    }
    if ( !isPlayerConnected(targetid) ) {
        return msg(playerid, "There's no such person on server!");
    }

    if(getPlayerState( playerid ) != "free" || getPlayerState( targetid ) != "free") {
        return msg(playerid, "You can't send money." );
    }

    if (checkDistanceBtwTwoPlayersLess(playerid, targetid, 2.0)) {
        if(canMoneyBeSubstracted(playerid, amount)) {
            subMoneyToPlayer(playerid, amount);
            addMoneyToPlayer(targetid, amount);
            msg(playerid, "You've given $" + amount + " to " + getPlayerName(targetid) + " (#" + targetid + "). Your balance: $" + getPlayerBalance(playerid) );
            msg(targetid, "You've taken $" + amount + " from " + getPlayerName(playerid) + " (#" + playerid + "). Your balance: $" + getPlayerBalance(targetid) );

            dbg("money", "send", getPlayerName(playerid), getPlayerName(targetid), amount);
            statisticsPushText("money", playerid, format("to: %s, amount: %.2f", getPlayerName(targetid), amount), "send");
        } else {
            msg(playerid, "Not enough money to give!");
            msg(targetid, getPlayerName(playerid) + " (#" + playerid + ") can't give you money!");
        }
    } else { msg(playerid, "Distance between both players is too large!"); }
}

/**
 * Send invoice to transfer <amount> dollars from <playerid> to <targetid>
 *
 * @param  {int} playerid
 * @param  {int} targetid
 * @param  {float} amount
 */
function sendInvoice(playerid, targetid = null, amount = null, callback = null) {

    if (targetid == null || amount == null) {
        return msg(playerid, "You must provide player id and amount for sending invoice.");
    }

    local targetid = targetid.tointeger();
    local amount = round(fabs(amount.tofloat()), 2);
    if (playerid == targetid) {
        return msg(playerid, "You can't transfer money to yourself.");
    }
    if ( !isPlayerConnected(targetid) ) {
        return msg(playerid, "There's no such person on server!");
    }
    if (checkDistanceBtwTwoPlayersLess(playerid, targetid, 2.0)) {
        players[playerid]["request"][targetid] <- [amount, callback];
        msg(playerid, "You send invoice to " + getPlayerName(targetid) + " (#" + targetid + ") on $" + amount + "." );
        msg(targetid, "You received invoice from " + getPlayerName(playerid) + " (#" + playerid + ") on $" + amount + "." );
        msg(targetid, "Please, /accept " + playerid + " or /decline " + playerid + " this invoice." );
    } else { msg(playerid, "Distance between you and receiver is too large!"); }
}

/**
 * Send invoice to transfer <amount> dollars from <playerid> to <targetid> SILENT MODE
 *
 * @param  {int} playerid
 * @param  {int} targetid
 * @param  {float} amount
 */
function sendInvoiceSilent(playerid, targetid = null, amount = null, callback = null) {

    if (targetid == null || amount == null) {
        dbg("[money invoice silent] need targetid and amount");
        return false;
    }

    local targetid = targetid.tointeger();
    local amount = round(fabs(amount.tofloat()), 2);
    /*if (playerid == targetid) {
        dbg("[money invoice silent] You can't transfer money to yourself.");
        return false;
    }*/
    if ( !isPlayerConnected(targetid) ) {
        dbg("[money invoice silent] There's no such person on server!");
        return false;
    }
    if (checkDistanceBtwTwoPlayersLess(playerid, targetid, 3.0)) {
        players[playerid]["request"][targetid] <- [amount, callback];
        //msg(playerid, "You send invoice to " + getPlayerName(targetid) + " (#" + targetid + ") on $" + amount + "." );
        //msg(targetid, "You received invoice from " + getPlayerName(playerid) + " (#" + playerid + ") on $" + amount + "." );
        msg(targetid, "money.invoice.selectaction", [ playerid, playerid ] );
    } else {
        msg(playerid, "money.invoice.distancetoolarge");
    }
}


translation("en", {
    "money.invoice.selectaction"        : "Please, /pay %d or /cancel %d to pay."
    "money.invoice.distancetoolarge"    : "Distance between you and receiver is too large!"
    "money.invoice.notenoughmoney"      : "Not enough money to pay!"
    "money.invoice.cantpay"             : "%s can't accept payment!"
    "money.invoice.needplayerid"        : "You must provide player id to accept invoice."
    "money.invoice.senderoff"           : "Validity period of payment has expired."//  sender offline
});


/**
 * Accept invoice to transfer from <senderid> to <playerid>
 *
 * @param  {int} playerid
 * @param  {int} senderid
 */
function invoiceAcceptNew(playerid, senderid = null) {

    if (senderid == null) {
        return msg(playerid, "money.invoice.needplayerid");
    }

    local senderid = senderid.tointeger();
    if ( !isPlayerConnected(senderid) ) {
        return msg(playerid, "money.invoice.senderoff");
    }
    if (checkDistanceBtwTwoPlayersLess(playerid, senderid, 2.0)) {
        if ("request" in players[senderid] && playerid in players[senderid]["request"]) {
            local amount = players[senderid]["request"][playerid][0];
            if(canMoneyBeSubstracted(playerid, amount)) {
                subMoneyToPlayer(playerid, amount);
                addMoneyToPlayer(senderid, amount);

                // trigger callback
                if (players[senderid]["request"][playerid][1]) {
                    players[senderid]["request"][playerid][1](playerid, senderid, true);
                }

                delete players[senderid]["request"][playerid];
                //msg(playerid, "You've given $" + amount + " to " + getPlayerName(senderid) + " (#" + senderid + "). Your cash: $" + getPlayerBalance(playerid) );
                //msg(senderid,  getPlayerName(playerid) + " (#" + playerid + ") accepted your invoice. You earned $" + amount + ". Your cash: $" + getPlayerBalance(senderid) );
            } else {
                msg(playerid, "money.invoice.notenoughmoney");
                msg(senderid, "money.invoice.cantpay", getPlayerNameShort(playerid));
                //return "notenough";
            }
        }
    } else { msg(playerid, "money.invoice.distancetoolarge"); }
}


/**
 * Decline invoice to transfer from <senderid> to <playerid>
 *
 * @param  {int} playerid
 * @param  {int} senderid
 */
function invoiceDeclineNew(playerid, senderid = null) {

    if (senderid == null) {
        return msg(playerid, "money.invoice.needplayerid");
    }

    local senderid = senderid.tointeger();
    if ( !isPlayerConnected(senderid) ) {
        return msg(playerid, "money.invoice.senderoff");
    }
        if ("request" in players[senderid] && playerid in players[senderid]["request"]) {

            // trigger callback
            if (players[senderid]["request"][playerid][1]) {
                players[senderid]["request"][playerid][1](playerid, senderid, false);
            }

            delete players[senderid]["request"][playerid];
        }
        //msg(playerid, "You decline invoice from " + getPlayerName(senderid) + " (#" + senderid + ")." );
        //msg(senderid,  getPlayerName(playerid) + " (#" + playerid + ") declined your invoice." );
}








//************************************************************************************************************************


/**
 * Accept invoice to transfer from <senderid> to <playerid>
 *
 * @param  {int} playerid
 * @param  {int} senderid
 */
function invoiceAccept(playerid, senderid = null) {

    if (senderid == null) {
        return msg(playerid, "You must provide player id to accept invoice.");
    }

    local senderid = senderid.tointeger();
    if ( !isPlayerConnected(senderid) ) {
        return msg(playerid, "Sender is'not on server!");
    }
    if (checkDistanceBtwTwoPlayersLess(playerid, senderid, 2.0)) {
        if ("request" in players[senderid] && playerid in players[senderid]["request"]) {
            local amount = players[senderid]["request"][playerid][0];
            if(canMoneyBeSubstracted(playerid, amount)) {
                subMoneyToPlayer(playerid, amount);
                addMoneyToPlayer(senderid, amount);

                // trigger callback
                if (players[senderid]["request"][playerid][1]) {
                    players[senderid]["request"][playerid][1](playerid, senderid, true);
                }

                delete players[senderid]["request"][playerid];
                msg(playerid, "You've given $" + amount + " to " + getPlayerName(senderid) + " (#" + senderid + "). Your cash: $" + getPlayerBalance(playerid) );
                msg(senderid,  getPlayerName(playerid) + " (#" + playerid + ") accepted your invoice. You earned $" + amount + ". Your cash: $" + getPlayerBalance(senderid) );
            } else {
                msg(playerid, "Not enough money to accept the invoice!");
                msg(senderid, getPlayerName(playerid) + " (#" + playerid + ") can't accept your invoice!");
            }
        }
    } else { msg(playerid, "Distance between you and receiver is too large!"); }
}


/**
 * Decline invoice to transfer from <senderid> to <playerid>
 *
 * @param  {int} playerid
 * @param  {int} senderid
 */
function invoiceDecline(playerid, senderid = null) {

    if (senderid == null) {
        return msg(playerid, "You must provide player id to decline invoice.");
    }

    local senderid = senderid.tointeger();
    if ( !isPlayerConnected(senderid) ) {
        return msg(playerid, "Sender is'not on server!");
    }
        if ("request" in players[senderid] && playerid in players[senderid]["request"]) {

            // trigger callback
            if (players[senderid]["request"][playerid][1]) {
                players[senderid]["request"][playerid][1](playerid, senderid, false);
            }

            delete players[senderid]["request"][playerid];
        }
        msg(playerid, "You decline invoice from " + getPlayerName(senderid) + " (#" + senderid + ")." );
        msg(senderid,  getPlayerName(playerid) + " (#" + playerid + ") declined your invoice." );
}
