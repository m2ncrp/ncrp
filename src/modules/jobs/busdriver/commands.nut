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

function busJobHelp ( playerid ) {
    local title = "job.bus.help.title";
    local commands = [
        { name = "job.bus.help.job",         desc = "job.bus.help.jobtext"           },
        { name = "job.bus.help.jobleave",    desc = "job.bus.help.jobleavetext"      },
        { name = "job.bus.help.busstop",     desc = "job.bus.help.busstoptext"    }
    ];
    msg_help(playerid, title, commands);
}

cmd("help", "bus", busJobHelp );
cmd("help", ["job", "bus"], busJobHelp );
cmd("help", ["bus", "job"], busJobHelp );
cmd("job", ["bus", "help"], busJobHelp );
cmd("bus", ["job", "help"], busJobHelp );
cmd("bus", busJobHelp );