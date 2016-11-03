include("controllers/money/commands.nut");

function addMoneyToPlayer(playerid, amount) {
    players[playerid]["money"] += amount;
}

function subMoneyToPlayer(playerid, amount) {
    local f_amount = amount.tofloat();
    if (players[playerid]["money"] > f_amount)
        players[playerid]["money"] -= f_amount;
    else
        msg(playerid, "You can't afford youself to spend $" + amount + "!");
}

function getPlayerBalance(playerid) {
    return players[playerid]["money"];
}

function isEnoughBalance(playerid, amount) {
    if (getPlayerBalance(playerid) < amount) {
        msg(playerid, "You can't afford youself to spend $" + amount + "!", CL_RED);
        return false;
    }
    return true;
}

function transfer(playerid, targetid, amount) {
    local f_amount = amount.tofloat();
    local i_targetid = targetid.tointeger();
    if (playerid == i_targetid) {
        msg(playerid, "You can't transfer money to youself.");
        return;
    }
    if ( !isPlayerConnected(i_targetid) ) {
        msg(playerid, "There's no such person on server!");
        return;
    }

    subMoneyToPlayer(playerid, f_amount);
    msg(playerid, "You transfer $" + amount + " to " + getPlayerName( i_targetid ) + "[" + targetid + "]");

	addMoneyToPlayer(i_targetid, f_amount);
	msg(i_targetid, "You recived $" + amount + " from " + getPlayerName( playerid ) + "[" + playerid + "]");
}