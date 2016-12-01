local ticker;

event("onServerStarted", function() {
    // ticker = timer(function() {
    //     foreach (playerid, data in getPlayers()) {
    //         foreach (targetid, value in getPlayers()) {
    //             if (playerid == targetid) continue;
    //             local posx = getPlayerPosition(targetid);
    //             trigger(playerid, "onServerSyncPackage", targetid, posx[0], posx[1], posx[2]);
    //         }
    //     }
    // }, 100, -1);
});
