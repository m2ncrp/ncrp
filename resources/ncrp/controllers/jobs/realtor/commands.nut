cmd("realtor", "sell", function(playerid, targetid, price) {
    realtyJobSell(playerid, targetid, price);
});

//DBG
cmd("place", function(playerid) {
    local plaPos = getPlayerPositionObj(playerid.tointeger());
    players[playerid]["housex"] = plaPos.x;
    players[playerid]["housey"] = plaPos.y;
    players[playerid]["housez"] = plaPos.z;
    msg(playerid, "It's your new spawn place now.");
});
