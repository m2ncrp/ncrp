include("controllers/money/commands.nut");

function addMoneyToPlayer(playerid, amount) {
    players[playerid]["money"] += amount;
}

function subMoneyToPlayer(playerid, amount) {
	if (players[playerid]["money"] > amount)
    	players[playerid]["money"] -= amount;
    else
    	msg(playerid, "You can't afford youself to spend $" + amount + "!");
}

function getPlayerBalance(playerid) {
	return players[playerid]["money"];
}

function transfer(playerid, targetid, amount) {
	subMoneyToPlayer(playerid, amount);
	msg(playerid, "You transfer $" + amount + " to " + getPlayerName( targetid ) + "[" + targetid + "]");

	addMoneyToPlayer(targetid, amount);
	msg(playerid, "You recived $" + amount + " from " + getPlayerName( playerid ) + "[" + playerid + "]");
}