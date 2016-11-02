include("controllers/money/commands.nut");

function addMoneyToPlayer(playerid, amount) {
    players[playerid]["money"] += amount;
}

function subMoneyToPlayer(playerid, amount) {
    players[playerid]["money"] -= amount;
}
