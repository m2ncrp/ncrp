local ticker;

// event("onServerStarted", function() {
//     ticker = timer(function() {
//         foreach (playerid, data in players) {
//             foreach (targetid, value in players) {
//                 if (playerid == targetid) continue;
//                 local posx = getPlayerPosition(targetid);
//                 trigger(playerid, "onServerPlayerSyncPackage", targetid, posx[0], posx[1], posx[2]);
//             }
//         }
//     }, 25, -1);
// });


// event("onPlayerSpawn", function(playerid) {
//     foreach (targetid, obj in players) {
//         trigger(playerid, "onServerPlayerPositionSet", targetid, obj.x, obj.y, obj.z);
//     }
// });
