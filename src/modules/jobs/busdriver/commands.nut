// usage: /bus job
/*
cmd("bus", "job", function(playerid) {
    busJob(playerid);
});
*/
// usage: /bus job leave
/*
cmd("bus", ["job", "leave"], function(playerid) {
    busJobLeave(playerid);
});
*/
// usage: /bus route list
/*
cmd("bus", ["route", "list"], function(playerid) {
    busJobRoutes(playerid);
});
*/
// usage: /bus route 5
/*
cmd("bus", "route", function(playerid, route = null) {
    busJobSelectRoute(playerid, toInt(route));
});
*/

// usage: /bus ready
/*
cmd("bus", "ready", function(playerid) {
    busJobReady(playerid);
});
*/

// usage: /bus stop
/*
cmd("bus", "stop", function(playerid) {
    busJobStop(playerid);
});
*/
// cmd("bus", "enter", function(playerid, busid) {
//     foreach (idx, value in players) {
//         triggerClientEvent(idx, "onServerPlayerBusEnter", playerid, busid.tointeger());
//     }
// });

// cmd("bus", "exit", function(playerid, busid) {
//     foreach (idx, value in players) {
//         triggerClientEvent(idx, "onServerPlayerBusExit", playerid, busid.tointeger());
//     }
// });