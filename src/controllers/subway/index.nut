



// (x3, y3, z3) = (1-t)*(x1, y1, z1) + t*(x2, y2, z2

// (x1, y1, z1) + p * ((x2, y2, z2) - (x1, y1, z1))






cmd("subwaypla", function (playerid) {
    triggerClientEvent(playerid, "spawnSubwayToPlayer");
});

cmd("subway", function (playerid) {
    triggerClientEvent(playerid, "spawnSubway", -281.67303466797, 558.40948486328, 2.1261413097382)//-281.645, 564.79, 2.30187);
    triggerClientEvent(playerid, "setSubwayCarReady");
});

cmd("sstart", function (playerid) {
    triggerClientEvent(playerid, "setSubwayCarGo");
});

cmd("sstop", function (playerid) {
    triggerClientEvent(playerid, "setSubwayCarStop");
});

cmd("box1", function (playerid) {
    triggerClientEvent(playerid, "moveBoxRandomByName1");
    dbg("box1")
});
cmd("box2", function (playerid) {
    triggerClientEvent(playerid, "moveBoxRandomByName2");
    dbg("box2")
});
cmd("box3", function (playerid) {
    triggerClientEvent(playerid, "moveBoxRandomById");
    dbg("box3")
});